import 'package:result_dart/result_dart.dart';

import '../entities/file_entity.dart';

abstract class FaceRecognitionOpencvApiService {

  /// Sends [image1] and [image2] to face recognition opencv api
  /// then returns true if persons in both images are equal
  AsyncResult<bool, String> areEqual(ImageFileEntity image1, ImageFileEntity image2);
}
