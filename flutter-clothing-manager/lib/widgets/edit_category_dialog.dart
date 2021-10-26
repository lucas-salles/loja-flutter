import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/category_bloc.dart';
import 'package:gerente_loja/widgets/image_source_sheet.dart';

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
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) =>
                          ImageSourceSheet(onImageSelected: (image) {
                            Navigator.of(context).pop();
                            widget._categoryBloc.setImage(image);
                          }));
                },
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
              title: StreamBuilder<String>(
                  stream: widget._categoryBloc.outTitle,
                  builder: (context, snapshot) {
                    return TextField(
                      controller: widget._controller,
                      onChanged: widget._categoryBloc.setTitle,
                      decoration: InputDecoration(
                        errorText:
                            snapshot.hasError ? snapshot.error as String : null,
                      ),
                    );
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StreamBuilder<bool>(
                    stream: widget._categoryBloc.outDelete,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Container();
                      return TextButton(
                        onPressed: snapshot.data!
                            ? () {
                                widget._categoryBloc.delete();
                                Navigator.of(context).pop();
                              }
                            : null,
                        child: Text(
                          "Excluir",
                          style: TextStyle(
                            color: snapshot.data! ? Colors.red : Colors.grey,
                          ),
                        ),
                      );
                    }),
                StreamBuilder<bool>(
                    stream: widget._categoryBloc.submitValid,
                    builder: (context, snapshot) {
                      return TextButton(
                        onPressed: snapshot.hasData
                            ? () async {
                                await widget._categoryBloc.saveData();
                                Navigator.of(context).pop();
                              }
                            : null,
                        child: Text(
                          "Salvar",
                          style: TextStyle(
                            color:
                                snapshot.hasData ? Colors.black : Colors.grey,
                          ),
                        ),
                      );
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
