import 'dart:io';
import 'dart:typed_data';

import 'package:openai_image_edit/openai_image_edit.dart';
import 'package:openai_image_edit/parameters/size_model.dart';

class ImageProcessor {

  void editImage(String prompt, List<Uint8List> images) async {
    final client = OpenAIImageEditClient(apiKey: 'sk-***');

    final imageBytes = await loadImageAsBytes('sunset_image.png');

    final imageData = await client.editImages(
        prompt: "Make the image more futuristic",
        images: [imageBytes],
        size: OpenAIImageSize.x1536x1024);

    if (imageData.isNotEmpty) {
      await saveImage(imageData.first);
    } else {
      print('No image was returned.');
    }
  }

  void generateImage(String prompt) async {
    final client = OpenAIImageEditClient(apiKey: 'sk-***');

    final imageData = await client.generateImage(
        prompt: "Draw a cat in a basket",
        size: OpenAIImageSize.x1536x1024);

    if (imageData.isNotEmpty) {
      await saveImage(imageData.first);
    } else {
      print('No image was returned.');
    }
  }

  Future<Uint8List> loadImageAsBytes(String fileName) async {
    final file = File(fileName);
    if (!await file.exists()) {
      throw Exception('❌ File not found: $fileName');
    }
    return await file.readAsBytes();
  }

  Future<void> saveImage(Uint8List imageBytes,
      {String fileName = 'generated_image.png'}) async {
    final directory = Directory.current.path;
    final filePath = '$directory/$fileName';
    final file = File(filePath);

    await file.writeAsBytes(imageBytes);
    print('✅ Image saved to: $filePath');
  }
}
