import 'package:flutter/material.dart';

class ChoiceDialogBox {
  final BuildContext context;
  final String title;
  final IconData icon;
  final String infoMessage;
  final Color titleTextColor;
  final Color messageTextColor;
  final Color button1Color;
  final Color button1TextColor;
  final String button1Text;
  final Color button2Color;
  final Color button2TextColor;
  final String button2Text;
  final Color backgroundColor;
  final Function onPressed1;
  final Function onPressed2;
  ChoiceDialogBox({
    @required this.context,
    this.title,
    this.infoMessage,
    this.titleTextColor,
    this.messageTextColor,
    this.button1Color,
    this.button1Text,
    this.button1TextColor,
    this.button2Color,
    this.button2Text,
    this.button2TextColor,
    this.backgroundColor,
    this.onPressed1,
    this.onPressed2,
    this.icon = Icons.photo,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(9.0))),
                      color: button1Color ?? Colors.white,
                      onPressed: onPressed1,
//                    Navigator.of(context).pop();

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            button1Text ?? "Close",
                            style: TextStyle(
                                color: button1TextColor ?? Colors.black),
                          ),
                        ],
                      ),
                    ),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(9.0))),
                      color: button2Color ?? Colors.white,
                      onPressed: onPressed2,
//                    Navigator.of(context).pop();

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            button2Text ?? "Close",
                            style: TextStyle(
                                color: button2TextColor ?? Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
