import 'package:image/image.dart' as img;
import 'dart:io';

class ImagePreprocessor {
  static Future<String> preprocess(
      String imagePath, {
        bool grayscale = false,
        bool gaussianBlur = false,
        double contrast = 1.0,
        double brightness = 0.0,
      }) async {
    img.Image? image = img.decodeImage(await File(imagePath).readAsBytes());

    if (image == null) throw Exception('No se pudo decodificar la imagen');

    if (grayscale) image = img.grayscale(image);
    if (gaussianBlur) image = img.gaussianBlur(image, radius: 5);
    image = img.adjustColor(image, contrast: contrast, brightness: brightness);

    String processedPath = imagePath.replaceFirst('.jpg', '_processed.jpg');
    await File(processedPath).writeAsBytes(img.encodeJpg(image));
    return processedPath;
  }
}
