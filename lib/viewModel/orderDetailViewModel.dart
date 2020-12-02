import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_config/flutter_config.dart';

class OrderDetailViewModel with ChangeNotifier {
  Completer<GoogleMapController> controller = Completer();
  PolylinePoints _polylinePoints = PolylinePoints();

  // Map storing polylines created by connecting
  // two points
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> _polylineCoordinates = List();
  // markers map
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  int _markerIdCounter = 1;

  double _zoomLevel = 18;

  PointLatLng start;
  List<PointLatLng> destination = List<PointLatLng>();

  OrderDetailViewModel.initRoute(LatLng startPoint, List<LatLng> dropPoints) {
    this.findCoordinatesFromAddress(startPoint, dropPoints);
  }

  void findCoordinatesFromAddress(
      LatLng address1, List<LatLng> address2) async {
    // add start marker
    _addMarker(address1);
    // assign start point
    start = PointLatLng(address1.latitude, address1.longitude);

    for (var i = 0; i < address2.length; i++) {
      destination.add(
        PointLatLng(address2[i].latitude, address2[i].longitude),
      );
      // add destination marker
      _addMarker(address2[i]);
    }
    // construct polyline
    await createPolylines(start, destination);

    notifyListeners();
  }

  void _addMarker(LatLng position) {
    // marker id
    final String markerIdVal = 'marker_$_markerIdCounter';
    // increment the marker
    _markerIdCounter += 1;

    final MarkerId markerId = MarkerId(markerIdVal);

    // create marker instance
    final Marker marker = Marker(
      markerId: MarkerId(markerIdVal),
      position: position,
    );

    print('added marker: $markerIdVal');

    markers[markerId] = marker;
  }

  void moveCameraToPosition(CameraPosition cm) {
    if (controller.isCompleted) {
      controller.future
          .then((c) => c.animateCamera(CameraUpdate.newCameraPosition(cm)));
    }
  }

  Future createPolylines(
      PointLatLng start, List<PointLatLng> destination) async {
    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      FlutterConfig.get('GOOGLE_MAPS_API_KEY'), // Google Maps API Key
      start,
      destination[0],
      travelMode: TravelMode.driving,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // check dropPoints length
    if (destination.length > 1) {
      var i = 1;
      for (final p in destination) {
        PolylineResult result =
            await _polylinePoints.getRouteBetweenCoordinates(
          FlutterConfig.get('GOOGLE_MAPS_API_KEY'), // Google Maps API Key
          destination[i - 1],
          p,
          travelMode: TravelMode.driving,
        );

        // Adding the coordinates to the list
        if (result.points.isNotEmpty) {
          result.points.forEach((PointLatLng point) {
            _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          });
        }

        i++;
      }
    }

    // Defining an ID
    PolylineId id = PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: _polylineCoordinates,
      width: 2,
    );

    // Adding the polyline to the map
    polylines[id] = polyline;
  }

  void onTapPickUpLocation() {
    if (start == null) return;
    moveCameraToPosition(
      CameraPosition(
        target: LatLng(start.latitude, start.longitude),
        zoom: _zoomLevel,
      ),
    );
  }

  void onTapDropOffLocation(int index) {
    if (destination == null || destination[index] == null) return;
    moveCameraToPosition(
      CameraPosition(
        target:
            LatLng(destination[index].latitude, destination[index].longitude),
        zoom: _zoomLevel,
      ),
    );
  }
}
