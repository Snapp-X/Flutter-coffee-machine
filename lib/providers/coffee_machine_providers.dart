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
