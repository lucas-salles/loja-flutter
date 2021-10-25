import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc extends BlocBase {
  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();

  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outloading => _loadingController.stream;

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
    await Future.delayed(Duration(seconds: 3));
    _loadingController.add(false);
    return true;
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    super.dispose();
  }
}
