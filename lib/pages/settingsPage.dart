import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_courier_app/helpers/screen_navigation.dart';
import 'package:delivery_courier_app/model/user.dart';
import 'package:delivery_courier_app/pages/profilePage.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class SettingsPage extends StatelessWidget {
  final User user;

  const SettingsPage({Key key, @required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    const Widget _rightArrow = Icon(Icons.chevron_right, size: 26);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              onTap: () {
                changeScreen(context, ProfilePage(user: user));
              },
              leading: CircleAvatar(
                radius: 22,
                backgroundImage: (user.profilePic?.isEmpty ?? true)
                    ? const AssetImage('assets/img/avatar.jpg')
                    : CachedNetworkImageProvider(Constant.serverName +
                        Constant.imagePath +
                        user.profilePic) as ImageProvider,
              ),
              title: Text(user.name),
              subtitle: const Text('click to enter profile'),
              trailing: IconButton(
                onPressed: () {},
                icon: _rightArrow,
              ),
            ),
            const Divider(),
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
