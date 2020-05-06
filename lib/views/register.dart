import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _firsName = TextEditingController();
  final _lastName = TextEditingController();
  String _jenisKelamin = 'Male';

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
              CupertinoTextField(
                placeholder: 'First Name',
                controller: _firsName,
              ),
              SizedBox(height: 10),
              CupertinoTextField(
                placeholder: 'Last Name',
                controller: _lastName,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                      color:
                          _jenisKelamin == 'Male' ? Colors.blue : Colors.grey,
                      elevation: 0,
                      child: Text(
                        'Male',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        setState(() {
                          _jenisKelamin = 'Male';
                        });
                      }),
                  RaisedButton(
                      color:
                          _jenisKelamin == 'Female' ? Colors.blue : Colors.grey,
                      elevation: 0,
                      child: Text(
                        'Female',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        setState(() {
                          _jenisKelamin = 'Female';
                        });
                      })
                ],
              ),
              SizedBox(height: 10),
              CupertinoButton.filled(
                child: Text(
                  'Daftar',
                ),
                onPressed: () {
                  final FirebaseDatabase _database = FirebaseDatabase.instance;
                  DatabaseReference query;
                  query = _database.reference().child("account");
                  query
                      .orderByChild('email')
                      .equalTo(_email.text)
                      .once()
                      .then((DataSnapshot snapshot) {
                    if (snapshot.value == null) {
                      var toFirebase =
                          _database.reference().child("account").push();
                      toFirebase.set({
                        'email': _email.text,
                        'password': _password.text,
                        'first_name': _firsName.text,
                        'last_name': _lastName.text,
                        'gender': _jenisKelamin,
                      });
                    } else {
                      Toast.show(
                          'Email Sudah Terdaftar Silahkan, Gunakan Email Lain',
                          context,
                          duration: Toast.LENGTH_SHORT,
                          gravity: Toast.TOP);
                    }
                    debugPrint(snapshot.value.toString());
                  });
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}
