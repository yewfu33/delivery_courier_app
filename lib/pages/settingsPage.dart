import 'package:delivery_courier_app/helpers/screen_navigation.dart';
import 'package:delivery_courier_app/model/user.dart';
import 'package:delivery_courier_app/pages/profilePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);

    const Widget _rightArrow = Icon(Icons.chevron_right, size: 26);

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              onTap: () {
                changeScreen(context, ProfilePage(user: user));
              },
              leading: CircleAvatar(
                radius: 22,
                backgroundImage: user.profilePic?.isEmpty ?? true
                    ? AssetImage('assets/img/avatar.jpg')
                    : NetworkImage(Constant.imagePath + user.profilePic),
              ),
              title: Text(user.name),
              subtitle: Text('online'),
              trailing: IconButton(
                onPressed: () {},
                icon: _rightArrow,
              ),
            ),
            const Divider(),
            const SettingsListTile(
              rightArrow: _rightArrow,
              icon: Icons.drive_eta,
              title: 'Vehicle Management',
              bgColor: Constant.primaryColor,
            ),
            const SettingsListTile(
              rightArrow: _rightArrow,
              icon: Icons.notifications,
              title: 'Notification',
              bgColor: Colors.pink,
            ),
            const SettingsListTile(
              rightArrow: _rightArrow,
              icon: Icons.security,
              title: 'Terms and Privacy Policy',
              bgColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    Key key,
    @required Widget rightArrow,
    @required this.title,
    @required this.icon,
    @required this.bgColor,
  })  : _rightArrow = rightArrow,
        super(key: key);

  final Widget _rightArrow;
  final String title;
  final IconData icon;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: bgColor,
        ),
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(title),
      trailing: IconButton(
        onPressed: () {},
        icon: _rightArrow,
      ),
    );
  }
}
