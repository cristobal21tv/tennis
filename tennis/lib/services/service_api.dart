import 'dart:convert';
import 'package:http/http.dart' as http;

class ServiceApi {
  static const String apiKey = 'example-api-key';
  static const double lat = 58.7984;
  static const double lng = 17.8081;
  static const String params = 'windSpeed';

  Future obtenerPronostico(formattedDate) async {
    const username = 'educativo_florez_cristobal';
    const password = 'uqO2rM068Z';
    final basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    final url =
        'https://api.meteomatics.com/$formattedDate--$formattedDate:PT1H/t_2m:C/6.2443382,75.573553/json';
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': basicAuth,
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedData = json.decode(response.body);
      // Acceder al valor que necesitas
      return decodedData['data'][0]['coordinates'][0]['dates'][0]['value'];
    }
    return [];
  }
}
