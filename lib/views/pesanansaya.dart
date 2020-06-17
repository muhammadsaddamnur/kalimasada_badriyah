import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kalimasada2020/ui_core/productimage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'detailpesanan.dart';
import 'login.dart';

class PesananSaya extends StatefulWidget {
  final String email;
  PesananSaya({@required this.email});

  @override
  _PesananSayaState createState() => _PesananSayaState();
}

class _PesananSayaState extends State<PesananSaya> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Pesanan Saya',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FirebaseAnimatedList(
        query: _database
            .reference()
            .child("pesanan")
            .orderByChild("email")
            .equalTo(widget.email),
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          return ListTile(
            title: Text(snapshot.value['team_name']),
            subtitle: Text(
              Currency.setPrice(
                  value: snapshot.value['grand_total'].toString()),
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => DetailPesanan(
                            keyFirebase: snapshot.key,
                          )));
            },
          );
        },
      ),
    );
  }
}
