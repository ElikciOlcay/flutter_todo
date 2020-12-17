import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todoey/shared/date_formatter.dart';
import 'package:todoey/widgets/chip.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    Key key,
    @required this.imgPath,
    @required this.firebaseImagePath,
    @required this.userLocation,
  }) : super(key: key);

  final String imgPath;
  final String firebaseImagePath;
  final String userLocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.symmetric(vertical: 20.0),
      child: imgPath != null || firebaseImagePath != null
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: firebaseImagePath != null
                      ? Image.network(
                          firebaseImagePath,
                          height: 150.0,
                          width: 100.0,
                          fit: BoxFit.fitWidth,
                        )
                      : Image.file(
                          File(imgPath),
                          height: 150.0,
                          width: 100.0,
                          fit: BoxFit.fitWidth,
                        ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Container(
                  width: 200.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ToolChip(
                          icon: Icon(
                            Icons.date_range,
                            color: Colors.white,
                            size: 18.0,
                          ),
                          label: DateFormatter(date: DateTime.now())
                              .formattedDate),
                      ToolChip(
                        icon: Icon(
                          Icons.location_pin,
                          color: Colors.white,
                          size: 18.0,
                        ),
                        label: userLocation,
                      ),
                    ],
                  ),
                )
              ],
            )
          : SizedBox(),
    );
  }
}
