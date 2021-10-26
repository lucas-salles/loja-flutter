import 'package:flutter/material.dart';

class AddSizeDialod extends StatelessWidget {
  final _controller = TextEditingController();

  AddSizeDialod({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.only(
          left: 8,
          right: 8,
          top: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.pinkAccent,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(_controller.text);
                },
                child: Text(
                  "Add",
                  style: TextStyle(
                    color: Colors.pinkAccent,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
