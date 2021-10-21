import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/product_data.dart';

class CartProduct {
  late String cid;
  late String category;
  late String pid;
  late int quantity;
  late String size;
  late ProductData productData = ProductData();

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot document) {
    cid = document.id;
    category = document.get("category");
    pid = document.get("pid");
    quantity = document.get("quantity");
    size = document.get("size");
  }

  Map<String, dynamic> toMap() {
    return {
      "category": category,
      "pid": pid,
      "quantity": quantity,
      "size": size,
      "product": productData.toResumeMap(),
    };
  }

  @override
  String toString() {
    return "{cid=${cid}, category=${category}, pid=${pid}, quantity=${quantity}, size=${size}, productData=${productData}}";
  }
}
