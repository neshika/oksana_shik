import 'package:dio/dio.dart';

const String baseUrl = 'https://openai.api.proxyapi.ru/v1/chat/completions';
const String apiKey = '22sk-JuUam0b8FY1RgXjzzCYo6T7LewvAiZHn';

class DioClient {
  DioClient._();

  static final DioClient instance = DioClient._();
  final Dio _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: Duration(seconds: 30),
      responseType: ResponseType.json,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      }));

  //получаем сценарии:

  Future<String> getScenario(String userMessage) async {
    try {
      final Map<String, dynamic> data = {
        'model': 'gpt-4o-mini',
        'messages': [
          {
            'role': 'user',
            'content': userMessage,
          }
        ],
        'max_tokens': 500,
        'temperature': 0.7,
      };
      //создаем запрос , отправляем данные
      final Response response = await _dio.post(
        '',
        data: data,
      );
      //условие
      if (response.statusCode == 200) {
        return response.data['choices'][0]['message']['content'] ??
            'No response generated';
      }
    } catch (error) {
      throw 'Error $error';
    }
    return 'Data';
  }
}
