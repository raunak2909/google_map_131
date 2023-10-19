import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var initPos = CameraPosition(target: LatLng(19.228825, 72.854118), zoom: 15);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps'),
      ),
      body: GoogleMap(
        initialCameraPosition: initPos,
        markers: {
          Marker(
              infoWindow: InfoWindow(
                  title: "Delhi"
              ),
              markerId: MarkerId("1"),
              position: LatLng(28.6563, 77.2321),
              onTap: () {
                print("Tapped on Marker..");
              }),
          Marker(
              infoWindow: InfoWindow(
                  title: "Market"
              ),
              markerId: MarkerId("1"),
              position: LatLng(19.199821, 72.842590),
              onTap: () {
                print("Tapped on Marker..");
              }),
          Marker(
              infoWindow: InfoWindow(
                  title: "Haryana"
              ),
              markerId: MarkerId("1"),
              position: LatLng(28.408913, 77.317787),
              onTap: () {
                print("Tapped on Marker..");
              }),
          Marker(
            infoWindow: InfoWindow(
              title: "Jaipur"
            ),
              markerId: MarkerId("1"),
              position: LatLng(26.860830, 75.814807),
              onTap: () {
                print("Tapped on Marker..");
              }),
        },
      ),
    );
  }
}
