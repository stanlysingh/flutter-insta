// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//         // This makes the visual density adapt to the platform that you run
//         // the app on. For desktop platforms, the controls will be smaller and
//         // closer together (more dense) than on mobile platforms.
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       interpretReceivedData("abt_HANDS_SHAKE");
//       _counter++;
//     });
//   }
//
//
//
// //We're making these three things global so that we-
// //can check the state and device later in this class
//   BluetoothDevice device;
//   BluetoothState state;
//   BluetoothDeviceState deviceState;
//   var scanSubscription;
//   var bluetoothInstance;
//
//
//   FlutterBlue flutterBlue = FlutterBlue.instance;
//
//   ///Initialisation and listening to device state
//   @override
//   void initState() {
//     super.initState();
// //checks bluetooth current state
//     bluetoothInstance= FlutterBlue.instance.state.listen((state) {
//       if (state == BluetoothState.off) {
// //Alert user to turn on bluetooth.
//       } else if (state == BluetoothState.on) {
// //if bluetooth is enabled then go ahead.
// //Make sure user's device gps is on.
//         scanForDevices();
//       }
//     });
//   }
//
//
//   ///// **** Scan and Stop Bluetooth Methods  ***** /////
//   void scanForDevices() async {
//
//     // Start scanning
//     flutterBlue.startScan(timeout: Duration(seconds: 4));
//
// // Listen to scan results
//     var subscription = flutterBlue.scanResults.listen((results) {
//       // do something with scan results
//       for (ScanResult r in results) {
//         print('${r.device.name} found! rssi: ${r.rssi}');
//       }
//     });
//
// // Stop scanning
//     flutterBlue.stopScan();
//
//   }
//
//   ///// ******* Bluetooth device Handling Methods ******** //////
//   connectToDevice() async {
// //flutter_blue makes our life easier
//     await device.connect();
// //After connection start dicovering services
//     discoverServices();
//   }
//
//   // ADD YOUR OWN SERVICES & CHAR UUID, EACH DEVICE HAS DIFFERENT UUID
// // device Proprietary characteristics of the ISSC service
//   static const ISSC_PROPRIETARY_SERVICE_UUID = "49535343-*****";
// //device char for ISSC characteristics
//   static const UUIDSTR_ISSC_TRANS_TX = "49535343-4554-*****";
//   static const UUIDSTR_ISSC_TRANS_RX = "49535343-8841-****";
// // This characteristic to send command to device
//   BluetoothCharacteristic c;
// //This stream is for taking characteristic's value
// //for reading data provided by device
//   Stream<List<int>> listStream;
//   discoverServices() async {
//     List<BluetoothService> services = await device.discoverServices();
// //checking each services provided by device
//     services.forEach((service) {
//       if (service.uuid.toString() == ISSC_PROPRIETARY_SERVICE_UUID) {
//         service.characteristics.forEach((characteristic) {
//           if (characteristic.uuid.toString() == UUIDSTR_ISSC_TRANS_RX) {
// //Updating characteristic to perform write operation.
//             c = characteristic;
//           } else if (characteristic.uuid.toString() == UUIDSTR_ISSC_TRANS_TX) {
// //Updating stream to perform read operation.
//             listStream = characteristic.value;
//             characteristic.setNotifyValue(!characteristic.isNotifying);
//           }
//         });
//       }
//     });
//   }
//
//
//
//   //SEE WHAT TYPE OF COMMANDS YOUR DEVICE GIVES YOU & WHAT IT MEANS
//   interpretReceivedData(String data) async {
//     if (data == "abt_HANDS_SHAKE") {
// //Do something here or send next command to device
//       sendTransparentData('Hello');
//     } else {
//       print("Determine what to do with $data");
//     }
//   }
//
//   sendTransparentData(String dataString) async {
// //Encoding the string
//     List<int> data = utf8.encode(dataString);
//     await c.write(data);
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//
//             StreamBuilder<List<int>>(
//               stream: listStream,  //here we're using our char's value
//               initialData: [],
//               builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.active) {
// //In this method we'll interpret received data
//
//                   Fluttertoast.showToast(
//                       msg: "This is Received data Toast",
//                       toastLength: Toast.LENGTH_SHORT,
//                       gravity: ToastGravity.CENTER,
//                       timeInSecForIosWeb: 1,
//                       backgroundColor: Colors.red,
//                       textColor: Colors.white,
//                       fontSize: 16.0
//                   );
//
//                   return Center(
//                       child: Text('We are finding the data..')
//                   );
//                 } else {
//                   return SizedBox();
//                 }
//               },
//             )
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
