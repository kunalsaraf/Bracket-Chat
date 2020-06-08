import 'dart:async';
import 'package:bracketchat/components/dialog_box.dart';
import 'package:bracketchat/screens/login_screen.dart';
import 'package:bracketchat/screens/update_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bracketchat/constants.dart';
import 'package:bracketchat/components/contact_tile.dart';
import 'package:bracketchat/components/text_field_dialog_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

Firestore _firestore = Firestore.instance;
String userEmail;

class ContactsScreen extends StatefulWidget {
  static String id = 'contacts_screen';

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _loggedInUser;
  String _userName;
  String _imageUrl =
      'https://firebasestorage.googleapis.com/v0/b/bracket-chat.appspot.com/o/user.jpg?alt=media&token=567a7069-97a6-4c75-99a2-7d0ce510fc37';
  bool _showSpinner = false;

  void delayedReload() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {});
    });
  }

  void getCurrentUserDetails() async {
    try {
      _loggedInUser = await _auth.currentUser();
      userEmail = _loggedInUser.email;
      await _firestore
          .collection('users')
          .document(userEmail)
          .get()
          .then((value) {
        var userData = value.data;
        setState(() {
          _userName = userData['name'];
          _imageUrl = userData['imageUrl'];
        });
      });
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

  @override
  void initState() {
    getCurrentUserDetails();
    delayedReload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 60.0,
                            height: 60.0,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 2.0, color: Colors.white),
                              color: Color(0xFF6BC9EF),
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image.network(_imageUrl),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            'Contacts',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 25.0,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  TextFieldDialogBox(
                                    context: context,
                                    newContactCallback:
                                        (String newContact) async {
                                      setState(() {
                                        _showSpinner = true;
                                      });
                                      final snapShot = await _firestore
                                          .collection('users')
                                          .document(newContact)
                                          .get();
                                      if (snapShot == null ||
                                          !snapShot.exists) {
                                        setState(() {
                                          _showSpinner = false;
                                        });
                                        DialogBox(
                                            context: context,
                                            title: 'Contact Not Found',
                                            infoMessage:
                                                'Email ID does not exist in our database, kindly verify and try again.',
                                            backgroundColor: Colors.red,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            });
                                      } else {
                                        String newContactName;
                                        String newContactPhotoUrl;

                                        await _firestore
                                            .collection('users')
                                            .document(newContact)
                                            .get()
                                            .then((value) {
                                          var userData = value.data;
                                          newContactName = userData['name'];
                                          newContactPhotoUrl =
                                              userData['imageUrl'];
                                        });

                                        await _firestore
                                            .collection('users')
                                            .document(newContact)
                                            .collection('contacts')
                                            .document(userEmail)
                                            .setData({
                                          'name': _userName,
                                          'imageUrl': _imageUrl
                                        });

                                        await _firestore
                                            .collection('users')
                                            .document(userEmail)
                                            .collection('contacts')
                                            .document(newContact)
                                            .setData({
                                          'name': newContactName,
                                          'imageUrl': newContactPhotoUrl
                                        });
                                        setState(() {
                                          _showSpinner = false;
                                        });
                                        DialogBox(
                                          context: context,
                                          title: 'Contact Added',
                                          infoMessage:
                                              'Contact has been added successfully.',
                                          backgroundColor: Colors.green,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        );
                                      }
                                    },
                                    backgroundColor: Color(0xFF6BC9EF),
                                    title: 'Add New Contact',
                                    hintText: 'Enter the e-mail address',
                                    icon: Icons.contact_mail,
                                    buttonText: 'Proceed',
                                    onPressed: (newContact) {
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                                child: CircleAvatar(
                                  child: Icon(
                                    Icons.person_add,
                                    color: Color(0xFF6BC9EF),
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {});
                                },
                                child: CircleAvatar(
                                  child: Icon(
                                    Icons.refresh,
                                    color: Color(0xFF6BC9EF),
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await Navigator.pushNamed(
                                      context, UpdateProfileScreen.id);
                                  getCurrentUserDetails();
                                },
                                child: CircleAvatar(
                                  child: Icon(
                                    Icons.mode_edit,
                                    color: Color(0xFF6BC9EF),
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          _auth.signOut();
                          if (Navigator.canPop(context) == true)
                            Navigator.pop(context);
                          else
                            Navigator.popAndPushNamed(context, LoginScreen.id);
                        },
                        child: CircleAvatar(
                          child: Icon(
                            Icons.power_settings_new,
                            color: Color(0xFF6BC9EF),
                          ),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ],
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
            children: <Widget>[
              ContactStream(),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('users')
          .document(userEmail)
          .collection('contacts')
          .snapshots(),
      initialData: null,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blueAccent,
            ),
          );
        }
        final contacts = snapshot.data.documents;
        List<ContactTile> allContacts = <ContactTile>[];
        for (var contact in contacts) {
          final email = contact.documentID;
          final name = contact.data['name'];
          final image = contact.data['imageUrl'];
          final contactTile = ContactTile(
            receiverName: name,
            receiverImageUrl: image,
            receiverEmail: email,
          );
          allContacts.add(contactTile);
        }
        return Expanded(
          child: ListView(
            children: allContacts,
          ),
        );
      },
    );
  }
}
