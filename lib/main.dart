import 'package:flutter/material.dart';
import 'package:provaflutter/card.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AppCard()),
      );
    }
  }

  // LOGIN
  Widget _buildTextFieldLogin({
    required TextEditingController controller,
    required IconData prefixIcon,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.black),
          border: InputBorder.none,
          prefixIcon: Icon(prefixIcon, color: Colors.black),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, preencha o campo de Login.';
          }
          if (value.length > 20) {
            return 'O login não pode ter mais de 20 caracteres.';
          }
          if (value.endsWith(' ')) {
            return 'O Login não pode terminar com espaço.';
          }
          return null;
        },
      ),
    );
  }

  // SENHA
  Widget _buildTextFieldPassword({
    required TextEditingController controller,
    required IconData prefixIcon,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.black),
          border: InputBorder.none,
          prefixIcon: Icon(prefixIcon, color: Colors.black),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, preencha o campo de senha.';
          }
          if (value.length < 2) {
            return 'A senha deve ter pelo menos dois caracteres.';
          }
          if (value.length > 20) {
            return 'A senha não pode ter mais de 20 caracteres.';
          }
          if (value.endsWith(' ')) {
            return 'A senha não pode terminar com espaço.';
          }
          if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
            return 'A senha só pode conter letras e números.';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff1E4D60), Color(0xff2E9690)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 40),
                      child: Text('Usuario',
                          style: TextStyle(color: Colors.white, fontSize: 16)))
                ],
              ),
              SizedBox(height: 10),
              _buildTextFieldLogin(
                controller: _usuarioController,
                prefixIcon: Icons.person,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 40, top: 16),
                      child: Text('Senha',
                          style: TextStyle(color: Colors.white, fontSize: 16)))
                ],
              ),
              SizedBox(height: 10),
              _buildTextFieldPassword(
                controller: _senhaController,
                prefixIcon: Icons.lock,
              ),
              SizedBox(height: 16),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // background color
                    onPrimary: Colors.white, // text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('Entrar'),
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: MediaQuery.of(context).size.width * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        const url = 'https://www.google.com.br';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          print('Não foi possível abrir o link.');
                        }
                      },
                      child: Text(
                        'Política de Privacidade',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
