import 'dart:math';

import '../models/temperature.dart';

class TemperatureRepository {
  Stream<List<Temperature>> fetchTemperatureData() {
    final List<Temperature> mockData = [];
    final now = DateTime.now();
    final random = Random();

    // Generate initial mock data
    for (int i = 0; i < 10; i++) {
      final temperature = random.nextInt(101);
      final time = now.subtract(Duration(minutes: i));

      mockData.add(Temperature(temperature, time));
    }

    return Stream.periodic(const Duration(seconds: 5), (count) {
      // Update the temperature values every 5 seconds
      final updatedData = mockData.map((temperature) {
        final newTemperature = random.nextInt(101);
        return Temperature(newTemperature, temperature.time);
      }).toList();

      return updatedData;
    });
  }
}
