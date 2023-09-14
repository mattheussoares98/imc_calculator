import 'package:flutter/material.dart';
import 'package:imc_calculator/components/text_form_field_personalized.dart';
import 'package:imc_calculator/controllers/imc_controller.dart';

import '../models/imc_model.dart';

class RegisterNewImc extends StatefulWidget {
  final List<ImcModel> imcResults;
  final Function setState;
  final Function validateForm;
  const RegisterNewImc({
    required this.imcResults,
    required this.validateForm,
    required this.setState,
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterNewImc> createState() => _RegisterNewImcState();
}

class _RegisterNewImcState extends State<RegisterNewImc> {
  String heightRegex = r'^[0-9]+([,.][0-9]+)?$';
  String nameRegex = r'^[a-zA-ZÀ-ÖØ-öø-ÿ\s]*$';
  String weightRegex = r'^\d+([\.,]\d{1,2})?$';

  FocusNode nameFocusNode = FocusNode();
  FocusNode heightFocusNode = FocusNode();
  FocusNode weightFocusNode = FocusNode();

  Future<void> _addNewImcResult() async {
    double height = double.tryParse(
            ImcController.heightController.text.replaceAll(',', '.')) ??
        0;
    double weight = double.tryParse(
            ImcController.weightController.text.replaceAll(',', '.')) ??
        0;

    String imcResult = ImcController.imcResult(
      weight: weight,
      height: height,
    );
    ImcController.addNewImcCalculator(
      context: context,
      validateForm: widget.validateForm,
      setState: widget.setState,
      imcModel: ImcModel(
        result: imcResult,
        height: height,
        weight: weight,
        name: ImcController.nameController.text,
      ),
      imcResults: widget.imcResults,
    );
    widget.setState();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormFieldPersonalized.formField(
          maxLength: 50,
          focusNode: nameFocusNode,
          textInputType: TextInputType.name,
          controller: ImcController.nameController,
          context: context,
          labelText: "Nome",
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(heightFocusNode);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, informe o nome.';
            }
            if (!RegExp(nameRegex).hasMatch(value)) {
              return 'Nome inválido. Use apenas letras!';
            }
            return null;
          },
        ),
        TextFormFieldPersonalized.formField(
          maxLength: 4,
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(weightFocusNode);
          },
          focusNode: heightFocusNode,
          textInputType: TextInputType.number,
          controller: ImcController.heightController,
          context: context,
          labelText: "Altura (m)",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Informe a altura!';
            }
            if (!RegExp(heightRegex).hasMatch(value)) {
              return 'Altura inválida!';
            } else if (double.parse(
                    value.toString().replaceAll(RegExp(r'\,'), '.')) >
                2.3) {
              return "Se você realmente tiver mais que 2,3m de altura, entre em contato com o suporte técnico";
            }
            return null;
          },
        ),
        TextFormFieldPersonalized.formField(
          maxLength: 6,
          textInputType: TextInputType.number,
          controller: ImcController.weightController,
          context: context,
          labelText: "Peso (kg)",
          onFieldSubmitted: (value) async {
            await _addNewImcResult();
          },
          focusNode: weightFocusNode,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, informe o peso.';
            } else if (!RegExp(weightRegex).hasMatch(value)) {
              return 'Peso inválido. Use números com vírgula ou ponto como separador!';
            } else if (double.parse(value.replaceAll(RegExp(r','), '.')) >
                200) {
              return "Se você tiver mais que 200KG, entre em contato com o suporte técnico!";
            }
            return null;
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async => _addNewImcResult(),
          child: const Text("Calcular ICM"),
        ),
      ],
    );
  }
}
