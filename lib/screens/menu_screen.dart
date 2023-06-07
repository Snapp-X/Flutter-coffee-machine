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
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Consumer(
                      builder: (context, ref, child) {
                        final switchState = ref.watch(switchStateProvider);

                        return switchState.when(
                          data: (value) => SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: Column(
                              children: [
                                const Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'ON/OFF',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.grey),
                                    color: value ? Colors.green : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      value ? 'On' : 'Off',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stackTrace) =>
                              const Text('Error fetching switch state'),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    Consumer(
                      builder: (context, watch, child) {
                        return currentTemperature.when(
                          data: (temperatureList) {
                            final currentTemperature = temperatureList.last;
                            return SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Current Temperature:',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        currentTemperature.toString(),
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stackTrace) =>
                              const Text('Error fetching temperature data'),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Consumer(builder: (context, ref, child) {
                      final desiredTemperature =
                          ref.watch(desiredTemperatureProvider);

                      return _buildValueSection(
                        context: context,
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
                    const SizedBox(height: 30),
                    Consumer(builder: (context, ref, child) {
                      final desiredPValue = ref.watch(pValueProvider);

                      return _buildValueSection(
                        context: context,
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
                    Consumer(builder: (context, ref, child) {
                      final desiredIValue = ref.watch(iValueProvider);

                      return _buildValueSection(
                        context: context,
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
                    Consumer(builder: (context, ref, child) {
                      final desiredDValue = ref.watch(dValueProvider);

                      return _buildValueSection(
                        context: context,
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
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.475,
              height: MediaQuery.of(context).size.height * 0.6,
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
                        /*        swapAnimationDuration:
                            Duration(milliseconds: 150),
                        swapAnimationCurve: Curves.linear,*/
                        mainData(data, desiredTemperature),
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stackTrace) => Text('Error: $error'),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData mainData(
      List<double> currentTemperatureData, double desiredTemperature) {
    // Generate increasing desired temperature values over time
    final desiredTemperatureSpots = currentTemperatureData
        .asMap()
        .map((index, _) => MapEntry(
            index.toDouble(),
            FlSpot(
                index.toDouble(),
                index.toDouble() *
                    (desiredTemperature / currentTemperatureData.length))))
        .values
        .toList();
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 20,
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
          axisNameWidget: const Align(
              alignment: Alignment.centerLeft,
              child: Text('Temperaturverlauf in C°')),
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 3,
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
          isCurved: true,
          spots: currentTemperatureData
              .asMap()
              .map((index, temperature) => MapEntry(
                  index.toDouble(), FlSpot(index.toDouble(), temperature)))
              .values
              .toList(),
        ),
        LineChartBarData(
          isCurved: true,
          spots: desiredTemperatureSpots,
        ),
        /*LineChartBarData(
          isCurved: true,
          spots: currentTemperatureData
              .asMap()
              .map((index, _) => MapEntry(index.toDouble(),
                  FlSpot(index.toDouble(), desiredTemperature)))
              .values
              .toList(),
        ),*/
      ],
    );
  }

  Widget bottomTitleWidgets(double value, List<double> currentTemperatureData) {
    final now = DateTime.now();
    const elapsedMinutes = 30;
    const stepMinutes = elapsedMinutes / 4;
    final time =
        now.subtract(Duration(minutes: ((4 - value) * stepMinutes).toInt()));
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
    required BuildContext context,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.35,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              title,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Container(
            //  height: MediaQuery.of(context).size.height * 0.06,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
            ),
          ),
        ],
      ),
    );
  }
}
