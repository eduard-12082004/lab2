import 'package:flutter/material.dart';

void main() {
  runApp(Calculator());
}

class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: FirstScreen());
  }
}

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final _formKey = GlobalKey<FormState>();
  final _aController = TextEditingController();
  final _bController = TextEditingController();
  bool _agreement = false;

  @override
  void dispose() {
    _aController.dispose();
    _bController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Guboyan Eduard')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _aController,
              decoration: InputDecoration(labelText: 'Число a'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите число a';
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _bController,
              decoration: InputDecoration(labelText: 'Число b'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите число b';
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            CheckboxListTile(
              title: Text('Согласие на обработку данных'),
              value: _agreement,
              onChanged: (value) {
                setState(() {
                  _agreement = value!;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_agreement) {
                    double a = double.parse(_aController.text);
                    double b = double.parse(_bController.text);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SecondScreen(a: a, b: b),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Необходимо согласие на обработку данных',
                        ),
                      ),
                    );
                  }
                  ;
                }
              },
              child: Text('Рассчитать'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  final double a;
  final double b;

  SecondScreen({required this.a, required this.b});

  @override
  Widget build(BuildContext context) {
    double result = (a + b) * (a + b);

    return Scaffold(
      appBar: AppBar(title: Text('Результат')),
      body: Center(
        child: Column(
          children: [
            Text('Квадрат суммы ($a + $b)² = $result'),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FirstScreen()),
                );
              },
              child: Text('Вернуться'),
            ),
          ],
        ),
      ),
    );
  }
}
