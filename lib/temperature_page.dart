import 'package:flutter/material.dart';

class TemperatureConversionPage extends StatefulWidget {
  const TemperatureConversionPage({super.key});

  @override
  TemperatureConversionPageState createState() =>
      TemperatureConversionPageState();
}

class TemperatureConversionPageState extends State<TemperatureConversionPage> {
  final TextEditingController tempController = TextEditingController();
  double convertedTemperature = 0.0;
  String inputUnit = 'Celsius (°C)';
  String outputUnit = 'Fahrenheit (°F)';
  String errorMessage = '';

  // Function to convert temperature
  void convertTemperature() {
    setState(() {
      double inputTemp = double.tryParse(tempController.text) ?? 0.0;
      if (inputTemp == 0.0 && tempController.text.isNotEmpty) {
        errorMessage = 'Please enter a valid temperature.';
        convertedTemperature = 0.0;
      } else {
        errorMessage = '';
        double tempInCelsius = toCelsius(inputTemp, inputUnit);
        double outputTemp = fromCelsius(tempInCelsius, outputUnit);
        convertedTemperature = outputTemp;
      }
    });
  }

  // Converts any unit to Celsius
  double toCelsius(double temp, String unit) {
    switch (unit) {
      case 'Fahrenheit (°F)':
        return (temp - 32) * 5 / 9;
      case 'Kelvin (K)':
        return temp - 273.15;
      case 'Rankine (°R)':
        return (temp - 491.67) * 5 / 9;
      case 'Reaumur (°Re)':
        return temp * 5 / 4;
      default:
        return temp; // Celsius
    }
  }

  // Converts Celsius to the target unit
  double fromCelsius(double temp, String unit) {
    switch (unit) {
      case 'Fahrenheit (°F)':
        return (temp * 9 / 5) + 32;
      case 'Kelvin (K)':
        return temp + 273.15;
      case 'Rankine (°R)':
        return (temp + 273.15) * 9 / 5;
      case 'Reaumur (°Re)':
        return temp * 4 / 5;
      default:
        return temp; // Celsius
    }
  }

  // Function to show the description dialog
  void showDescription() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Temperature Conversion Description'),
        content: const Text(
            'Basic conversion formulas:\n\n'
            '1. Celsius to Kelvin: °C + 273.15 = K\n'
            '2. Celsius to Fahrenheit: (°C × 9/5) + 32 = °F\n'
            '3. Celsius to Rankine: (°C + 273.15) × 9/5 = °R\n'
            '4. Celsius to Reaumur: °C × 4/5 = °Re\n\n'
            ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Swap the input and output units
  void swapUnits() {
    setState(() {
      final temp = inputUnit;
      inputUnit = outputUnit;
      outputUnit = temp;
      convertTemperature(); // Trigger conversion after swap
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Convert Temperature'),
        backgroundColor: colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: showDescription, // Show description when clicked
            tooltip: 'View Description',
          ),
        ],
      ),
      body: Container(
        color: colorScheme.background,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            // Input Field with error handling
            Tooltip(
              message: 'Enter the temperature to be converted.',
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: tempController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: colorScheme.onBackground),
                  decoration: InputDecoration(
                    labelText: 'Enter temperature',
                    labelStyle: TextStyle(color: colorScheme.onBackground),
                    border: InputBorder.none,
                    errorText: errorMessage.isEmpty ? null : errorMessage,
                  ),
                  onChanged: (value) {
                    convertTemperature();
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Row for Input and Output Unit dropdowns
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Tooltip(
                  message: 'Select the input temperature unit.',
                  child: Text(
                    'From:',
                    style: TextStyle(color: colorScheme.onBackground),
                  ),
                ),
                Tooltip(
                  message: 'Choose the unit to convert from.',
                  child: DropdownButton<String>(
                    value: inputUnit,
                    dropdownColor: colorScheme.surface,
                    style: TextStyle(color: colorScheme.onBackground),
                    items: ['Celsius (°C)', 'Fahrenheit (°F)', 'Kelvin (K)', 'Rankine (°R)', 'Reaumur (°Re)']
                        .map((String unit) {
                      return DropdownMenuItem<String>(
                        value: unit,
                        child: Text(unit),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        inputUnit = newValue!;
                      });
                      convertTemperature(); // Trigger conversion automatically
                    },
                  ),
                ),
                // Swap Button
                IconButton(
                  icon: const Icon(Icons.swap_horiz),
                  onPressed: swapUnits,
                  tooltip: 'Swap Units',
                ),
                Tooltip(
                  message: 'Select the output temperature unit.',
                  child: Text(
                    'To:',
                    style: TextStyle(color: colorScheme.onBackground),
                  ),
                ),
                Tooltip(
                  message: 'Choose the unit to convert to.',
                  child: DropdownButton<String>(
                    value: outputUnit,
                    dropdownColor: colorScheme.surface,
                    style: TextStyle(color: colorScheme.onBackground),
                    items: ['Celsius (°C)', 'Fahrenheit (°F)', 'Kelvin (K)', 'Rankine (°R)', 'Reaumur (°Re)']
                        .map((String unit) {
                      return DropdownMenuItem<String>(
                        value: unit,
                        child: Text(unit),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        outputUnit = newValue!;
                      });
                      convertTemperature(); // Trigger conversion automatically
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Result Display with tooltip
            Tooltip(
              message: 'The result of the temperature conversion.',
              child: Text(
                'Converted Temperature: ${convertedTemperature.toStringAsFixed(2)} $outputUnit',
                style: TextStyle(color: colorScheme.onBackground, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
