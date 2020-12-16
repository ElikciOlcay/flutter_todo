import 'package:flutter/material.dart';

class ToolChip extends StatelessWidget {
  final Icon icon;
  final String label;

  ToolChip({this.icon, this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: icon,
      backgroundColor: Colors.blueGrey,
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
