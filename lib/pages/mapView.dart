import 'package:delivery_courier_app/model/orderModel.dart';
import 'package:delivery_courier_app/pages/orderDetail.dart';
import 'package:delivery_courier_app/providers/mapProvider.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';

class MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List arguments = ModalRoute.of(context).settings.arguments;
    final OrderModel order = arguments[0];
    final BuildContext appProviderContext = arguments[1];

    return new Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        // elevation: 1.0,
        leading: const BackButton(),
        title: Text('Order #${order.orderId}'),
        actions: [
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
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
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    compassEnabled: true,
                    rotateGesturesEnabled: true,
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
                    appProviderContext: appProviderContext,
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
