import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/cupertino.dart';

class homeScreen extends StatefulWidget {
  static const String routeName = 'home';

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    streamsupscreated?.cancel();
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 20.4746,
  );
  Set<Marker> markrs = {};
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GPS'),
      ),
      body: GoogleMap(
        onLongPress: (LatLng) {
          Marker marker =
              Marker(markerId: MarkerId("Marker$counter"), position: LatLng);
          markrs.add(marker);
          setState(() {
            counter++;
          });
        },
        markers: markrs,
        mapType: MapType.normal,
        initialCameraPosition: MyLocation == null ? _kGooglePlex : MyLocation!,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the Your location'),
        icon: const Icon(Icons.home),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(MyLocation!));
  }

  Location location = Location();
  PermissionStatus? permissionStatus;
  bool serviceEnabled = false;
  CameraPosition? MyLocation;
  LocationData? locationData;
  StreamSubscription<LocationData>? streamsupscreated;

  void getCurrentLocation() async {
    bool permission = await IsPermissionGranted();
    if (permission == false) return;
    bool service = await IsServiceEnabled();
    if (!service) return;
    print("Hello Permission");
    locationData = await location.getLocation();
location.changeSettings(accuracy:LocationAccuracy.balanced );
    streamsupscreated = location.onLocationChanged.listen((event) {
      locationData = event;
      print(
          "My Location > lat:${locationData?.latitude} long: ${locationData?.longitude}");

      print(
          "My Location > lat:${locationData?.latitude} long: ${locationData?.longitude}");
    });
    Marker userMarker = Marker(
        markerId: MarkerId("userLocation"),
        position: LatLng(locationData!.latitude!, locationData!.longitude!));
    markrs.add(userMarker);
    MyLocation = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(locationData!.latitude!, locationData!.longitude!),
        tilt: 59.440717697143555,
        zoom: 25.151926040649414);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(MyLocation!));
    setState(() {
      markrs.add(userMarker);
    });
  }

  Future<bool> IsPermissionGranted() async {
    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      return permissionStatus == PermissionStatus.granted;
    } else if (permissionStatus == PermissionStatus.deniedForever) {
      return false;
    } else {
      return permissionStatus == PermissionStatus.granted;
    }
  }

  Future<bool> IsServiceEnabled() async {
    serviceEnabled = await location.serviceEnabled();
    if (serviceEnabled == false) {
      serviceEnabled = await location.requestService();
      return serviceEnabled;
    }
    return serviceEnabled;
  }
}


