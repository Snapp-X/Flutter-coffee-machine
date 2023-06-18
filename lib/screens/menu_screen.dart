// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_coffee/repositories/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';

// class MyWidget extends StatefulWidget {
//   const MyWidget({super.key});

//   @override
//   State<MyWidget> createState() => _MyWidgetState();
// }

// class _MyWidgetState extends State<MyWidget> {
//   late MqttClient client;
//   var topic = "topic/test";

//   void _publish(String message) {
//     final builder = MqttClientPayloadBuilder();
//     builder.addString('Hello from flutter_client');
//     client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               child: Text('Connect'),
//               onPressed: () => {
//                 connect().then((value) {
//                   client = value;
//                 })
//               },
//             ),
//             ElevatedButton(
//               child: Text('Subscribe'),
//               onPressed: () {
//                 return {client.subscribe(topic, MqttQos.atLeastOnce)};
//               },
//             ),
//             ElevatedButton(
//               child: Text('Publish'),
//               onPressed: () => {this._publish('Hello')},
//             ),
//             ElevatedButton(
//               child: Text('Unsubscribe'),
//               onPressed: () => {client.unsubscribe(topic)},
//             ),
//             ElevatedButton(
//               child: Text('Disconnect'),
//               onPressed: () => {client.disconnect()},
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MenuScreen extends StatelessWidget {
//   const MenuScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ElevatedButton(
//         child: Text('asdf'),
//         onPressed: () async {
//           const broker = '10.42.0.1';
//           const username = 'dash';
//           const passwd = 'esel1234';
//           const clientIdentifier = 'FlutterClient';

//           final client = MqttServerClient(broker, clientIdentifier);

//           client.logging(on: true);
//           client.keepAlivePeriod = 30;

//           final connMess = MqttConnectMessage()
//               .withClientIdentifier(clientIdentifier)
//               .withWillTopic(
//                   'Raspy') // If you set this you must set a will message
//               .withWillMessage('Connected to FlutterCoffeeV13')
//               .startClean() // Non persistent session for testing
//               .withWillQos(MqttQos.atLeastOnce);
//           print('EXAMPLE::Mosquitto client connecting....');
//           client.connectionMessage = connMess;

//           try {
//             await client.connect(username, passwd);
//           } on NoConnectionException catch (e) {
//             // Raised by the client when connection fails.
//             print('EXAMPLE::client exception - $e');
//             client.disconnect();
//           } on SocketException catch (e) {
//             // Raised by the socket layer
//             print('EXAMPLE::socket exception - $e');
//             client.disconnect();
//           }
//         },
//       ),
//     );
//   }
// }
