import 'package:flutter/material.dart';

class DataConversionPage extends StatefulWidget {
  const DataConversionPage({super.key});

  @override
  DataConversionPageState createState() => DataConversionPageState();
}

class DataConversionPageState extends State<DataConversionPage> {
  final TextEditingController dataController = TextEditingController();
  double convertedData = 0.0;
  String inputUnit = 'Byte (B)';
  String outputUnit = 'Kilobyte (KB)';
  String errorMessage = '';

  // Function to handle the automatic conversion
  void convertData() {
    double inputData = double.tryParse(dataController.text) ?? 0.0;

    if (inputData <= 0.0 && dataController.text.isNotEmpty) {
      // Show warning if invalid input
      setState(() {
        errorMessage = 'Please enter a valid number greater than 0.';
      });
      return;
    }

    setState(() {
      errorMessage = ''; // Clear any previous error message
    });

    double dataInBytes = toBytes(inputData, inputUnit);
    double outputData = fromBytes(dataInBytes, outputUnit);

    setState(() {
      convertedData = outputData;
    });
  }

  // Convert to bytes based on selected unit
  double toBytes(double data, String unit) {
    switch (unit) {
      case 'Kilobyte (KB)':
        return data * 1024;
      case 'Megabyte (MB)':
        return data * 1024 * 1024;
      case 'Gigabyte (GB)':
        return data * 1024 * 1024 * 1024;
      case 'Terabyte (TB)':
        return data * 1024 * 1024 * 1024 * 1024;
      case 'Petabyte (PB)':
        return data * 1024 * 1024 * 1024 * 1024 * 1024;
      default:
        return data; // Byte
    }
  }

  // Convert from bytes to selected output unit
  double fromBytes(double data, String unit) {
    switch (unit) {
      case 'Kilobyte (KB)':
        return data / 1024;
      case 'Megabyte (MB)':
        return data / (1024 * 1024);
      case 'Gigabyte (GB)':
        return data / (1024 * 1024 * 1024);
      case 'Terabyte (TB)':
        return data / (1024 * 1024 * 1024 * 1024);
      case 'Petabyte (PB)':
        return data / (1024 * 1024 * 1024 * 1024 * 1024);
      default:
        return data; // Byte
    }
  }

  // Function to swap input and output units
  void swapUnits() {
    setState(() {
      String temp = inputUnit;
      inputUnit = outputUnit;
      outputUnit = temp;
    });
    convertData(); // Re-trigger conversion after swapping
  }

  // Function to show a dialog with unit descriptions
  void showUnitInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Unit Descriptions'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Byte (B): The basic unit of data storage.'),
                SizedBox(height: 8),
                Text('Kilobyte (KB): 1 KB = 1024 bytes.'),
                SizedBox(height: 8),
                Text('Megabyte (MB): 1 MB = 1024 KB.'),
                SizedBox(height: 8),
                Text('Gigabyte (GB): 1 GB = 1024 MB.'),
                SizedBox(height: 8),
                Text('Terabyte (TB): 1 TB = 1024 GB.'),
                SizedBox(height: 8),
                Text('Petabyte (PB): 1 PB = 1024 TB.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Convert Data'),
        backgroundColor: colorScheme.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: colorScheme.onPrimary),
            onPressed: showUnitInfo, // Show unit information dialog
          ),
        ],
      ),
      body: Container(
        color: colorScheme.background, // Use background color for page
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            // Input Field with distinct background and error handling
            Tooltip(
              message: 'Enter the data size you want to convert.',
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: dataController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(color: colorScheme.onBackground, fontSize: 18),
                  decoration: InputDecoration(
                    labelText: 'Enter data size',
                    labelStyle: TextStyle(color: colorScheme.onBackground, fontSize: 16),
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
                    convertData(); // Trigger conversion automatically on input change
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
                  message: 'Select the unit for the data you are converting from.',
                  child: Text(
                    'From:',
                    style: TextStyle(color: colorScheme.onBackground, fontSize: 16),
                  ),
                ),
                Tooltip(
                  message: 'Choose the input unit for data.',
                  child: DropdownButton<String>(
                    value: inputUnit,
                    dropdownColor: colorScheme.surface,
                    style: TextStyle(color: colorScheme.onBackground, fontSize: 16),
                    items: [
                      'Byte (B)', 'Kilobyte (KB)', 'Megabyte (MB)', 'Gigabyte (GB)', 'Terabyte (TB)', 'Petabyte (PB)'
                    ].map((String unit) {
                      return DropdownMenuItem<String>(
                        value: unit,
                        child: Text(unit),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        inputUnit = newValue!;
                      });
                      convertData(); // Trigger conversion on unit change
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
                  message: 'Select the output unit for the converted data.',
                  child: Text(
                    'To:',
                    style: TextStyle(color: colorScheme.onBackground, fontSize: 16),
                  ),
                ),
                Tooltip(
                  message: 'Choose the output unit for data.',
                  child: DropdownButton<String>(
                    value: outputUnit,
                    dropdownColor: colorScheme.surface,
                    style: TextStyle(color: colorScheme.onBackground, fontSize: 16),
                    items: [
                      'Byte (B)', 'Kilobyte (KB)', 'Megabyte (MB)', 'Gigabyte (GB)', 'Terabyte (TB)', 'Petabyte (PB)'
                    ].map((String unit) {
                      return DropdownMenuItem<String>(
                        value: unit,
                        child: Text(unit),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        outputUnit = newValue!;
                      });
                      convertData(); // Trigger conversion on unit change
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Result Display with bold and larger font size
            Tooltip(
              message: 'This will display the result of the conversion.',
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                'Converted Data: ${convertedData.toStringAsFixed(6)} $outputUnit',
                style: TextStyle(color: colorScheme.onBackground, fontSize: 18),
                textAlign: TextAlign.center,
                  ),
                  
              ),
            ),
          ],
        ),
      ),
    );
  }
}
