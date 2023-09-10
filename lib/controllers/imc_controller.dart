import 'package:flutter/material.dart';

import '../models/imc_model.dart';

class ImcController {
  static TextEditingController heightController = TextEditingController();
  static TextEditingController nameController = TextEditingController();
  static TextEditingController weightController = TextEditingController();

  static void addNewImcCalculator({
    required ImcModel imcModel,
    required List<ImcModel> imcResults,
  }) {
    imcResults.add(imcModel);
    clearControllers();
  }

  static void clearControllers() {
    heightController.text = "";
    weightController.text = "";
    nameController.text = "";
  }
}
