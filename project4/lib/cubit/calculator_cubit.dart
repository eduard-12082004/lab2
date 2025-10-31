import 'package:flutter_bloc/flutter_bloc.dart';
import 'calculator_state.dart';

class CalculatorCubit extends Cubit<CalculatorState> {
  CalculatorCubit() : super(CalculatorInitial());

  void calculate(double a, double b, bool agreement) {
    if (!agreement) {
      emit(CalculatorError('Необходимо согласие на обработку данных'));
      return;
    }

    double result = (a + b) * (a + b);
    emit(CalculatorResult(a, b, result));
  }

  void reset() {
    emit(CalculatorInitial());
  }
}
