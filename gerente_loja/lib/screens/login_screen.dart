import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/login_bloc.dart';
import 'package:gerente_loja/widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc();
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.store_mall_directory,
                  color: Colors.pinkAccent,
                  size: 160,
                ),
                InputField(
                  icon: Icons.person_outline,
                  hint: "Usuário",
                  obscure: false,
                  stream: _loginBloc.outEmail,
                  onChanged: _loginBloc.changeEmail,
                ),
                InputField(
                  icon: Icons.lock_outline,
                  hint: "Senha",
                  obscure: true,
                  stream: _loginBloc.outPassword,
                  onChanged: _loginBloc.changePassword,
                ),
                SizedBox(
                  height: 32,
                ),
                StreamBuilder<bool>(
                    stream: _loginBloc.outSubmitValid,
                    builder: (context, snapshot) {
                      return SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: snapshot.data != null ? () {} : null,
                          child: Text(
                            "Entrar",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.pinkAccent,
                            onSurface: Colors.pinkAccent.withAlpha(140),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
