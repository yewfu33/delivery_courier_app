import 'package:delivery_courier_app/constant.dart';
import 'package:delivery_courier_app/helpers/screen_navigation.dart';
import 'package:delivery_courier_app/helpers/util.dart';
import 'package:delivery_courier_app/model/orderModel.dart';
import 'package:delivery_courier_app/providers/taskProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class OnTaskPage extends StatefulWidget {
  final OrderModel order;
  final String snackBarMessage;

  const OnTaskPage({
    Key key,
    @required this.order,
    this.snackBarMessage = "",
  }) : super(key: key);

  @override
  _OnTaskPageState createState() => _OnTaskPageState();
}

class _OnTaskPageState extends State<OnTaskPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.snackBarMessage.isNotEmpty) {
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(widget.snackBarMessage),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Order #${widget.order.orderId}"),
        leading: BackButton(
          onPressed: () {
            changeScreenReplacement(context, MyHomePage());
          },
        ),
        actions: [
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            bottom: MediaQuery.of(context).size.height * 0.4,
            child: BackPanel(order: widget.order),
          ),
          Positioned.fill(
            child: DraggableScrollableSheet(
              maxChildSize: 0.75,
              minChildSize: 0.45,
              initialChildSize: 0.7,
              builder: (context, scrollController) {
                return Panel(scrollController: scrollController);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BackPanel extends StatelessWidget {
  final OrderModel order;

  const BackPanel({Key key, @required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final map = Provider.of<TaskProvider>(context);

    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      rotateGesturesEnabled: true,
      markers: map.markers,
      polylines: map.poly,
      initialCameraPosition: CameraPosition(
        target: LatLng(order.latitude, order.longitude),
        zoom: 14.4746,
      ),
      onMapCreated: (GoogleMapController controller) async {
        await map.onMapCreate(controller);

        // center the view
        map.moveCameraBounds(
          LatLng(order.latitude, order.longitude),
          LatLng(order.dropPoint[0].latitude, order.dropPoint[0].longitude),
        );
      },
    );
  }
}

class Panel extends StatelessWidget {
  final ScrollController scrollController;

  const Panel({
    Key key,
    @required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyScrollBehavior(),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Material(
          elevation: 10,
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () {},
                  color: Constant.primaryColor,
                  child: Text(
                    'Mark Arrived Pickup',
                    // Start Delivery Task
                    // Mark Arrived DropPoint
                    // Complete task
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Info',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: GreyBoxContainer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.access_time),
                      const SizedBox(width: 8),
                      Text(
                        '3.50 PM - Pick-Up',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              UserInfoSection(),
              SignaturesSection(),
              PaymentSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class UserInfoSection extends StatelessWidget {
  const UserInfoSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.person),
                const SizedBox(width: 10),
                Text('David Smith'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.phone),
                const SizedBox(width: 10),
                Text('+60167970741'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Icon(Icons.location_on),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '5.13 & 5.14 5th Floor Wisma Central Jalan Ampang',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    softWrap: true,
                  ),
                ),
                // Container(
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: Colors.grey[300],
                //   ),
                //   child: IconButton(
                //     icon: Icon(Icons.near_me),
                //     onPressed: () {},
                //   ),
                // ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.event_note),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec feugiat elementum eros sed tincidunt. Praesent consequat consectetur justo, in elementum justo porta sed.',
                    softWrap: true,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Expanded(
                  child: FlatButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.call),
                    color: Colors.grey[300],
                    label: Text('Call'),
                  ),
                ),
                const VerticalDivider(),
                Expanded(
                  child: FlatButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.near_me),
                    color: Colors.grey[300],
                    label: Text('Direction'),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SignaturesSection extends StatelessWidget {
  const SignaturesSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        children: [
          GreyBoxContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Signatures',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                Icon(Icons.add, size: 24),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              Text('No Signature yet'),
            ],
          ),
        ],
      ),
    );
  }
}

class PaymentSection extends StatelessWidget {
  const PaymentSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        children: [
          GreyBoxContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payments',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Table(
              children: [
                TableRow(
                  children: [
                    CustomTableCell(content: Text('Your Commission')),
                    CustomTableCell(content: Text('Rm 4')),
                  ],
                ),
                TableRow(
                  children: [
                    CustomTableCell(content: Text('Payment Method')),
                    CustomTableCell(content: Text('Cash Payment')),
                  ],
                ),
                TableRow(
                  children: [
                    CustomTableCell(content: Text('Payment Status')),
                    CustomTableCell(content: Text('Pending')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          FlatButton.icon(
            onPressed: () {},
            icon: Icon(Icons.payment),
            color: Colors.grey[300],
            label: Text('Add Payment'),
          ),
        ],
      ),
    );
  }
}

class GreyBoxContainer extends StatelessWidget {
  final Widget child;

  const GreyBoxContainer({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: child,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
    );
  }
}

class CustomTableCell extends StatelessWidget {
  final Widget content;

  const CustomTableCell({Key key, @required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: SizedBox(
        height: 25,
        child: content,
      ),
    );
  }
}
