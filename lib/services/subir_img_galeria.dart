// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// Función asíncrona para subir imágenes a la galería de una unidad económica
Future<List<String>> subirImgGaleria(
    {required List<File> imagenes,
    required String contactKey,
    List<String>? galeriaUrl,
    required BuildContext context}) async {
  // Lista para almacenar las URLs de las imágenes subidas

  List<String> urls = [...galeriaUrl!];
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref('UnidadesEconomicas');

  try {
    // Itera sobre cada imagen en la lista
    for (var imagen in imagenes) {
      // Crea una referencia en Firebase Storage para la imagen
      Reference reference = FirebaseStorage.instance
          .ref()
          .child('Galeria $contactKey')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Inicia la tarea de carga de la imagen
      UploadTask task = reference.putFile(imagen);

      // Muestra un diálogo de carga mientras se sube la imagen
      
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Subiendo Imagenes...'),
                LinearProgressIndicator(),
              ],
            ),
          );
        },
        barrierDismissible: false,
      );

      // Espera a que se complete la tarea de carga
      TaskSnapshot taskSnapshot = await task;

      // Obtiene la URL de descarga de la imagen y la agrega a la lista
      String url = await taskSnapshot.ref.getDownloadURL();

      urls.add(url);

      // Obtiene la referencia a la base de datos

      // Cierra el diálogo de carga después de completar la subida de imágenes
      Navigator.of(context).pop();

      // Actualiza la URL de la galería en la base de datos
      Map<String, dynamic> actualizarImagenes = {
        'GaleriaUrl': urls,
      };

      await databaseReference.child(contactKey).update(actualizarImagenes);
    }
  } catch (e) {
    // Captura cualquier excepción y la imprime en la consola
    Exception(e);
  }

  // Retorna la lista de URLs de imágenes subidas
  return urls;
}

Future<void> actualizarUrl(
    {required String contactKey,
    List<String>? galeriaUrl,
    required BuildContext context}) async {
  // Lista para almacenar las URLs de las imágenes subidas

  List<String> urls = [...galeriaUrl!];
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref('UnidadesEconomicas');
  try {
    // ignore: prefer_is_empty
    if (urls.length >= 1) {
     /* ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black38,
          duration: const Duration(seconds: 1),
          content: ListTile(
            leading: Icon(
              Icons.backup_outlined,
              color: Colors.amber.shade400,
            ),
            title: const Text(
              'Galeria Actualizada',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );*/
      Map<String, dynamic> actualizarNegocios = {
        'GaleriaUrl': urls,
      };
      await databaseReference.child(contactKey).update(actualizarNegocios);
    } else {
      await databaseReference.child(contactKey).update({'GaleriaUrl': ''});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.black38,
          duration: Duration(seconds: 1),
          content: ListTile(
            leading: Icon(
              Icons.image_not_supported_outlined,
            ),
            title: Text(
              'Sin imagenes en galeria',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }
  } catch (e) {
    Exception(e); // Imprime el error en la consola para referencia

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error al actualizar la información'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Retorna la lista de URLs de imágenes subidas
}
