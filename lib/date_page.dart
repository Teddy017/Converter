import 'package:flutter/material.dart';

class DatePage extends StatefulWidget {
  const DatePage({super.key});

  @override
  DatePageState createState() => DatePageState();
}

class DatePageState extends State<DatePage> {
  DateTime? fromDate;
  DateTime? toDate;
  String difference = '';

  // Show the date picker
  Future<void> pickDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
      calculateDifference(); // Trigger the calculation after date selection
    }
  }

  // Calculate the difference between two dates
  void calculateDifference() {
    if (fromDate != null && toDate != null) {
      final differenceDuration = toDate!.difference(fromDate!);
      
      // Calculate absolute difference
      final absoluteDifference = differenceDuration.abs();
      
      final years = (absoluteDifference.inDays / 365).floor();
      final months = ((absoluteDifference.inDays % 365) / 30).floor();
      final days = (absoluteDifference.inDays % 365) % 30;

      setState(() {
        difference = '$years Year(s), $months Month(s), $days Day(s)';
      });
    } else {
      setState(() {
        difference = 'Please select both dates';
      });
    }
  }

  // Swap the From and To Dates
  void swapDates() {
    setState(() {
      final temp = fromDate;
      fromDate = toDate;
      toDate = temp;
    });
    calculateDifference(); // Recalculate after swapping
  }

  // Show a dialog with date difference calculation info
  void showDateInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Date Difference Info'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Year(s) are approximated as 365 days.'),
                SizedBox(height: 8),
                Text('Month(s) are approximated as 30 days.'),
                SizedBox(height: 8),
                Text('Day(s) are the remainder of the calculation.'),
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
        title: const Text('Date Difference'),
        backgroundColor: colorScheme.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: colorScheme.onPrimary),
            onPressed: showDateInfo, // Show date information dialog
          ),
        ],
      ),
      body: Container(
        color: colorScheme.surface,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select Dates to Calculate Difference',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // From Date Picker
            TextButton(
              onPressed: () => pickDate(context, true),
              child: Text(
                fromDate == null
                    ? 'Select From Date'
                    : 'From Date: ${fromDate!.day}-${fromDate!.month}-${fromDate!.year}',
                style: TextStyle(color: colorScheme.onSurface),
              ),
            ),
            const SizedBox(height: 20),
            // To Date Picker
            TextButton(
              onPressed: () => pickDate(context, false),
              child: Text(
                toDate == null
                    ? 'Select To Date'
                    : 'To Date: ${toDate!.day}-${toDate!.month}-${toDate!.year}',
                style: TextStyle(color: colorScheme.onSurface),
              ),
            ),
            const SizedBox(height: 20),
            // Swap Button
            IconButton(
              icon: Icon(Icons.swap_horiz, color: colorScheme.primary),
              onPressed: swapDates, // Swap dates on button press
            ),
            const SizedBox(height: 20),
            // Result Display in TextField-like Box
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                enabled: false,
                controller: TextEditingController(text: difference),
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Difference',
                  labelStyle: TextStyle(color: colorScheme.onSurface),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
