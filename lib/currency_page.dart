import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyConversionPage extends StatefulWidget {
  const CurrencyConversionPage({super.key});

  @override
  CurrencyConversionPageState createState() => CurrencyConversionPageState();
}

class CurrencyConversionPageState extends State<CurrencyConversionPage> {
  final TextEditingController amountController = TextEditingController();
  double convertedAmount = 0.0;
  String fromCurrency = 'USD';
  String toCurrency = 'EUR';
  String errorMessage = '';
  List<String> currencies = [];

  @override
  void initState() {
    super.initState();
    fetchCurrencies();
  }

  // Function to fetch available currencies from the API
  Future<void> fetchCurrencies() async {
    try {
      final url = Uri.parse("https://v6.exchangerate-api.com/v6/46e09ecbe214ba645b21bd37/codes");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        setState(() {
          currencies = List<String>.from(jsonData['supported_codes'].map((code) => code[0]));
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load currency data';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    }
  }

  // Function to handle the currency conversion with debounce
  void onAmountChanged(String value) {
    final input = double.tryParse(value);
    setState(() {
      errorMessage = input == null || input <= 0 ? 'Please enter a valid amount greater than 0.' : '';
    });

    if (input != null && input > 0) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (value == amountController.text) {
          convertCurrency(input);
        }
      });
    }
  }

  Future<void> convertCurrency(double inputAmount) async {
    setState(() {
      errorMessage = ''; // Clear any previous error message
    });

    try {
      final url = Uri.parse("https://v6.exchangerate-api.com/v6/46e09ecbe214ba645b21bd37/pair/$fromCurrency/$toCurrency/$inputAmount");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          convertedAmount = jsonData['conversion_result'];
        });
      } else {
        setState(() {
          errorMessage = 'Conversion failed. Try again.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Convert Currency'),
        backgroundColor: colorScheme.primary,
      ),
      body: currencies.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : Container(
              color: colorScheme.background,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  // Input Field with error handling
                  Tooltip(
                    message: 'Enter the amount you want to convert.',
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: amountController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        style: TextStyle(color: colorScheme.onBackground, fontSize: 18),
                        decoration: InputDecoration(
                          labelText: 'Enter amount',
                          labelStyle: TextStyle(color: colorScheme.onBackground, fontSize: 16),
                          border: InputBorder.none,
                          errorText: errorMessage.isEmpty ? null : errorMessage,
                        ),
                        onChanged: onAmountChanged, // Debounced conversion
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Row for From and To Currency selection with swap button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('From:', style: TextStyle(color: colorScheme.onBackground, fontSize: 16)),
                      DropdownButton<String>(
                        value: fromCurrency,
                        dropdownColor: colorScheme.surface,
                        style: TextStyle(color: colorScheme.onBackground, fontSize: 16),
                        items: currencies.map((String currency) {
                          return DropdownMenuItem<String>(
                            value: currency,
                            child: Text(currency),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            fromCurrency = newValue!;
                          });
                          if (amountController.text.isNotEmpty) {
                            convertCurrency(double.tryParse(amountController.text) ?? 0.0);
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.swap_horiz),
                        onPressed: () {
                          setState(() {
                            String temp = fromCurrency;
                            fromCurrency = toCurrency;
                            toCurrency = temp;
                          });
                          if (amountController.text.isNotEmpty) {
                            convertCurrency(double.tryParse(amountController.text) ?? 0.0);
                          }
                        },
                        color: colorScheme.onBackground,
                      ),
                      Text('To:', style: TextStyle(color: colorScheme.onBackground, fontSize: 16)),
                      DropdownButton<String>(
                        value: toCurrency,
                        dropdownColor: colorScheme.surface,
                        style: TextStyle(color: colorScheme.onBackground, fontSize: 16),
                        items: currencies.map((String currency) {
                          return DropdownMenuItem<String>(
                            value: currency,
                            child: Text(currency),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            toCurrency = newValue!;
                          });
                          if (amountController.text.isNotEmpty) {
                            convertCurrency(double.tryParse(amountController.text) ?? 0.0);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Result Display with larger font size
                  Tooltip(
                    message: 'This will display the result of the conversion.',
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Converted Amount: ${convertedAmount.toStringAsFixed(2)} $toCurrency',
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
