
import 'package:directorio_grullo/providers/favoritos_provider.dart';
import 'package:directorio_grullo/services/firebase_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widget/categorias.dart';
import '../../widget/imagen_categorias.dart';

class Contenido extends StatefulWidget {
  const Contenido({super.key});

  @override
  State<Contenido> createState() => _ContenidoState();
}

class _ContenidoState extends State<Contenido> {
  Query databaseReference =
      FirebaseDatabase.instance.ref().child('UnidadesEconomicas');
  late FavoritosProvider favoritosProvider;

  List<String> unidadesFavoritas = [];

  @override
  void initState() {
    super.initState();
    favoritosProvider = context.read<FavoritosProvider>();
    _cargarUnidadesFavoritas();
    _cargarFavoritas();
  }

  void _cargarUnidadesFavoritas() async {
    // Obtén la lista de unidades favoritas del FavoritosProvider
    unidadesFavoritas = favoritosProvider.favoritos;
  }

  void _cargarFavoritas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Obtén la lista de unidades favoritas del SharedPreferences
    List<String>? storedFavoritos = prefs.getStringList('favoritos');

    if (storedFavoritos != null) {
      setState(() {
        unidadesFavoritas = storedFavoritos;
      });
    }
  }

  // Función para guardar la lista en SharedPreferences
  void _guardarUnidadesFavoritas(List<String> favoritos) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favoritos', favoritos);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 40, right: 235),
          child: Text(
            'Categorías',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.w300),
          ),
        ),
        SizedBox(
          height: 175,
          child: Padding(
            padding: const EdgeInsets.only(left: 2, right: 10, bottom: 25),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ImagenCategorias(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const Categorias(
                          categorias: 'Bares, cantinas y similares',
                        ),
                      ),
                    );
                  },
                  imagen: 'assets/BaresR.png',
                  text: 'BARES',
                  starRating: 4.0,
                ),
                ImagenCategorias(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const Categorias(
                          categorias:
                              'Restaurantes con servicio de preparación de alimentos a la carta o de comida corrida',
                        ),
                      ),
                    );
                  },
                  imagen: 'assets/RestaurantesR.png',
                  text: 'RESTAURANTES',
                  starRating: 5.0,
                ),
                ImagenCategorias(
                  onPressed: () { 
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const Categorias(
                          categorias:
                              'Cafeterías, fuentes de sodas, neverías, refresquerías y similares',
                        ),
                      ),
                    );
                  },
                  imagen: 'assets/CafeteriasR.png',
                  text: 'CAFETERIAS',
                  starRating: 0.0,
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 245, bottom: 10),
          child: Text(
            'Favoritos',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.w300),
          ),
        ),
        SizedBox(
          height: 450,
          child: unidadesFavoritas.isEmpty
              ? const Center(
                  child: Text(
                    'Sin Favoritos',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : FirebaseAnimatedList(
                  query: databaseReference,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    final String unidadEconomica =
                        snapshot.child('NombreNegocio').value.toString();
                    if (unidadesFavoritas.contains(unidadEconomica)) {
                      _guardarUnidadesFavoritas(unidadesFavoritas);
                      return CustomFirebaseList(snapshot: snapshot);
                    } else {
                      return Container();
                    }
                  },
                ),
        ),
      ],
    );
  }
}
