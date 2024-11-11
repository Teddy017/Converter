import 'package:flutter/material.dart';

class SpeedPage extends StatefulWidget {
  const SpeedPage({super.key});

  @override
  SpeedPageState createState() => SpeedPageState();
}

class SpeedPageState extends State<SpeedPage> {
  final TextEditingController speedController = TextEditingController();
  double convertedSpeed = 0.0;
  String inputUnit = 'km/s';
  String outputUnit = 'm/s';
  String errorMessage = '';
  String conversionDescription = ''; // To hold the conversion explanation

  // Map of conversion factors relative to meters per second (m/s)
  final Map<String, double> conversionFactors = {
    'km/s': 1000,
    'm/s': 1,
    'mph': 0.44704,
    'km/h': 0.277778,
    'fps': 0.3048,
    'ips': 0.0254,
    'Ma': 340.29, // Approximate speed of sound at sea level in m/s
    'c': 299792458, // Speed of light in m/s
  };

  // Function to convert the speed
  void convertSpeed() {
    setState(() {
      double inputSpeed = double.tryParse(speedController.text) ?? 0.0;
      if (inputSpeed <= 0) {
        errorMessage = 'Please enter a valid speed greater than 0';
        convertedSpeed = 0.0;
        conversionDescription = ''; // Reset the description
      } else {
        errorMessage = '';
        double inputInMps = inputSpeed * (conversionFactors[inputUnit] ?? 1);
        double output = inputInMps / (conversionFactors[outputUnit] ?? 1);
        convertedSpeed = output;

        // Set the conversion explanation
        conversionDescription = _generateConversionDescription(inputUnit, outputUnit);
      }
    });
  }

  // Function to swap input and output units
  void swapUnits() {
    setState(() {
      final temp = inputUnit;
      inputUnit = outputUnit;
      outputUnit = temp;
      convertSpeed(); // Trigger conversion after swap
    });
  }

  // Generate the description of the conversion process
  String _generateConversionDescription(String inputUnit, String outputUnit) {
    double inputFactor = conversionFactors[inputUnit] ?? 1;
    double outputFactor = conversionFactors[outputUnit] ?? 1;
    String factorDescription = '${inputUnit} = ${(inputFactor / outputFactor).toStringAsFixed(2)} $outputUnit';
    return factorDescription;
  }

  // Show the conversion description in a dialog
  void showDescription() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Speed Conversion Description'),
        content: const Text(
          'This page allows you to convert speeds between various units such as km/s, m/s, mph, km/h, and more. '
          'Enter a value, select the input and output units, and the conversion will happen automatically. '
          'You can choose from several units like kilometers per second (km/s), meters per second (m/s), '
          'miles per hour (mph), kilometers per hour (km/h), and more. The result will be displayed in the unit you select. '
          'Additionally, you can swap the input and output units for easy conversions in both directions.',
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Speed Conversion'),
        backgroundColor: colorScheme.primary,
        actions: [
          // Description Button
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: showDescription, // Show description when tapped
            tooltip: 'Speed Conversion Description',
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
              message: 'Enter the speed to be converted.',
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: speedController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: colorScheme.onBackground),
                  decoration: InputDecoration(
                    labelText: 'Enter speed',
                    labelStyle: TextStyle(color: colorScheme.onBackground),
                    border: InputBorder.none,
                    errorText: errorMessage.isEmpty ? null : errorMessage,
                  ),
                  onChanged: (value) {
                    convertSpeed(); // Trigger conversion whenever input changes
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Row for Input and Output Unit dropdowns and Swap Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Tooltip(
                  message: 'Select the input speed unit.',
                  child: Text(
                    'From:',
                    style: TextStyle(
                      color: colorScheme.onBackground, // Dynamic color change
                    ),
                  ),
                ),
                Tooltip(
                  message: 'Choose the unit to convert from.',
                  child: DropdownButton<String>(
                    value: inputUnit,
                    dropdownColor: colorScheme.surface,
                    style: TextStyle(color: colorScheme.onBackground),
                    items: conversionFactors.keys.map((String unit) {
                      return DropdownMenuItem<String>(
                        value: unit,
                        child: Text(unit),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        inputUnit = newValue!;
                      });
                      convertSpeed(); // Trigger conversion automatically
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.swap_horiz),
                  onPressed: swapUnits, // Swap the units
                  tooltip: 'Swap Units',
                ),
                Tooltip(
                  message: 'Select the output speed unit.',
                  child: Text(
                    'To:',
                    style: TextStyle(
                      color: colorScheme.onBackground, // Dynamic color change
                    ),
                  ),
                ),
                Tooltip(
                  message: 'Choose the unit to convert to.',
                  child: DropdownButton<String>(
                    value: outputUnit,
                    dropdownColor: colorScheme.surface,
                    style: TextStyle(color: colorScheme.onBackground),
                    items: conversionFactors.keys.map((String unit) {
                      return DropdownMenuItem<String>(
                        value: unit,
                        child: Text(unit),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        outputUnit = newValue!;
                      });
                      convertSpeed(); // Trigger conversion automatically
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Result Display with tooltip
            Tooltip(
              message: 'The result of the speed conversion.',
              child: Text(
                'Converted Speed: ${convertedSpeed.toStringAsFixed(10)} $outputUnit', // Display 10 decimal points
                style: TextStyle(color: colorScheme.onBackground, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            // Description of conversion
            Tooltip(
              message: 'Explanation of the conversion process.',
              child: Text(
                'Conversion Explanation: $conversionDescription',
                style: TextStyle(color: colorScheme.onBackground),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
