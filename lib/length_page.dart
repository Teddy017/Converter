import 'package:flutter/material.dart';

class LengthConversionPage extends StatefulWidget {
  const LengthConversionPage({super.key});

  @override
  LengthConversionPageState createState() => LengthConversionPageState();
}

class LengthConversionPageState extends State<LengthConversionPage> {
  final TextEditingController lengthController = TextEditingController();
  double convertedLength = 0.0;
  String inputUnit = 'Meter (m)';
  String outputUnit = 'Kilometer (km)';
  String errorMessage = '';

  void convertLength() {
    double inputData = double.tryParse(lengthController.text) ?? 0.0;

    if (inputData <= 0.0 && lengthController.text.isNotEmpty) {
      setState(() {
        errorMessage = 'Please enter a valid number greater than 0.';
      });
      return;
    }

    setState(() {
      errorMessage = ''; // Clear any previous error message
    });

    double lengthInMeters = toMeters(inputData, inputUnit);
    double outputLength = fromMeters(lengthInMeters, outputUnit);

    setState(() {
      convertedLength = outputLength;
    });
  }

  // Convert any unit to Meters
  double toMeters(double length, String unit) {
    switch (unit) {
      case 'Kilometer (km)':
        return length * 1000;
      case 'Decimeter (dm)':
        return length * 0.1;
      case 'Centimeter (cm)':
        return length * 0.01;
      case 'Millimeter (mm)':
        return length * 0.001;
      case 'Micrometer (μm)':
        return length * 0.000001;
      case 'Nanometer (nm)':
        return length * 0.000000001;
      case 'Picometer (pm)':
        return length * 0.000000000001;
      case 'Nautical mile (nmi)':
        return length * 1852;
      case 'Mile (mi)':
        return length * 1609.344;
      case 'Furlong (fur)':
        return length * 201.168;
      case 'Fathom (fath)':
        return length * 1.8288;
      case 'Yard (yd)':
        return length * 0.9144;
      case 'Foot (ft)':
        return length * 0.3048;
      case 'Inch (in)':
        return length * 0.0254;
      default:
        return length; // Meter (m)
    }
  }

  // Convert Meters to the target unit
  double fromMeters(double length, String unit) {
    switch (unit) {
      case 'Kilometer (km)':
        return length / 1000;
      case 'Decimeter (dm)':
        return length / 0.1;
      case 'Centimeter (cm)':
        return length / 0.01;
      case 'Millimeter (mm)':
        return length / 0.001;
      case 'Micrometer (μm)':
        return length / 0.000001;
      case 'Nanometer (nm)':
        return length / 0.000000001;
      case 'Picometer (pm)':
        return length / 0.000000000001;
      case 'Nautical mile (nmi)':
        return length / 1852;
      case 'Mile (mi)':
        return length / 1609.344;
      case 'Furlong (fur)':
        return length / 201.168;
      case 'Fathom (fath)':
        return length / 1.8288;
      case 'Yard (yd)':
        return length / 0.9144;
      case 'Foot (ft)':
        return length / 0.3048;
      case 'Inch (in)':
        return length / 0.0254;
      default:
        return length; // Meter (m)
    }
  }

  // Function to swap input and output units
  void swapUnits() {
    setState(() {
      String temp = inputUnit;
      inputUnit = outputUnit;
      outputUnit = temp;
    });
    convertLength(); // Re-trigger conversion after swapping
  }

  // Function to show a dialog with unit descriptions
  void showUnitInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Unit Descriptions'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Kilometer (km): 1000 meters.'),
                const SizedBox(height: 8),
                const Text('Meter (m): Base unit of length.'),
                const SizedBox(height: 8),
                const Text('Decimeter (dm): 0.1 meters.'),
                const SizedBox(height: 8),
                const Text('Centimeter (cm): 0.01 meters.'),
                const SizedBox(height: 8),
                const Text('Millimeter (mm): 0.001 meters.'),
                const SizedBox(height: 8),
                const Text('Micrometer (μm): 0.000001 meters.'),
                const SizedBox(height: 8),
                const Text('Nanometer (nm): 0.000000001 meters.'),
                const SizedBox(height: 8),
                const Text('Picometer (pm): 0.000000000001 meters.'),
                const SizedBox(height: 8),
                const Text('Nautical mile (nmi): 1852 meters.'),
                const SizedBox(height: 8),
                const Text('Mile (mi): 1609.344 meters.'),
                const SizedBox(height: 8),
                const Text('Furlong (fur): 201.168 meters.'),
                const SizedBox(height: 8),
                const Text('Fathom (fath): 1.8288 meters.'),
                const SizedBox(height: 8),
                const Text('Yard (yd): 0.9144 meters.'),
                const SizedBox(height: 8),
                const Text('Foot (ft): 0.3048 meters.'),
                const SizedBox(height: 8),
                const Text('Inch (in): 0.0254 meters.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
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
        title: const Text('Length Conversion'),
        backgroundColor: colorScheme.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: colorScheme.onPrimary),
            onPressed: showUnitInfo, // Show unit information dialog
          ),
        ],
      ),
      body: Container(
        color: colorScheme.surface, // Use surface color for page
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            // Input Field with distinct background
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: lengthController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Enter length',
                  labelStyle: TextStyle(color: colorScheme.onSurface),
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
                  convertLength(); // Trigger conversion automatically on input change
                },
              ),
            ),
            const SizedBox(height: 20),
            // Row for Input and Output units with Swap button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('From:', style: TextStyle(color: colorScheme.onSurface)),
                DropdownButton<String>(
                  value: inputUnit,
                  dropdownColor: colorScheme.surface,
                  style: TextStyle(color: colorScheme.onSurface),
                  items: [
                    'Kilometer (km)',
                    'Meter (m)',
                    'Decimeter (dm)',
                    'Centimeter (cm)',
                    'Millimeter (mm)',
                    'Micrometer (μm)',
                    'Nanometer (nm)',
                    'Picometer (pm)',
                    'Nautical mile (nmi)',
                    'Mile (mi)',
                    'Furlong (fur)',
                    'Fathom (fath)',
                    'Yard (yd)',
                    'Foot (ft)',
                    'Inch (in)'
                  ].map((unit) {
                    return DropdownMenuItem<String>(
                      value: unit,
                      child: Text(unit),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      inputUnit = newValue!;
                    });
                    convertLength();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.swap_horiz),
                  onPressed: swapUnits,
                  color: colorScheme.onSurface,
                ),
                Text('To:', style: TextStyle(color: colorScheme.onSurface)),
                DropdownButton<String>(
                  value: outputUnit,
                  dropdownColor: colorScheme.surface,
                  style: TextStyle(color: colorScheme.onSurface),
                  items: [
                    'Kilometer (km)',
                    'Meter (m)',
                    'Decimeter (dm)',
                    'Centimeter (cm)',
                    'Millimeter (mm)',
                    'Micrometer (μm)',
                    'Nanometer (nm)',
                    'Picometer (pm)',
                    'Nautical mile (nmi)',
                    'Mile (mi)',
                    'Furlong (fur)',
                    'Fathom (fath)',
                    'Yard (yd)',
                    'Foot (ft)',
                    'Inch (in)'
                  ].map((unit) {
                    return DropdownMenuItem<String>(
                      value: unit,
                      child: Text(unit),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      outputUnit = newValue!;
                    });
                    convertLength();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Result Display
            Text(
              'Converted Length: $convertedLength $outputUnit',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
