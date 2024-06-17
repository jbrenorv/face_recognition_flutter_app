import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';

class ImageCropperWidget extends StatelessWidget {
  const ImageCropperWidget({
    Key? key,
    required this.imageData,
    required this.cropController,
    required this.onImageCropped,
  }) : super(key: key);

  final Uint8List imageData;
  final CropController cropController;
  final void Function(Uint8List) onImageCropped;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Crop(
              image: imageData,
              controller: cropController,
              onCropped: onImageCropped,
              aspectRatio: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: cropController.crop,
              child: const Text('Cortar'),
            ),
          ),
        ],
      ),
    );
  }
}
