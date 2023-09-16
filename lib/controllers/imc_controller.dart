import 'package:flutter/material.dart';
import 'package:imc_calculator/database/sqflite_database.dart';
import '../models/imc_model.dart';

class ImcController {
  static TextEditingController heightController = TextEditingController();
  static TextEditingController nameController = TextEditingController();
  static TextEditingController weightController = TextEditingController();

  static void addNewImcCalculator({
    required ImcModel imcModel,
    required Function validateForm,
    required BuildContext context,
    required List<ImcModel> imcResults,
    required Function setState,
  }) async {
    bool isValid = validateForm();

    if (isValid) {
      int id = await SQFLiteDataBase.saveNewImcAndReturnId(imcModel: imcModel);

      if (id != 0) {
        imcModel.id = id;
        imcResults.add(imcModel);
        clearControllers();
        setState();
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Ocorreu um erro não esperado durante a gravação dos dados!",
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "O formulário não está válido! Corrija-o!",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  static void clearControllers() {
    heightController.text = "";
    weightController.text = "";
    nameController.text = "";
  }

  static double calculateImc({
    required double weight,
    required double height,
  }) {
    return weight / (height * height);
  }

  static String imcResult({
    required double weight,
    required double height,
  }) {
    double imc = calculateImc(weight: weight, height: height);
    String imcResultText = "";

    if (imc < 16) {
      imcResultText = "Magreza grave";
    } else if (imc < 17) {
      imcResultText = "Magreza moderada";
    } else if (imc < 18.5) {
      imcResultText = "Magreza leve";
    } else if (imc < 25) {
      imcResultText = "Saudável";
    } else if (imc < 30) {
      imcResultText = "Sobrepeso";
    } else if (imc < 35) {
      imcResultText = "Obesidade grau I";
    } else if (imc < 40) {
      imcResultText = "Obesidade grau II (severa)";
    } else {
      imcResultText = "Obesidade grau III (mórbido)";
    }

    return imcResultText;
  }
}
