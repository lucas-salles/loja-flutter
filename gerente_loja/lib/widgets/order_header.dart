import 'package:flutter/material.dart';

class OrderHeader extends StatelessWidget {
  const OrderHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Teste"),
              Text("Rua Flutter"),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Preço Produtos",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text("Preço Total"),
          ],
        ),
      ],
    );
  }
}
