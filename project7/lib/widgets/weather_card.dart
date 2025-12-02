import 'package:flutter/material.dart';
import '../models/weather_data.dart';
import '../services/weather_service.dart';
import 'weather_detail_item.dart';

class WeatherCard extends StatelessWidget {
  final WeatherData weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Заголовок с городом
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        weather.cityName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                      Text(
                        '${weather.country} • Местное время: ${weather.localTime}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 30, thickness: 1),
            // Основная информация
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      '${weather.temperature.round()}°C',
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: WeatherService.getTemperatureColor(
                            weather.temperature),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ощущается как ${weather.feelsLike.round()}°C',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.network(
                        weather.iconUrl,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            WeatherService.getWeatherIcon(
                                weather.conditionText),
                            size: 80,
                            color: Colors.blue,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        weather.conditionText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Детали погоды
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                WeatherDetailItem(
                  icon: Icons.water_drop,
                  title: 'Влажность',
                  value: '${weather.humidity}%',
                  color: Colors.blue,
                ),
                WeatherDetailItem(
                  icon: Icons.air,
                  title: 'Ветер',
                  value: '${weather.windSpeed.toStringAsFixed(1)} км/ч',
                  subtitle:
                      WeatherService.getWindDirection(weather.windDirection),
                  color: Colors.green,
                ),
                WeatherDetailItem(
                  icon: Icons.speed,
                  title: 'Давление',
                  value: '${weather.pressure} мм рт.ст.',
                  color: Colors.purple,
                ),
                WeatherDetailItem(
                  icon: Icons.visibility,
                  title: 'Видимость',
                  value: '${weather.visibility} км',
                  color: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Дополнительная информация
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMiniDetail('Восход', '6:30'),
                  _buildMiniDetail('Закат', '18:45'),
                  _buildMiniDetail(
                      'УФ индекс', weather.uvIndex.toStringAsFixed(1)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniDetail(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
      ],
    );
  }
}
