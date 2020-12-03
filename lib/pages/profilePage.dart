import 'package:delivery_courier_app/model/user.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key key, @required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          FlatButton(
            onPressed: () {},
            child: Text('Edit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundImage: user.profilePic?.isEmpty ?? true
                          ? AssetImage('assets/img/avatar.jpg')
                          : NetworkImage(Constant.imagePath + user.profilePic),
                    ),
                    const SizedBox(height: 5),
                    const OnlineIndicator(),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 5),
                    child: Text(
                      'Information'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    color: Colors.white,
                    child: Column(
                      children: [
                        ProfileListTile(title: 'Name', value: user.name),
                        ProfileListTile(
                            title: 'Phone Number',
                            value: '+60 ${user.phoneNum}'),
                        ProfileListTile(title: 'Email', value: user.email),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnlineIndicator extends StatelessWidget {
  const OnlineIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 4),
        Text('Online'),
      ],
    );
  }
}

class OfflineIndicator extends StatelessWidget {
  const OfflineIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Constant.primaryColor,
          ),
        ),
        const SizedBox(width: 4),
        Text('Offline'),
      ],
    );
  }
}

class ProfileListTile extends StatelessWidget {
  const ProfileListTile({
    Key key,
    @required this.title,
    @required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        title,
        style: TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Text(
        value,
        style: TextStyle(fontSize: 15.5),
      ),
    );
  }
}
