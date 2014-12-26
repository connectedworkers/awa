
# Documentation for `io.connectedworkers.mqtt.device`

This is a little fluent DSL "around" Paho client library
see [Paho java client library](http://www.eclipse.org/paho/files/javadoc/overview-summary.html)
sample: 

	let mybroker = broker()
		: protocol("tcp")
		: host("localhost")
		: port(1883)

	let options = mqttHelper(): getConnectOptions()

	let johnDoeDevice = mqttDevice(): broker(mybroker): connectOptions(options): initialize()

	johnDoeDevice
		: messageArrived(|topic, message| { 
				println("["+ johnDoeDevice: id() +"] you've got a mail : " + topic + " | " + message)
				johnDoeDevice: topic("all"): content("I've got a mail!"): publish()
			})

	johnDoeDevice: connect()
		: onSet(|token| {
			println("id: " + johnDoeDevice: id() + " is connected | token: " + token)
			johnDoeDevice: subscribe("hi")
		}): onFail(|error| {
			println("Huston, we've got a problem:")
			println(JSON.stringify(error))
		})			




## Structs

### `actionListenerError`

##### Members

- token

- exception


Used to pass error when actionListenerCallback is used with promises


### `broker`

##### Members

- protocol

- host

- port


Mqtt Broker structure (helper/reference to the mqtt server)

Use:



### `mqttDevice`

##### Members

- id

- topic

- content

- broker

- qos

- connectOptions

- messageArrived

- deliveryComplete

- connectionLost

- _client


Mqtt device structure

It's a decorator (or proxy ?) around MqttAsyncClient

`messageArrived`, `deliveryComplete` and `connectionLost` are references to the handler methods of the `MqttCallback` adapter



### `mqttHelper`

##### Members

- _foo


Mqtt helper, kind of class with tool-belt methods




## Augmentations

### `broker`

Broker augmentations




#### `url(this)`


`url` method returns the url of the mqtt broker built from the broker structure properties


### `mqttDevice`

mqttDevice augmentations




#### `activateCallBacks(this)`


Set the mqtt callback of the device (MqttClient)



#### `connect(this)`


Asynchronous connection returning a promise



#### `connect(this, success, failed)`


Asynchronous connection with actionListenerCallback



#### `disconnect(this)`


Asynchronous disconnection returning a promise



#### `disconnect(this, onSuccess, onFailure)`


Asynchronous disconnection with actionListenerCallback



#### `getMqttClient(this)`


MqttAsyncClient factory
Used by

- `initialize` method



#### `initialize(this, clientId)`


This is the constructor of the mqtt device
You've to call it only after defining(setting) properties

- default value of `qos` is `0`
- `id` of the device is a parameter of the constructor



#### `initialize(this)`


This is the constructor of the mqtt device
You've to call it only after defining(setting) properties

- default value of `qos` is `0`
- `id` of the device is automatically generated



#### `publish(this)`


Asynchronous publication of content property value to the current topic returning a promise



#### `publish(this, onSuccess, onFailure)`


Asynchronous publication of content property value to the current topic with actionListenerCallback



#### `subscribe(this, topic)`


Asynchronous topic subscription returning a promise



#### `subscribe(this, topic, success, failed)`


Asynchronous topic subscription with actionListenerCallback

see: [http://www.eclipse.org/paho/files/javadoc/org/eclipse/paho/client/mqttv3/MqttAsyncClient.html#subscribe(java.lang.String[], int[], java.lang.Object, org.eclipse.paho.client.mqttv3.IMqttActionListener)](http://www.eclipse.org/paho/files/javadoc/org/eclipse/paho/client/mqttv3/MqttAsyncClient.html#subscribe(java.lang.String[], int[], java.lang.Object, org.eclipse.paho.client.mqttv3.IMqttActionListener))

TODO:

- subscribe to several topics



#### `syncConnect(this)`


Synchronous connection *(to be tested)*



#### `syncDisconnect(this)`


Synchronous disconnection *(to be tested)*



#### `syncPublish(this)`


Synchronous publication of content property value to the current topic *(to be tested)*



#### `syncSubscribe(this, topic)`


Synchronous topic subscription *(to be tested)*



#### `syncUnsubscribe(this, topic)`


Synchronous topic un-subscription *(to be tested)*

TODO:

- Asynchronous methods


### `mqttHelper`

mqttHelper augmentations




#### `getConnectOptions(this, cleanSession)`


return MqttConnectOptions

Holds the set of options that control how the client connects to a server.

- see [http://www.eclipse.org/paho/files/javadoc/org/eclipse/paho/client/mqttv3/MqttConnectOptions.html](http://www.eclipse.org/paho/files/javadoc/org/eclipse/paho/client/mqttv3/MqttConnectOptions.html)



#### `getConnectOptions(this)`


return MqttConnectOptions

Holds the set of options that control how the client connects to a server.

usage:

	let options = mqttHelper(): getConnectOptions()

- see [http://www.eclipse.org/paho/files/javadoc/org/eclipse/paho/client/mqttv3/MqttConnectOptions.html](http://www.eclipse.org/paho/files/javadoc/org/eclipse/paho/client/mqttv3/MqttConnectOptions.html)



## Functions


#### `actionListenerCallback(onSuccessCbk, onFailureCbk)`


IMqttActionListener adapter

- see [http://www.eclipse.org/paho/files/javadoc/org/eclipse/paho/client/mqttv3/IMqttActionListener.html](http://www.eclipse.org/paho/files/javadoc/org/eclipse/paho/client/mqttv3/IMqttActionListener.html)

Implementors of this interface will be notified when an asynchronous action completes.
A listener is registered on an MqttToken and a token is associated with an action like connect or publish. 
When used with tokens on the MqttAsyncClient the listener will be called back on the MQTT client's thread. 
The listener will be informed if the action succeeds or fails. 
It is important that the listener returns control quickly otherwise the operation of the MQTT client will be stalled.



#### `mqttCallback(messageArrivedCbk, deliveryCompleteCbk, connectionLostCbk)`


MqttCallback adapter

- see [http://www.eclipse.org/paho/files/javadoc/org/eclipse/paho/client/mqttv3/MqttCallback.html](http://www.eclipse.org/paho/files/javadoc/org/eclipse/paho/client/mqttv3/MqttCallback.html)

Enables an application to be notified when asynchronous events related to the client occur. 
Classes implementing this interface can be registered on both types of client: 
- IMqttClient.setCallback(MqttCallback) 
- and IMqttAsyncClient.setCallback(MqttCallback)


