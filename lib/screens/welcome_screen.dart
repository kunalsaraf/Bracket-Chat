import 'package:bracketchat/screens/contacts_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  FirebaseAuth _auth = FirebaseAuth.instance;
  AnimationController _animationController;
  Animation _colorAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _colorAnimation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(_animationController);

    _animationController.forward();

    _animationController.addListener(() {
      setState(() {});
    });

    super.initState();

    Future.delayed(Duration(seconds: 4), () async {
      if (await _auth.currentUser() != null) {
        Navigator.popAndPushNamed(context, ContactsScreen.id);
      } else
        Navigator.popAndPushNamed(context, LoginScreen.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorAnimation.value,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/bracket_icon.png',
            height: _animationController.value * 200.0,
//            width: animationController.value * 200.0,
          ),
          SizedBox(
            height: 40.0,
          ),
          Text(
            'Bracket Chat',
            style: TextStyle(
              color: Color(0xFF6BC9EF),
              fontSize: 45.0,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      )),
    );
  }
}
