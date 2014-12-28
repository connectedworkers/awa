----
First, launch the broker:

	cd mqtt-broker/moquette/bin
	rm *.log
	./moquette.sh

Then run the demo:

	golo golo --classpath jars/*.jar --files imports/dsl.adapters/*.golo imports/mqtt.device/*.golo demo.mqtt.golo 
----
module demo.mqtt

import io.connectedworkers.mqtt.device

function main = |args| {

	let mybroker = broker()
		: protocol("tcp")
		: host("localhost")
		: port(1883)

	let options = mqttHelper(): getConnectOptions()

	# qos is 0 by default
	let bobDevice = mqttDevice(): broker(mybroker): connectOptions(options): initialize("bob")
	let johnDoeDevice = mqttDevice(): broker(mybroker): connectOptions(options): initialize()

	let slaveDevice = mqttDevice(): broker(mybroker): connectOptions(options): initialize("slave")

	let devices = list[]
	let sentinel = Observable(0) # not the good solution
	
	# observe if all devices are connected and then if true publish some messages
	sentinel: onChange(|value| {
		devices: add(value)
		let maxDevices = 3
		println(devices)
		if devices: size(): equals(maxDevices) {
			# all devices are connected
			println("all devices are connected")
			10: times(|index| {

				sleep(1000_L)

				bobDevice: topic("hi"): content("#: message n°" + index + " from " + bobDevice: id())
					: publish(): onSet(|token| -> println("published!")): onFail(|error| -> println("ouch!"))

				johnDoeDevice: topic("hello"): content("#: message n°" + index + " from " + johnDoeDevice: id())
					: publish(): onSet(|token| -> println("published!")): onFail(|error| -> println("ouch!"))

			})

			#bobDevice: disconnect()
			#johnDoeDevice: disconnect()
			#slaveDevice: disconnect()
		}
	})

	let slaveDeviceConnection = {

		slaveDevice
		: messageArrived(|topic, message| { 
				println("["+ slaveDevice: id() +"] you've got a mail : " + topic + " | " + message)
			})
		: deliveryComplete(|token| { 
				println("delivery is complete " + token) 
			})
		: connectionLost(|error| -> println("ouch"))

		slaveDevice: connect()
			: onSet(|token| {
				println("id: " + slaveDevice: id() + " is connected | token: " + token)
				slaveDevice: subscribe("all")
				sentinel: set(slaveDevice)

			}): onFail(|error| {
				println("Huston, we've got a problem:")
				println(JSON.stringify(error))
			})
	}

	let bobDeviceConnection = {
		bobDevice
			: messageArrived(|topic, message| { 
					println("["+ bobDevice: id() +"] you've got a mail : " + topic + " | " + message)
					bobDevice: topic("all"): content("@@@@@"): publish()
					# never publish here on a subscribed topic by the current device
				})
			: deliveryComplete(|token| { 
					println("delivery is complete " + token) 
				})
			: connectionLost(|error| -> println("ouch"))

		bobDevice: connect()
			: onSet(|token| {
				println("id: " + bobDevice: id() + " is connected | token: " + token)
				bobDevice: subscribe("hello")
				sentinel: set(bobDevice)

			}): onFail(|error| {
				println("Huston, we've got a problem:")
				println(JSON.stringify(error))
			})
	}

	let johnDoeDeviceConnection = {
		johnDoeDevice
			: messageArrived(|topic, message| { 
					println("["+ johnDoeDevice: id() +"] you've got a mail : " + topic + " | " + message)
					johnDoeDevice: topic("all"): content("@@@@@"): publish()
				})
			#: deliveryComplete(|token| { 
			#		println("delivery is complete " + token) 
			#	})
			#: connectionLost(|error| -> println("ouch"))

		johnDoeDevice: connect()
			: onSet(|token| {
				println("id: " + johnDoeDevice: id() + " is connected | token: " + token)
				johnDoeDevice: subscribe("hi")
				sentinel: set(johnDoeDevice)

			}): onFail(|error| {
				println("Huston, we've got a problem:")
				println(JSON.stringify(error))
			})		
	}

	johnDoeDeviceConnection()
	bobDeviceConnection()
	slaveDeviceConnection()



}
