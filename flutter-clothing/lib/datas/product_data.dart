import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  late String category = "";
  late String id = "";
  late String title = "";
  late String description = "";
  late double price = 0;
  late List images = [];
  late List sizes = [];

  ProductData();

  ProductData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.id;
    title = snapshot.get("title");
    description = snapshot.get("description");
    price = snapshot.get("price") + 0.0;
    images = snapshot.get("images");
    sizes = snapshot.get("sizes");
  }

  Map<String, dynamic> toResumeMap() {
    return {
      "title": title,
      "description": description,
      "price": price,
    };
  }

  @override
  String toString() {
    return "{category=${category}, id=${id}, title=${title}, description=${description}, price=${price}, images=${images}, sizes=${sizes}}";
  }
}
