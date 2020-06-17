import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kalimasada2020/ui_core/productimage.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPesanan extends StatelessWidget {
  final String keyFirebase;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  DetailPesanan({this.keyFirebase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('data'),
        ),
        body: StreamBuilder(
            stream: _database.reference().child("pesanan").onValue,
            builder: (context, snapshot) {
              // debugPrint(snapshot.data.snapshot.value[keyFirebase].toString());
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Nama Team',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        snapshot.data.snapshot.value[keyFirebase]['team_name'],
                        style: TextStyle(fontSize: 17),
                      ),
                      Text(
                        'Kode Produk',
                        style: TextStyle(color: Colors.grey),
                      ),
                      snapshot.data.snapshot.value[keyFirebase]
                                  ['catalog_name'] ==
                              null
                          ? SizedBox()
                          : Text(
                              snapshot.data.snapshot.value[keyFirebase]
                                  ['catalog_name'],
                              style: TextStyle(fontSize: 17),
                            ),
                      Text(
                        'Katagori',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        snapshot.data.snapshot.value[keyFirebase]
                            ['catalog_name'],
                        style: TextStyle(fontSize: 17),
                      ),
                      Text(
                        'Bahan',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        snapshot.data.snapshot.value[keyFirebase]
                            ['team_material'],
                        style: TextStyle(fontSize: 17),
                      ),
                      Text(
                        'Jumlah',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        snapshot.data.snapshot.value[keyFirebase]['team_amount']
                                .toString() +
                            ' pcs',
                        style: TextStyle(fontSize: 17),
                      ),
                      Divider(),
                      Text(
                        'Total',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        Currency.setPrice(
                            value: snapshot
                                .data.snapshot.value[keyFirebase]['grand_total']
                                .toString()),
                        style: TextStyle(fontSize: 17),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: CupertinoButton(
                          child: Text(
                            'Konfirmasi Whatsapp',
                          ),
                          color: Colors.green,
                          onPressed: () {
                            String text = Uri.encodeFull(
                                'Halo saya mau konfirmasi pesanan saya $keyFirebase');
                            launch(
                                'https://api.whatsapp.com/send?phone=087884222413&text=$text');
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            }));
  }
}
