// ignore_for_file: avoid_print

import 'package:file_picker/file_picker.dart';
import 'package:result_dart/result_dart.dart';

import '../entities/file_entity.dart';
import 'file_picker_service.dart';

class FilePickerServiceImpl implements FilePickerService {

  const FilePickerServiceImpl(this._filePicker);
  
  final FilePicker _filePicker;

  static const _allowedExtensions = ['png', 'jpg', 'jpeg'];

  @override
  AsyncResult<ImageFileEntity, String> pickImage() async {
    try {
      final result = await _filePicker.pickFiles(
        type: FileType.image,
        allowedExtensions: _allowedExtensions,
        withData: true,
      );

      // No picked image. This usually occurs when the user gives up
      if (result == null) {
        return Success(ImageFileEntity.invalid());
      }

      return Success(
        ImageFileEntity(
          name: result.files.first.name,
          bytes: result.files.first.bytes!,
        ),
      );

    } catch (e) {

      print('[ERROR] FilePickerServiceImpl.pickImage\n$e');

      return Failure(e.toString());
    }
  }
}
