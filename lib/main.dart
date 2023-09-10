import 'package:flutter/material.dart';
import 'package:imc_calculator/components/imc_results.dart';
import 'package:imc_calculator/components/imc_table.dart';
import 'package:imc_calculator/components/register_new_imc.dart';
import 'package:imc_calculator/models/imc_model.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final List<ImcModel> _imcResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Calculadora de IMC",
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                RegisterNewImc(
                  imcResults: _imcResults,
                  validateForm: () {
                    return _formKey.currentState!.validate();
                  },
                  setState: () {
                    setState(() {});
                  },
                ),
                if (_imcResults.isNotEmpty)
                  ImcResults(
                    imcResults: _imcResults,
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: const ImcTable(),
    );
  }
}
