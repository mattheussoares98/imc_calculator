import 'package:flutter/material.dart';

class ImcTable extends StatelessWidget {
  const ImcTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Image.asset(
                "lib\\assets\\imcTable.png",
              ),
            );
          },
        );
      },
      child: FittedBox(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: const [Text("Tabela"), Icon(Icons.table_chart_rounded)],
          ),
        ),
      ),
    );
  }
}
