import 'package:delivery_courier_app/constant.dart';
import 'package:delivery_courier_app/model/orderModel.dart';
import 'package:delivery_courier_app/pages/landing.dart';
import 'package:delivery_courier_app/pages/loginPage.dart';
import 'package:delivery_courier_app/pages/mapView.dart';
import 'package:delivery_courier_app/providers/appProvider.dart';
import 'package:delivery_courier_app/providers/userProvider.dart';
import 'package:delivery_courier_app/route.dart';
import 'package:delivery_courier_app/widgets/Drawer.dart';
import 'package:delivery_courier_app/widgets/PickOrderList.dart';
import 'package:flutter/material.dart';

import 'package:flutter_config/flutter_config.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // obtain .env variables
  await FlutterConfig.loadEnvVariables();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>.value(
            value: UserProvider.initialize()),
      ],
      child: MaterialApp(
        title: 'Delivery Courier App',
        theme: ThemeData(
          primaryColor: Constant.primaryColor,
        ),
        home: MyHomePage(),
        routes: {
          Router.detailsPage: (context) => MapView(),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserProvider auth = Provider.of<UserProvider>(context);

    return FutureBuilder(
      future: auth.initUser,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Something went wrong")),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          switch (auth.status) {
            case Status.Uninitialized:
              // show loading
              return LoadingScaffold();

            case Status.Unauthenticated:
              return LandingPage();

            case Status.Authenticating:
              return LoginPage();

            case Status.Authenticated:
              return ChangeNotifierProvider.value(
                value: AppProvider.user(
                    user: Provider.of<UserProvider>(context).user),
                child: AvailableOrdersPage(),
              );

            default:
              return LandingPage();
          }
        }

        // Otherwise, show something while waiting for future to complete
        return LoadingScaffold();
      },
    );
  }
}

class LoadingScaffold extends StatelessWidget {
  const LoadingScaffold({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Constant.primaryColor),
        ),
      ),
    );
  }
}

class AvailableOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppProvider provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pickup available orders'),
        actions: <Widget>[
          Switch(
            value: true,
            onChanged: (_) {},
            activeColor: Colors.white,
          ),
        ],
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: ConstrainedBox(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: Container(
          height: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      //   'Web, 1 August',
                      DateFormat('EEEE, dd MMM').format(DateTime.now()),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(Icons.filter_list)
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    /// todo refresh
                  },
                  child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height),
                      child: Container(
                        width: double.infinity,
                        child: FutureBuilder<List<OrderModel>>(
                            future: provider.orders,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting)
                                return Padding(
                                  padding: const EdgeInsets.only(top: 25),
                                  child: const Center(
                                      child: CircularProgressIndicator()),
                                );

                              final orders = snapshot.data;

                              if (orders == null || orders.length == 0)
                                return Padding(
                                    padding: const EdgeInsets.all(30),
                                    child: const Text(
                                        'No orders avaiable at the moment.'));
                              else
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: orders
                                      .map((o) => PickOrderList(orderModel: o))
                                      .toList(),
                                );
                            }),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
