import 'package:flutter/material.dart';

class CameraControlWidget extends StatelessWidget {
  final Function onCaptureCallback;

  CameraControlWidget({this.onCaptureCallback});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: FloatingActionButton(
          heroTag: 'btn1',
          child: Icon(
            Icons.camera,
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          onPressed: () {
            onCaptureCallback(context);
          },
        ),
      ),
    );
  }
}
