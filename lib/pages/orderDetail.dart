import 'package:delivery_courier_app/helpers/screen_navigation.dart';
import 'package:delivery_courier_app/helpers/util.dart';
import 'package:delivery_courier_app/model/dropPointModel.dart';
import 'package:delivery_courier_app/model/enum.dart';
import 'package:delivery_courier_app/model/orderModel.dart';
import 'package:delivery_courier_app/model/userModel.dart';
import 'package:delivery_courier_app/pages/onTaskPage.dart';
import 'package:delivery_courier_app/providers/appProvider.dart';
import 'package:delivery_courier_app/providers/mapProvider.dart';
import 'package:delivery_courier_app/providers/taskProvider.dart';
import 'package:delivery_courier_app/styleScheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constant.dart';

class PickOrderDetail extends StatelessWidget {
  final OrderModel order;
  final ScrollController scrollController;
  final BuildContext appProviderContext;

  const PickOrderDetail({
    Key key,
    @required this.order,
    @required this.scrollController,
    @required this.appProviderContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyScrollBehavior(),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Material(
          elevation: 10,
          child: Container(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Divider(color: Colors.transparent, height: 5),
                      if (order.status == DeliveryStatus.MarkArrivedPickUp)
                        ActionButton(
                          order: order,
                          appProviderContext: appProviderContext,
                        ),
                      const Divider(color: Colors.transparent),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'RM 30',
                              style: TextStyle(
                                color: Constant.primaryColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Today at ${DateFormat('h:mm a').format(order.dateTime)}",
                              // 'Today at 11.42 pm',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              order.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            if (order.vehicleType == 0)
                              FaIcon(
                                FontAwesomeIcons.motorcycle,
                                color: Constant.primaryColor,
                              ),
                            if (order.vehicleType == 1)
                              FaIcon(
                                FontAwesomeIcons.car,
                                color: Constant.primaryColor,
                              ),
                            const SizedBox(width: 10),
                            Text(
                              'By ${setVehicleType(order.vehicleType)}',
                              style: const TextStyle(
                                color: Constant.primaryColor,
                                fontSize: 15.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Divider(color: Colors.black),
                ),
                UserInfoSection(user: order.user),
                const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: const Divider(color: Colors.black),
                ),
                //pickup location
                PickUpSection(order: order),
                const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: const Divider(color: Colors.black),
                ),
                //drop off location
                DropOffLocationSection(dp: order.dropPoint),
                // ActionButtonSection(),
              ],
            ),
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        child: const CircleAvatar(
          radius: 20,
          child: Icon(
            Icons.person,
            size: 20,
          ),
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
      trailing: Container(
        child: CircleAvatar(
          backgroundColor: Colors.green[400],
          radius: 20,
          child: Icon(
            Icons.call,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatefulWidget {
  final OrderModel order;
  final BuildContext appProviderContext;
  const ActionButton({
    Key key,
    @required this.order,
    @required this.appProviderContext,
  }) : super(key: key);

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  Future<bool> openConfimationDialog(BuildContext context) {
    return showDialog(
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
          content: Text("Take the order?"),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(_, false);
              },
              child: Text('CANCEL'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(_, true);
              },
              child: Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MapProvider model = Provider.of<MapProvider>(context, listen: false);
    final AppProvider app =
        Provider.of<AppProvider>(widget.appProviderContext, listen: false);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: double.infinity,
      child: RaisedButton(
        onPressed: () async {
          var confirmation = await openConfimationDialog(context);
          if (confirmation ?? false) {
            var isSuccessRegistered = await model.registerOrder(
                context, widget.order.orderId, app.user);

            if (isSuccessRegistered) {
              changeScreenReplacement(
                context,
                ChangeNotifierProvider(
                  create: (_) => TaskProvider(
                      markers: model.markers,
                      destination: model.destination,
                      origin: model.origin,
                      poly: model.poly,
                      user: app.user,
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
        },
        color: Constant.primaryColor,
        child: Text(
          'TAKE ORDER',
          style: contentStyle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class PickUpSection extends StatelessWidget {
  final OrderModel order;
  const PickUpSection({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MapProvider model = Provider.of<MapProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Text(
              'Pickup Location',
              style: TextStyle(
                color: Constant.primaryColor,
                letterSpacing: 0.4,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Stepper(
            physics: NeverScrollableScrollPhysics(),
            controlsBuilder: (BuildContext context,
                    {VoidCallback onStepContinue, VoidCallback onStepCancel}) =>
                Container(),
            currentStep: 0,
            onStepTapped: (index) {
              model.onTapPickUpLocation();
            },
            steps: [
              Step(
                isActive: true,
                title: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.76,
                  child: Text(
                    order.address,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: const TextStyle(height: 1.3, letterSpacing: 0.3),
                  ),
                ),
                subtitle: Text(
                    "Today at ${DateFormat('h:mm a').format(order.dateTime)}"),
                content: Container(
                  padding: const EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FlatButton(
                        color: Colors.grey[300],
                        onPressed: () {},
                        child: Text('Call +60 ${order.contact}'),
                      ),
                      const SizedBox(height: 3),
                      (order.comment.isNotEmpty)
                          ? Text(order.comment)
                          : SizedBox.shrink(),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Row(
                          children: <Widget>[
                            const FaIcon(
                              FontAwesomeIcons.wallet,
                            ),
                            const SizedBox(width: 6),
                            const Text('Payment at this address'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class DropOffLocationSection extends StatefulWidget {
  final List<DropPointModel> dp;

  const DropOffLocationSection({Key key, this.dp}) : super(key: key);

  @override
  _DropOffLocationSectionState createState() => _DropOffLocationSectionState();
}

class _DropOffLocationSectionState extends State<DropOffLocationSection> {
  int _step = 0;

  @override
  Widget build(BuildContext context) {
    final MapProvider model = Provider.of<MapProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Text(
              'Drop Off Location (${widget.dp.length})',
              style: TextStyle(
                color: Constant.primaryColor,
                letterSpacing: 0.4,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Stepper(
            physics: NeverScrollableScrollPhysics(),
            controlsBuilder: (_,
                    {VoidCallback onStepContinue, VoidCallback onStepCancel}) =>
                Container(),
            currentStep: _step,
            onStepTapped: (int i) {
              setState(() => _step = i);
              model.onTapDropOffLocation(i);
            },
            steps: [
              for (var i = 0; i < widget.dp.length; i++)
                Step(
                  isActive: true,
                  title: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.76,
                    child: Text(
                      widget.dp[i].address,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: const TextStyle(height: 1.3, letterSpacing: 0.3),
                    ),
                  ),
                  subtitle: Text(DateFormat('dd MMM yyyy h:mm a')
                      .format(widget.dp[i].dateTime)),
                  content: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FlatButton(
                          color: Colors.grey[300],
                          onPressed: () {},
                          child: Text('Call +60 ${widget.dp[i].contact}'),
                        ),
                        const SizedBox(height: 3),
                        (widget.dp[i].comment.isNotEmpty)
                            ? Text(widget.dp[i].comment)
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}
