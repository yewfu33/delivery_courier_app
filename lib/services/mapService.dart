import 'dart:convert';

import 'package:delivery_courier_app/model/routeModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

class MapService {
  Future<RouteModel> getRouteByCoordinates(LatLng l1, LatLng l2) async {
    var apikey = FlutterConfig.get('GOOGLE_MAPS_API_KEY');

    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apikey";
    http.Response response = await http.get(url);

    Map values = jsonDecode(response.body);
    Map routes = values["routes"][0];
    Map legs = values["routes"][0]["legs"][0];

    RouteModel route = RouteModel(
      points: routes["overview_polyline"]["points"],
      distance: Distance.fromMap(legs['distance']),
      timeNeeded: TimeNeeded.fromMap(legs['duration']),
      endAddress: legs['end_address'],
      startAddress: legs['end_address'],
    );

    return route;
  }

  List decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    return lList;
  }
}
