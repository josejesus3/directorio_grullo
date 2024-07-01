
import 'package:directorio_grullo/services/posicion_distancia_gps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../delegates/buscador_delegate.dart';
import '../../widget/popup_menu.dart';
import 'contenido.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  double u=0;
  Future<bool> onBackPressed() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('¿Desea salir de la aplicación?'),
            content: const Text('Presione "Salir" para salir de la aplicación'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: const Text('Salir'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarGrullo(context),
      body: WillPopScope(
        onWillPop: onBackPressed,
        child: const SingleChildScrollView(
          child: Contenido(),
        ),
      ),
    );
  }
}

AppBar _appBarGrullo(BuildContext context) {
  return AppBar(
    // Ajusta la altura del AppBar según tus necesidades
    titleSpacing: -20, // Elimina el espacio alrededor del título
    leading: IconButton(
        icon: Icon(
          Icons.location_on_outlined,
          color: Colors.orange.shade500,
          size: 40,
        ),
        splashColor: Colors.transparent,
        splashRadius: null,
        onPressed: () {
          askGpsAccess(context,0,0);
        }),
    title: ListTile(
      contentPadding: const EdgeInsets.symmetric(
          horizontal: 16), // Ajusta el espacio en torno al contenido
      title: Container(
        height: 38,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(17)),
          color: Colors.white,
        ),
        child: const Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(
                Icons.search_outlined,
                color: Colors.black26,
                size: 25,
              ),
            ),
            Text(
              '¿Que desea Buscar?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
      onTap: () {
        showSearch(
          context: context,
          delegate: CustomSearchDelegate(),
        );
      },
    ),
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(234, 147, 89, 0.581),
            Color.fromRGBO(232, 161, 113, 0.174),
          ],
        ),
      ),
    ),
    actions: const [
      PopupMenu(),
    ],
  );
}

