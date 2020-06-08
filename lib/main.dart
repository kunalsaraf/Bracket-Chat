import 'package:bracketchat/screens/update_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:bracketchat/screens/welcome_screen.dart';
import 'package:bracketchat/screens/login_screen.dart';
import 'package:bracketchat/screens/registration_screen.dart';
import 'package:bracketchat/screens/contacts_screen.dart';
import 'package:bracketchat/screens/chat_screen.dart';
import 'dart:async';

void main() => runApp(
      BracketChat(),
    );

class BracketChat extends StatefulWidget {
  @override
  _BracketChatState createState() => _BracketChatState();
}

class _BracketChatState extends State<BracketChat> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushNamed(context, LoginScreen.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'OpenSans',
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        UpdateProfileScreen.id: (context) => UpdateProfileScreen(),
        ContactsScreen.id: (context) => ContactsScreen(),
        ChatScreen.id: (context) =>
            ChatScreen(arguments: ModalRoute.of(context).settings.arguments),
      },
    );
  }
}
