import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fitnessapp/Models/Youtube_Videos.dart';

class Youtube_VideoApi {
  // final String baseUrl = 'http://192.168.31.104:5001';

  final String baseUrl =
      'https://nodejs-fitness-app-server-shalin.onrender.com';

  final StreamController<List<Youtube_Videos>> _youtubeStreamController =
      StreamController<List<Youtube_Videos>>();
  Stream<List<Youtube_Videos>> get youtubeVideos =>
      _youtubeStreamController.stream.asBroadcastStream();

  Future<void> fetchVideos(String query) async {
    final url = Uri.parse("$baseUrl/api/youtube/search?query=$query");

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = json.decode(res.body);

        print("API Response: $data"); // Debugging print statement

        if (data is List) {
          // If API returns a list directly
          _youtubeStreamController.add(
              data.map((video) => Youtube_Videos.fromJson(video)).toList());
        } else if (data is Map<String, dynamic>) {
          // If API returns an object with videos inside
          if (data.containsKey('videos') && data['videos'] is List) {
            _youtubeStreamController.add((data['videos'] as List)
                .map((video) => Youtube_Videos.fromJson(video))
                .toList());
          } else {
            throw Exception(
                "Invalid API response format: Missing 'videos' key");
          }
        } else {
          throw Exception("Unexpected API response format");
        }
      } else {
        throw Exception("API Error: ${res.body}");
      }
    } catch (e) {
      print("Error: $e"); // Debugging print statement
      _youtubeStreamController.addError(e);
    }
  }
}
