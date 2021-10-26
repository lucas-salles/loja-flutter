import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc extends BlocBase {
  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();

  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outloading => _loadingController.stream;
  Stream<bool> get outCreated => _createdController.stream;

  String categoryId;
  DocumentSnapshot? product;

  late Map<String, dynamic> unsavedData;

  FirebaseStorage storage = FirebaseStorage.instance;

  ProductBloc({required this.categoryId, this.product}) {
    if (product != null) {
      unsavedData = Map.of(product!.data() as Map<String, dynamic>);
      unsavedData["images"] = List.of(product!.get("images"));
      unsavedData["sizes"] = List.of(product!.get("sizes"));

      _createdController.add(true);
    } else {
      unsavedData = {
        "title": null,
        "description": null,
        "price": null,
        "images": [],
        "sizes": [],
      };

      _createdController.add(false);
    }

    _dataController.add(unsavedData);
  }

  void saveTitle(String? title) {
    if (title != null) unsavedData["title"] = title;
  }

  void saveDescription(String? description) {
    if (description != null) unsavedData["description"] = description;
  }

  void savePrice(String? price) {
    if (price != null) unsavedData["price"] = double.parse(price);
  }

  void saveImages(List? images) {
    if (images != null) unsavedData["images"] = images;
  }

  Future<bool> saveProduct() async {
    _loadingController.add(true);

    try {
      if (product != null) {
        await _uploadImages(product!.id);
        await product!.reference.update(unsavedData);
      } else {
        DocumentReference docReference = await FirebaseFirestore.instance
            .collection("products")
            .doc(categoryId)
            .collection("items")
            .add(Map.from(unsavedData)..remove("images"));
        await _uploadImages(docReference.id);
        await docReference.update(unsavedData);
      }

      _createdController.add(true);
      _loadingController.add(false);
      return true;
    } catch (e) {
      _loadingController.add(false);
      return false;
    }
  }

  Future<void> _uploadImages(String productId) async {
    for (int i = 0; i < unsavedData["images"].length; i++) {
      if (unsavedData["images"][i] is String) continue;

      Reference reference = storage
          .ref()
          .child(categoryId)
          .child(productId)
          .child(DateTime.now().millisecondsSinceEpoch.toString());

      TaskSnapshot taskSnapshot = await reference
          .putFile(unsavedData["images"][i])
          .whenComplete(() async {
        String downloadURL = await reference.getDownloadURL();
        unsavedData["images"][i] = downloadURL;
      });
    }
  }

  void deleteProduct() {
    if (product != null) {
      product!.reference.delete();
    }
  }

  @override
  void dispose() {
    _createdController.close();
    _dataController.close();
    _loadingController.close();
    super.dispose();
  }
}
