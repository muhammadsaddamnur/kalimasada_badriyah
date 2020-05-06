import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kalimasada2020/ui_core/productimage.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:kalimasada2020/views/pemesanankatalog.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  DatabaseReference _messagesRef;
  @override
  void initState() {
    super.initState();
    getEmail();
    permission();
    // DatabaseReference _userRef = _database.reference().child('coba');
    // debugPrint(_userRef.toString());
  }

  permission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
    ].request();
  }

  getEmail() async {
    _messagesRef = _database.reference().child("produk");
    _messagesRef.once().then((DataSnapshot snapshot) {
      debugPrint(snapshot.value.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.image),
          backgroundColor: Colors.white,
          title: Text('Kalimasada'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
              stream: _database.reference().child("produk").onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

                  return GridView.builder(
                      itemCount: map.values.toList().length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        return ProductImage(
                          image: map.values.toList()[index]['image'][0],
                          onTap: () {
                            debugPrint(
                                map.values.toList()[index]['image'].toString());
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => PemesananKatalog(
                                          nama: map.values.toList()[index]
                                              ['nama'],
                                          imagesTemplate: map.values
                                              .toList()[index]['image'],
                                        )));
                          },
                        );
                      });
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ));
  }
}
