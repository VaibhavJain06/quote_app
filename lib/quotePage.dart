import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;


class QuotePage extends StatefulWidget {
  const QuotePage({super.key});

  @override
  _QuotePageState createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  String _quote = 'Your quote will appear here';
  Future<void> _fetchQuote() async {
    final apiKey = dotenv.env['API_KEY'];
    final response = await http.get(
      Uri.parse('https://api.api-ninjas.com/v1/quotes'),
      headers: {
        'X-Api-Key': apiKey!,
      }
      );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _quote = data[0]['quote'];
      });
    } else {
      setState(() {
        _quote = 'Failed to fetch quote';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Quote Fetcher')),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _quote,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
               const SizedBox(height: 20),
               ElevatedButton(
                onPressed: _fetchQuote,
                child: const Text('Fetch Quote'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

