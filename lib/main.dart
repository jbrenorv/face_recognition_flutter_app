import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:window_manager/window_manager.dart';

import 'pages/home_page.dart';
import 'services/face_recognition_opencv_api_service.dart';
import 'services/face_recognition_opencv_api_service_impl.dart';
import 'services/file_picker_service.dart';
import 'services/file_picker_service_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await windowManager.ensureInitialized();

  windowManager.waitUntilReadyToShow(null, () async {
    await windowManager.setTitle('Face Recognition Flutter App');
  });

  runApp(const FaceRecognitionFlutterApp());
}

class FaceRecognitionFlutterApp extends StatelessWidget {
  const FaceRecognitionFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FilePickerService>.value(
          value: FilePickerServiceImpl(FilePicker.platform),
        ),
        RepositoryProvider<FaceRecognitionOpencvApiService>.value(
          value: FaceRecognitionOpencvApiServiceImpl(dotenv.get('API_BASE_URL')),
        ),
      ],
      child: MaterialApp(
        title: 'Face Recognition Flutter App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          fontFamily: 'Roboto'
        ),
        home: const LoaderOverlay(
          child: HomePage(),
        ),
      ),
    );
  }
}
