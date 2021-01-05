import 'package:delivery_courier_app/constant.dart';
import 'package:flutter/material.dart';

class SlideItem {
  String image;
  String title;
  String description;

  SlideItem({this.image, this.title, this.description});
}

List<SlideItem> slideItems = [
  SlideItem(
    image: 'assets/img/undraw_confirmed_81ex.png',
    title: "Accept a Delivery Order",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque non nisi quis augue rutrum",
  ),
  SlideItem(
    image: 'assets/img/undraw_Delivery_re_f50b.png',
    title: "Tracking Realtime",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque non nisi quis augue rutrum",
  ),
  SlideItem(
    image: 'assets/img/undraw_wallet_aym5.png',
    title: "Earn Money",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque non nisi quis augue rutrum",
  )
];

class SliderView extends StatefulWidget {
  final List<SlideItem> slide;

  const SliderView({
    Key key,
    @required this.slide,
  }) : super(key: key);

  @override
  _SliderViewState createState() => _SliderViewState();
}

class _SliderViewState extends State<SliderView> {
  final PageController _sliderController = PageController();
  int currentPage = 0;

  @override
  void dispose() {
    super.dispose();
    _sliderController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _sliderController,
            itemCount: widget.slide.length,
            onPageChanged: (i) {
              setState(() {
                currentPage = i;
              });
            },
            itemBuilder: (_, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(widget.slide[i].image),
                    const Divider(color: Colors.transparent),
                    Text(
                      widget.slide[i].title,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Constant.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Divider(color: Colors.transparent),
                    Text(
                      widget.slide[i].description,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int j = 0; j < widget.slide.length; j++)
                if (currentPage == j)
                  const SlideIndicator(isCurrent: true)
                else
                  const SlideIndicator(isCurrent: false)
            ],
          ),
        ),
      ],
    );
  }
}

class SlideIndicator extends StatelessWidget {
  final bool isCurrent;

  const SlideIndicator({
    Key key,
    @required this.isCurrent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      height: isCurrent ? 9 : 6,
      width: isCurrent ? 9 : 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCurrent ? Constant.primaryColor : Colors.grey,
      ),
    );
  }
}
