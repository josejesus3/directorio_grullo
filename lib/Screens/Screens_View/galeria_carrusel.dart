// Importaciones necesarias

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
/*Este código define un widget llamado GaleriaCarrusel que utiliza el paquete carousel_slider 
para mostrar una galería de imágenes en 
forma de carrusel. La lista de URLs de imágenes se proporciona como parámetro al constructor del widget.*/

// Widget para mostrar una galería de imágenes en forma de carrusel
class GaleriaCarrusel extends StatelessWidget {
  // Lista de URLs de las imágenes
  final List<String> urls;

  // Constructor que requiere la lista de URLs
  const GaleriaCarrusel({super.key, required this.urls});

  // Método para construir la interfaz de usuario
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 300,
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        autoPlay: true,
      ),
      // Mapear cada URL a un elemento del carrusel
      items: urls.map((url) {
        return Builder(
          builder: (BuildContext context) {
            return Image.network(
              url.trim(),
              width: double.infinity,
              fit: BoxFit.cover,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                return child;
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return const SizedBox(
                    width: 110,
                    height: 65,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.black26,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                  );
                }
              },
            );
          },
        );
      }).toList(),
    );
  }
}
