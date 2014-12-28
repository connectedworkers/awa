----
First, launch the broker:

		cd mqtt-broker/moquette/bin
		rm *.log
		./moquette.sh

Then run the demo:

		./go.sh
----
module sphero.mqtt

import io.connectedworkers.mqtt.device
import io.connectedworkers.toolbelt.time.helper
import io.connectedworkers.toolbelt.math.helper
import io.connectedworkers.toolbelt.files.helper

function main = |args| {

	let mybroker = broker()
		: protocol("tcp")
		: host("localhost")
		: port(1883)

	let options = mqttHelper(): getConnectOptions()

	# qos is 0 by default
	let bobDevice = mqttDevice(): broker(mybroker): connectOptions(options): initialize("bob")

	bobDevice
		: messageArrived(|topic, message| { 
				println("["+ bobDevice: id() +"] you've got a mail : " + topic + " | " + message)
				# never publish here on a subscribed topic by the current device
			})
		: connectionLost(|error| -> println("ouch"))

	let dynamicController = DynamicObject()

	bobDevice: connect()
		: onSet(|token| {
			println("id: " + bobDevice: id() + " is connected | token: " + token)
			#bobDevice: subscribe("hello")

			# load plugin here
			# then listen to change
			every(): ms(500_L): times(50): do({
				bobDevice: topic("hello"): content(
					JSON.stringify(DynamicObject()
						: colorIndex(rndInteger(0,2))
						: speed(rndInteger(0,60))
						: direction(rndInteger(0,360))
					)
				): publish()
			})

		}): onFail(|error| {
			println("Huston, we've got a problem:")
			println(JSON.stringify(error))
		})



}
