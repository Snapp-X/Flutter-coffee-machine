import 'package:flutter_coffee/repositories/menu_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/temperature.dart';

final temperatureProvider = StreamProvider<List<Temperature>>((ref) {
  final repository = ref.watch(temperatureRepositoryProvider);
  return repository.fetchTemperatureData();
});

final temperatureRepositoryProvider = Provider<TemperatureRepository>((ref) {
  return TemperatureRepository();
});
