import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class PemesananKatalog extends StatefulWidget {
  final List<dynamic> imagesTemplate;
  final String nama;
  PemesananKatalog({this.imagesTemplate, this.nama});
  _PemesananKatalogState createState() => _PemesananKatalogState();
}

class _PemesananKatalogState extends State<PemesananKatalog> {
  final _namaTeam = TextEditingController();
  String bahan = 'kain';
  String kategori = 'diamond';
  int jumlah = 0;
  File _logo;
  File _sponsor;
  File _pemain;

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
    String _uploadLogoURL;
    String _uploadSponsorURL;
    String _uploadPemainURL;

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

    StorageReference sponsorStorageReference = FirebaseStorage.instance.ref().child(
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

    // if(_database.reference().)

    if (_uploadLogoURL != null) {
      var toFirebase = _database.reference().child("pesanan").push();
      toFirebase.set({
        'katalog': widget.nama,
        'logo': _uploadLogoURL,
        'sponsor': _uploadSponsorURL,
        'pemain': _uploadPemainURL,
        'nama_team': _namaTeam.text,
        'jumlah': jumlah,
        'bahan': bahan,
        'kategori': kategori
      });
      debugPrint('bisa');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('data'),
      ),
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
            Text('Jenis Bahan'),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 'kain',
                  groupValue: bahan,
                  onChanged: (value) {
                    setState(() {
                      bahan = value;
                    });
                  },
                ),
                Text('Kain')
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 'plastik',
                  groupValue: bahan,
                  onChanged: (value) {
                    setState(() {
                      bahan = value;
                    });
                  },
                ),
                Text('Plastik')
              ],
            ),
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
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            CupertinoButton.filled(
              child: Text(
                'Selanjutnya',
              ),
              onPressed: () {
                uploadFile();
              },
            ),
          ],
        ),
      ),
    );
  }
}
