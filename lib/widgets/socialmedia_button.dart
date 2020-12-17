import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialMediaButton extends StatelessWidget {
  final Function onPressedCallback;
  final FaIcon icon;

  SocialMediaButton({this.icon, this.onPressedCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.grey),
      ),
      child: FlatButton(
        onPressed: onPressedCallback,
        child: icon,
      ),
    );
  }
}
