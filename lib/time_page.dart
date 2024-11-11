import 'package:flutter/material.dart';

class TimeConversionPage extends StatefulWidget {
  const TimeConversionPage({super.key});

  @override
  TimeConversionPageState createState() => TimeConversionPageState();
}

class TimeConversionPageState extends State<TimeConversionPage> {
  final TextEditingController timeController = TextEditingController();
  double convertedTime = 0.0;
  String inputUnit = 'Second (s)';
  String outputUnit = 'Minute (min)';
  String errorMessage = '';
  String conversionDescription = ''; // To hold the conversion explanation

  // Conversion factors relative to seconds
  final Map<String, double> conversionFactors = {
    'Year': 31536000,       // seconds in a year (approx.)
    'Week': 604800,         // seconds in a week
    'Day': 86400,           // seconds in a day
    'Hour': 3600,           // seconds in an hour
    'Minute (min)': 60,     // seconds in a minute
    'Second (s)': 1,        // base unit
    'Millisecond (ms)': 0.001,   // 1 ms is 0.001 seconds
    'Microsecond (µs)': 0.000001, // 1 µs is 1e-6 seconds
    'Picosecond (ps)': 1e-12,    // 1 ps is 1e-12 seconds
  };

  // Convert the time input
  void convertTime() {
    setState(() {
      double inputTime = double.tryParse(timeController.text) ?? 0.0;
      if (inputTime == 0.0 && timeController.text.isNotEmpty) {
        errorMessage = 'Please enter a valid time.';
        convertedTime = 0.0;
        conversionDescription = ''; // Reset the description
      } else {
        errorMessage = '';
        double inputInSeconds = inputTime * (conversionFactors[inputUnit] ?? 1);
        double output = inputInSeconds / (conversionFactors[outputUnit] ?? 1);
        convertedTime = output;

        // Set the conversion explanation
        conversionDescription = _generateConversionDescription(inputUnit, outputUnit);
      }
    });
  }

  // Swap input and output units
  void swapUnits() {
    setState(() {
      final temp = inputUnit;
      inputUnit = outputUnit;
      outputUnit = temp;
      convertTime(); // Trigger conversion after swap
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
        title: const Text('Time Conversion Description'),
        content: const Text(
          ' 1 Year = 31,536,000 seconds\n'
          ' 1 Week = 604,800 seconds\n'
          ' 1 Day = 86,400 seconds\n'
          ' 1 Hour = 3,600 seconds\n'
          ' 1 Minute = 60 seconds\n'
          ' 1 Second = The basic unit of time.\n'
          ' 1 Millisecond = 0.001 seconds\n'
          ' 1 Microsecond = 0.000001 seconds\n'
          ' 1 Picosecond = 0.000000000001 seconds\n\n'
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
        title: const Text('Time Conversion'),
        backgroundColor: colorScheme.primary,
        actions: [
          // Description Button
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: showDescription, // Show description when tapped
            tooltip: 'Time Conversion Description',
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
              message: 'Enter the time to be converted.',
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: timeController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: colorScheme.onBackground),
                  decoration: InputDecoration(
                    labelText: 'Enter time',
                    labelStyle: TextStyle(color: colorScheme.onBackground),
                    border: InputBorder.none,
                    errorText: errorMessage.isEmpty ? null : errorMessage,
                  ),
                  onChanged: (value) {
                    convertTime(); // Trigger conversion whenever input changes
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
                  message: 'Select the input time unit.',
                  child: const Text(
                    'From:',
                    style: TextStyle(color: Colors.white),
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
                      convertTime(); // Trigger conversion automatically
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.swap_horiz),
                  onPressed: swapUnits, // Swap the units
                  tooltip: 'Swap Units',
                ),
                Tooltip(
                  message: 'Select the output time unit.',
                  child: const Text(
                    'To:',
                    style: TextStyle(color: Colors.white),
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
                      convertTime(); // Trigger conversion automatically
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Result Display with tooltip
            Tooltip(
              message: 'The result of the time conversion.',
              child: Text(
                'Converted Time: ${convertedTime.toStringAsFixed(6)} $outputUnit',
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
