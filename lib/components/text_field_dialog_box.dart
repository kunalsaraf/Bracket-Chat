import 'package:flutter/material.dart';

import '../constants.dart';

class TextFieldDialogBox {
  String newContact;
  final Function(String) newContactCallback;
  final BuildContext context;
  final String title;
  final IconData icon;
  final String infoMessage;
  final Color titleTextColor;
  final Color messageTextColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final String buttonText;
  final Color backgroundColor;
  final String hintText;
  final Function onPressed;
  TextFieldDialogBox({
    @required this.context,
    this.title,
    this.infoMessage,
    this.titleTextColor,
    this.messageTextColor,
    this.buttonColor,
    this.buttonText,
    this.buttonTextColor,
    this.backgroundColor,
    this.onPressed,
    this.icon = Icons.notifications,
    this.hintText,
    this.newContactCallback,
  }) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            contentPadding:
                const EdgeInsets.only(bottom: 0, left: 8, right: 8, top: 8),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  color: titleTextColor ?? Colors.white,
                  size: 60.0,
                ),
                Flexible(
                    child: Text(
                  title ?? "Your alert title",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: titleTextColor ?? Colors.white),
                )),
                SizedBox(
                  height: 4.0,
                ),
                Flexible(
                  child: TextField(
                    onChanged: (newValue) {
                      newContact = newValue;
                    },
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    decoration: kDialogBoxTextFieldDecoration.copyWith(
                      hintText: hintText,
                    ),
                  ),
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(9.0))),
                  color: buttonColor ?? Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (newContact != null) newContactCallback(newContact);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        buttonText ?? "Close",
                        style:
                            TextStyle(color: buttonTextColor ?? Colors.black),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
