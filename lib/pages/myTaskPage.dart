import 'dart:convert';

import 'package:delivery_courier_app/model/orderModel.dart';
import 'package:delivery_courier_app/model/user.dart';
import 'package:delivery_courier_app/widgets/Loading.dart';
import 'package:delivery_courier_app/widgets/PickOrderList.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:http/http.dart' as http;
import '../constant.dart';

class MyTaskPage extends StatelessWidget {
  final User user;

  const MyTaskPage({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Tasks'),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text('Active', style: TextStyle(fontSize: 16)),
              ),
              Tab(
                child: Text('Completed', style: TextStyle(fontSize: 16)),
              ),
              Tab(
                child: Text('Cancelled', style: TextStyle(fontSize: 16)),
              ),
            ],
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            TaskList(
              status: 0,
              user: user,
            ),
            TaskList(
              status: 2,
              user: user,
            ),
            TaskList(
              status: 3,
              user: user,
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Expanded(flex: 2, child: SizedBox()),
          SizedBox(
            width: 50.0,
            height: 60.0,
            child: FaIcon(
              FontAwesomeIcons.folderOpen,
              size: 40,
              color: Colors.grey[500],
            ),
          ),
          Text(
            'No task found',
            style: TextStyle(fontSize: 14.0, color: Colors.grey[500]),
          ),
          const Expanded(flex: 3, child: SizedBox()),
        ],
      ),
    );
  }
}

class TaskList extends StatefulWidget {
  final int status;
  final User user;

  const TaskList({
    Key key,
    @required this.status,
    @required this.user,
  }) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final path = "${Constant.serverName}${Constant.orderPath}/task/courier/";

  Future<List<OrderModel>> _orders;

  @override
  void initState() {
    super.initState();
    _orders = fetchTasks();
  }

  Future<List<OrderModel>> fetchTasks() async {
    final String query = [
      'status=${widget.status}',
    ].join('&');

    try {
      final http.Response res = await http.post(
        '$path${widget.user.id}${'?$query'}',
        headers: {
          'Authorization': 'Bearer ${widget.user.token}',
        },
      );

      if (res.statusCode == 200) {
        return _setOrderModel(res.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  List<OrderModel> _setOrderModel(String jsonBody) {
    final List body = json.decode(jsonBody) as List;
    return body
        .map<OrderModel>((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderModel>>(
      initialData: const [],
      future: _orders,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Loading());
        }

        if (!snapshot.hasData || snapshot.data.isEmpty) return EmptyTask();

        return ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
          itemCount: snapshot.data.length,
          itemBuilder: (_, i) {
            return PickOrderList(
              orderModel: snapshot.data[i],
              user: widget.user,
              isRestoreOnTaskPage: true,
            );
          },
          separatorBuilder: (_, __) {
            return const Divider(color: Colors.transparent);
          },
        );
      },
    );
  }
}

// class PickDropShowCase extends StatelessWidget {
//   const PickDropShowCase({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           height: 100,
//           width: 10,
//           child: Column(
//             children: [
//               Icon(
//                 Icons.location_on,
//                 color: Colors.grey,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 9),
//                 child: Container(
//                   height: 45,
//                   width: 2,
//                   color: Colors.grey,
//                 ),
//               ),
//               Icon(Icons.flag),
//             ],
//           ),
//         ),
//         SizedBox(width: 30),
//         Expanded(
//           child: Container(
//             height: 100,
//             child: Column(
//               children: [
//                 Text(
//                   '20, Jalan Pulai Harmoni 4, Bandar Baru Kangkar Pulai, 81110 Johor Bahru, Johor, Malaysia',
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   softWrap: true,
//                   style: TextStyle(fontSize: 14),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   '20, Jalan Pulai Harmoni 4, Bandar Baru Kangkar Pulai, 81110 Johor Bahru, Johor, Malaysia',
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   softWrap: true,
//                   style: TextStyle(fontSize: 14),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
