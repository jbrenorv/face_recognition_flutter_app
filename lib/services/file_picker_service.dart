import 'package:result_dart/result_dart.dart';

import '../entities/file_entity.dart';

abstract class FilePickerService {

  AsyncResult<ImageFileEntity, String> pickImage();
}
