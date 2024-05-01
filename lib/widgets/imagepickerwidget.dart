import 'dart:io';

import 'package:flutter/material.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key, required this.image});

  final File? image;

  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePickerWidget> {
  get image => null;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      child: Center(child: Image.file(image!)),
    );
  }
}
