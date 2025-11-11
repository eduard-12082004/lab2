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
  final int calculationCount;

  const CalculatorResult(this.a, this.b, this.result, this.calculationCount);

  @override
  List<Object> get props => [a, b, result, calculationCount];
}

class CalculatorError extends CalculatorState {
  final String message;

  const CalculatorError(this.message);

  @override
  List<Object> get props => [message];
}

// Добавляем состояния для истории расчетов
abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<Calculation> calculations;
  const HistoryLoaded(this.calculations);

  @override
  List<Object> get props => [calculations];
}

class HistoryError extends HistoryState {
  final String message;
  const HistoryError(this.message);

  @override
  List<Object> get props => [message];
}

// Добавляем модель расчета
class Calculation extends Equatable {
  final int? id;
  final double a;
  final double b;
  final double result;
  final DateTime createdAt;

  const Calculation({
    this.id,
    required this.a,
    required this.b,
    required this.result,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'a': a,
      'b': b,
      'result': result,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Calculation.fromMap(Map<String, dynamic> map) {
    return Calculation(
      id: map['id'] as int?,
      a: map['a'] as double,
      b: map['b'] as double,
      result: map['result'] as double,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  @override
  List<Object> get props => [a, b, result, createdAt];
}
