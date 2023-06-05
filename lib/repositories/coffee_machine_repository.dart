import 'dart:math';

class CoffeeMachineRepository {
  // Mock data representing the current state of the coffee machine
  double _currentTemperature = 0;
  double _desiredTemperature = 0;
  double _pValue = 0;
  double _iValue = 0;
  double _dValue = 0;

  // Getters for current temperature, desired temperature, and PID values
  double get currentTemperature => _currentTemperature;
  double get desiredTemperature => _desiredTemperature;
  double get pValue => _pValue;
  double get iValue => _iValue;
  double get dValue => _dValue;

  Future<bool> fetchSwitchState() async {
    // Simulate a delay to mimic an API call
    await Future.delayed(const Duration(seconds: 2));

    // Mock data representing the switch state
    const bool switchState = true;

    return switchState;
  }

  Stream<List<double>> fetchTemperatureData() {
    final List<double> mockData = [];
    final random = Random();

    // Generate initial mock data
    for (int i = 0; i < 10; i++) {
      final temperature = random.nextInt(101).toDouble();

      mockData.add(temperature);
    }

    return Stream.periodic(const Duration(seconds: 5), (count) {
      // Update the temperature values every 5 seconds
      final updatedData = mockData.map((temperature) {
        final newTemperature = random.nextInt(101).toDouble();
        return newTemperature;
      }).toList();

      mockData.clear();
      mockData.addAll(updatedData);

      return updatedData;
    });
  }

  // Setters for desired temperature and PID values
  void setDesiredTemperature(double temperature) {
    _desiredTemperature = temperature;
    // TODO: Implement the logic to send the desired temperature to the coffee machine
  }

  void setPValue(double value) {
    _pValue = value;
    // TODO: Implement the logic to send the P value to the coffee machine
  }

  void setIValue(double value) {
    _iValue = value;
    // TODO: Implement the logic to send the I value to the coffee machine
  }

  void setDValue(double value) {
    _dValue = value;
    // TODO: Implement the logic to send the D value to the coffee machine
  }

  // Method to update the current temperature (simulating data from the coffee machine)
  void updateCurrentTemperature(double temperature) {
    _currentTemperature = temperature;
  }
}
