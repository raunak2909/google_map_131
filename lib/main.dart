import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  var initPos = CameraPosition(
    target: LatLng(19.228825, 72.854118),
    zoom: 15,
    tilt: 16,
  );

  LatLng? myLoc;

  @override
  void initState() {
    super.initState();
    checkBeforeGettingLocation();
  }

  @override
  Widget build(BuildContext context) {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      timeLimit: Duration(seconds: 10),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Maps'),
      ),
      body: GoogleMap(
        onMapCreated: (mController) {
          _controller.complete(mController);
        },
        onTap: (location) {
          print("Location: ${location.latitude}, ${location.longitude}");
        },
        initialCameraPosition: initPos,
        mapType: MapType.hybrid,
        markers: {
          Marker(
              infoWindow: InfoWindow(title: "My Location"),
              markerId: MarkerId("Home"),
              position: myLoc ?? LatLng(28.6563, 77.2321),
              onTap: () {
                print("Tapped on Marker..");
              }),
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        /*circles: {
          Circle(
            circleId: CircleId("home_circle"),
            center: myLoc ?? LatLng(28.6563, 77.2321),
            fillColor: Colors.blue.withOpacity(0.5),
            strokeWidth: 0,
            radius: 50,
          )
        },*/
      ),
    );
  }

  void checkBeforeGettingLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please Enable Location Services!!')));
    } else {
      // GPS is ON
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Please allow app to request your current location')));
        } else if (permission == LocationPermission.deniedForever) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'You\'ve denied this permission forever, therfore you wont be able to access this particular feature!!')));
        } else {
          //permission granted!!
          //getCurrentLocation();
          getCurrentLocation();
        }
      } else {
        // permission already given
        //getCurrentLocation();
        getCurrentLocation();
      }
    }
  }

  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition();

    print("Location: ${position.latitude}, ${position.longitude}");
    if (position != null) {
      myLoc = LatLng(position.latitude, position.longitude);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      print(placemarks);
      print(placemarks[0].locality);
      print(placemarks[0].name);
      final GoogleMapController controller = await _controller.future;
      setState(() {});
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: myLoc!, tilt: 59.440717697143555, zoom: 19)));
    }
  }

  void getContinuousLocation() {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      timeLimit: Duration(seconds: 10),
    );
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) async {
      print(position == null
          ? 'Unknown'
          : '${position.latitude.toString()}, ${position.longitude.toString()}');

      if (position != null) {
        myLoc = LatLng(position.latitude, position.longitude);
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        print(placemarks);
        print(placemarks[0].locality);
        print(placemarks[0].name);
        final GoogleMapController controller = await _controller.future;
        setState(() {});
        controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: myLoc!, tilt: 59.440717697143555, zoom: 19)));
      }
    });
  }
}
