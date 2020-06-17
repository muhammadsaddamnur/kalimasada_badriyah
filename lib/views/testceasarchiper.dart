import 'package:flutter/material.dart';
import 'package:kalimasada2020/ui_core/caesarchipher.dart';
import 'package:kalimasada2020/ui_core/vigenerecipher.dart';

class TestCaesarChiper extends StatefulWidget {
  @override
  _TestCaesarChiperState createState() => _TestCaesarChiperState();
}

class _TestCaesarChiperState extends State<TestCaesarChiper> {
  String text = '';
  String text2 = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Text(text),
          RaisedButton(
              child: Text('test'),
              onPressed: () {
                setState(() {
                  text = CaesarChiper.process(false, 'xfiifr');
                });
              }),
          Text(text2),
          RaisedButton(
              child: Text('test'),
              onPressed: () {
                setState(() {
                  text2 = VigenereCipher.encrypt('e', 'a');
                  debugPrint(text2.toString());
                  String text3 = VigenereCipher.decrypt(text2, 'a');
                  debugPrint(text3.toString());
                });
              })
        ],
      ),
    );
  }
}
