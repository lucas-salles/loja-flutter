import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  const UserTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.white,
    );

    return ListTile(
      title: Text(
        "title",
        style: textStyle,
      ),
      subtitle: Text(
        "subtitle",
        style: textStyle,
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Pedidos: 0",
            style: textStyle,
          ),
          Text(
            "Gasto: 0",
            style: textStyle,
          )
        ],
      ),
    );
  }
}
