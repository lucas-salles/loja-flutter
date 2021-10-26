import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/screens/product_screen.dart';
import 'package:gerente_loja/widgets/edit_category_dialog.dart';

class CategoryTile extends StatelessWidget {
  final DocumentSnapshot category;

  const CategoryTile({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      child: Card(
        child: ExpansionTile(
          leading: GestureDetector(
            onTap: () {
              showDialog(
                  context: context, builder: (context) => EditCategoryDialog());
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                category.get("icon"),
              ),
              backgroundColor: Colors.transparent,
            ),
          ),
          title: Text(
            category.get("title"),
            style: TextStyle(
              color: Colors.grey[850],
              fontWeight: FontWeight.w500,
            ),
          ),
          children: [
            FutureBuilder<QuerySnapshot>(
              future: category.reference.collection("items").get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else {
                  return Column(
                    children: snapshot.data!.docs.map((doc) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(doc.get("images")[0]),
                        ),
                        title: Text(doc.get("title")),
                        trailing:
                            Text("R\$ ${doc.get("price").toStringAsFixed(2)}"),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProductScreen(
                                    categoryId: category.id,
                                    product: doc,
                                  )));
                        },
                      );
                    }).toList()
                      ..add(
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              Icons.add,
                              color: Colors.pinkAccent,
                            ),
                          ),
                          title: Text("Adicionar"),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProductScreen(
                                      categoryId: category.id,
                                    )));
                          },
                        ),
                      ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
