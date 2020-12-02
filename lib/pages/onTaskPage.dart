import 'package:delivery_courier_app/constant.dart';
import 'package:delivery_courier_app/helpers/util.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OnTaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order #123"),
        actions: [
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            bottom: MediaQuery.of(context).size.height * 0.4,
            child: BackPanel(),
          ),
          Positioned.fill(
            child: DraggableScrollableSheet(
              maxChildSize: 0.75,
              minChildSize: 0.45,
              initialChildSize: 0.7,
              builder: (context, scrollController) {
                return Panel(scrollController: scrollController);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BackPanel extends StatelessWidget {
  final GoogleMapController controller;

  const BackPanel({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(37.42796133580664, -122.085749655962),
        zoom: 14.4746,
      ),
      onMapCreated: (GoogleMapController controller) {
        controller = controller;
      },
    );
  }
}

class Panel extends StatelessWidget {
  final ScrollController scrollController;

  const Panel({
    Key key,
    @required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyScrollBehavior(),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Material(
          elevation: 10,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () {},
                  color: Constant.primaryColor,
                  child: Text(
                    'Mark Arrived Pickup',
                    // Start Delivery Task
                    // Mark Arrived DropPoint
                    // Complete task
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Info',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: GreyBoxContainer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time),
                      SizedBox(width: 8),
                      Text(
                        '3.50 PM - Pick-Up',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.person),
                          SizedBox(width: 10),
                          Text('David Smith'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.phone),
                          SizedBox(width: 10),
                          Text('+60167970741'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(Icons.location_on),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '5.13 & 5.14 5th Floor Wisma Central Jalan Ampang',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              softWrap: true,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[300],
                            ),
                            child: IconButton(
                              icon: Icon(Icons.near_me),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: FlatButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.call),
                              color: Colors.grey[300],
                              label: Text('Call'),
                            ),
                          ),
                          VerticalDivider(),
                          Expanded(
                            child: FlatButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.message),
                              color: Colors.grey[300],
                              label: Text('Message'),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  children: [
                    GreyBoxContainer(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Signatures',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          Icon(Icons.add, size: 24),
                        ],
                      ),
                    ),
                    SizedBox(height: 14),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Text('No Signature yet'),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  children: [
                    GreyBoxContainer(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Payments',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              CustomTableCell(content: Text('Your Commission')),
                              CustomTableCell(content: Text('Rm 4')),
                            ],
                          ),
                          TableRow(
                            children: [
                              CustomTableCell(content: Text('Payment Method')),
                              CustomTableCell(content: Text('Cash Payment')),
                            ],
                          ),
                          TableRow(
                            children: [
                              CustomTableCell(content: Text('Payment Status')),
                              CustomTableCell(content: Text('Pending')),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GreyBoxContainer extends StatelessWidget {
  final Widget child;

  const GreyBoxContainer({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: child,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
    );
  }
}

class CustomTableCell extends StatelessWidget {
  final Widget content;

  const CustomTableCell({Key key, @required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: SizedBox(
        height: 25,
        child: content,
      ),
    );
  }
}
