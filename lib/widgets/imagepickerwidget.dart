import 'dart:io';

import 'package:flutter/material.dart';

class ImagePickerWidget extends StatelessWidget {
  const ImagePickerWidget({super.key, required this.image});

  final File image;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Center(child: Image.file(image!)),
    );
  }
}
