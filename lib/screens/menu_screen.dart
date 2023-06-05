import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/coffee_machine_providers.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTemperature = ref.watch(currentTemperatureProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee Machine'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer(builder: (context, ref, child) {
                    final switchState = ref.watch(switchStateProvider);

                    return switchState.when(
                      data: (value) => Switch(
                        value: value,
                        onChanged: null,
                        activeTrackColor: Colors.green,
                        inactiveTrackColor: Colors.red,
                        thumbColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return Colors.green;
                          } else {
                            return Colors.red;
                          }
                        }),
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stackTrace) =>
                          const Text('Error fetching switch state'),
                    );
                  }),
                  const SizedBox(height: 20),
                  Consumer(
                    builder: (context, watch, child) {
                      return currentTemperature.when(
                        data: (temperatureList) {
                          final currentTemperature = temperatureList.last;
                          return Text(
                            'Current Temperature: $currentTemperature',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stackTrace) =>
                            const Text('Error fetching temperature data'),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Consumer(builder: (context, ref, child) {
                    final desiredTemperature =
                        ref.watch(desiredTemperatureProvider);

                    return _buildValueSection(
                      title: 'Desired Temperature',
                      value: desiredTemperature,
                      onIncrease: () {
                        ref.read(desiredTemperatureProvider.notifier).state++;
                      },
                      onDecrease: () {
                        ref.read(desiredTemperatureProvider.notifier).state--;
                      },
                    );
                  }),
                  const SizedBox(height: 10),
                  Consumer(builder: (context, ref, child) {
                    final desiredPValue = ref.watch(pValueProvider);

                    return _buildValueSection(
                      title: 'P',
                      value: desiredPValue,
                      onIncrease: () {
                        ref.read(pValueProvider.notifier).state++;
                      },
                      onDecrease: () {
                        ref.read(pValueProvider.notifier).state--;
                      },
                    );
                  }),
                  const SizedBox(height: 10),
                  Consumer(builder: (context, ref, child) {
                    final desiredIValue = ref.watch(iValueProvider);

                    return _buildValueSection(
                      title: 'I',
                      value: desiredIValue,
                      onIncrease: () {
                        ref.read(iValueProvider.notifier).state++;
                      },
                      onDecrease: () {
                        ref.read(iValueProvider.notifier).state--;
                      },
                    );
                  }),
                  const SizedBox(height: 10),
                  Consumer(builder: (context, ref, child) {
                    final desiredDValue = ref.watch(dValueProvider);

                    return _buildValueSection(
                      title: 'D',
                      value: desiredDValue,
                      onIncrease: () {
                        ref.read(dValueProvider.notifier).state++;
                      },
                      onDecrease: () {
                        ref.read(dValueProvider.notifier).state--;
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Consumer(builder: (context, watch, child) {
                  final currentTemperature =
                      ref.watch(currentTemperatureProvider);
                  final desiredTemperature =
                      ref.watch(desiredTemperatureProvider.notifier).state;

                  return currentTemperature.when(
                    data: (data) => LineChart(
                      mainData(data, desiredTemperature),
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stackTrace) => Text('Error: $error'),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData mainData(
      List<double> currentTemperatureData, double desiredTemperature) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.black,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.black,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 20,
            getTitlesWidget: rightTitleWidgets,
            reservedSize: 42,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 5,
            getTitlesWidget: (value, meta) =>
                bottomTitleWidgets(value, currentTemperatureData),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: currentTemperatureData.length.toDouble() - 1,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: currentTemperatureData
              .asMap()
              .map((index, temperature) => MapEntry(
                  index.toDouble(), FlSpot(index.toDouble(), temperature)))
              .values
              .toList(),
        ),
        LineChartBarData(
          spots: currentTemperatureData
              .asMap()
              .map((index, _) => MapEntry(index.toDouble(),
                  FlSpot(index.toDouble(), desiredTemperature)))
              .values
              .toList(),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, List<double> currentTemperatureData) {
    final now = DateTime.now();
    const elapsedMinutes = 30;
    const stepMinutes = elapsedMinutes / 4;
    final time = now.subtract(Duration(minutes: (value * stepMinutes).toInt()));
    final formattedTime =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return Text(
      formattedTime,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    return Text(
      value.toInt().toString(),
      style: style,
      textAlign: TextAlign.left,
    );
  }

  Widget _buildValueSection({
    required String title,
    required double value,
    required VoidCallback onIncrease,
    required VoidCallback onDecrease,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: onDecrease,
        ),
        Text(value.toString()),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: onIncrease,
        ),
      ],
    );
  }
}
