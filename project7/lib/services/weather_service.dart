import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/weather_data.dart';

class WeatherService {
  Future<WeatherData?> getWeather(String city) async {
    try {
      final url =
          '${WeatherConfig.baseUrl}/current.json?key=${WeatherConfig.apiKey}&q=$city&lang=ru';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return WeatherData.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static String getWindDirection(String dir) {
    switch (dir) {
      case 'N':
        return 'Северный';
      case 'NE':
        return 'Северо-восточный';
      case 'E':
        return 'Восточный';
      case 'SE':
        return 'Юго-восточный';
      case 'S':
        return 'Южный';
      case 'SW':
        return 'Юго-западный';
      case 'W':
        return 'Западный';
      case 'NW':
        return 'Северо-западный';
      default:
        return dir;
    }
  }

  static IconData getWeatherIcon(String condition) {
    final cond = condition.toLowerCase();

    if (cond.contains('ясно') ||
        cond.contains('солн') ||
        cond.contains('sunny') ||
        cond.contains('clear')) {
      return Icons.wb_sunny;
    } else if (cond.contains('облач') || cond.contains('cloud')) {
      return Icons.cloud;
    } else if (cond.contains('дожд') || cond.contains('rain')) {
      return Icons.grain;
    } else if (cond.contains('снег') || cond.contains('snow')) {
      return Icons.ac_unit;
    } else if (cond.contains('туман') ||
        cond.contains('fog') ||
        cond.contains('mist')) {
      return Icons.blur_on;
    } else if (cond.contains('гроз') || cond.contains('thunder')) {
      return Icons.flash_on;
    } else {
      return Icons.cloud;
    }
  }

  static Color getTemperatureColor(double temp) {
    final t = temp.round();
    if (t >= 30) return Colors.red[900]!;
    if (t >= 25) return Colors.red[700]!;
    if (t >= 20) return Colors.orange[700]!;
    if (t >= 15) return Colors.yellow[700]!;
    if (t >= 10) return Colors.lightGreen[700]!;
    if (t >= 5) return Colors.green[700]!;
    if (t >= 0) return Colors.blue[700]!;
    if (t >= -10) return Colors.blue[900]!;
    return Colors.purple[900]!;
  }
}
