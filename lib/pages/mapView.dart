import 'package:delivery_courier_app/model/orderModel.dart';
import 'package:delivery_courier_app/model/user.dart';
import 'package:delivery_courier_app/pages/orderDetail.dart';
import 'package:delivery_courier_app/providers/mapProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';

class MapView extends StatelessWidget {
  const MapView({
    Key key,
    @required this.user,
    @required this.isRestoreOnTaskPage,
  }) : super(key: key);

  final User user;
  final bool isRestoreOnTaskPage;

  @override
  Widget build(BuildContext context) {
    final OrderModel order =
        ModalRoute.of(context).settings.arguments as OrderModel;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('Order #${order.orderId}'),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: ChangeNotifierProvider.value(
        value: MapProvider.init(
          LatLng(order.latitude, order.longitude),
          order.dropPoint
              .map((dp) => LatLng(dp.latitude, dp.longitude))
              .toList(),
        ),
        child: Stack(
          children: [
            Consumer<MapProvider>(
              builder: (context, map, _) {
                return Positioned.fill(
                  bottom: MediaQuery.of(context).size.height * 0.4,
                  child: GoogleMap(
                    myLocationEnabled: true,
                    markers: map.markers,
                    polylines: map.poly,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(order.latitude, order.longitude),
                      zoom: 15,
                    ),
                    onMapCreated: (controller) {
                      map.onMapCreate(controller);
                      // animate camera focus center
                      map.moveCameraBounds(
                        LatLng(order.latitude, order.longitude),
                        LatLng(order.dropPoint[0].latitude,
                            order.dropPoint[0].longitude),
                      );
                    },
                  ),
                );
              },
            ),
            Positioned.fill(
              child: DraggableScrollableSheet(
                maxChildSize: 0.75,
                minChildSize: 0.45,
                initialChildSize: 0.7,
                builder: (_, scrollController) {
                  return PickOrderDetail(
                    order: order,
                    scrollController: scrollController,
                    user: user,
                    isRestoreOnTaskPage: isRestoreOnTaskPage,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
