import 'package:converter/length_page.dart';
import 'package:converter/mass_page.dart';
import 'package:converter/temperature_page.dart';
import 'package:flutter/material.dart';
import 'currency_page.dart'; // Import the CurrencyPage
import 'package:logging/logging.dart'; // Import logging package
import 'package:converter/data_page.dart';
import 'package:converter/time_page.dart';
import 'package:converter/number_system_page.dart';
import 'package:converter/speed_page.dart';
import 'package:converter/date_page.dart';

void main() {
  // Configure logging
  Logger.root.level = Level.ALL; // Set logging level
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Create a logger instance
  final Logger log = Logger('MyApp');
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Icon Buttons Grid',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Converter', style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              icon: Icon(_themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
              onPressed: _toggleTheme,
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1,
            children: <Widget>[
              _buildIconButton(Icons.currency_exchange, 'Currency', context),
              _buildIconButton(Icons.line_weight_rounded, 'Mass', context),
              _buildIconButton(Icons.legend_toggle_sharp, 'Length', context),
              _buildIconButton(Icons.data_object, 'Data', context),
              _buildIconButton(Icons.sunny_snowing, 'Temperature', context),
              _buildIconButton(Icons.timelapse, 'Time', context),
              _buildIconButton(Icons.numbers, 'Number System', context),
              _buildIconButton(Icons.speed, 'Speed', context),
              _buildIconButton(Icons.date_range, 'Date', context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Builder(
          builder: (BuildContext newContext) {
            return IconButton(
              icon: Icon(icon, size: 40),
              onPressed: () {
                _navigateToPage(label, newContext);
              },
            );
          },
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  void _navigateToPage(String label, BuildContext context) {
    final Map<String, Widget> pages = {
      'Currency': const CurrencyConversionPage(),
      'Mass': const MassSystemPage(),
      'Length': const LengthConversionPage(),
      'Data': const DataConversionPage(),
      'Temperature': const TemperatureConversionPage(),
      'Time': const TimeConversionPage(),
      'Number System': const NumberSystemPage(),
      'Speed': const SpeedPage(),
      'Date': const DatePage(),
    };

    if (pages.containsKey(label)) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => pages[label]!));
    } else {
      log.info('$label button pressed');
    }
  }
}
