import 'package:delivery_courier_app/model/orderModel.dart';
import 'package:delivery_courier_app/providers/appProvider.dart';
import 'package:delivery_courier_app/widgets/Drawer.dart';
import 'package:delivery_courier_app/widgets/PickOrderList.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constant.dart';

class AvailableOrdersPage extends StatefulWidget {
  @override
  _AvailableOrdersPageState createState() => _AvailableOrdersPageState();
}

class _AvailableOrdersPageState extends State<AvailableOrdersPage> {
  @override
  Widget build(BuildContext context) {
    final AppProvider provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickup Order'),
        actions: <Widget>[
          Switch(
            value: true,
            onChanged: (_) {},
            activeColor: Colors.white,
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
            child: Row(
              children: <Widget>[
                Text(
                  //   'Web, 1 August',
                  DateFormat('EEEE, dd MMM').format(DateTime.now()),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<OrderModel>>(
              stream: provider.ordersStream(),
              builder: (_, snapshot) {
                // show loading during waiting state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Constant.primaryColor),
                        ),
                      ),
                    ],
                  );
                }

                if (snapshot.hasError) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: Text(snapshot.error.toString())),
                    ],
                  );
                }

                if (!snapshot.hasData || snapshot.data.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Center(child: Text('No orders avaiable at the moment.')),
                    ],
                  );
                }

                // finally show the order list
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        vertical: 13, horizontal: 12),
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, i) {
                      return PickOrderList(
                        orderModel: snapshot.data[i],
                        user: provider.user,
                      );
                    },
                    separatorBuilder: (_, __) {
                      return const Divider(color: Colors.transparent);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
