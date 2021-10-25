import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc extends BlocBase {
  final _dataController = BehaviorSubject<Map>();

  Stream<Map> get outData => _dataController.stream;

  String categoryId;
  DocumentSnapshot? product;

  late Map<String, dynamic> unsavedData;

  ProductBloc({required this.categoryId, this.product}) {
    if (product != null) {
      unsavedData = Map.of(product!.data() as Map<String, dynamic>);
      unsavedData["images"] = List.of(product!.get("images"));
      unsavedData["sizes"] = List.of(product!.get("sizes"));
    } else {
      unsavedData = {
        "title": null,
        "description": null,
        "price": null,
        "images": [],
        "sizes": [],
      };
    }

    _dataController.add(unsavedData);
  }

  @override
  void dispose() {
    _dataController.close();
    super.dispose();
  }
}
