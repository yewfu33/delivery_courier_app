import 'package:delivery_courier_app/model/orderModel.dart';
import 'package:delivery_courier_app/pages/orderDetail.dart';
import 'package:delivery_courier_app/viewModel/orderDetailViewModel.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';

class MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final OrderModel order = ModalRoute.of(context).settings.arguments;

    return new Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        // elevation: 1.0,
        leading: BackButton(),
        title: Text('Order #${order.orderId}'),
        actions: [
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      //   floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      body: ChangeNotifierProvider(
        create: (_) => OrderDetailViewModel.initRoute(
          LatLng(order.latitude, order.longitude),
          order.dropPoint
              .map((dp) => LatLng(dp.latitude, dp.longitude))
              .toList(),
        ),
        child: Stack(
          children: [
            Consumer<OrderDetailViewModel>(builder: (context, model, _) {
              return Positioned.fill(
                bottom: MediaQuery.of(context).size.height * 0.4,
                child: GoogleMap(
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  compassEnabled: true,
                  rotateGesturesEnabled: true,
                  markers: Set<Marker>.of(model.markers.values),
                  polylines: Set<Polyline>.of(model.polylines.values),
                  initialCameraPosition: CameraPosition(
                    target: LatLng(order.latitude, order.longitude),
                    zoom: 15,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    if (model.controller.isCompleted) return;
                    model.controller.complete(controller);
                  },
                ),
              );
            }),
            Positioned.fill(
              child: DraggableScrollableSheet(
                maxChildSize: 0.7,
                minChildSize: 0.45,
                initialChildSize: 0.6,
                builder: (context, scrollController) {
                  return PickOrderDetail(
                      order: order, scrollController: scrollController);
                },
              ),
            ),
          ],
        ),
      ),
      //   floatingActionButton: FloatingActionButton.extended(
      //     onPressed: () {},
      //     label: Text('TAKE ORDER'),
      //     elevation: 0,
      //     shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.all(Radius.circular(2))),
      //     icon: FaIcon(FontAwesomeIcons.stackOverflow),
      //   ),
    );
  }
}
