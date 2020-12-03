import 'package:delivery_courier_app/helpers/screen_navigation.dart';
import 'package:delivery_courier_app/model/user.dart';
import 'package:delivery_courier_app/pages/onTaskPage.dart';
import 'package:delivery_courier_app/pages/settingsPage.dart';
import 'package:delivery_courier_app/providers/appProvider.dart';
import 'package:delivery_courier_app/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../constant.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = context.select<AppProvider, User>((p) => p.user);

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
                    radius: 25,
                    backgroundImage: user.profilePic?.isEmpty ?? true
                        ? AssetImage('assets/img/avatar.jpg')
                        : NetworkImage(Constant.imagePath + user.profilePic),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16.5,
                          ),
                        ),
                        const SizedBox(height: 2.5),
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
                  const Spacer(),
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
            DrawerListTile(
              onTap: null,
              text: "Pick-up",
              leading: FaIcon(FontAwesomeIcons.truckLoading),
            ),
            DrawerListTile(
              onTap: null,
              text: "Records",
              leading: FaIcon(FontAwesomeIcons.history),
            ),
            DrawerListTile(
              onTap: null,
              text: "Earnings",
              leading: FaIcon(FontAwesomeIcons.wallet),
            ),
            DrawerListTile(
              onTap: () {
                changeScreen(
                    context,
                    Provider<User>.value(
                      value: user,
                      builder: (_, __) => SettingsPage(),
                    ));
              },
              text: "Settings",
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

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key key,
    @required this.text,
    @required this.onTap,
    @required this.leading,
  }) : super(key: key);

  final String text;
  final VoidCallback onTap;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text),
      onTap: onTap,
      leading: leading,
    );
  }
}
