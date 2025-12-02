class WeatherData {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String windDirection;
  final int pressure;
  final String conditionText;
  final String iconUrl;
  final String localTime;
  final double visibility;
  final double uvIndex;

  WeatherData({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.pressure,
    required this.conditionText,
    required this.iconUrl,
    required this.localTime,
    required this.visibility,
    required this.uvIndex,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final location = json['location'];
    final current = json['current'];
    final condition = current['condition'];

    return WeatherData(
      cityName: location['name'],
      country: location['country'],
      temperature: (current['temp_c'] as num).toDouble(),
      feelsLike: (current['feelslike_c'] as num).toDouble(),
      humidity: current['humidity'],
      windSpeed: (current['wind_kph'] as num).toDouble(),
      windDirection: current['wind_dir'],
      pressure: (current['pressure_mb'] * 0.75).round(),
      conditionText: condition['text'],
      iconUrl: 'https:${condition['icon']}',
      localTime: location['localtime'].split(' ')[1],
      visibility: (current['vis_km'] as num).toDouble(),
      uvIndex: (current['uv'] as num).toDouble(),
    );
  }
}
