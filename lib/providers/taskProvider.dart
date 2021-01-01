import 'dart:async';
import 'dart:convert';

import 'package:delivery_courier_app/constant.dart';
import 'package:delivery_courier_app/model/enum.dart';
import 'package:delivery_courier_app/model/locationModel.dart';
import 'package:delivery_courier_app/model/orderModel.dart';
import 'package:delivery_courier_app/model/user.dart';
import 'package:delivery_courier_app/services/locationService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'appProvider.dart';

class TaskProvider with ChangeNotifier {
  GoogleMapController _mapController;
  final LocationService _locationService = LocationService();

  StreamSubscription locationSubscription;

  final LatLng origin;
  final List<LatLng> destination;

  final Set<Marker> markers;
  final Set<Polyline> poly;
  final User user;
  final OrderModel order;

  DeliveryStatus _status;
  DeliveryStatus get status => _status;

  String _clock;
  String get clock => _clock;

  String _currentTel;
  String get currentTel => _currentTel;
  String _currentAddress;
  String get currentAddress => _currentAddress;
  LatLng _currentLatLng;
  LatLng get currentLatLng => _currentLatLng;
  String _currentRemark;
  String get currentRemark => _currentRemark;

  int dropPointIndex = 0;

  int _dpLength;
  int get dpLength => _dpLength;

  final updateStatusPath =
      "${Constant.serverName}${Constant.orderPath}/status/update/";

  final notificationPath = "${Constant.serverName}api/notification/send";

  TaskProvider({
    @required this.destination,
    @required this.markers,
    @required this.poly,
    @required this.origin,
    @required this.user,
    @required this.order,
  }) {
    // initliaze from the order
    _status = order.status;
    _clock = "${this.extractTimeFormat(order.dateTime)} - Pick-up";
    _currentTel = order.user.phoneNum;
    _currentAddress = order.address;
    _currentLatLng = LatLng(order.latitude, order.longitude);
    _currentRemark = order.comment;
    _dpLength = order.dropPoint.length;
  }

  Future onMapCreate(GoogleMapController controller) async {
    _mapController = controller;
    notifyListeners();
  }

  Future updateDeliveryStatus(int id, int status,
      {BuildContext context}) async {
    String query = [
      'status=$status',
    ].join('&');

    try {
      http.Response res = await http.post(
        updateStatusPath + id.toString() + '?$query',
        headers: {
          'Authorization': 'Bearer ${user.token}',
        },
      );

      if (res.statusCode == 200) {
        int s = int.parse(res.body);

        if (s == 1) {
          _clock =
              "${this.extractTimeFormat(order.dropPoint[0].dateTime)} - Drop-point ${dropPointIndex + 1}";
          _currentTel = order.dropPoint[0].contact;
          _currentAddress = order.dropPoint[0].address;
          _currentLatLng =
              LatLng(order.dropPoint[0].latitude, order.dropPoint[0].longitude);
          _currentRemark = order.dropPoint[0].comment;

          // invoke location tracing
          invokeTracking(order.user.userId);

          _notifyUpdateStatus(DeliveryStatus.MarkArrivedDropPoint);
        } else if (s == 2) {
          AppProvider.openCustomDialog(
            context,
            "Delivery Completed",
            "detailss",
            false,
          );

          // close the stream
          locationSubscription.cancel();
        }
      } else {
        print('====== fail to update status');
      }
    } catch (e) {
      print(e);
    }
  }

  Future invokeSendNotifications(String title, String fcmToken,
      {DeliveryStatus toUpdateStatus}) async {
    try {
      var body = {
        "fcmToken": fcmToken,
        "collapseKey": title,
        "title": title,
        "body": "Click enter the app for more info"
      };

      var res = await http.post(
        notificationPath,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer ${user.token}',
        },
        body: json.encode(body),
      );

      if (res.statusCode == 200) {
        if (toUpdateStatus != null) {
          _notifyUpdateStatus(toUpdateStatus);
        }
      } else {
        print('fail to send notification');
      }
    } catch (e) {
      print(e);
    }
  }

  void invokeTracking(int userId) {
    // start listening location changes
    _locationService.populateOnLocationChanged();

    // subscribe to the stream
    locationSubscription =
        _locationService.locationStream.listen((LocationModel d) async {
      await _locationService.sendLocation(d, userId);
    });
  }

  void showConfirmationDialog(
      BuildContext context, String text, AsyncCallback callback) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Theme(
        data: ThemeData(
          colorScheme: ColorScheme.light().copyWith(
            primary: Constant.primaryColor,
          ),
        ),
        child: AlertDialog(
          title: Text("Confirmation"),
          content: Text(text),
          actions: [
            FlatButton(
              onPressed: () => Navigator.of(_).pop(),
              child: Text('CANCEL'),
            ),
            FlatButton(
              onPressed: () async {
                await callback();
                Navigator.of(_).pop();
              },
              child: Text('YES'),
            )
          ],
        ),
      ),
    );
  }

  void _notifyUpdateStatus(DeliveryStatus status) {
    _status = status;
    notifyListeners();
  }

  void notifyNextDropPoint() {
    // indicate finish a dp
    dropPointIndex += 1;

    _clock =
        "${this.extractTimeFormat(order.dropPoint[dropPointIndex].dateTime)} - Drop-point ${dropPointIndex + 1}";
    _currentTel = order.dropPoint[dropPointIndex].contact;
    _currentAddress = order.dropPoint[dropPointIndex].address;
    _currentLatLng = LatLng(order.dropPoint[dropPointIndex].latitude,
        order.dropPoint[dropPointIndex].longitude);
    _currentRemark = order.dropPoint[dropPointIndex].comment;

    notifyListeners();
  }

  String extractTimeFormat(DateTime dt) {
    return DateFormat.jm().format(order.dateTime);
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
