import 'dart:convert';

import 'package:dcli/dcli.dart';
import 'package:http/http.dart' as http;

import 'models/data/api.dart';

class ApiFetcher {
  final String baseUrl;
  final Map<String, String> headers;

  ApiFetcher(this.baseUrl, this.headers);

  Future<String> fetch(Api api) async {
    var url = Uri(
      scheme: 'https',
      host: baseUrl,
      path: api.pathWithValues,
    );
    var response;
    if (api.method == 'GET') {
      print(orange('get $url ..'));
      response = await http.get(
        url,
        headers: headers,
      );
    } else if (api.method == 'POST') {
      print(orange('post ${api.body} to $url ..'));
      response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(api.body ?? {}),
      );
    }
    if (response.statusCode <= 204) {
      return response.body;
    } else {
      throw Exception('cann\'t generate models dut to invalid'
          ' status code ${response.statusCode}'
          ' for ${api.pathWithValues}');
    }
  }
}
