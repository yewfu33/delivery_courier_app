import 'dart:async';
import 'dart:io';

import 'package:delivery_courier_app/model/locationModel.dart';
import 'package:location/location.dart';
import 'package:signalr_client/errors.dart';
import 'package:signalr_client/signalr_client.dart';

class LocationService {
  static final LocationService _singleton = LocationService._init();

  // register sigleton instance
  factory LocationService() => _singleton;

  final Location _location = new Location();
  // HubConnection instance
  final HubConnection hubConnection =
      HubConnectionBuilder().withUrl(trackingHub).build();

  static final trackingHub = "http://192.168.0.131:57934/tracking";

  static final sendLocationName = "LatLngToServer";

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  StreamController<LocationModel> _locationController =
      StreamController<LocationModel>.broadcast();

  Stream<LocationModel> get locationStream => _locationController.stream;

  Sink<LocationModel> get locationSink => _locationController.sink;

  LocationService._init() {
    this.init();
    try {
      hubConnection.start().catchError((e) => throw e);

      hubConnection.on("OnHubConnected", (List parameters) {
        print('${parameters[0]}');
      });
    } on SocketException catch (e) {
      print("socket exception in \"hub start\" ${e.toString()}");
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
    _location.onLocationChanged
        .map((m) => LocationModel(latitude: m.latitude, longitude: m.longitude))
        .distinct((LocationModel p, LocationModel n) =>
            (p.latitude == n.latitude) || (p.longitude == n.longitude))
        .pipe(_locationController)
        .then((_) => _locationController.close());
  }

  Future sendLocation(LocationModel location) async {
    try {
      // null safety
      if (hubConnection == null) return;

      await hubConnection.invoke(sendLocationName, args: <Object>[
        location.latitude,
        location.longitude,
      ]);
    } on GeneralError catch (e) {
      print('error in send. ' + e.toString());
    } catch (e) {
      print('error in send, ' + e.toString());
    }
  }

  void dispose() {
    _locationController.close();
  }
}
