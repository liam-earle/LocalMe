import 'package:flutter/material.dart';
import 'package:localmeapp/globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';

class LogoWidget extends StatelessWidget {
  @override
  double logoWidth;
  double logoHeight;

  LogoWidget({
    this.logoHeight,
    this.logoWidth,
  });

  Widget build(BuildContext context) {
    var assetImage = new AssetImage('assets/images/logoblue.png');
    var image = new Image(image: assetImage, width: logoWidth, height: logoHeight);
    return new Container(child: image);
  }
}

class PostCard extends StatelessWidget {
  Widget build(BuildContext context) {
    return new Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
      child: Column(
        
      ),
    );
  }
}