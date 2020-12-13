import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TaskProvider with ChangeNotifier {
  GoogleMapController _mapController;

  final LatLng origin;
  final List<LatLng> destination;

  final Set<Marker> markers;
  final Set<Polyline> poly;

  TaskProvider({
    @required this.destination,
    @required this.markers,
    @required this.poly,
    @required this.origin,
  });

  Future onMapCreate(GoogleMapController controller) async {
    _mapController = controller;
    notifyListeners();
  }

  void moveCameraBounds(LatLng from, LatLng to) {
    var sLat, sLng, nLat, nLng;
    if (from.latitude <= to.latitude) {
      sLat = from.latitude;
      nLat = to.latitude;
    } else {
      sLat = to.latitude;
      nLat = from.latitude;
    }

    if (from.longitude <= to.longitude) {
      sLng = from.longitude;
      nLng = to.longitude;
    } else {
      sLng = to.longitude;
      nLng = from.longitude;
    }

    LatLngBounds bounds = LatLngBounds(
        northeast: LatLng(nLat, nLng), southwest: LatLng(sLat, sLng));
    _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
  }
}
