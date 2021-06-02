import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import './auth.dart';
//import 'package:email_validator/email_validator.dart';

class ResetScreen extends StatefulWidget {
  final auth = FirebaseAuth.instance;

  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  String _email;
  final _formKey = GlobalKey<FormState>();
  bool _validate = false;

  final _text = TextEditingController();

  String message = '';

  FocusNode myFocusNode = new FocusNode();

  // void validateEmail(String enteredEmail) {
  //   if (!EmailValidator.validate(enteredEmail)) {
  //     //   setState(() {
  //     //     message = 'Your email seems nice!';
  //     //   });
  //     // } else {
  //     setState(() {
  //       message = 'Please enter a valid email address!';
  //     });
  //   } else {
  //     setState(() {
  //       message = '';
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'To reset your password, enter your registered email address.',
                style: TextStyle(fontSize: 15, fontFamily: 'OpenSans'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextFormField(
                focusNode: myFocusNode,
                controller: _text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email address cannot be empty';
                  } else if (value.isEmpty ||
                      !value.contains('@') ||
                      !value.contains('.') ||
                      value.contains('#') ||
                      value.contains('!') ||
                      value.contains('\$') ||
                      value.contains('&') ||
                      value.contains('%') ||
                      value.contains('^') ||
                      value.contains('*') ||
                      value.contains('(') ||
                      value.contains(')') ||
                      value.contains(',') ||
                      value.contains('/') ||
                      value.contains('\\') ||
                      value.contains('{') ||
                      value.contains('}') ||
                      value.contains(';') ||
                      value.contains(':') ||
                      value.contains('-') ||
                      value.contains('_') ||
                      value.contains('+') ||
                      value.contains('=') ||
                      value.contains('[') ||
                      value.contains(']') ||
                      value.contains('\'') ||
                      value.contains('"') ||
                      value.contains('<') ||
                      value.contains('?') ||
                      value.contains('>') ||
                      value.contains('`') ||
                      value.contains('~') ||
                      value.contains('}')) {
                    return 'Invalid email address';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  fillColor: Colors.cyan,
                  labelText: 'Enter your email address',
                  //  labelStyle: TextStyle(color: Colors.cyan),
                  // focusColor: Colors.cyan,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan)),
                  border: OutlineInputBorder(borderSide: BorderSide()),
                  // errorText: _validate ? 'Email address cannot be empty' : null,
                ),
                keyboardType: TextInputType.emailAddress,
                //    onChanged: (enteredEmail) => validateEmail(enteredEmail),
                onChanged: (value) {
                  setState(() {
                    _email = value.trim();
                  });
                },
              ),
            ),
            Text(message),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                  child: Text('Send Request'),
                  onPressed: () async {
                    //  var response = await checkEmail();

                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      try {
                        await widget.auth.sendPasswordResetEmail(email: _email);
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  //   backgroundColor: Colors.cyan[50],
                                  title: Text('Reset Password',
                                      style: TextStyle(
                                          fontFamily: 'Raleway',
                                          fontWeight: FontWeight.bold)),
                                  content: Text(
                                      'Please check your email for password reset link.',
                                      style: TextStyle(fontFamily: 'Raleway')),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                            // color: Colors.redAccent,
                                            fontFamily: 'Raleway',
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AuthScreen()));
                                      },
                                    ),
                                  ],
                                ));
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('An Error Occurred!'),
                            content: Text(e.message),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Okay'),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                              )
                            ],
                          ),
                        );
                      }
                    }
                  },

                  // showDialog(
                  //     context: context,
                  //     builder: (ctx) => AlertDialog(
                  //           //   backgroundColor: Colors.cyan[50],
                  //           title: Text('Reset Password',
                  //               style: TextStyle(
                  //                   fontFamily: 'Raleway',
                  //                   fontWeight: FontWeight.bold)),
                  //           content: Text(
                  //               'Please check your email for password reset link.',
                  //               style: TextStyle(fontFamily: 'Raleway')),
                  //           actions: <Widget>[
                  //             FlatButton(
                  //               child: Text(
                  //                 'Login',
                  //                 style: TextStyle(
                  //                     // color: Colors.redAccent,
                  //                     fontFamily: 'Raleway',
                  //                     fontWeight: FontWeight.bold),
                  //               ),
                  //               onPressed: () {
                  //                 Navigator.of(context).pushReplacement(
                  //                     MaterialPageRoute(
                  //                         builder: (context) =>
                  //                             AuthScreen()));
                  //               },
                  //             ),
                  //           ],
                  //         ));

                  //  _text.text.isEmpty ? _validate = true : _validate = false;

                  // auth.sendPasswordResetEmail(email: _email);
                  // Navigator.of(context).pushReplacement(
                  //     MaterialPageRoute(builder: (context) => AuthScreen()));

                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => AuthScreen()));
                },
                child: Text(
                  'Go back to Login Page',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 15),
                ))
          ],
        ),
      ),
    );
  }
}
