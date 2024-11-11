import 'package:flutter/material.dart';

class NumberSystemPage extends StatefulWidget {
  const NumberSystemPage({super.key});

  @override
  NumberSystemPageState createState() => NumberSystemPageState();
}

class NumberSystemPageState extends State<NumberSystemPage> {
  final TextEditingController numberController = TextEditingController();
  String inputSystem = 'DEC';
  String outputSystem = 'BIN';
  String convertedNumber = '';
  String errorMessage = '';

  // Conversion functions for different number systems
  String convertNumber(String number, String fromSystem, String toSystem) {
    int baseFrom = getBase(fromSystem);
    int baseTo = getBase(toSystem);

    // Try to parse the input number to an integer based on the input system's base
    try {
      int decimalValue = int.parse(number, radix: baseFrom);
      return decimalValue.toRadixString(baseTo).toUpperCase();
    } catch (e) {
      return 'Invalid input';
    }
  }

  // Helper function to get the base for each system
  int getBase(String system) {
    switch (system) {
      case 'BIN':
        return 2;
      case 'OCT':
        return 8;
      case 'DEC':
        return 10;
      case 'HEX':
        return 16;
      default:
        return 10;
    }
  }

  // Function to automatically trigger conversion when input changes
  void onInputChange() {
    setState(() {
      convertedNumber = convertNumber(numberController.text, inputSystem, outputSystem);
    });
  }

  // Function to swap input and output systems
  void swapSystems() {
    setState(() {
      String temp = inputSystem;
      inputSystem = outputSystem;
      outputSystem = temp;
    });
    onInputChange(); // Re-trigger conversion after swapping
  }

  // Function to show description dialog
  void showDescription() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Number System Conversion Description'),
        content: const Text(
            'This page allows you to convert between number systems: '
            'Binary (BIN), Octal (OCT), Decimal (DEC), and Hexadecimal (HEX). '
            'The conversion is done based on the chosen input and output systems.\n\n'
            'It works by first converting the input number to decimal, and then converting '
            'it to the target number system (e.g., binary, octal, etc.).'),
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
        title: const Text('Number System Conversion'),
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
        color: colorScheme.background, // Use background color for the page
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            // Input Field with error handling
            Tooltip(
              message: 'Enter a number in the selected input system.',
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: numberController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: colorScheme.onBackground),
                  decoration: InputDecoration(
                    labelText: 'Enter number',
                    labelStyle: TextStyle(color: colorScheme.onBackground),
                    border: InputBorder.none,
                    errorText: errorMessage.isEmpty ? null : errorMessage,
                  ),
                  onChanged: (value) {
                    if (value.isEmpty || int.tryParse(value, radix: getBase(inputSystem)) == null) {
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
            // Row for Input and Output systems with Swap button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Tooltip(
                  message: 'Select the input number system (BIN, OCT, DEC, HEX).',
                  child: const Text('From:', style: TextStyle(color: Colors.white)),
                ),
                Tooltip(
                  message: 'Choose the number system to convert from.',
                  child: DropdownButton<String>(
                    value: inputSystem,
                    dropdownColor: colorScheme.surface,
                    style: TextStyle(color: colorScheme.onBackground),
                    items: ['BIN', 'OCT', 'DEC', 'HEX'].map((String system) {
                      return DropdownMenuItem<String>(
                        value: system,
                        child: Text(system),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        inputSystem = newValue!;
                      });
                      onInputChange(); // Trigger conversion automatically
                    },
                  ),
                ),
                Tooltip(
                  message: 'Swap input and output systems.',
                  child: IconButton(
                    icon: const Icon(Icons.swap_horiz),
                    onPressed: swapSystems,
                    color: colorScheme.onBackground,
                  ),
                ),
                Tooltip(
                  message: 'Select the output number system (BIN, OCT, DEC, HEX).',
                  child: const Text('To:', style: TextStyle(color: Colors.white)),
                ),
                Tooltip(
                  message: 'Choose the number system to convert to.',
                  child: DropdownButton<String>(
                    value: outputSystem,
                    dropdownColor: colorScheme.surface,
                    style: TextStyle(color: colorScheme.onBackground),
                    items: ['BIN', 'OCT', 'DEC', 'HEX'].map((String system) {
                      return DropdownMenuItem<String>(
                        value: system,
                        child: Text(system),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        outputSystem = newValue!;
                      });
                      onInputChange(); // Trigger conversion automatically
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Result Display with tooltip
            Tooltip(
              message: 'The result of the conversion.',
              child: Text(
                'Converted Number: $convertedNumber',
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
