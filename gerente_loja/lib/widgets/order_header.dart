import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/user_bloc.dart';

class OrderHeader extends StatelessWidget {
  final DocumentSnapshot order;

  const OrderHeader({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userBloc = BlocProvider.getBloc<UserBloc>();

    final _user = _userBloc.getUser(order.get("clientId"));

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${_user["name"]}"),
              Text("${_user["address"]}"),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Produtos: R\$ ${order.get("productsPrice").toStringAsFixed(2)}",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text("Total: R\$ ${order.get("totalPrice").toStringAsFixed(2)}"),
          ],
        ),
      ],
    );
  }
}
