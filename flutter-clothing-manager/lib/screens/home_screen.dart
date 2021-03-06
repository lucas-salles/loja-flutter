import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gerente_loja/blocs/login_bloc.dart';
import 'package:gerente_loja/blocs/orders.bloc.dart';
import 'package:gerente_loja/blocs/user_bloc.dart';
import 'package:gerente_loja/screens/login_screen.dart';
import 'package:gerente_loja/tabs/orders_tab.dart';
import 'package:gerente_loja/tabs/products_tab.dart';
import 'package:gerente_loja/tabs/users_tab.dart';
import 'package:gerente_loja/widgets/edit_category_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _page = 0;

  LoginBloc _loginBloc = LoginBloc();
  UserBloc _userBloc = UserBloc();
  OrdersBloc _ordersBloc = OrdersBloc();

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        onTap: (page) {
          _pageController.animateToPage(
            page,
            duration: Duration(
              milliseconds: 500,
            ),
            curve: Curves.ease,
          );
        },
        backgroundColor: Colors.pinkAccent,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Clientes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Pedidos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Produtos",
          ),
        ],
      ),
      body: SafeArea(
        child: BlocProvider(
          blocs: [Bloc((i) => _userBloc), Bloc((i) => _ordersBloc)],
          dependencies: [],
          child: PageView(
            controller: _pageController,
            onPageChanged: (page) {
              setState(() {
                _page = page;
              });
            },
            children: [
              UserTab(),
              OrdersTab(),
              ProductsTab(),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloating(),
    );
  }

  Widget? _buildFloating() {
    switch (_page) {
      case 0:
        return FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text("Logout"),
                      content: Text("Deseja sair?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Cancelar",
                            style: TextStyle(
                              color: Colors.pinkAccent,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await _loginBloc.signOut();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: Text(
                            "Sair",
                            style: TextStyle(
                              color: Colors.pinkAccent,
                            ),
                          ),
                        ),
                      ],
                    ));
          },
          child: Icon(Icons.logout),
          backgroundColor: Colors.pinkAccent,
        );
      case 1:
        return SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: Colors.pinkAccent,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
              child: Icon(
                Icons.arrow_downward,
                color: Colors.pinkAccent,
              ),
              backgroundColor: Colors.white,
              label: "Conclu??dos Abaixo",
              labelStyle: TextStyle(
                fontSize: 14,
              ),
              onTap: () {
                _ordersBloc.setOrderCriteria(SortCriteria.READY_LAST);
              },
            ),
            SpeedDialChild(
              child: Icon(
                Icons.arrow_upward,
                color: Colors.pinkAccent,
              ),
              backgroundColor: Colors.white,
              label: "Conclu??dos Acima",
              labelStyle: TextStyle(
                fontSize: 14,
              ),
              onTap: () {
                _ordersBloc.setOrderCriteria(SortCriteria.READY_FIRST);
              },
            ),
          ],
        );
      case 2:
        return FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context, builder: (context) => EditCategoryDialog());
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.pinkAccent,
        );
    }
  }
}
