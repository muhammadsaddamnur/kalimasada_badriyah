import 'package:flutter/cupertino.dart';

class CaesarChiper {
  static String process(bool _isEncrypt, text) {
    String _text = text;
    int _key;
    String _temp = "";

    try {
      _key = 5;
    } catch (e) {
      debugPrint("Invalid Key");
    }

    for (int i = 0; i < _text.length; i++) {
      int ch = text.codeUnitAt(i);
      int offset;
      String h;
      if (ch >= 'a'.codeUnitAt(0) && ch <= 'z'.codeUnitAt(0)) {
        offset = 97;
      } else if (ch >= 'A'.codeUnitAt(0) && ch <= 'Z'.codeUnitAt(0)) {
        offset = 65;
      } else if (ch == ' '.codeUnitAt(0)) {
        _temp += " ";
        continue;
      } else {
        debugPrint("Invalid Text");
        _temp = "";
        break;
      }

      int c;
      if (_isEncrypt) {
        c = (ch + _key - offset) % 26;
      } else {
        c = (ch - _key - offset) % 26;
      }
      h = String.fromCharCode(c + offset);
      _temp += h;
    }

    return _temp.toString();
  }
}
