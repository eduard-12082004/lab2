import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/calculator_cubit.dart';
import '../cubit/calculator_state.dart';

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
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
      appBar: AppBar(
        title: Text('Guboyan Eduard - Cubit Calculator'),
        actions: [
          // Добавляем кнопку истории в AppBar
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, '/history');
            },
          ),
        ],
      ),
      body: BlocBuilder<CalculatorCubit, CalculatorState>(
        builder: (context, state) {
          if (state is CalculatorInitial) {
            return _buildForm(context);
          } else if (state is CalculatorResult) {
            return _buildResult(context, state);
          } else if (state is CalculatorError) {
            return _buildError(context, state);
          } else {
            return _buildForm(context);
          }
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _aController,
              decoration: InputDecoration(
                labelText: 'Число a',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите число a';
                }
                if (double.tryParse(value) == null) {
                  return 'Введите корректное число';
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _bController,
              decoration: InputDecoration(
                labelText: 'Число b',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите число b';
                }
                if (double.tryParse(value) == null) {
                  return 'Введите корректное число';
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
              controlAffinity: ListTileControlAffinity.leading,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  double a = double.parse(_aController.text);
                  double b = double.parse(_bController.text);
                  context.read<CalculatorCubit>().calculate(a, b, _agreement);
                }
              },
              child: Text('Рассчитать'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult(BuildContext context, CalculatorResult state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text('Результат расчета:', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 15),
                  Text(
                    '(${state.a} + ${state.b})² = ${state.result}',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 15),
                  Divider(),
                  SizedBox(height: 10),
                  Text(
                    'Всего расчетов: ${state.calculationCount}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _aController.clear();
                    _bController.clear();
                    setState(() {
                      _agreement = false;
                    });
                    context.read<CalculatorCubit>().reset();
                  },
                  child: Text('Новый расчет'),
                  style: ElevatedButton.styleFrom(minimumSize: Size(0, 50)),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/history');
                  },
                  child: Text('История'),
                  style: ElevatedButton.styleFrom(minimumSize: Size(0, 50)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, CalculatorError state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 64),
          SizedBox(height: 20),
          Text(
            state.message,
            style: TextStyle(fontSize: 18, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              context.read<CalculatorCubit>().reset();
            },
            child: Text('Вернуться'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }
}
