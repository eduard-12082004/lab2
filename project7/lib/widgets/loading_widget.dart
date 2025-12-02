import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String city;

  const LoadingWidget({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            const CircularProgressIndicator(
              strokeWidth: 3,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            Text(
              'Загружаем погоду для $city...',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
