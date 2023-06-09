import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/coffee_machine_repository.dart';

final currentTemperatureProvider = StreamProvider<List<double>>((ref) {
  final repository = ref.watch(coffeeMachineRepositoryProvider);
  return repository.fetchTemperatureData();
});

final desiredTemperatureProvider = StateProvider<double>((ref) {
  final repository = ref.watch(coffeeMachineRepositoryProvider);
  return repository.desiredTemperature;
});

final desiredTemperatureDataProvider = StreamProvider<List<double>>((ref) {
  final repository = ref.watch(coffeeMachineRepositoryProvider);
  final desiredTemperature =
      ref.watch(desiredTemperatureProvider.notifier).state;
  final mockData = <double>[];

  // Add initial mock data with a single value
  final initialTemperature = repository.desiredTemperature;
  mockData.add(initialTemperature);

  return Stream.periodic(const Duration(seconds: 5), (_) {
    // Add the current desired temperature value as a new spot in the mock data
    mockData.add(desiredTemperature);

    // If the list has more than 10 values, remove the oldest value
    if (mockData.length > 10) {
      mockData.removeAt(0);
    }

    // Return the updated temperature data
    return mockData;
  }).asyncMap((currentTemperatureData) async {
    // You can await any asynchronous operations here if needed

    // Update the current temperature data with the desired temperature added
    final updatedTemperatureData = currentTemperatureData + mockData;

    return updatedTemperatureData;
  });
});

/*final desiredTemperatureProvider = StateProvider<double>((ref) {
  final repository = ref.watch(coffeeMachineRepositoryProvider);
  return repository.desiredTemperature;
});*/

final pValueProvider = StateProvider<double>((ref) {
  final repository = ref.watch(coffeeMachineRepositoryProvider);
  return repository.pValue;
});

final iValueProvider = StateProvider<double>((ref) {
  final repository = ref.watch(coffeeMachineRepositoryProvider);
  return repository.iValue;
});

final dValueProvider = StateProvider<double>((ref) {
  final repository = ref.watch(coffeeMachineRepositoryProvider);
  return repository.dValue;
});

final coffeeMachineRepositoryProvider =
    Provider<CoffeeMachineRepository>((ref) {
  return CoffeeMachineRepository();
});

final switchStateProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(coffeeMachineRepositoryProvider);
  return repository.fetchSwitchState();
});
