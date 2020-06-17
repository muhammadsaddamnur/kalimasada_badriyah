import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kalimasada2020/ui_core/productimage.dart';
import 'package:kalimasada2020/views/detailpesanan.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class PemesananCustom extends StatefulWidget {
  final List<dynamic> imagesTemplate;
  final String nama;
  final dynamic harga;
  PemesananCustom({this.imagesTemplate, this.nama, this.harga});
  _PemesananCustomState createState() => _PemesananCustomState();
}

class _PemesananCustomState extends State<PemesananCustom> {
  final _namaTeam = TextEditingController();
  final _noHp = TextEditingController();
  final _alamat = TextEditingController();

  String bahan = 'kain';
  String kategori = 'diamond';
  int jumlah = 0;
  File _logo;
  File _teamCustom;
  File _sponsor;
  File _pemain;
  bool loading = false;

  Future getTeamCustom() async {
    var teamCustom = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (teamCustom != null) {
      setState(() {
        _teamCustom = teamCustom;
      });
    }
  }

  Future getLogo() async {
    var logo = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (logo != null) {
      setState(() {
        _logo = logo;
      });
    }
  }

  Future getSponsor() async {
    var sponsor = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (sponsor != null) {
      setState(() {
        _sponsor = sponsor;
      });
    }
  }

  Future getPemain() async {
    var pemain = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['xls', 'xlsx'],
    );

