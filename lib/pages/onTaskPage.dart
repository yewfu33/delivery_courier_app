import 'package:delivery_courier_app/constant.dart';
import 'package:delivery_courier_app/helpers/screen_navigation.dart';
import 'package:delivery_courier_app/helpers/util.dart';
import 'package:delivery_courier_app/model/enum.dart';
import 'package:delivery_courier_app/model/orderModel.dart';
import 'package:delivery_courier_app/providers/taskProvider.dart';
import 'package:delivery_courier_app/widgets/GreyBoxContainer.dart';
import 'package:delivery_courier_app/widgets/PaymentSection.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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

  void showCancelOrderConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Theme(
        data: ThemeData(
          colorScheme: const ColorScheme.light().copyWith(
            primary: Constant.primaryColor,
          ),
        ),
        child: AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Cancel the delivery order?"),
          actions: [
            FlatButton(
              onPressed: () => Navigator.of(_).pop(),
              child: const Text('NO'),
            ),
            FlatButton(
              onPressed: () async {
                await Provider.of<TaskProvider>(context, listen: false)
                    .cancelDeliveryOrder(_);
              },
              child: const Text('YES'),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TaskProvider>(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Order #${widget.order.orderId}"),
        leading: BackButton(
          onPressed: () {
            if (model.isCancelable) {
              changeScreenReplacement(context, MyHomePage());
            } else {
              showCancelOrderConfirmation(context);
            }
          },
        ),
        actions: [
          PopupMenuButton(
            onSelected: (_) {
              showCancelOrderConfirmation(context);
            },
            offset: const Offset(0, 40),
            itemBuilder: (_) {
              return [
                const PopupMenuItem(
                  value: true,
                  child: Text('Cancel Delivery Order'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            bottom: MediaQuery.of(context).size.height * 0.4,
            child: BackPanel(order: widget.order, map: model),
          ),
          Positioned.fill(
            child: DraggableScrollableSheet(
              maxChildSize: 0.75,
              minChildSize: 0.45,
              initialChildSize: 0.7,
              builder: (context, scrollController) {
                return Panel(
                  scrollController: scrollController,
                  order: widget.order,
                );
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
  final TaskProvider map;

  const BackPanel({
    Key key,
    @required this.order,
    @required this.map,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationEnabled: true,
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
  final OrderModel order;
  final ScrollController scrollController;

  const Panel({
    Key key,
    @required this.scrollController,
    @required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<TaskProvider>(context);

    return ScrollConfiguration(
      behavior: MyScrollBehavior(),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Material(
          elevation: 10,
          child: Column(
            children: [
              UpdateStatusButton(
                status: p.status,
                currentDropPointIndex: p.dropPointIndex,
                dpLength: p.dpLength,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  children: const [
                    Text(
                      'Delivery Info',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: GreyBoxContainer(
                  child: Row(
                    children: [
                      const Icon(Icons.access_time),
                      const SizedBox(width: 8),
                      Text(
                        p.clock,
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
              UserInfoSection(
                name: order.user.name,
                address: p.currentAddress,
                phoneNum: p.currentTel,
                remark: p.currentRemark,
                latLng: p.currentLatLng,
              ),
              //   SignaturesSection(),
              PaymentSection(user: p.user, order: order),
            ],
          ),
        ),
      ),
    );
  }
}

class UpdateStatusButton extends StatelessWidget {
  final DeliveryStatus status;
  final int currentDropPointIndex;
  final int dpLength;

  const UpdateStatusButton({
    Key key,
    @required this.status,
    @required this.currentDropPointIndex,
    @required this.dpLength,
  }) : super(key: key);

  static const style = TextStyle(
    color: Colors.white,
    fontSize: 16,
    letterSpacing: 1,
  );

  @override
  Widget build(BuildContext context) {
    final task = Provider.of<TaskProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      width: double.infinity,
      child: Builder(
        builder: (_) {
          switch (status) {
            case DeliveryStatus.markArrivedPickUp:
              return RaisedButton(
                onPressed: () {
                  task.showConfirmationDialog(
                    _,
                    "Mark arrived pick up?",
                    () => task.invokeSendNotifications(
                      "Courier have arrived your pick up",
                      toUpdateStatus: DeliveryStatus.startDeliveryTask,
                    ),
                  );
                },
                color: Constant.primaryColor,
                child: const Text('Mark Arrived Pickup', style: style),
              );
              break;
            case DeliveryStatus.startDeliveryTask:
              return RaisedButton(
                onPressed: () {
                  if (!task.addedPayment) {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => Theme(
                        data: ThemeData(
                          colorScheme: const ColorScheme.light().copyWith(
                            primary: Constant.primaryColor,
                          ),
                        ),
                        child: AlertDialog(
                          title: const Text("Alert"),
                          content: const Text(
                              "Be sure collected cash payment from user before start the delivery task."),
                          actions: [
                            FlatButton(
                              onPressed: () {
                                Navigator.of(_).pop();
                              },
                              child: const Text('OK'),
                            )
                          ],
                        ),
                      ),
                    );

                    return;
                  }
                  task.showConfirmationDialog(_, "Start the delivery task?",
                      () => task.updateDeliveryStatus(1));
                },
                color: Constant.primaryColor,
                child: const Text('Start Delivery Task', style: style),
              );
              break;
            case DeliveryStatus.markArrivedDropPoint:
              return RaisedButton(
                onPressed: () {
                  task.showConfirmationDialog(_, "Mark arrived a drop point?",
                      () async {
                    if (currentDropPointIndex + 1 >= dpLength) {
                      return task.invokeSendNotifications(
                        "Courier have arrived a drop point",
                        toUpdateStatus: DeliveryStatus.completeDelivery,
                      );
                    } else {
                      // indicate move on to next dp
                      task.notifyNextDropPoint();

                      return task.invokeSendNotifications(
                          "Courier have arrived a drop point");
                    }
                  });
                },
                color: Constant.primaryColor,
                child: const Text('Mark Arrived DropPoint', style: style),
              );
              break;
            case DeliveryStatus.completeDelivery:
              return RaisedButton(
                onPressed: () => task.updateDeliveryStatus(2, context: _),
                color: Constant.primaryColor,
                child: const Text('Mark Complete Delivery', style: style),
              );
              break;
            default:
              return const Text("error.");
          }
        },
      ),
    );
  }
}

class UserInfoSection extends StatelessWidget {
  final String name;
  final String phoneNum;
  final String address;
  final String remark;
  final LatLng latLng;

  const UserInfoSection({
    Key key,
    @required this.name,
    @required this.phoneNum,
    @required this.address,
    @required this.remark,
    @required this.latLng,
  }) : super(key: key);

  Future _makePhoneCall(String tel) async {
    if (await canLaunch(tel)) {
      await launch(tel);
    } else {
      print('Could not call $tel');
    }
  }

  Future _launchMap(double lat, double lng) async {
    final googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng';

    final String encodedURl = Uri.encodeFull(googleMapsUrl);

    if (await canLaunch(encodedURl)) {
      await launch(encodedURl);
    } else {
      print('Could not launch map');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                const Icon(Icons.person),
                const SizedBox(width: 10),
                Text(name),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                const Icon(Icons.phone),
                const SizedBox(width: 10),
                Text('+60$phoneNum'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                const Icon(Icons.location_on),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    address,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                const Icon(Icons.event_note),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    (remark.isEmpty) ? "-" : remark,
                    softWrap: true,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: FlatButton.icon(
                  onPressed: () {
                    _makePhoneCall('tel:+60$phoneNum');
                  },
                  icon: const Icon(Icons.call),
                  color: Colors.grey[300],
                  label: const Text('Call'),
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: FlatButton.icon(
                  onPressed: () {
                    _launchMap(latLng.latitude, latLng.longitude);
                  },
                  icon: const Icon(Icons.near_me),
                  color: Colors.grey[300],
                  label: const Text('Direction'),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
