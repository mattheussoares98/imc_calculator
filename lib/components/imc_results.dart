import 'package:flutter/material.dart';
import 'package:imc_calculator/controllers/imc_controller.dart';
import 'package:imc_calculator/database/sqflite_database.dart';

import '../models/imc_model.dart';

class ImcResults extends StatefulWidget {
  final List<ImcModel> imcResults;
  final Function setState;
  const ImcResults({
    required this.imcResults,
    required this.setState,
    Key? key,
  }) : super(key: key);

  @override
  State<ImcResults> createState() => _ImcResultsState();
}

class _ImcResultsState extends State<ImcResults> {
  static Widget _icmResult({
    required double weight,
    required double height,
  }) {
    String imcResultText = ImcController.imcResult(
      weight: weight,
      height: height,
    );

    double imc = ImcController.calculateImc(weight: weight, height: height);

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
      child: Wrap(
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
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
                      InkWell(
                        onTap: () async {
                          await SQFLiteDataBase.remove(id: imcModel.id!);
                          widget.imcResults.removeWhere(
                              (element) => element.id == imcModel.id);
                          widget.setState();
                        },
                        child: const Column(
                          children: [
                            Text(
                              "Excluir",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      )
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
