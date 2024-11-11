import 'package:flutter/material.dart';

class MassSystemPage extends StatefulWidget {
  const MassSystemPage({super.key});

  @override
  MassSystemPageState createState() => MassSystemPageState();
}

class MassSystemPageState extends State<MassSystemPage> {
  final TextEditingController massController = TextEditingController();
  String inputUnit = 'kg';
  String outputUnit = 'g';
  String convertedMass = '';
  String errorMessage = '';

  // Conversion factor for each unit to grams
  double convertToGrams(double mass, String unit) {
    switch (unit) {
      case 't': return mass * 1000000; // Tonne to grams
      case 'kg': return mass * 1000; // Kilograms to grams
      case 'g': return mass; // Grams
      case 'mg': return mass / 1000; // Milligrams to grams
      case 'µg': return mass / 1000000; // Micrograms to grams
      case 'q': return mass * 100000; // Quintals to grams
      case 'lb': return mass * 453.592; // Pounds to grams
      case 'oz': return mass * 28.3495; // Ounces to grams
      case 'ct': return mass / 5; // Carats to grams
      case 'st': return mass * 6350.29; // Stones to grams
      default: return mass; // Default to grams if unknown
    }
  }

  // Conversion from grams to the desired output unit
  String convertMass(String mass, String fromUnit, String toUnit) {
    try {
      double massValue = double.parse(mass);
      double massInGrams = convertToGrams(massValue, fromUnit);
      double convertedValue = 0.0;

      switch (toUnit) {
        case 't': convertedValue = massInGrams / 1000000; break; // Grams to Tonne
        case 'kg': convertedValue = massInGrams / 1000; break; // Grams to Kilogram
        case 'g': convertedValue = massInGrams; break; // Grams
        case 'mg': convertedValue = massInGrams * 1000; break; // Grams to Milligrams
        case 'µg': convertedValue = massInGrams * 1000000; break; // Grams to Micrograms
        case 'q': convertedValue = massInGrams / 100000; break; // Grams to Quintal
        case 'lb': convertedValue = massInGrams / 453.592; break; // Grams to Pounds
        case 'oz': convertedValue = massInGrams / 28.3495; break; // Grams to Ounces
        case 'ct': convertedValue = massInGrams * 5; break; // Grams to Carats
        case 'st': convertedValue = massInGrams / 6350.29; break; // Grams to Stones
        default: return 'Invalid output unit';
      }
      return convertedValue.toStringAsFixed(3); // Show 3 decimal places
    } catch (e) {
      return 'Invalid input';
    }
  }

  // Function to automatically update the conversion
  void onInputChange() {
    setState(() {
      convertedMass = convertMass(massController.text, inputUnit, outputUnit);
    });
  }

  // Function to swap input and output units
  void swapUnits() {
    setState(() {
      String temp = inputUnit;
      inputUnit = outputUnit;
      outputUnit = temp;
    });
    onInputChange(); // Re-trigger conversion after swapping
  }

  // Function to show description (describes unit conversion logic)
  void showDescription() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Description'),
        content: const Text(
          ' 1 Tonne = 1,000,000 grams\n'
          ' 1 Kilogram = 1,000 grams\n'
          ' 1 Gram = The basic unit of mass.\n'
          ' 1 Milligram = 0.001 grams\n'
          ' 1 Microgram = 0.000001 grams\n'
          ' 1 Quintal = 100,000 grams\n'
          ' 1 Pound = 453.592 grams\n'
          ' 1 Ounce = 28.3495 grams\n'
          ' 1 Carat = 0.2 grams\n'
          ' 1 Stone = 6350.29 grams\n\n'
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
        title: const Text('Mass Unit Conversion'),
        backgroundColor: colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: showDescription, // Show the description dialog
            tooltip: 'View Description',
          ),
        ],
      ),
      body: Container(
        color: colorScheme.background, // Use background color for the page
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            // Input Field with distinct background and error handling
            Tooltip(
              message: 'Enter the mass value that you want to convert.',
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: massController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: colorScheme.onBackground),
                  decoration: InputDecoration(
                    labelText: 'Enter mass',
                    labelStyle: TextStyle(color: colorScheme.onBackground),
                    border: InputBorder.none,
                    errorText: errorMessage.isEmpty ? null : errorMessage,
                  ),
                  onChanged: (value) {
                    if (value.isEmpty || double.tryParse(value) == null) {
                      setState(() {
                        errorMessage = 'Please enter a valid number.';
                      });
                    } else {
                      setState(() {
                        errorMessage = ''; // Clear the error when valid input is detected
                      });
                    }
                    onInputChange(); // Trigger conversion automatically on input change
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Row for Input and Output units with Swap button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Tooltip(
                  message: 'Select the unit for the mass value you are converting from.',
                  child: Text(
                    'From:',
                    style: TextStyle(color: colorScheme.onBackground),
                  ),
                ),
                Tooltip(
                  message: 'Choose the input unit for mass.',
                  child: DropdownButton<String>(
                    value: inputUnit,
                    dropdownColor: colorScheme.surface,
                    style: TextStyle(color: colorScheme.onBackground),
                    items: ['t', 'kg', 'g', 'mg', 'µg', 'q', 'lb', 'oz', 'ct', 'st']
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
                      onInputChange();
                    },
                  ),
                ),
                Tooltip(
                  message: 'Swap the input and output units.',
                  child: IconButton(
                    icon: const Icon(Icons.swap_horiz),
                    onPressed: swapUnits,
                    color: colorScheme.onBackground,
                  ),
                ),
                Tooltip(
                  message: 'Select the unit you want to convert to.',
                  child: Text(
                    'To:',
                    style: TextStyle(color: colorScheme.onBackground),
                  ),
                ),
                Tooltip(
                  message: 'Choose the output unit for the converted mass.',
                  child: DropdownButton<String>(
                    value: outputUnit,
                    dropdownColor: colorScheme.surface,
                    style: TextStyle(color: colorScheme.onBackground),
                    items: ['t', 'kg', 'g', 'mg', 'µg', 'q', 'lb', 'oz', 'ct', 'st']
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
                      onInputChange();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Result Display with tooltip
            Tooltip(
              message: 'This will display the result of the conversion.',
              child: Text(
                'Converted Mass: $convertedMass $outputUnit',
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
