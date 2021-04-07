import 'package:boxes/style/colors.dart';
import 'package:flutter/material.dart';

class HomeMobileScreen extends StatefulWidget {
  @override
  _HomeMobileScreenState createState() => _HomeMobileScreenState();
}

class _HomeMobileScreenState extends State<HomeMobileScreen>
    with SingleTickerProviderStateMixin {
  Tween<Offset> _slideAnimation =
      Tween<Offset>(begin: Offset.zero, end: Offset(.9, .1));
  Tween<double> _scaleAnimation = Tween<double>(begin: 1.0, end: .8);
  Tween<Offset> _slideAnimation2 =
      Tween<Offset>(begin: Offset.zero, end: Offset(.85, .1));
  Tween<double> _scaleAnimation2 = Tween<double>(begin: 1.0, end: .7);
  AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF505050),
      body: Stack(
        children: [
          Container(
            color: Color(0xFF505050),
            child: GestureDetector(
              onTap: () => _controller.reverse(),
            ),
          ),
          ScaleTransition(
            scale: _scaleAnimation2.animate(CurvedAnimation(
                parent: _controller,
                curve: Interval(0.2, 1.0, curve: Curves.ease))),
            child: SlideTransition(
              position: _slideAnimation2.animate(CurvedAnimation(
                  parent: _controller,
                  curve: Interval(0.2, 1.0, curve: Curves.ease))),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kDefaultPadding),
                child: Container(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          ScaleTransition(
            scale: _scaleAnimation.animate(CurvedAnimation(
                parent: _controller,
                curve: Interval(0.0, .8, curve: Curves.ease))),
            child: SlideTransition(
              position: _slideAnimation.animate(CurvedAnimation(
                  parent: _controller,
                  curve: Interval(0.0, .8, curve: Curves.ease))),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kDefaultPadding),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      AppBar(
                        leading: IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () {
                            _controller.forward();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
