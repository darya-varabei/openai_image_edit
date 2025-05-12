library openai_image_edit;

import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class OpenAIImageEditClient {
  final String apiKey;
  final http.Client _http;

  OpenAIImageEditClient({required this.apiKey, http.Client? client})
      : _http = client ?? http.Client();

  Future<List<Uint8List>> generateImage({
    required String prompt,
    int n = 1,
    String size = '1024x1024',
  }) async {
    final uri = Uri.parse('https://api.openai.com/v1/images/generations');

    final response = await _http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'gpt-image-1',
        'prompt': prompt,
        'n': n,
        'size': size,
        'response_format': 'b64_json',
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Image generation failed: ${response.body}');
    }

    final Map<String, dynamic> json = jsonDecode(response.body);

    final List<dynamic> data = json['data'];
    return data.map((e) {
      final b64 = e['b64_json'];
      return base64Decode(b64);
    }).toList();
  }

  Future<List<Uint8List>> editImages({
    required List<Uint8List> images,
    required String prompt,
  }) async {
    final uri = Uri.parse('https://api.openai.com/v1/images/edits');

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $apiKey'
      ..fields['model'] = 'gpt-image-1'
      ..fields['prompt'] = prompt;

    for (int i = 0; i < images.length; i++) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image[]',
          images[i],
          filename: 'file$i.png',
          contentType: MediaType('image', 'png'),
        ),
      );
    }

    final streamedResponse = await _http.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception('Request failed: ${response.body}');
    }

    final Map<String, dynamic> json = jsonDecode(response.body);

    final List<dynamic> data = json['data'];
    return data.map((e) {
      final b64 = e['b64_json'];
      return base64Decode(b64);
    }).toList();
  }
}
