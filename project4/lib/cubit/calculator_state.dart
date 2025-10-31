import 'package:equatable/equatable.dart';

abstract class CalculatorState extends Equatable {
  const CalculatorState();

  @override
  List<Object> get props => [];
}

class CalculatorInitial extends CalculatorState {}

class CalculatorResult extends CalculatorState {
  final double result;
  final double a;
  final double b;

  const CalculatorResult(this.a, this.b, this.result);

  @override
  List<Object> get props => [a, b, result];
}

class CalculatorError extends CalculatorState {
  final String message;

  const CalculatorError(this.message);

  @override
  List<Object> get props => [message];
}
