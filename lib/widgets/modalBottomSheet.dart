import 'package:flutter/material.dart';

class ModalBottomSheet {
  final Widget sheetWidget;
  final BuildContext context;

  ModalBottomSheet({this.sheetWidget, this.context});

  void showSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: sheetWidget),
      ),
    );
  }
}
