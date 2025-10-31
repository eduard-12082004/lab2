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
      appBar: AppBar(title: Text('Guboyan Eduard - Cubit Calculator')),
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
    return Form(
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
                double a = double.parse(_aController.text);
                double b = double.parse(_bController.text);
                context.read<CalculatorCubit>().calculate(a, b, _agreement);
              }
            },
            child: Text('Рассчитать'),
          ),
        ],
      ),
    );
  }

  Widget _buildResult(BuildContext context, CalculatorResult state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Квадрат суммы (${state.a} + ${state.b})² = ${state.result}'),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              context.read<CalculatorCubit>().reset();
            },
            child: Text('Вернуться'),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, CalculatorError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(state.message),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              context.read<CalculatorCubit>().reset();
            },
            child: Text('Вернуться'),
          ),
        ],
      ),
    );
  }
}
