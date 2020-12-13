import 'package:delivery_courier_app/constant.dart';
import 'package:delivery_courier_app/model/routeModel.dart';
import 'package:delivery_courier_app/services/mapService.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapProvider with ChangeNotifier {
  final MapService mapService = MapService();
  GoogleMapController _mapController;

  int _markerIdCounter = 1;

  final double _zoomLevel = 17;

  LatLng origin;
  List<LatLng> destination = List<LatLng>();

  Set<Marker> _markers = {};
  Set<Polyline> _poly = {};
  RouteModel _routeModel;
  List<LatLng> _polylineCoordinates = List();
  List<RouteModel> _routeModelCollection = List();

  Set<Marker> get markers => _markers;
  Set<Polyline> get poly => _poly;

  GoogleMapController get mapController => _mapController;
  RouteModel get routeModel => _routeModel;

  MapProvider.init(LatLng a1, List<LatLng> a2) {
    this.initRoute(a1, a2);
  }

  void onMapCreate(GoogleMapController controller) {
    _mapController = controller;

    notifyListeners();
  }

  Future initRoute(LatLng a1, List<LatLng> a2) async {
    // add start marker
    _addMarker(a1);
    // assign start point
    origin = LatLng(a1.latitude, a1.longitude);

    for (var i = 0; i < a2.length; i++) {
      destination.add(
        LatLng(a2[i].latitude, a2[i].longitude),
      );
      // add destination marker
      _addMarker(a2[i]);
    }

    // construct polyline
    await _createPolylines(origin, destination);

    notifyListeners();
  }

  void _addMarker(LatLng position) {
    // marker id
    final String markerIdVal = 'marker_$_markerIdCounter';
    // increment the marker
    _markerIdCounter += 1;

    // create marker instance
    final Marker marker = Marker(
      markerId: MarkerId(markerIdVal),
      position: position,
    );

    print('added marker: $markerIdVal');

    _markers.add(marker);
  }

  void clearMarkers() {
    _markers.clear();
    notifyListeners();
  }

  Future _createPolylines(LatLng origin, List<LatLng> destination) async {
// Generating the list of coordinates to be used for
    // drawing the polylines
    RouteModel route =
        await mapService.getRouteByCoordinates(origin, destination[0]);

    _routeModel = route;
    // append on the collection
    _routeModelCollection.add(route);

    // reset poly
    _poly = {};

    // Add the coordinates to the list
    _polylineCoordinates
        .addAll(_convertToLatLong(mapService.decodePoly(route.points)));

    // check dropPoints length
    if (destination.length > 1) {
      for (var i = 0; i < destination.length; i++) {
        if (i % 2 != 0) {
          RouteModel r = await mapService.getRouteByCoordinates(
              destination[i - 1], destination[i]);

          // append on the collection
          _routeModelCollection.add(r);

          // merge the coordinates to the list
          _polylineCoordinates
              .addAll(_convertToLatLong(mapService.decodePoly(r.points)));
        }
      }
    }

    // finally create the route
    _createRoute(_polylineCoordinates);
  }

  void _createRoute(List<LatLng> points) {
    _poly.add(
      Polyline(
          polylineId: PolylineId('poly000'),
          width: 2,
          color: Constant.primaryColor,
          onTap: () {},
          points: points),
    );
  }

  void onTapPickUpLocation() {
    if (origin == null) return;
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(origin.latitude, origin.longitude),
        zoom: _zoomLevel,
      ),
    ));
  }

  void onTapDropOffLocation(int i) {
    if (destination == null || destination[i] == null) return;
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(destination[i].latitude, destination[i].longitude),
        zoom: _zoomLevel,
      ),
    ));
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

  List<LatLng> _convertToLatLong(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }
}
