// ignore_for_file: use_build_context_synchronously

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../entities/file_entity.dart';
import '../services/face_recognition_opencv_api_service.dart';
import '../services/file_picker_service.dart';
import '../widgets/image_cropper_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final FilePickerService _filePickerService;
  late final FaceRecognitionOpencvApiService _faceRecognitionOpencvApiService;

  @override
  void initState() {
    super.initState();

    _filePickerService = context.read<FilePickerService>();
    _faceRecognitionOpencvApiService = context.read<FaceRecognitionOpencvApiService>();
  }

  final List<ImageFileEntity> _images = [
    ImageFileEntity.invalid(),
    ImageFileEntity.invalid(),
  ];

  String? _areEqualResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(child: _buildImageCard(0)),
                  Expanded(child: _buildImageCard(1)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _images.any((image) => !image.isValid) ? null : _areEqual,
                child: const Text('Comparar'),
              ),
            ),
            if (_areEqualResult != null) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _areEqualResult!,
                  style: const TextStyle(fontSize: 32.0),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(int imageIndex) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400.0),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Imagem $imageIndex'),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () => _pickFile(imageIndex),
                      child: const Text('Escolher'),
                    ),
                  ],
                ),
                if (_images[imageIndex].isValid) ...[
                  Image.memory(
                    _images[imageIndex].bytes,
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    top: 0.0,
                    right: 0.0,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _images[imageIndex] = ImageFileEntity.invalid();
                          _areEqualResult = null;
                        });
                      },
                      icon: const Icon(Icons.close),
                      splashRadius: 20.0,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickFile(int imageIndex) async {
    context.loaderOverlay.show();
    
    final result = await _filePickerService.pickImage();

    context.loaderOverlay.hide();

    result.fold(
      (image) {
        if (image.isValid) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageCropperWidget(
                imageData: image.bytes,
                cropController: CropController(),
                onImageCropped: (imageData) {
                  Navigator.pop(context);
                  setState(() {
                    _images[imageIndex] = image.copyWith(bytes: imageData);
                  });
                },
              ),
            ),
          );
        }
      },
      _showErrorModal,
    );
  }

  Future<void> _areEqual() async {
    context.loaderOverlay.show();
    
    final result = await _faceRecognitionOpencvApiService.areEqual(_images[0], _images[1]);

    context.loaderOverlay.hide();

    String? newAreEqualResult;

    result.fold(
      (equal) {
        if (equal) {
          newAreEqualResult = 'São a mesma pessoa';
        } else {
          newAreEqualResult = 'São pessoas diferentes';
        }
      },
      _showErrorModal,
    );

    setState(() {
      _areEqualResult = newAreEqualResult;
    });
  }

  void _showErrorModal(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Erro: $errorMessage'),
        ),
      ),
    );
  }
}
