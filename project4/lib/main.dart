import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/calculator_cubit.dart';
import 'screens/calculator_screen.dart';

void main() {
  runApp(Calculator());
}

class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => CalculatorCubit(),
        child: CalculatorScreen(),
      ),
    );
  }
}
