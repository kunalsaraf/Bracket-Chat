import 'package:bracketchat/screens/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactTile extends StatelessWidget {
  final Function onTap;
  final String receiverName;
  final String receiverImageUrl;
  final String receiverEmail;

  ContactTile({
    @required this.receiverName,
    @required this.receiverImageUrl,
    @required this.receiverEmail,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: Color(0xFF6BC9EF),
            border: Border.all(width: 2.0, color: Colors.white),
            shape: BoxShape.circle,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(receiverImageUrl),
          ),
        ),
        title: Text(
          receiverName,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17.5,
          ),
        ),
        onTap: onTap != null
            ? onTap
            : () {
                Navigator.pushNamed(context, ChatScreen.id,
                    arguments: [receiverName, receiverImageUrl, receiverEmail]);
              },
      ),
      margin: EdgeInsets.only(
        top: 5.0,
        left: 5.0,
        right: 5.0,
      ),
      decoration: BoxDecoration(
        color: Color(0xFF6BC9EF),
        borderRadius: BorderRadius.circular(30.0),
      ),
    );
  }
}
