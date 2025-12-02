import 'package:flutter/material.dart';
import 'config.dart';
import 'models/weather_data.dart';
import 'services/weather_service.dart';
import 'widgets/city_selector_widget.dart';
import 'widgets/weather_card.dart';
import 'widgets/loading_widget.dart';
import 'widgets/error_widget.dart' as error_widget;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCity = 'Москва';
  final TextEditingController _cityController = TextEditingController();
  WeatherData? _weatherData;
  bool _isLoading = false;
  String _errorMessage = '';
  bool _useCustomCity = false;

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
    if (WeatherConfig.apiKey == '0b2cc7ba34bc464b9ed131648250112') {
      setState(() {
        _errorMessage = 'Ошибка';
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
      final weather = await WeatherService().getWeather(cityToFetch);
      if (weather != null) {
        setState(() {
          _weatherData = weather;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Город "$cityToFetch" не найден';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Погода в России'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CitySelectorWidget(
            useCustomCity: _useCustomCity,
            selectedCity: _selectedCity,
            cityController: _cityController,
            cities: _russianCities,
            onModeChanged: (value) {
              setState(() {
                _useCustomCity = value;
              });
            },
            onCitySelected: (newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedCity = newValue;
                });
                _fetchWeather();
              }
            },
            onSearchPressed: _fetchWeather,
          ),
          const SizedBox(height: 20),
          _buildContent(),
          const SizedBox(height: 20),
          _buildHelpInfo(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return LoadingWidget(city: _selectedCity);
    } else if (_errorMessage.isNotEmpty) {
      return error_widget.WeatherErrorWidget(
        message: _errorMessage,
        onRetry: _fetchWeather,
      );
    } else if (_weatherData != null) {
      return WeatherCard(weather: _weatherData!);
    } else {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.cloud, size: 60, color: Colors.grey[400]),
                const SizedBox(height: 16),
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
      );
    }
  }

  Widget _buildHelpInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
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
              const Icon(Icons.info, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Text(
                'Как пользоваться:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '1. Выберите режим "Выбрать из списка" или "Ввести вручную"\n'
            '2. Выберите город из списка или введите свой\n'
            '3. Нажмите "Узнать погоду"\n'
            '4. Для российских городов используйте русские названия',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
