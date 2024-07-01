
import 'package:directorio_grullo/services/firebase_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate {
  Query databaseReference =
      FirebaseDatabase.instance.ref().child('UnidadesEconomicas');
  bool isLoading = true;

  @override
  String get searchFieldLabel => 'Escribe qué deseas buscar';

  @override
  TextStyle get searchFieldStyle => const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w400,
      );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buscador(query: query, databaseReference: databaseReference);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return query.isEmpty
        ? const Text('')
        : buscador(query: query, databaseReference: databaseReference);
  }

  Widget buscador({required String query, required Query databaseReference}) {
    return StreamBuilder(
      stream: databaseReference.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data?.snapshot.value != snapshot) {
          // Verifica si hay datos y si los datos son diferentes a los anteriores
          return query != ''
              ? FirebaseAnimatedList(
                  query: databaseReference,
                  shrinkWrap: true,
                  itemBuilder: (context, snapshot, animation, index) {
                    final unidadEco =
                        snapshot.child('NombreNegocio').value.toString();

                    if (unidadEco
                            .toLowerCase()
                            .trim()
                            .startsWith(query.toLowerCase().trim()) ||
                        unidadEco
                            .toLowerCase()
                            .trim()
                            .contains(query.toLowerCase().trim())) {
                      // Filtra la lista basándose en la consulta
                      return CustomFirebaseList(snapshot: snapshot,);
                      
                     } else {
                      return Container();
                    }
                  },
                )
              : const Center(
                  child: Text(
                    'Porfavor Ingresar Unidad economica a buscar',
                    style: TextStyle(fontSize: 15),
                  ),
                );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de carga mientras espera los datos
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        } else {
          // Puedes mostrar un mensaje de carga más largo aquí si lo deseas
          return Container();
        }
      },
    );
  }
}
