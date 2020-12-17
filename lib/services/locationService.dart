import 'package:location/location.dart';

class LocationService {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  LocationService() {
    this.init();
  }

  Future init() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  void dispose() {}
}
