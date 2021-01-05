import 'dart:async';

import 'package:delivery_courier_app/model/locationModel.dart';
import 'package:location/location.dart';
import 'package:signalr_client/signalr_client.dart';

import '../constant.dart';

class LocationService {
  static final LocationService _singleton = LocationService._init();

  // register sigleton instance
  factory LocationService() => _singleton;

  final Location _location = Location();
  // HubConnection instance
  final HubConnection hubConnection =
      HubConnectionBuilder().withUrl(trackingHub).build();

  static const trackingHub = "${Constant.serverName}tracking";

  static const sendLocationName = "LatLngToServer";

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  final StreamController<LocationModel> _locationController =
      StreamController<LocationModel>.broadcast();

  Stream<LocationModel> get locationStream => _locationController.stream;

  StreamSubscription onLocationStreamSubscription;

  LocationService._init() {
    // initialize
    init();
    try {
      hubConnection.start().catchError((e) => throw e);

      hubConnection.on("OnHubConnected", (List parameters) {
        print('${parameters[0]}');
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future init() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  void populateOnLocationChanged() {
    onLocationStreamSubscription = _location.onLocationChanged
        .map((m) => LocationModel(latitude: m.latitude, longitude: m.longitude))
        .distinct((p, n) =>
            (p.latitude == n.latitude) || (p.longitude == n.longitude))
        .listen((l) => _locationController.add(l));
  }

  Future sendLocation(LocationModel location, int userId) async {
    try {
      // null safety
      if (hubConnection == null) return;

      print(
          "send location -------> ${location.latitude} , ${location.longitude}");

      await hubConnection.invoke(sendLocationName, args: <Object>[
        location.latitude,
        location.longitude,
        userId,
      ]);
    } catch (e) {
      print('error in send, $e');
    }
  }

  void dispose() {
    onLocationStreamSubscription.cancel();
  }
}
