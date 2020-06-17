import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kalimasada2020/ui_core/productimage.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:kalimasada2020/views/login.dart';
import 'package:kalimasada2020/views/pemesanancustom.dart';
import 'package:kalimasada2020/views/pemesanankatalog.dart';
import 'package:kalimasada2020/views/pengaturan.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          // leading: Icon(Icons.image),
          backgroundColor: Colors.white,
          title: Text(
            'Kalimasada',
            style: TextStyle(color: Colors.black),
          ),
          bottom: TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            tabs: [
              Tab(
                text: 'Collection',
              ),
              Tab(
                text: 'Custom',
              ),
              Tab(
                text: 'Note',
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => Pengaturan()));
                })
          ],
        ),
        body: TabBarView(
          children: [
            StreamBuilder(
                stream: _database.reference().child("produk").onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
                    return GridView.builder(
                        itemCount: map.values.toList().length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 0.8),
                        itemBuilder: (context, index) {
                          return ProductImage(
                            image: map.values.toList()[index]['image'][0],
                            harga: map.values.toList()[index]['harga'],
                            model: map.values.toList()[index]['nama'],
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              if (prefs.getString('email') == null) {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => Login()));
                              } else {
                                debugPrint(map.values
                                    .toList()[index]['image']
                                    .toString());
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => PemesananKatalog(
                                              nama: map.values.toList()[index]
                                                  ['nama'],
                                              imagesTemplate: map.values
                                                  .toList()[index]['image'],
                                              harga: map.values.toList()[index]
                                                  ['harga'],
                                            )));
                              }
                            },
                          );
                        });
                  } else {
                    return Center(
                      child: Container(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator()),
                    );
                  }
                }),
            PemesananCustom(),
            Icon(Icons.directions_bike),
          ],
        ),
        // bottomNavigationBar:
        //     BottomNavigationBar(currentIndex: 0, onTap: (value) {}, items: [
        //   new BottomNavigationBarItem(
        //       icon: new Icon(Icons.home), title: new Text("Home")),
        //   new BottomNavigationBarItem(
        //       icon: new Icon(Icons.book), title: new Text("Custom")),
        //   new BottomNavigationBarItem(
        //       icon: new Icon(Icons.list), title: new Text("Pesanan")),
        // ]),
      ),
    );
  }
}
