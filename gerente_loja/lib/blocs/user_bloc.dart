import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends BlocBase {
  final _usersController = BehaviorSubject<List>();

  Stream<List> get outUsers => _usersController.stream;

  Map<String, Map<String, dynamic>> _users = {};

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserBloc() {
    _addUsersListener();
  }

  void onChangedSearch(String search) {
    if (search.trim().isEmpty) {
      _usersController.add(_users.values.toList());
    } else {
      _usersController.add(_filter(search.trim()));
    }
  }

  List<Map<String, dynamic>> _filter(String search) {
    return _users.values
        .where(
            (user) => user["name"].toUpperCase().contains(search.toUpperCase()))
        .toList();
  }

  void _addUsersListener() {
    _firestore.collection("users").snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        String uid = change.doc.id;

        switch (change.type) {
          case DocumentChangeType.added:
            _users[uid] = change.doc.data()!;
            _subscribeToOrders(uid);
            break;
          case DocumentChangeType.modified:
            _users[uid]!.addAll(change.doc.data()!);
            _usersController.add(_users.values.toList());
            break;
          case DocumentChangeType.removed:
            _users.remove(uid);
            _unsubscribeToOrders(uid);
            _usersController.add(_users.values.toList());
            break;
        }
      });
    });
  }

  Map<String, dynamic> getUser(String uid) {
    return _users[uid]!;
  }

  void _subscribeToOrders(String uid) {
    _users[uid]!["subscription"] = _firestore
        .collection("users")
        .doc(uid)
        .collection("orders")
        .snapshots()
        .listen((orders) async {
      int numOrders = orders.docs.length;
      double money = 0.0;

      for (DocumentSnapshot doc in orders.docs) {
        DocumentSnapshot order =
            await _firestore.collection("orders").doc(doc.id).get();

        if (order.data() == null) continue;

        money += order.get("totalPrice");
      }

      _users[uid]!.addAll({"money": money, "orders": numOrders});

      _usersController.add(_users.values.toList());
    });
  }

  void _unsubscribeToOrders(String uid) {
    _users[uid]!["subscription"].cancel();
  }

  @override
  void dispose() {
    _usersController.close();
    super.dispose();
  }
}
