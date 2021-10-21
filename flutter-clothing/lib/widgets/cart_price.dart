import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartPrice extends StatelessWidget {
  final VoidCallback buy;

  const CartPrice({Key? key, required this.buy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child:
            ScopedModelDescendant<CartModel>(builder: (context, child, model) {
          double price = model.getProductsPrice();
          double discount = model.getDiscount();
          double ship = model.getShipPrice();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Resumo do Pedido",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Subtotal"),
                  Text("R\$ ${price.toStringAsFixed(2)}"),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Desconto"),
                  Text("R\$ ${discount.toStringAsFixed(2)}"),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Entrega"),
                  Text("R\$ ${ship.toStringAsFixed(2)}"),
                ],
              ),
              Divider(),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "R\$ ${(price + ship - discount).toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              ElevatedButton(
                onPressed: buy,
                child: Text(
                  "Finzalizar Pedido",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
