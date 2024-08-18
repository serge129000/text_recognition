import 'package:camera/camera.dart';

abstract class ImageToTextServices {
  Future<String> textExtractedOnImage({required XFile image, required int imageIndex});
}
