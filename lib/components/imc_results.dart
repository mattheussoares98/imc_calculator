import 'package:flutter/material.dart';

import '../models/imc_model.dart';

class ImcResults extends StatefulWidget {
  final List<ImcModel> imcResults;
  const ImcResults({
    required this.imcResults,
    Key? key,
  }) : super(key: key);

  @override
  State<ImcResults> createState() => _ImcResultsState();
}

class _ImcResultsState extends State<ImcResults> {
  static double _calculateImc({
    required double weight,
    required double height,
  }) {
    return weight / (height * height);
  }

  static Widget _icmResult({
    required double weight,
    required double height,
  }) {
    double imc = _calculateImc(weight: weight, height: height);
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

    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "Resultado: ",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "(${imc.toStringAsFixed(0)}) $imcResultText",
            style: TextStyle(
              color: imcResultText == "Saudável" ? Colors.green : Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget nameAndValue({
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle.replaceAll(RegExp(r'\.'), ','),
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          height: 20,
          color: Colors.black,
        ),
        const Text(
          "IMCs calculados",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        ListView.builder(
          reverse: true,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.imcResults.length,
          itemBuilder: (context, index) {
            ImcModel imcModel = widget.imcResults[index];
            return Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                shadowColor: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      nameAndValue(
                        title: "Nome: ",
                        subtitle: imcModel.name,
                      ),
                      nameAndValue(
                        title: "Altura: ",
                        subtitle: "${imcModel.height}m",
                      ),
                      nameAndValue(
                        title: "Peso: ",
                        subtitle: "${imcModel.weight} KG",
                      ),
                      _icmResult(
                        weight: imcModel.weight,
                        height: imcModel.height,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
