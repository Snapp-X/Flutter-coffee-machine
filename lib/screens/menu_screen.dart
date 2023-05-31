import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/menu_providers.dart';

class MenuScreen extends ConsumerWidget {
  final currentTemperatureProvider =
      StateProvider<int>((ref) => ref.watch(temperatureProvider).maybeWhen(
            data: (data) => data.first.temperature,
            orElse: () => 0,
          ));

  MenuScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTemperature = ref.watch(currentTemperatureProvider);
    final temperatureData = ref.watch(temperatureProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature App'),
      ),
      body: Column(
        children: [
          Text(
            'Current Temperature: $currentTemperature°C',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(currentTemperatureProvider.notifier).state++;
            },
            child: const Text('Increase Temperature'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(currentTemperatureProvider.notifier).state--;
            },
            child: const Text('Decrease Temperature'),
          ),
          const SizedBox(height: 16),
          temperatureData.when(
            data: (data) {
              return const SizedBox();
              /*return Expanded(
                child: ,
              );*/
            },
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Text('Error: $error'),
          ),
          /*   temperatureData.when(
            data: (data) {
              return Expanded(
                child: charts.TimeSeriesChart(
                  _createTemperatureSeries(data),
                  animate: true,
                  dateTimeFactory: const charts.LocalDateTimeFactory(),
                ),
              );
            },
            loading: () => CircularProgressIndicator(),
            error: (error, stackTrace) => Text('Error: $error'),
          ),*/
        ],
      ),
    );
  }

  /*List<charts.Series<Temperature, DateTime>> _createTemperatureSeries(
      List<Temperature> data) {
    return [
      charts.Series<Temperature, DateTime>(
        id: 'Temperature',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Temperature temp, _) => temp.time,
        measureFn: (Temperature temp, _) => temp.temperature,
        data: data,
      )
    ];
  }*/
}
