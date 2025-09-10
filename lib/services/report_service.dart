import 'dart:convert';
import 'package:http/http.dart' as http;

/// This is a mock reporting service to demonstrate how the app would send
/// incident reports to an endpoint. Replace the URL with your endpoint.
class ReportService {
  static Future<bool> sendIncident({
    required String title,
    required String description,
    double? lat,
    double? lng,
  }) async {
    // Example endpoint (mock). Replace with your actual server endpoint.
    final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts");

    final body = {
      "title": title,
      "description": description,
      "lat": lat,
      "lng": lng,
      "timestamp": DateTime.now().toIso8601String(),
    };

    try {
      final resp = await http.post(uri, body: jsonEncode(body), headers: {
        "Content-Type": "application/json",
      });

      return resp.statusCode == 201 || resp.statusCode == 200;
    } catch (e) {
      // network error, return false
      return false;
    }
  }
}
