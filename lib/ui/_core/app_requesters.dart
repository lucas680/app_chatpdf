import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AppRequesters {
  final String url = 'http://127.0.0.1:8000';

  Future<String> enviarPdfs(List<File> arquivos) async {
    final uri = Uri.parse('$url/listPdfs');
    final request = http.MultipartRequest('POST', uri);

    for (var arquivo in arquivos) {
      request.files.add(
        await http.MultipartFile.fromPath('files', arquivo.path),
      );
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      return 'ok';
    } else {
      return 'erro';
    }
  }

  Future<String> fazerPergunta(String pergunta) async {
    final uri = Uri.parse('$url/question');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'pergunta': pergunta}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['resposta'];
    } else {
      if (response.statusCode == 400 && response.body.contains('/listPdfs')) {
        throw Exception('${jsonDecode(response.body)['error']}');
      }
      throw Exception('Erro ao consultar API: ${response.statusCode}');
    }
  }
}
