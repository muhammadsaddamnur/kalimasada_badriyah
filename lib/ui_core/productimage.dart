import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Currency {
  Currency._();

  static String setPrice(
      {String value, String currency = 'Rp. ', String errorMessage}) {
    final currencys = new NumberFormat("#,##0", "en_US");
    var valid = int.tryParse(value);
    if (valid == null) {
      return value;
    } else {
      String result = currency + currencys.format(valid);
      return result;
    }
  }

  static int decodePrice({String value}) {
    final currencys = value.replaceAll('Rp. ', '').replaceAll(',', '');
    int result = int.parse(currencys);
    return result;
  }
}

class ProductImage extends StatelessWidget {
  final String image;
  final String model;
  final dynamic harga;
  final Function onTap;
  ProductImage({this.image, this.onTap, this.model, this.harga});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: <Widget>[
            Center(
                child: Column(
              children: <Widget>[
                Container(
                  color: Colors.amberAccent,
                  height: 150,
                  width: 120,
                  child: Image.network(
                    image,
                    fit: BoxFit.fill,
                  ),
                ),
                Text(
                  model,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  Currency.setPrice(value: harga.toString()),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ],
            )),
            Positioned.fill(
              child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
