import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// Communicates with flask to connect to the python script
Future<Map<String, dynamic>> readReceipt(String image) async {
  try {
    var uri = Uri.parse('http://127.0.0.1:5000/read-receipt');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('image', image));
    var response = await request.send();

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(await response.stream.bytesToString());
      return jsonResponse;
    } else {
      return {'error': 'Failed to process image'};
    }
  } on SocketException {
    return {'error': 'Network error'};
  } catch (e) {
    return {'error': 'An error occurred'};
  }
}