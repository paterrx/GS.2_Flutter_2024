import 'dart:convert';
import 'dart:io';

class ApiService {
  final String _baseUrl = "https://eletropostos.azurewebsites.net/api/eletroposto";

  Future<List<dynamic>> fetchEletropostos() async {
    try {
      final url = Uri.parse(_baseUrl);
      final request = await HttpClient().getUrl(url);
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        return jsonDecode(responseBody) as List<dynamic>;
      } else {
        throw Exception("Erro na requisição: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Erro ao acessar a API: $e");
    }
  }
}
