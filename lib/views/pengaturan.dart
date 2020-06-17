import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kalimasada2020/views/pesanansaya.dart';
import 'package:kalimasada2020/views/testceasarchiper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'login.dart';

class Pengaturan extends StatefulWidget {
  @override
  _PengaturanState createState() => _PengaturanState();
}

class _PengaturanState extends State<Pengaturan> {
  String email;
  @override
  void initState() {
    emailSharedPreferences();
    super.initState();
  }

  emailSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('email') == null) {
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => Login(),
          ),
          (Route<dynamic> route) => false);
    } else {
      setState(() {
        email = prefs.getString('email');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Pengaturan',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Akun saya'),
            subtitle: Text(email.toString()),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            title: Text('Pesanan saya'),
            onTap: () {
              // Navigator.push(context,
              //     CupertinoPageRoute(builder: (context) => TestCaesarChiper()));

              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => PesananSaya(
                            email: email,
                          )));
            },
          ),
          Divider(),
          ListTile(
            title: Text('Keluar'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('email');
              Navigator.push(
                  context, CupertinoPageRoute(builder: (context) => Home()));
            },
          )
        ],
      ),
    );
  }
}
