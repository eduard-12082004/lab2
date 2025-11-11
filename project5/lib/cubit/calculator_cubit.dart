import 'package:flutter_bloc/flutter_bloc.dart';
import 'calculator_state.dart';
import 'dart:async';

class CalculatorCubit extends Cubit<CalculatorState> {
  CalculatorCubit() : super(CalculatorInitial());

  int _calculationCount = 0;
  final List<Calculation> _calculations = [];

  void calculate(double a, double b, bool agreement) {
    if (!agreement) {
      emit(CalculatorError('Необходимо согласие на обработку данных'));
      return;
    }

    _calculationCount++;
    double result = (a + b) * (a + b);
    emit(CalculatorResult(a, b, result, _calculationCount));

    // Сохраняем в историю (в памяти)
    final calculation = Calculation(
      a: a,
      b: b,
      result: result,
      createdAt: DateTime.now(),
    );
    _calculations.insert(0, calculation); // Добавляем в начало
  }

  void reset() {
    emit(CalculatorInitial());
  }

  // Методы для работы с историей
  List<Calculation> get calculations => List.unmodifiable(_calculations);

  void clearHistory() {
    _calculations.clear();
  }

  int get calculationCount => _calculationCount;
}

// Добавляем HistoryCubit в тот же файл
class HistoryCubit extends Cubit<HistoryState> {
  final CalculatorCubit calculatorCubit;
  late final StreamSubscription _calculatorSubscription;

  HistoryCubit({required this.calculatorCubit}) : super(HistoryInitial()) {
    // Слушаем изменения в CalculatorCubit для обновления истории
    _calculatorSubscription = calculatorCubit.stream.listen((state) {
      if (state is CalculatorResult) {
        emit(HistoryLoaded(calculatorCubit.calculations));
      }
    });

    // Загружаем начальную историю
    loadHistory();
  }

  void loadHistory() {
    emit(HistoryLoading());
    try {
      // Имитируем загрузку (в реальном приложении здесь был бы SQLite)
      Future.delayed(Duration(milliseconds: 500), () {
        emit(HistoryLoaded(calculatorCubit.calculations));
      });
    } catch (e) {
      emit(HistoryError('Ошибка загрузки истории: $e'));
    }
  }

  void clearHistory() {
    calculatorCubit.clearHistory();
    emit(HistoryLoaded(calculatorCubit.calculations));
  }

  @override
  Future<void> close() {
    _calculatorSubscription.cancel();
    return super.close();
  }
}
