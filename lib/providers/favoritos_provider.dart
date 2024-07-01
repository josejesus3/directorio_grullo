import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritosProvider extends ChangeNotifier {
  var favoritos = <String>[];

  FavoritosProvider() {
    _cargarFavoritos();
  }

  void marcaFavoritos(String unidadEconomica) {
    if (favoritos.contains(unidadEconomica)) {
      favoritos.remove(unidadEconomica);
    } else {
      favoritos.add(unidadEconomica);
    }
    _guardarFavoritos();
    notifyListeners();
  }


  bool esFavorito(String unidadEconomica) {
    _guardarFavoritos();
    return favoritos.contains(unidadEconomica);
  }

  // Método para guardar la lista de favoritos en SharedPreferences
  Future<void> _guardarFavoritos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favoritos', favoritos);
  }

  // Método para cargar la lista de favoritos desde SharedPreferences
  Future<void> _cargarFavoritos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    favoritos = prefs.getStringList('favoritos') ?? [];
    notifyListeners();
  }
}
