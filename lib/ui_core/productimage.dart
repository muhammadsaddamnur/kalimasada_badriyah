import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String image;
  final Function onTap;
  ProductImage({this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: <Widget>[
            Center(
                child: Container(
              color: Colors.amberAccent,
              height: 150,
              width: 120,
              child: Image.network(
                image,
                fit: BoxFit.fill,
              ),
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
