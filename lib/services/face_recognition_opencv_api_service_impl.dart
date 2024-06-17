// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'package:result_dart/result_dart.dart';

import '../entities/file_entity.dart';
import 'face_recognition_opencv_api_service.dart';

class FaceRecognitionOpencvApiServiceImpl implements FaceRecognitionOpencvApiService {

  const FaceRecognitionOpencvApiServiceImpl(this._apiBaseUrl);

  final String _apiBaseUrl;

  @override
  AsyncResult<bool, String> areEqual(ImageFileEntity image1, ImageFileEntity image2) async {
    try {
      final uri = Uri.parse(_apiBaseUrl);

      final request = http.MultipartRequest('POST', uri);

      request.files.add(http.MultipartFile.fromBytes(
        'image01',
        image1.bytes,
        filename: image1.name,
      ));

      request.files.add(http.MultipartFile.fromBytes(
        'image02',
        image2.bytes,
        filename: image2.name,
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final faceRecoginitionResultString = await response.stream.bytesToString();

        final faceRecoginitionResult = bool.parse(faceRecoginitionResultString.toLowerCase());

        return Success(faceRecoginitionResult);
      } else {

        _logRequestFailure(response);

        return const Failure('Serviço indisponível');
      }
    } catch (e) {

      print('[ERROR] FaceRecognitionOpencvApiServiceImpl.areEqual\n$e');

      return Failure(e.toString());
    }
  }

  void _logRequestFailure(http.StreamedResponse response) async {
    print('[RESQUEST FAILURE]');
    print('\tCode=${response.statusCode}');
    print('\tBody=${await response.stream.bytesToString()}');
  }
}
