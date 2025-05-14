import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:openai_image_edit/parameters/size_model.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

import 'package:openai_image_edit/openai_image_edit.dart';

void main() {
  test('should return decoded image data from OpenAI', () async {
    final mockClient = MockClient((request) async {
      final response = {
        "created": 1713833628,
        "data": [
          {"b64_json": base64Encode(utf8.encode("FAKE_IMAGE_DATA"))}
        ],
        "usage": {
          "total_tokens": 100,
          "input_tokens": 50,
          "output_tokens": 50,
          "input_tokens_details": {"text_tokens": 10, "image_tokens": 40}
        }
      };
      return http.Response(jsonEncode(response), 200);
    });

    final client = OpenAIImageEditClient(apiKey: 'sk-***', client: mockClient);

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

    expect(imageData, isNotNull);
    expect(imageData.first, isA<List<int>>());
  });
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
