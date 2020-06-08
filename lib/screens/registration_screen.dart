import 'dart:io';
import 'package:bracketchat/components/choice_dialog_box.dart';
import 'package:bracketchat/components/dialog_box.dart';
import 'package:bracketchat/components/rounded_button.dart';
import 'package:bracketchat/constants.dart';
import 'package:bracketchat/screens/contacts_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  final _fireStore = Firestore.instance;
  final _storage = FirebaseStorage.instance;
  String _name;
  String _email;
  String _password;
  String _confirmPassword;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  File _imageFile;
  final _picker = ImagePicker();
  AnimationController _animationController;
  bool _showSpinner = false;

  Future getImage({source}) async {
    final pickedFile = await _picker.getImage(
      source: source,
      maxHeight: 200.0,
      maxWidth: 200.0,
    );
    if (pickedFile != null) {
      final cropped = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(
          ratioX: 1,
          ratioY: 1,
        ),
        cropStyle: CropStyle.circle,
        compressQuality: 100,
        compressFormat: ImageCompressFormat.jpg,
      );
      setState(() {
        _imageFile = File(cropped.path);
      });
    }
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _animationController.forward();

    _animationController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF6BC9EF),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(150.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                flexibleSpace: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        child: Image.asset(
                          'assets/images/bracket_icon_invert.png',
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        'Bracket Chat',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 40.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                centerTitle: true,
                elevation: 0.0,
                backgroundColor: Color(0xFF6BC9EF),
              ),
            ],
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: _showSpinner,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: kContainerBoxDecoration,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 24.0,
                      ),
                      Text(
                        'REGISTER',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: _animationController.value * 30.0,
                          color: Color(0xFF6BC9EF),
                          fontWeight: FontWeight.w400,
                          letterSpacing: 2.0,
                        ),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          ChoiceDialogBox(
                              context: context,
                              backgroundColor: Color(0xFF6BC9EF),
                              title: 'Choose Appropriate Medium',
                              button1Text: 'Camera',
                              button2Text: 'Gallery',
                              onPressed1: () {
                                Navigator.pop(context);
                                getImage(source: ImageSource.camera);
                              },
                              onPressed2: () {
                                Navigator.pop(context);
                                getImage(source: ImageSource.gallery);
                              });
                        },
                        child: Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            color: Color(0xFF6BC9EF),
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40.0),
                            child: _imageFile == null
                                ? Icon(
                                    Icons.add_a_photo,
                                    color: Colors.white,
                                  )
                                : Image.file(_imageFile),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      TextField(
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (value) {
                          _name = value;
                        },
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter Your Name'),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        controller: _emailController,
                        onChanged: (value) {
                          _email = value;
                        },
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter Your Email'),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextField(
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        controller: _passwordController,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          _password = value;
                        },
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter Your Password'),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextField(
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        controller: _confirmPasswordController,
                        onChanged: (value) {
                          _confirmPassword = value;
                        },
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Confirm Your Password'),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      RoundedButton(
                        color: Color(0xFF6BC9EF),
                        title: 'Sign Up',
                        onPressed: () async {
                          setState(() {
                            _showSpinner = true;
                          });
                          if (_name == null) {
                            setState(() {
                              _showSpinner = false;
                            });
                            DialogBox(
                                context: context,
                                backgroundColor: Colors.red,
                                title: 'Invalid Name',
                                infoMessage: 'Name cannot be empty.',
                                icon: Icons.error,
                                onPressed: () {
                                  Navigator.pop(context);
                                });
                          } else if (_email == null ||
                              EmailValidator.validate(_email) == false) {
                            setState(() {
                              _showSpinner = false;
                            });
                            DialogBox(
                                context: context,
                                backgroundColor: Colors.red,
                                title: 'Invalid Email',
                                infoMessage:
                                    'Kindly enter a valid email address.',
                                icon: Icons.error,
                                onPressed: () {
                                  Navigator.pop(context);
                                });
                          } else if (_password != _confirmPassword) {
                            setState(() {
                              _showSpinner = false;
                            });
                            DialogBox(
                                context: context,
                                backgroundColor: Colors.red,
                                title: 'Password Mismatch',
                                infoMessage:
                                    'Passwords do not match, please re-enter.',
                                icon: Icons.error,
                                onPressed: () {
                                  Navigator.pop(context);
                                });
                          } else if (_password == null ||
                              _password.length < 6) {
                            setState(() {
                              _showSpinner = false;
                            });
                            DialogBox(
                                context: context,
                                backgroundColor: Colors.red,
                                title: 'Invalid Password',
                                infoMessage:
                                    'Length of the password should be greater than 6 characters.',
                                icon: Icons.error,
                                onPressed: () {
                                  Navigator.pop(context);
                                });
                          } else {
                            try {
                              final newUser =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: _email, password: _password);
                              if (newUser != null) {
                                String imageUrl;
                                if (_imageFile != null) {
                                  final StorageReference storageReference =
                                      _storage.ref().child('$_email.jpg');

                                  final StorageUploadTask storageUploadTask =
                                      storageReference.putFile(_imageFile);

                                  StorageTaskSnapshot taskSnapshot =
                                      await storageUploadTask.onComplete;

                                  imageUrl = await taskSnapshot.ref
                                      .getDownloadURL() as String;
                                } else {
                                  imageUrl =
                                      "https://firebasestorage.googleapis.com/v0/b/bracket-chat.appspot.com/o/user.jpg?alt=media&token=567a7069-97a6-4c75-99a2-7d0ce510fc37";
                                }

                                await _fireStore
                                    .collection('users')
                                    .document('$_email')
                                    .setData({
                                  'email': _email,
                                  'name': _name,
                                  'imageUrl': imageUrl,
                                });
                                _nameController.clear();
                                _emailController.clear();
                                _passwordController.clear();
                                _confirmPasswordController.clear();
                                setState(() {
                                  _showSpinner = false;
                                });
                                DialogBox(
                                  context: context,
                                  title: 'Registration Successful',
                                  infoMessage:
                                      'Welcome to Bracket Chat, we are happy to serve you.',
                                  icon: Icons.check_circle,
                                  backgroundColor: Colors.green,
                                  buttonText: 'Proceed',
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.popAndPushNamed(
                                        context, ContactsScreen.id);
                                  },
                                );
                              }
                            } catch (e) {
                              setState(() {
                                _showSpinner = false;
                              });
                              DialogBox(
                                  context: context,
                                  backgroundColor: Colors.red,
                                  title: e.toString(),
                                  infoMessage: e.message.toString(),
                                  icon: Icons.error,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  });
                            }
                          }
                        },
                      ),
                      RoundedButton(
                        color: Color(0xFF6BC9EF),
                        title: 'Already Registered',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