    if (pemain != null) {
      setState(() {
        _pemain = pemain;
      });
    }
  }

  Future uploadFile() async {
    final FirebaseDatabase _database = FirebaseDatabase.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _uploadTeamCustomURL;
    String _uploadLogoURL;
    String _uploadSponsorURL;
    String _uploadPemainURL;

    setState(() {
      loading = true;
    });

    StorageReference teamCustomStorageReference = FirebaseStorage.instance
        .ref()
        .child(
            'image/${DateTime.now().toUtc().millisecondsSinceEpoch.toString() + '-' + path.basename(_teamCustom.path)}');
    StorageUploadTask teamCustomUploadTask =
        teamCustomStorageReference.putFile(_teamCustom);
    await teamCustomUploadTask.onComplete;
    print('File Uploaded');

    await teamCustomStorageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadTeamCustomURL = fileURL;
      });
    });

    StorageReference logoStorageReference = FirebaseStorage.instance.ref().child(
        'image/${DateTime.now().toUtc().millisecondsSinceEpoch.toString() + '-' + path.basename(_logo.path)}');
    StorageUploadTask logoUploadTask = logoStorageReference.putFile(_logo);
    await logoUploadTask.onComplete;
    print('File Uploaded');

    await logoStorageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadLogoURL = fileURL;
      });
    });

    if (_sponsor != null) {
      StorageReference sponsorStorageReference = FirebaseStorage.instance
          .ref()
          .child(
              'image/${DateTime.now().toUtc().millisecondsSinceEpoch.toString() + '-' + path.basename(_sponsor.path)}');
      StorageUploadTask sponsorUploadTask =
          sponsorStorageReference.putFile(_sponsor);
      await sponsorUploadTask.onComplete;
      print('File Uploaded');

      await sponsorStorageReference.getDownloadURL().then((fileURL) {
        setState(() {
          _uploadSponsorURL = fileURL;
        });
      });
    }

    StorageReference pemainStorageReference = FirebaseStorage.instance.ref().child(
        'data/${DateTime.now().toUtc().millisecondsSinceEpoch.toString() + '-' + path.basename(_pemain.path)}');
    StorageUploadTask pemainUploadTask =
        pemainStorageReference.putFile(_pemain);
    await pemainUploadTask.onComplete;
    print('File Uploaded');

    await pemainStorageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadPemainURL = fileURL;
      });
    });

    if (_uploadLogoURL != null) {
      DateTime now = DateTime.now();
      var toFirebase = _database.reference().child("pesanan").push();
      toFirebase.set({
        'date': DateFormat('yyyy-MM-dd – kk:mm').format(now).toString(),
        'email': prefs.getString('email'),
        'no_handphone': _noHp.text,
        'address': _alamat.text,
        'purchase_status': 'Menunggu Pembayaran',
        'purchase_photo': 'null',
        'custom_order': _uploadTeamCustomURL,
        'catalog_name': widget.nama,
        'team_name': _namaTeam.text,
        'team_logo': _uploadLogoURL,
        'team_sponsor': _uploadSponsorURL == null ? 'null' : _uploadSponsorURL,
        'team_player': _uploadPemainURL,
        'team_amount': jumlah,
        'team_material': bahan,
        'team_category': kategori,
        'price': widget.harga,
        'grand_total': widget.harga * jumlah
      });
      debugPrint(toFirebase.key);

      setState(() {
        loading = false;
      });

      Navigator.pop(context);

      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => DetailPesanan(
                    keyFirebase: toFirebase.key,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            widget.imagesTemplate == null
                ? SizedBox()
                : Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: PageView(
                      scrollDirection: Axis.horizontal,
                      children: widget.imagesTemplate
                          .asMap()
                          .map((index, value) => MapEntry(index,
                              Image.network(widget.imagesTemplate[index])))
                          .values
                          .toList(),
                    ),
                  ),
            Center(
              child: Text(
                Currency.setPrice(value: widget.harga.toString()) + ' /pcs',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Text('Team Custom'),
            _teamCustom == null ? SizedBox() : Image.file(_teamCustom),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: RaisedButton(
                      elevation: 0,
                      color: _teamCustom == null ? Colors.blue : Colors.red,
                      child: Text(
                        _teamCustom == null
                            ? 'Upload Desain Kostum'
                            : 'Ganti Desain Kostum',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: getTeamCustom,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                _teamCustom == null
                    ? SizedBox()
                    : RaisedButton(
                        elevation: 0,
                        color: Colors.red,
                        child: Text(
                          'X',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          setState(() {
                            _teamCustom = null;
                          });
                        },
                      ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text('Logo'),
            _logo == null ? SizedBox() : Image.file(_logo),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: RaisedButton(
                      elevation: 0,
                      color: _logo == null ? Colors.blue : Colors.red,
                      child: Text(
                        _logo == null ? 'Upload Logo' : 'Ganti Logo',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: getLogo,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                _logo == null
                    ? SizedBox()
                    : RaisedButton(
                        elevation: 0,
                        color: Colors.red,
                        child: Text(
                          'X',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          setState(() {
                            _logo = null;
                          });
                        },
                      ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text('Sponsor'),
            _sponsor == null ? SizedBox() : Image.file(_sponsor),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: RaisedButton(
                      elevation: 0,
                      color: _sponsor == null ? Colors.blue : Colors.red,
                      child: Text(
                        _sponsor == null ? 'Upload Sponsor' : 'Ganti Sponsor',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: getSponsor,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                _sponsor == null
                    ? SizedBox()
                    : RaisedButton(
                        elevation: 0,
                        color: Colors.red,
                        child: Text(
                          'X',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          setState(() {
                            _sponsor = null;
                          });
                        },
                      ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text('Pemain'),
            _pemain == null ? SizedBox() : Text(_pemain.toString()),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: RaisedButton(
                      elevation: 0,
                      color: _pemain == null ? Colors.blue : Colors.red,
                      child: Text(
                        _pemain == null
                            ? 'Upload Data Pemain'
                            : 'Ganti Data Pemain',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: getPemain,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                _pemain == null
                    ? SizedBox()
                    : RaisedButton(
                        elevation: 0,
                        color: Colors.red,
                        child: Text(
                          'X',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          setState(() {
                            _pemain = null;
                          });
                        },
                      ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text('Nama Team'),
            SizedBox(
              height: 5,
            ),
            CupertinoTextField(
              placeholder: 'Nama Team',
              controller: _namaTeam,
            ),
            SizedBox(
              height: 10,
            ),
            // Text('Jenis Bahan'),
            // SizedBox(
            //   height: 5,
            // ),
            // Row(
            //   children: <Widget>[
            //     Radio(
            //       value: 'kain',
            //       groupValue: bahan,
            //       onChanged: (value) {
            //         setState(() {
            //           bahan = value;
            //         });
            //       },
            //     ),
            //     Text('Kain')
            //   ],
            // ),
            // Row(
            //   children: <Widget>[
            //     Radio(
            //       value: 'plastik',
            //       groupValue: bahan,
            //       onChanged: (value) {
            //         setState(() {
            //           bahan = value;
            //         });
            //       },
            //     ),
            //     Text('Plastik')
            //   ],
            // ),
            Text('Kategori'),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 'diamond',
                  groupValue: kategori,
                  onChanged: (value) {
                    setState(() {
                      kategori = value;
                    });
                  },
                ),
                Text('Diamond')
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 'gold',
                  groupValue: kategori,
                  onChanged: (value) {
                    setState(() {
                      kategori = value;
                    });
                  },
                ),
                Text('Gold')
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text('Jumlah'),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Text('Berapa banyak '),
                IconButton(
                  icon: Text('-'),
                  onPressed: () {
                    setState(() {
                      if (jumlah != 0) {
                        jumlah = jumlah - 1;
                      }
                    });
                  },
                ),
                Text(jumlah.toString()),
                IconButton(
                  icon: Text('+'),
                  onPressed: () {
                    setState(() {
                      jumlah = jumlah + 1;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text('No. Hp'),
            SizedBox(
              height: 5,
            ),
            CupertinoTextField(
              placeholder: 'No. Hp',
              controller: _noHp,
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text('Alamat Pengiriman'),
            SizedBox(
              height: 5,
            ),
            CupertinoTextField(
              placeholder: 'Alamat Pengiriman',
              controller: _alamat,
            ),
            SizedBox(
              height: 5,
            ),
            // Text(
            //   'Total : ' +
            //       Currency.setPrice(value: (widget.harga * jumlah).toString()),
            //   style: TextStyle(fontSize: 20),
            // ),
            SizedBox(
              height: 5,
            ),
            CupertinoButton.filled(
              child: loading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    )
                  : Text(
                      'Selanjutnya',
                    ),
              onPressed: loading
                  ? null
                  : () {
                      if (_logo == null ||
                          _pemain == null ||
                          jumlah == 0 ||
                          jumlah == null ||
                          _noHp.text.isEmpty ||
                          _alamat.text.isEmpty) {
                        Toast.show('Data Harus dilengkapi', context,
                            duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
                      } else {
                        uploadFile();
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
