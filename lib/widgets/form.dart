import 'dart:io';

import 'package:ciao/screens/reset_password.dart';
import 'package:flutter/material.dart';
import './user_img_picker.dart';
import '../screens/reset_password.dart';

class AForm extends StatefulWidget {
  AForm(
    this.submitFunction,
    this.isLoading,
  );
  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitFunction;
  @override
  _AFormState createState() => _AFormState();
}

class _AFormState extends State<AForm> {
  bool _showPassword = false;
  bool _obscureText = true;
  final _formkey = GlobalKey<FormState>();
  var _isLogin = true;
  var _email = '';
  var _userName = '';
  var _password = '';
  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final isValid = _formkey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An Error Occurred!'),
          content: Text('Please pick an Image!'),
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
      return;
    }

    if (isValid) {
      _formkey.currentState.save();
      widget.submitFunction(_email.trim(), _password.trim(), _userName.trim(),
          _userImageFile, _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(10.0),
        children: [
          Center(
            // Flexible(
            child: Container(
                margin: EdgeInsets.only(bottom: 30.0),
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: Color.fromARGB(255, 21, 236, 234),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black26,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: FlatButton.icon(
                  onPressed: null,
                  icon: Icon(
                    Icons.chat,
                    color: Colors.black,
                    // color: Color.fromARGB(255, 25, 178, 238),
                    size: 40.0,
                  ),
                  label: Text(
                    'CIAO',
                    style: TextStyle(
                      color: Theme.of(context).accentTextTheme.title.color,
                      fontSize: 42,
                      fontFamily: 'Pangolin',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
          ),
          Card(
            margin: EdgeInsets.all(18),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(15),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (!_isLogin) UserImagePicker(_pickedImage),
                    TextFormField(
                      key: ValueKey('email'),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Invalid email address';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Email address',
                      ),
                      onSaved: (value) {
                        _email = value;
                      },
                    ),
                    if (!_isLogin)
                      TextFormField(
                        key: ValueKey('username'),
                        autocorrect: true,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value.isEmpty || value.length < 5) {
                            return 'Username must be at least 5 characters long';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.verified_user),
                          labelText: 'Username',
                        ),
                        onSaved: (value) {
                          _userName = value;
                        },
                      ),
                    TextFormField(
                      key: ValueKey('password'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 6) {
                          return 'Passwords must be at least 6 characters long.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        // suffixIcon: ,
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                          color:
                              this._showPassword ? Colors.cyan : Colors.black45,
                          onPressed: () {
                            setState(
                                () => this._showPassword = !this._showPassword);
                            _obscureText = !_obscureText;
                          },
                        ),
                      ),
                      obscureText: !this._showPassword,
                      onSaved: (value) {
                        _password = value;
                      },
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    if (widget.isLoading) CircularProgressIndicator(),
                    if (!widget.isLoading)
                      RaisedButton(
                        child: Text(_isLogin ? 'Login' : 'Signup'),
                        onPressed: _submit,
                      ),
                    if (!widget.isLoading)
                      FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(
                          _isLogin
                              ? 'Create new account'
                              : 'Already have an account?',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16),
                        ),
                      ),
                    if (_isLogin)
                      FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => ResetScreen()));
                        },
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 15),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
