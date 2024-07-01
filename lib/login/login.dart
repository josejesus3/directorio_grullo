// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../Screens/home/principal.dart';
import '../delegates/registrar_delegate.dart';
import '../services/redes_sociales.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeUser = FocusNode();
  bool _obscurePassword = true;
  bool botonExit = true;
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref('UnidadesEconomicas');

  final TextEditingController textUsuario = TextEditingController();
  final TextEditingController textRFC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // Aquí puedes construir tu pantalla de inicio de sesión
    return WillPopScope(
      onWillPop: () async {
        botonExit
            ? Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return const Principal();
                }),
              )
            : botonExit = false;

        return botonExit;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      colors: [
                        Color.fromRGBO(241, 192, 159, 1),
                        Color.fromRGBO(241, 192, 159, 0.013),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 70,
                      ),
                      Image.asset(
                        'assets/TrasKiosko.png',
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white38,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 20, left: 20),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 45,
                                    ),
                                    _formUser(),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    _formPassword(),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    _buttonLogin(),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const Principal();
                                        },
                                      ),
                                    );
                                  },
                                  child: TextButton(
                                      onPressed: () => launcher(
                                          'https://drive.google.com/file/d/1fLntMp8-0bUBEALgUe0dZAwAS1XT7_j-/view?usp=sharing'),
                                      child: const Text(
                                          "¿Cómo modifico una Unidad Económica(Negocio)?")),
                                ),
                              ],
                            ),
                            const SizedBox(height: 60),
                            Image.asset('assets/TrasPagina.png')
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    top: 33,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const Principal()),
                        );
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 35,
                        color: Colors.white,
                      ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _formUser() {
    final outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black));
    return StreamBuilder(
      builder: (
        BuildContext context,
        AsyncSnapshot snapshot,
      ) {
        return TextField(
          focusNode: _focusNodeUser,
          controller: textUsuario,
          decoration: InputDecoration(
              labelText: 'Propietario',
              hintText: 'Nombre completo(propietario de UE)',
              labelStyle: const TextStyle(color: Colors.black),
              prefixIcon: const Icon(Icons.person_outline_outlined),
              border: outlineInputBorder,
              focusedBorder: outlineInputBorder
              ),
          onEditingComplete: () => _focusNodePassword.requestFocus(),
        );
      },
      stream: null,
    );
  }

  Widget _formPassword() {
    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.black),
    );
    return StreamBuilder(
      builder: (
        BuildContext context,
        AsyncSnapshot snapshot,
      ) {
        return TextField(
          controller: textRFC,
          obscureText: _obscurePassword,
          focusNode: _focusNodePassword,
          decoration: InputDecoration(
            labelText: 'RFC',
            hintText: 'Escribe el RFC de la UE',
            labelStyle: const TextStyle(color: Colors.black),
            prefixIcon: const Icon(Icons.password),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              icon: _obscurePassword
                  ? const Icon(Icons.visibility_outlined)
                  : const Icon(Icons.visibility_off_outlined),
            ),
            border: outlineInputBorder,
            focusedBorder: outlineInputBorder,
          ),
        );
      },
      stream: null,
    );
  }

  Widget _buttonLogin() {
    return SizedBox(
      width: 180,
      child: ElevatedButton(
        onPressed: () {
          if (textUsuario.text.isEmpty) {
            FocusScope.of(context).requestFocus(_focusNodeUser);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 2),
              content: Text('El campo propietario no puede estar vacío'),
            ));
          } else if (textRFC.text.isEmpty) {
            FocusScope.of(context).requestFocus(_focusNodePassword);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 1),
              content: Text('El campo RFC no puede estar vacío'),
            ));
          } else if (textUsuario.text.isNotEmpty && textRFC.text.isNotEmpty) {
            validarUsuarioRFC(textUsuario.text, int.parse(textRFC.text));
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange.shade600,
          elevation: 10,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Ingresar',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w300, color: Colors.black87),
        ),
      ),
    );
  }

  void validarUsuarioRFC(String usuario, int rfc) async {
    try {
      final response = await Dio().get(
          'https://appgobierno-c3e76-default-rtdb.firebaseio.com/Usuarios.json');

      if (response.statusCode == 200) {
        bool encontrado = false;

        for (var element in response.data) {
          if (element['NombrePropietario'] == usuario.trim() &&
              element['CodigoSCIAN'] == rfc) {
            encontrado = true;
            break;
          }
        }

        if (encontrado) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) {
              return RegisterSearchDelegate(
                textUsuario: textUsuario.text,
                textRFC: textRFC.text,
              );
            }),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.black38,
              duration: const Duration(seconds: 4),
              content: ListTile(
                leading: Icon(
                  Icons.warning_amber,
                  color: Colors.amber.shade400,
                ),
                title: const Text(
                  'Datos Incorrectos',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                subtitle: const Text(
                  'Revisar nombre del propietario sin acento\nAsegurarse que el RFC sea correcto',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        }
      } else {
        Exception();
      }
    } catch (e) {
      print(Exception(e));
    }
  }
}
