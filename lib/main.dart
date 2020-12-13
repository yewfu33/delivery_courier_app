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

import 'model/user.dart';

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
    final UserProvider auth = Provider.of<UserProvider>(context, listen: false);

    return StreamBuilder(
      stream: auth.validateAuthState(),
      builder: (_, AsyncSnapshot<User> snapshot) {
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
              return const LoadingScaffold();

            case Status.Unauthenticated:
              return LandingPage();

            case Status.Authenticating:
              return LoginPage();

            case Status.Authenticated:
              return ChangeNotifierProvider.value(
                value: AppProvider.user(
                  user: snapshot.data,
                ),
                child: AvailableOrdersPage(),
              );

            default:
              return LandingPage();
          }
        }

        // Otherwise, show something while waiting for future to complete
        return const LoadingScaffold();
      },
    );
  }
}

// splash screen
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

class AvailableOrdersPage extends StatefulWidget {
  @override
  _AvailableOrdersPageState createState() => _AvailableOrdersPageState();
}

class _AvailableOrdersPageState extends State<AvailableOrdersPage> {
  @override
  Widget build(BuildContext context) {
    final AppProvider provider =
        Provider.of<AppProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pickup Order'),
        actions: <Widget>[
          Switch(
            value: true,
            onChanged: (_) {},
            activeColor: Colors.white,
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                    const Icon(Icons.format_line_spacing)
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  width: double.infinity,
                  child: StreamBuilder<List<OrderModel>>(
                      stream: provider.ordersStream(),
                      builder: (_, snapshot) {
                        // show loading during waiting state
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Constant.primaryColor),
                              ),
                            ),
                          );
                        } else {
                          if (snapshot.hasError) {
                            return Padding(
                              padding: const EdgeInsets.all(30),
                              child: Text(snapshot.error.toString()),
                            );
                          }

                          if (!snapshot.hasData || snapshot.data.length == 0)
                            return Padding(
                                padding: const EdgeInsets.all(30),
                                child: const Text(
                                    'No orders avaiable at the moment.'));

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: snapshot.data
                                .map((o) => PickOrderList(orderModel: o))
                                .toList(),
                          );
                        }
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
