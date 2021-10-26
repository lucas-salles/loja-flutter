import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/product_bloc.dart';
import 'package:gerente_loja/validators/product_validator.dart';
import 'package:gerente_loja/widgets/images_field_widget.dart';
import 'package:gerente_loja/widgets/product_sizes_field.dart';

class ProductScreen extends StatefulWidget {
  final String categoryId;
  final DocumentSnapshot? product;

  final ProductBloc _productBloc;

  ProductScreen({Key? key, required this.categoryId, this.product})
      : _productBloc = ProductBloc(
          categoryId: categoryId,
          product: product,
        ),
        super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> with ProductValidator {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _fieldStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
    );

    InputDecoration _buildDecoration(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.pinkAccent,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        elevation: 0,
        title: StreamBuilder<bool>(
            stream: widget._productBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              return Text(snapshot.data! ? "Editar Produto" : "Criar Produto");
            }),
        backgroundColor: Colors.pinkAccent,
        actions: [
          StreamBuilder<bool>(
              stream: widget._productBloc.outCreated,
              initialData: false,
              builder: (context, snapshot) {
                if (snapshot.data!) {
                  return StreamBuilder<bool>(
                      stream: widget._productBloc.outloading,
                      initialData: false,
                      builder: (context, snapshot) {
                        return IconButton(
                          onPressed: snapshot.data!
                              ? null
                              : () {
                                  widget._productBloc.deleteProduct();
                                  Navigator.of(context).pop();
                                },
                          icon: Icon(Icons.remove),
                        );
                      });
                } else {
                  return Container();
                }
              }),
          StreamBuilder<bool>(
              stream: widget._productBloc.outloading,
              initialData: false,
              builder: (context, snapshot) {
                return IconButton(
                  onPressed: snapshot.data! ? null : saveProduct,
                  icon: Icon(Icons.save),
                );
              }),
        ],
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: StreamBuilder<Map>(
                stream: widget._productBloc.outData,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  return ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      Text(
                        "Imagens",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      ImagesFieldWidget(
                        context: context,
                        initialValue: snapshot.data!["images"],
                        onSaved: widget._productBloc.saveImages,
                        validator: validateImages,
                      ),
                      TextFormField(
                        initialValue: snapshot.data!["title"],
                        style: _fieldStyle,
                        decoration: _buildDecoration("Título"),
                        onSaved: widget._productBloc.saveTitle,
                        validator: validateTitle,
                      ),
                      TextFormField(
                        initialValue: snapshot.data!["description"],
                        style: _fieldStyle,
                        maxLines: 6,
                        decoration: _buildDecoration("Descrição"),
                        onSaved: widget._productBloc.saveDescription,
                        validator: validateDescription,
                      ),
                      TextFormField(
                        initialValue:
                            snapshot.data!["price"]?.toStringAsFixed(2),
                        style: _fieldStyle,
                        decoration: _buildDecoration("Preço"),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        onSaved: widget._productBloc.savePrice,
                        validator: validatePrice,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Tamanhos",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      ProductSizesField(
                        context: context,
                        initialValue: snapshot.data!["sizes"],
                        onSaved: widget._productBloc.saveSizes,
                        validator: (sizes) {
                          if (sizes == null || sizes.isEmpty) {
                            return "Adicione um tamanho";
                          }
                        },
                      ),
                    ],
                  );
                }),
          ),
          StreamBuilder<bool>(
              stream: widget._productBloc.outloading,
              initialData: false,
              builder: (context, snapshot) {
                return IgnorePointer(
                  ignoring: !snapshot.data!,
                  child: Container(
                    color: snapshot.data! ? Colors.black54 : Colors.transparent,
                  ),
                );
              }),
        ],
      ),
    );
  }

  void saveProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Salvando produto...",
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(minutes: 1),
        backgroundColor: Colors.pinkAccent,
      ));

      bool success = await widget._productBloc.saveProduct();

      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          success ? "Produto salvo!" : "Erro ao salvar produto!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pinkAccent,
      ));
    }
  }
}
