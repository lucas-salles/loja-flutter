import 'package:flutter/material.dart';
import 'package:gerente_loja/widgets/order_tile.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 16,
      ),
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return OrderTile();
        },
      ),
    );
  }
}
