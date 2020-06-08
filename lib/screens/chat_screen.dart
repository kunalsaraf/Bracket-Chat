import 'package:bracketchat/components/dialog_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bracketchat/components/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:bracketchat/constants.dart';

String _userEmail;
String _receiverEmail;
final _firestore = Firestore.instance;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  final List arguments;
  ChatScreen({this.arguments});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  dynamic _auth = FirebaseAuth.instance;
  FirebaseUser _loggedInUser;
  String _messageBeingTyped;
  String _receiverName = 'Loading';
  String _receiverImageUrl =
      'https://firebasestorage.googleapis.com/v0/b/bracket-chat.appspot.com/o/user.jpg?alt=media&token=567a7069-97a6-4c75-99a2-7d0ce510fc37';
  TextEditingController _messageTextController = TextEditingController();
  @override
  void initState() {
    getCurrentUserDetails();
    delayedReload();
    _receiverName = widget.arguments[0];
    _receiverImageUrl = widget.arguments[1];
    _receiverEmail = widget.arguments[2];
    super.initState();
  }

  void getCurrentUserDetails() async {
    try {
      _loggedInUser = await _auth.currentUser();
      _userEmail = _loggedInUser.email;
    } catch (e) {
      DialogBox(
          context: context,
          backgroundColor: Colors.red,
          title: e.toString(),
//          infoMessage: e.message.toString(),
          onPressed: () {
            Navigator.pop(context);
          });
    }
  }

  void delayedReload() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
//    getCurrentUserDetails();
    return Scaffold(
      backgroundColor: Color(0xFF6BC9EF),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                elevation: 0.0,
                backgroundColor: Color(0xFF6BC9EF),
                flexibleSpace: Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 60.0,
                          height: 60.0,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2.0, color: Colors.white),
                            color: Color(0xFF6BC9EF),
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40.0),
                            child: Image.network(_receiverImageUrl),
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          _receiverName,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 30.0,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                      ],
                    ),
                  ),
                ),
                title: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: kContainerBoxDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            MessageStream(),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.text,
                      controller: _messageTextController,
                      onChanged: (value) {
                        _messageBeingTyped = value;
                      },
                      decoration: kChatFieldDecoration.copyWith(
                        hintText: 'Type Your Message',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 7.5),
                    child: GestureDetector(
                      onTap: () async {
                        _messageTextController.clear();
                        String _typedMessage = _messageBeingTyped;
                        String _timeOfMessage = DateTime.now().toString();
                        try {
                          await _firestore
                              .collection('users')
                              .document(_userEmail)
                              .collection('messages')
                              .add(
                            {
                              'sender': _userEmail,
                              'receiver': _receiverEmail,
                              'text': _typedMessage,
                              'timeStamp': _timeOfMessage,
                            },
                          );

                          await _firestore
                              .collection('users')
                              .document(_receiverEmail)
                              .collection('messages')
                              .add(
                            {
                              'sender': _userEmail,
                              'receiver': _receiverEmail,
                              'text': _typedMessage,
                              'timeStamp': _timeOfMessage,
                            },
                          );
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: Color(0xFF6BC9EF),
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('users')
          .document(_userEmail)
          .collection('messages')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blueAccent,
            ),
          );
        }
        List<DocumentSnapshot> messages = snapshot.data.documents;
        messages.sort((a, b) {
          DateTime A = DateTime.parse(a.data['timeStamp']);
          DateTime B = DateTime.parse(b.data['timeStamp']);
          if (A.compareTo(B) < 0) return 1;
          return 0;
        });
        List<MessageBubble> messageWidget = <MessageBubble>[];
        for (var message in messages) {
          if ((message.data['sender'] == _receiverEmail &&
                  message.data['receiver'] == _userEmail) ||
              (message.data['sender'] == _userEmail &&
                  message.data['receiver'] == _receiverEmail)) {
            final text = message.data['text'];
            final timeStamp = message.data['timeStamp'];
            final sender = message.data['sender'];
            final currentUser = _userEmail;

            final formattedTimeStamp = getDateInRequiredFormat(timeStamp);

            final messageWidgetData = MessageBubble(
              timeStamp: formattedTimeStamp,
              text: text,
              isMe: currentUser == sender,
            );
            messageWidget.add(messageWidgetData);
          }
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
            children: messageWidget,
          ),
        );
      },
    );
  }

  String getDateInRequiredFormat(timeStamp) {
    DateTime dateTime = DateTime.parse(timeStamp);
    return formatDate(
        dateTime, [dd, '/', mm, '/', yyyy, ' ', hh, ':', mm, ' ', am]);
  }
}
