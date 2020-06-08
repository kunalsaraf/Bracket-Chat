import 'package:bracketchat/components/rounded_button.dart';
import 'package:bracketchat/constants.dart';
import 'package:bracketchat/screens/contacts_screen.dart';
import 'package:bracketchat/screens/registration_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bracketchat/components/dialog_box.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  String _email;
  String _password;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _showSpinner = false;

  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
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
                      Text(
                        'LOG IN',
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
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        textAlign: TextAlign.center,
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
                        controller: _passwordController,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          _password = value;
                        },
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter Your Password'),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                          padding: EdgeInsets.all(0.0),
                          onPressed: () async {
                            setState(() {
                              _showSpinner = true;
                            });
                            if (_email == null) {
                              setState(() {
                                _showSpinner = false;
                              });
                              DialogBox(
                                context: context,
                                backgroundColor: Colors.red,
                                title: 'Invalid Email Address',
                                infoMessage: 'Email address cannot be empty.',
                                buttonText: 'OK',
                                icon: Icons.error,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              );
                            } else {
                              try {
                                await _auth.sendPasswordResetEmail(
                                    email: _email);

                                setState(() {
                                  _showSpinner = false;
                                });
                                DialogBox(
                                  context: context,
                                  title: 'Reset Password',
                                  infoMessage:
                                      'Password reset link has been sent to your registered e-mail id.',
                                  icon: Icons.info,
                                  backgroundColor: Color(0xFF6BC9EF),
                                  buttonText: 'OK',
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                );
                              } catch (e) {
                                setState(() {
                                  _showSpinner = false;
                                });
                                DialogBox(
                                  context: context,
                                  backgroundColor: Colors.red,
                                  title: e.code.toString(),
                                  infoMessage: e.message.toString(),
                                  buttonText: 'OK',
                                  icon: Icons.error,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                );
                              }
                            }
                          },
                          child: Text(
                            'Forgot Your Password',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          splashColor: Color(0xFF6BC9EF),
                        ),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      RoundedButton(
                        color: Color(0xFF6BC9EF),
                        title: 'Sign In',
                        onPressed: () async {
                          setState(() {
                            _showSpinner = true;
                          });
                          if (_email == null ||
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
                              final user =
                                  await _auth.signInWithEmailAndPassword(
                                      email: _email, password: _password);
                              if (user != null) {
                                setState(() {
                                  _showSpinner = false;
                                });
                                _passwordController.clear();
                                Navigator.popAndPushNamed(
                                    context, ContactsScreen.id);
                              }
                            } catch (e) {
                              setState(() {
                                _showSpinner = false;
                              });
                              DialogBox(
                                context: context,
                                backgroundColor: Colors.red,
                                title: e.code.toString(),
                                infoMessage: e.message.toString(),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              );
                            }
                          }
                        },
                      ),
                      RoundedButton(
                        color: Color(0xFF6BC9EF),
                        title: 'New User',
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            RegistrationScreen.id,
                          );
                        },
                      )
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
