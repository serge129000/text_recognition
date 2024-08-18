import 'dart:io';

import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:text_recognition/services/image_to_text_services.dart';

class ImageToTextServicesImpl implements ImageToTextServices {
  @override
  Future<String> textExtractedOnImage(
      {required XFile image, required int imageIndex}) async {
    try {
      final imageToInputImage = InputImage.fromFile(File(image.path));
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText =
          await textRecognizer.processImage(imageToInputImage);
      return recognizedText.text;
    } catch (e) {
      throw Exception(
          'The image at index $imageIndex have error this is the error: $e');
    }
  }
}
