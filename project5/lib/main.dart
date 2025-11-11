import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/calculator_cubit.dart';
import 'screens/calculator_screen.dart';
import 'screens/history_screen.dart';

void main() {
  runApp(Calculator());
}

class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CalculatorCubit>(create: (context) => CalculatorCubit()),
        BlocProvider<HistoryCubit>(
          create: (context) =>
              HistoryCubit(calculatorCubit: context.read<CalculatorCubit>()),
        ),
      ],
      child: MaterialApp(
        title: 'Guboyan Eduard - Cubit Calculator',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: CalculatorScreen(),
        routes: {'/history': (context) => HistoryScreen()},
      ),
    );
  }
}
