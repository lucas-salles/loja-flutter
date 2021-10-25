import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/product_bloc.dart';
import 'package:gerente_loja/widgets/images_field_widget.dart';

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

class _ProductScreenState extends State<ProductScreen> {
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
        title: Text("Criar Produto"),
        backgroundColor: Colors.pinkAccent,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.remove),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Form(
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
                    onSaved: (images) {},
                    validator: (images) {},
                  ),
                  TextFormField(
                    initialValue: snapshot.data!["title"],
                    style: _fieldStyle,
                    decoration: _buildDecoration("Título"),
                    onSaved: (value) {},
                    validator: (value) {},
                  ),
                  TextFormField(
                    initialValue: snapshot.data!["description"],
                    style: _fieldStyle,
                    maxLines: 6,
                    decoration: _buildDecoration("Descrição"),
                    onSaved: (value) {},
                    validator: (value) {},
                  ),
                  TextFormField(
                    initialValue: snapshot.data!["price"]?.toStringAsFixed(2),
                    style: _fieldStyle,
                    decoration: _buildDecoration("Preço"),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    onSaved: (value) {},
                    validator: (value) {},
                  ),
                ],
              );
            }),
      ),
    );
  }
}
