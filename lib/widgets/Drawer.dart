import 'package:delivery_courier_app/helpers/screen_navigation.dart';
import 'package:delivery_courier_app/pages/onTaskPage.dart';
import 'package:delivery_courier_app/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../constant.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.10,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Constant.primaryColor,
                    child: FaIcon(
                      FontAwesomeIcons.userShield,
                      size: 20,
                    ),
                    radius: 26,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Yew Fu',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16.5,
                          ),
                        ),
                        SizedBox(height: 2.5),
                        Text(
                          'ON DUTY', // off
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Switch.adaptive(
                    value: true,
                    onChanged: (v) {},
                    activeColor: Constant.primaryColor,
                  )
                ],
              ),
            ),
            Divider(
              thickness: 10,
              color: Colors.grey[200],
            ),
            ListTile(
              title: Text("Pick-up"),
              leading: FaIcon(FontAwesomeIcons.truckLoading),
            ),
            ListTile(
              title: Text("Records"),
              leading: FaIcon(FontAwesomeIcons.history),
            ),
            ListTile(
              title: Text("Earnings"),
              leading: FaIcon(FontAwesomeIcons.wallet),
            ),
            ListTile(
              title: Text("Settings"),
              leading: FaIcon(FontAwesomeIcons.slidersH),
            ),
            ListTile(
              title: FlatButton(
                onPressed: () {
                  changeScreen(context, OnTaskPage());
                },
                child: Text('ontaskpage'),
              ),
            ),
            ListTile(
              title: FlatButton(
                onPressed: () async {
                  await Provider.of<UserProvider>(context, listen: false)
                      .signOut();
                },
                child: Text('logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
