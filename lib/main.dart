import 'package:delivery_courier_app/constant.dart';
import 'package:delivery_courier_app/pages/availableOrderPage.dart';
import 'package:delivery_courier_app/pages/landing.dart';
import 'package:delivery_courier_app/pages/loginPage.dart';
import 'package:delivery_courier_app/providers/appProvider.dart';
import 'package:delivery_courier_app/providers/userProvider.dart';
import 'package:delivery_courier_app/services/locationService.dart';
import 'package:delivery_courier_app/widgets/SplashScreen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_config/flutter_config.dart';

import 'package:provider/provider.dart';

import 'model/user.dart';

Future main() async {
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
        Provider<LocationService>(
          create: (_) => LocationService(),
          dispose: (_, v) => v.dispose(),
        ),
      ],
      child: MaterialApp(
        title: 'Delivery Courier App',
        theme: ThemeData(
          primaryColor: Constant.primaryColor,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider auth = Provider.of<UserProvider>(context);

    return StreamBuilder(
      stream: auth.validateAuthState(),
      builder: (_, AsyncSnapshot<User> snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text("Something went wrong")),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          switch (auth.status) {
            case Status.uninitialized:
              // show loading
              return const SplashScreen();

            case Status.unauthenticated:
              return LandingPage();

            case Status.authenticating:
              return LoginPage();

            case Status.authenticated:
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
        return const SplashScreen();
      },
    );
  }
}
