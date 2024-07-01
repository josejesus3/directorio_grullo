
import 'package:flutter/material.dart';



class ImageDecoration extends StatelessWidget {
  final VoidCallback onPressed;
  final String imagen;
  final String text;
  final double starRating;
  const ImageDecoration(
      {super.key,
      required this.onPressed,
      required this.imagen,
      this.text = '',
      required this.starRating
     });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: ClipRRect(
            borderRadius:  BorderRadius.circular(25),
            child: Image.asset(
              imagen,
              height: 130,
              width: 220,
              // Asegúrate de que el ancho sea igual a la altura para obtener un círculo perfecto
              fit: BoxFit.cover, // Ajusta la imagen para llenar el círculo
            ),
          ),
        ),
        //Contenedor con nombre por categorias
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 18),
          decoration: const BoxDecoration(
            color: Colors.white24 ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 20, 
            color: Colors.white
            ),
          ),
        ),
      ],
    );
  }
}
