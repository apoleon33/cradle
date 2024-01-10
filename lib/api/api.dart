import 'package:dio/dio.dart';

abstract class Api {
  String baseUrl;
  final Dio _dio = Dio();

  Api({required this.baseUrl});

  Future<Map> callApi(String subUrl) async {
    final String url = Uri.encodeFull('$baseUrl$subUrl');
    return (await _dio.get(url)).data;
  }
}
