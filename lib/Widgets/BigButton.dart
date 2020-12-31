import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class BigButton extends StatelessWidget {
  final Function onTap;
  final String text;
  const BigButton({Key key, this.onTap, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      child: NeumorphicButton(
          margin: EdgeInsets.only(top: 12),
          onPressed: onTap,
          style: NeumorphicStyle(
            surfaceIntensity: 0.9,
            shape: NeumorphicShape.concave,

            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(100)),
            //border: NeumorphicBorder()
          ),
          padding: const EdgeInsets.all(12.0),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(color: Colors.black),
            ),
          )),
    );
  }
}
