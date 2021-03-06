import 'package:delivery_courier_app/helpers/screen_navigation.dart';
import 'package:delivery_courier_app/helpers/util.dart';
import 'package:delivery_courier_app/model/enum.dart';
import 'package:delivery_courier_app/model/orderModel.dart';
import 'package:delivery_courier_app/model/user.dart';
import 'package:delivery_courier_app/model/userModel.dart';
import 'package:delivery_courier_app/pages/onTaskPage.dart';
import 'package:delivery_courier_app/providers/mapProvider.dart';
import 'package:delivery_courier_app/providers/taskProvider.dart';
import 'package:delivery_courier_app/widgets/DropOffSection.dart';
import 'package:delivery_courier_app/widgets/Loading.dart';
import 'package:delivery_courier_app/widgets/PickUpSection.dart';
import 'package:delivery_courier_app/widgets/PricingSection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant.dart';

class PickOrderDetail extends StatelessWidget {
  final OrderModel order;
  final ScrollController scrollController;
  final User user;
  final bool isRestoreOnTaskPage;

  const PickOrderDetail({
    Key key,
    @required this.order,
    @required this.scrollController,
    @required this.user,
    @required this.isRestoreOnTaskPage,
  }) : super(key: key);

  String setWeightDisplay(int weight) {
    switch (weight) {
      case 0:
        return '<10KG';
        break;
      case 10:
        return '>10KG';
        break;
      case 50:
        return '>50KG';
        break;
      default:
        return '<10KG';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyScrollBehavior(),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Material(
          elevation: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Divider(color: Colors.transparent, height: 5),
              if (order.status == DeliveryStatus.markArrivedPickUp)
                ActionButton(
                  order: order,
                  user: user,
                  checkIsRestoreOnTaskPage: isRestoreOnTaskPage,
                ),
              const Divider(color: Colors.transparent),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      DateFormat('dd MMM | h:mm a').format(order.dateTime),
                      // 'Today at 11.42 pm',
                      style: const TextStyle(
                        color: Constant.primaryColor,
                        fontSize: 20.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: <Widget>[
                        if (order.vehicleType == 0)
                          const FaIcon(FontAwesomeIcons.motorcycle, size: 20),
                        if (order.vehicleType == 1)
                          const FaIcon(FontAwesomeIcons.car, size: 20),
                        const SizedBox(width: 5),
                        Text(
                          '${setVehicleType(order.vehicleType)} (weight ${setWeightDisplay(order.weight.round())})',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(
                      order.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.3,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 7),
                  ],
                ),
              ),
              PriceSection(order: order),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.0),
                child: Divider(color: Colors.black, height: 5),
              ),
              UserInfoSection(user: order.user),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.0),
                child: Divider(color: Colors.black),
              ),
              //pickup location
              PickUpSection(order: order),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.0),
                child: Divider(color: Colors.black),
              ),
              //drop off location
              DropOffLocationSection(dp: order.dropPoint),
            ],
          ),
        ),
      ),
    );
  }
}

class UserInfoSection extends StatelessWidget {
  final UserModel user;

  const UserInfoSection({
    Key key,
    @required this.user,
  }) : super(key: key);

  Future<void> _makePhoneCall(String tel) async {
    if (await canLaunch(tel)) {
      await launch(tel);
    } else {
      print('Could not call $tel');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        radius: 20,
        child: Icon(
          Icons.person,
          size: 20,
        ),
      ),
      title: Text(
        user.name,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      trailing: FlatButton.icon(
        onPressed: () {
          _makePhoneCall("tel:+60${user.phoneNum}");
        },
        icon: const Icon(
          Icons.call,
          color: Colors.white,
          size: 20,
        ),
        color: Colors.green,
        textColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        label: const Text("Call"),
      ),
    );
  }
}

class ActionButton extends StatefulWidget {
  final OrderModel order;
  final User user;
  final bool checkIsRestoreOnTaskPage;

  const ActionButton({
    Key key,
    @required this.order,
    @required this.user,
    @required this.checkIsRestoreOnTaskPage,
  }) : super(key: key);

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  MapProvider model;
  bool loading = false;

  Future<bool> openConfimationDialog(BuildContext context) {
    return showDialog(
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
          content: const Text("Take the order?"),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(_, false);
              },
              child: const Text('CANCEL'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(_, true);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    model = Provider.of<MapProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: double.infinity,
      child: loading
          ? Loading()
          : (!widget.checkIsRestoreOnTaskPage)
              ? RaisedButton(
                  onPressed: () async {
                    final confirmation = await openConfimationDialog(context);

                    if (confirmation ?? false) {
                      setState(() => loading = true);
                      final isSuccessRegistered = await model.registerOrder(
                          context, widget.order.orderId, widget.user);

                      if (isSuccessRegistered) {
                        changeScreenReplacement(
                          context,
                          ChangeNotifierProvider(
                            create: (_) => TaskProvider(
                                markers: model.markers,
                                destination: model.destination,
                                origin: model.origin,
                                poly: model.poly,
                                user: widget.user,
                                order: widget.order),
                            builder: (_, __) {
                              return OnTaskPage(
                                order: widget.order,
                                snackBarMessage: "Successfully registered task",
                              );
                            },
                          ),
                        );
                      }
                    }
                    setState(() => loading = false);
                  },
                  color: Constant.primaryColor,
                  child: const Text(
                    'TAKE ORDER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      letterSpacing: 0.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : RaisedButton(
                  onPressed: () {
                    changeScreenReplacement(
                      context,
                      ChangeNotifierProvider(
                        create: (_) => TaskProvider(
                            markers: model.markers,
                            destination: model.destination,
                            origin: model.origin,
                            poly: model.poly,
                            user: widget.user,
                            order: widget.order),
                        builder: (_, __) {
                          return OnTaskPage(order: widget.order);
                        },
                      ),
                    );
                  },
                  color: Constant.primaryColor,
                  child: const Text(
                    'BACK TO TASK PAGE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      letterSpacing: 0.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
    );
  }
}
