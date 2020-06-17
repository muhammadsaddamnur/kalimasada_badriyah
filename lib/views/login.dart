import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kalimasada2020/views/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CupertinoTextField(
                placeholder: 'Email address',
                controller: _email,
              ),
              SizedBox(height: 10),
              CupertinoTextField(
                placeholder: 'Password',
                controller: _password,
              ),
              SizedBox(height: 10),
              CupertinoButton.filled(
                child: Text(
                  'Masuk',
                ),
                onPressed: () async {
                  final FirebaseDatabase _database = FirebaseDatabase.instance;
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  DatabaseReference query;
                  query = _database.reference().child("account");
                  query
                      .orderByChild('email')
                      .equalTo(_email.text)
                      .once()
                      .then((DataSnapshot snapshot) {
                    Map<dynamic, dynamic> map = snapshot.value;

                    if (map != null) {
                      if (map.values.toList()[0]['email'] == _email.text &&
                          map.values.toList()[0]['password'] ==
                              _password.text) {
                        prefs.setString(
                            'email', map.values.toList()[0]['email']);
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) => Home()));
                      } else {
                        Toast.show('Email/Password Salah', context,
                            duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
                      }
                      debugPrint(snapshot.value.toString());
                    }
                  });
                },
              ),
              CupertinoButton(
                child: Text(
                  'Join Us',
                ),
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => Register()));
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}
