library openai_image_edit;

import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:openai_image_edit/parameters/api_request_parameters.dart';
import 'package:openai_image_edit/parameters/openai_model.dart';
import 'package:openai_image_edit/parameters/size_model.dart';

class OpenAIImageEditClient {
  final String apiKey;
  final http.Client _http;

  OpenAIImageEditClient({required this.apiKey, http.Client? client})
      : _http = client ?? http.Client();

  Future<List<Uint8List>> generateImage({
    required String prompt,
    int n = 1,
    OpenAIImageSize size = OpenAIImageSize.auto,
    OpenAIModel model = OpenAIModel.gpt_image_1,
  }) async {
    final uri = Uri.parse(ApiRequestParameters.generateImageUrl);

    final response = await _http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
          {'model': model.value, 'prompt': prompt, 'n': n, 'size': size.value}),
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
    OpenAIImageSize size = OpenAIImageSize.auto,
    OpenAIModel model = OpenAIModel.gpt_image_1,
  }) async {
    final uri = Uri.parse(ApiRequestParameters.editImageUrl);

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $apiKey'
      ..fields['model'] = model.toString()
      ..fields['prompt'] = prompt
      ..fields['size'] = size.toString();

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
