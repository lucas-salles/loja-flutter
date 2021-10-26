import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/category_bloc.dart';

class EditCategoryDialog extends StatefulWidget {
  final DocumentSnapshot? category;
  final CategoryBloc _categoryBloc;

  final TextEditingController _controller;

  EditCategoryDialog({Key? key, this.category})
      : _categoryBloc = CategoryBloc(category: category),
        _controller = TextEditingController(
            text: category != null ? category.get("title") : ""),
        super(key: key);

  @override
  State<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: GestureDetector(
                child: StreamBuilder(
                    stream: widget._categoryBloc.outImage,
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return CircleAvatar(
                          child: snapshot.data is File
                              ? Image.file(
                                  snapshot.data as File,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  snapshot.data as String,
                                  fit: BoxFit.cover,
                                ),
                          backgroundColor: Colors.transparent,
                        );
                      } else {
                        return Icon(Icons.image);
                      }
                    }),
              ),
              title: TextField(
                controller: widget._controller,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StreamBuilder<bool>(
                    stream: widget._categoryBloc.outDelete,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Container();
                      return TextButton(
                        onPressed: snapshot.data! ? () {} : null,
                        child: Text(
                          "Excluir",
                          style: TextStyle(
                            color: snapshot.data! ? Colors.red : Colors.grey,
                          ),
                        ),
                      );
                    }),
                TextButton(
                  onPressed: () {},
                  child: Text("Salvar"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
