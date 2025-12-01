import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Погода в России',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  String _selectedCity = 'Москва';
  TextEditingController _cityController = TextEditingController();
  Map<String, dynamic>? _weatherData;
  bool _isLoading = false;
  String _errorMessage = '';
  bool _useCustomCity = false;

  // Российские города для быстрого выбора
  final List<String> _russianCities = [
    'Москва',
    'Санкт-Петербург',
    'Новосибирск',
    'Екатеринбург',
    'Казань',
    'Нижний Новгород',
    'Челябинск',
    'Самара',
    'Омск',
    'Ростов-на-Дону',
    'Уфа',
    'Красноярск',
    'Пермь',
    'Воронеж',
    'Волгоград',
    'Краснодар',
    'Саратов',
    'Тюмень',
    'Тольятти',
    'Ижевск',
    'Барнаул',
    'Иркутск',
    'Ульяновск',
    'Хабаровск',
    'Ярославль',
    'Владивосток',
    'Махачкала',
    'Томск',
    'Оренбург',
    'Кемерово',
  ];

  @override
  void initState() {
    super.initState();
    _cityController.text = _selectedCity;
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    // Проверка API ключа
    if (WeatherConfig.apiKey == 'ваш_ключ_здесь') {
      setState(() {
        _errorMessage =
            'Замените API ключ в файле config.dart\nПолучите на weatherapi.com';
        _isLoading = false;
      });
      return;
    }

    String cityToFetch =
        _useCustomCity ? _cityController.text.trim() : _selectedCity;

    if (cityToFetch.isEmpty) {
      setState(() {
        _errorMessage = 'Введите название города';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final url =
          '${WeatherConfig.baseUrl}/current.json?key=${WeatherConfig.apiKey}&q=$cityToFetch&lang=ru';

      print('Запрашиваю погоду для: $cityToFetch');
      print('URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=utf-8',
        },
      );

      print('Код ответа: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Декодируем с поддержкой UTF-8
        final data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _weatherData = data;
          _isLoading = false;
        });
        print('Данные успешно получены');
      } else if (response.statusCode == 400) {
        setState(() {
          _errorMessage = 'Город "$cityToFetch" не найден. Проверьте написание';
          _isLoading = false;
        });
      } else if (response.statusCode == 401) {
        setState(() {
          _errorMessage = 'Неверный API ключ. Замените в config.dart';
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Ошибка сервера: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка сети: $e';
        _isLoading = false;
      });
      print('Ошибка: $e');
    }
  }

  // Получить иконку погоды
  IconData _getWeatherIcon(String? condition) {
    if (condition == null) return Icons.cloud;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Погода в России'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Блок выбора города
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Переключатель режима
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: Text('Выбрать из списка'),
                          selected: !_useCustomCity,
                          onSelected: (selected) {
                            setState(() {
                              _useCustomCity = !selected;
                            });
                          },
                          selectedColor: Colors.blue,
                          labelStyle: TextStyle(
                            color:
                                !_useCustomCity ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ChoiceChip(
                          label: Text('Ввести вручную'),
                          selected: _useCustomCity,
                          onSelected: (selected) {
                            setState(() {
                              _useCustomCity = selected;
                            });
                          },
                          selectedColor: Colors.blue,
                          labelStyle: TextStyle(
                            color: _useCustomCity ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Поле ввода или выпадающий список
                  if (_useCustomCity)
                    TextField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        labelText: 'Введите город',
                        hintText: 'Например: Сочи, Казань, Владивосток',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_city),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: _fetchWeather,
                        ),
                      ),
                      onSubmitted: (value) => _fetchWeather(),
                    )
                  else
                    DropdownButtonFormField<String>(
                      value: _selectedCity,
                      decoration: InputDecoration(
                        labelText: 'Выберите город',
                        border: OutlineInputBorder(),
                      ),
                      items: _russianCities.map((city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(city),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedCity = newValue;
                          });
                          _fetchWeather();
                        }
                      },
                    ),

                  SizedBox(height: 16),

                  // Кнопка обновления
                  ElevatedButton.icon(
                    onPressed: _fetchWeather,
                    icon: Icon(Icons.search),
                    label: Text('Узнать погоду'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.blue[600],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // Контент погоды
          if (_isLoading)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Загружаем погоду для $_selectedCity...',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            )
          else if (_errorMessage.isNotEmpty)
            Card(
              color: Colors.red[50],
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    SizedBox(height: 16),
                    Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red[800],
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _fetchWeather,
                      child: Text('Попробовать снова'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_weatherData != null)
            _buildWeatherCard()
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.cloud, size: 60, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text(
                        'Нет данных о погоде',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          SizedBox(height: 20),

          // Подсказка по использованию
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[100]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Как пользоваться:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '1. Выберите режим "Выбрать из списка" или "Ввести вручную"\n'
                  '2. Выберите город из списка или введите свой\n'
                  '3. Нажмите "Узнать погоду"\n'
                  '4. Для российских городов используйте русские названия\n'
                  '5. Для городов за рубежом - английские названия',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[700],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard() {
    final location = _weatherData!['location'];
    final current = _weatherData!['current'];
    final condition = current['condition'];

    final cityName = location['name'];
    final country = location['country'];
    final temp = current['temp_c'].round();
    final feelsLike = current['feelslike_c'].round();
    final humidity = current['humidity'];
    final windSpeed = current['wind_kph'];
    final windDir = _getWindDirection(current['wind_dir']);
    final pressure = (current['pressure_mb'] * 0.75).round(); // в мм рт.ст.
    final conditionText = condition['text'];
    final iconUrl = 'https:${condition['icon']}';
    final localTime = location['localtime'].split(' ')[1];
    final visibility = current['vis_km'];

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
                Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 28,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cityName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '$country • Местное время: $localTime',
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

            Divider(height: 30, thickness: 1),

            // Основная информация
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Температура
                Column(
                  children: [
                    Text(
                      '$temp°C',
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: _getTemperatureColor(temp),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Ощущается как $feelsLike°C',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                // Иконка и описание
                Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      child: Image.network(
                        iconUrl,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            _getWeatherIcon(conditionText),
                            size: 80,
                            color: Colors.blue,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        conditionText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 30),

            // Детали погоды
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildDetailItem(
                  icon: Icons.water_drop,
                  title: 'Влажность',
                  value: '$humidity%',
                  color: Colors.blue,
                ),
                _buildDetailItem(
                  icon: Icons.air,
                  title: 'Ветер',
                  value: '${windSpeed.toStringAsFixed(1)} км/ч',
                  subtitle: windDir,
                  color: Colors.green,
                ),
                _buildDetailItem(
                  icon: Icons.speed,
                  title: 'Давление',
                  value: '$pressure мм рт.ст.',
                  color: Colors.purple,
                ),
                _buildDetailItem(
                  icon: Icons.visibility,
                  title: 'Видимость',
                  value: '$visibility км',
                  color: Colors.orange,
                ),
              ],
            ),

            SizedBox(height: 20),

            // Дополнительная информация
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMiniDetail('Восход', '6:30'),
                  _buildMiniDetail('Закат', '18:45'),
                  _buildMiniDetail('УФ индекс', current['uv'].toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
    String subtitle = '',
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
              ],
            ),
          ),
        ],
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
        SizedBox(height: 4),
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

  Color _getTemperatureColor(int temp) {
    if (temp >= 30) return Colors.red[900]!;
    if (temp >= 25) return Colors.red[700]!;
    if (temp >= 20) return Colors.orange[700]!;
    if (temp >= 15) return Colors.yellow[700]!;
    if (temp >= 10) return Colors.lightGreen[700]!;
    if (temp >= 5) return Colors.green[700]!;
    if (temp >= 0) return Colors.blue[700]!;
    if (temp >= -10) return Colors.blue[900]!;
    return Colors.purple[900]!;
  }

  String _getWindDirection(String dir) {
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
}
