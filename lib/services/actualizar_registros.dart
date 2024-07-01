// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

/// Clase que contiene operaciones de base de datos para actualizar la información de la aplicación.
class DatabaseOperations {
  /// Actualiza la información de la aplicación, incluida la imagen del perfil.
  ///
  /// Parámetros:
  /// - [titulo]: Título del negocio.
  /// - [descripcion]: Descripción del negocio.
  /// - [telefono]: Número telefónico del negocio.
  /// - [direccion]: Dirección del negocio.
  /// - [horarioEntrada]: Hora de apertura del negocio.
  /// - [horarioSalida]: Hora de cierre del negocio.
  /// - [imagenUpload]: Archivo de imagen para cargar como perfil (puede ser nulo si no se está actualizando la imagen).
  /// - [contactKey]: Clave de contacto en la base de datos.
  /// - [databaseReference]: Referencia a la base de datos Firebase.
  /// - [context]: Contexto de la aplicación.
  /// - [url]: URL de la imagen de perfil después de la carga.
  /// - [facebook]: Enlace de Facebook del negocio.
  /// - [instagram]: Enlace de Instagram del negocio.
  /// - [whatsapp]: Número de WhatsApp del negocio.
  static Future<void> actualizarApp({
    required String titulo,
    required String descripcion,
    required String telefono,
    required String direccion,
    required String horarioEntrada,
    required String horarioSalida,
    required File? imagenUpload,
    required String contactKey,
    required DatabaseReference databaseReference,
    required BuildContext context,
    required String url,
    required String facebook,
    required String instagram,
    required String whatsapp,
  }) async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      Reference reference =
          storage.ref().child('ImagenesPerfil').child('/$titulo.jpg');
      UploadTask task = reference.putFile(imagenUpload!);

      // Muestra la barra de carga mientras se está subiendo la imagen
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Subiendo información...'),
                LinearProgressIndicator(),
              ],
            ),
          );
        },
        barrierDismissible: false,
      );

      TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();

      // Cierra la barra de carga después de completar la subida
      Navigator.of(context).pop();

      if (titulo.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.black38,
            content: ListTile(
                leading: Icon(
                  Icons.backup_outlined,
                  color: Colors.white,
                ),
                title: Text(
                  'Campos actualizados exitosamente',
                  style: TextStyle(color: Colors.white),
                )),
            duration: Duration(seconds: 1),
          ),
        );
        Map<String, dynamic> actualizarNegocios = {
          'NombreNegocio': titulo,
          'DescripcionNegocio': descripcion,
          'NumeroTelefonico': telefono,
          'Domicilio': direccion,
          'HoraApertura': horarioEntrada,
          'HoraCierre': horarioSalida,
          'Url': url,
          'Facebook': facebook,
          'Instagram': instagram,
          'WhatsApps': whatsapp,
        };
        await databaseReference.child(contactKey).update(actualizarNegocios);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.black38,
            content: ListTile(
                leading: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                title: Text(
                  'Campo nombre no puede quedar vacio',
                  style: TextStyle(color: Colors.white),
                )),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      Exception(e); // Imprime el error en la consola para referencia

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black38,
          duration: const Duration(seconds: 1),
          content: ListTile(
            leading: Icon(
              Icons.warning_amber,
              color: Colors.amber.shade400,
            ),
            title: const Text(
              'Error al actualizar la información',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }
  }

  /// Actualiza la información de la aplicación sin cambiar la imagen del perfil.
  ///
  /// Parámetros:
  /// - [titulo]: Título del negocio.
  /// - [descripcion]: Descripción del negocio.
  /// - [telefono]: Número telefónico del negocio.
  /// - [direccion]: Dirección del negocio.
  /// - [horarioEntrada]: Hora de apertura del negocio.
  /// - [horarioSalida]: Hora de cierre del negocio.
  /// - [contactKey]: Clave de contacto en la base de datos.
  /// - [databaseReference]: Referencia a la base de datos Firebase.
  /// - [context]: Contexto de la aplicación.
  /// - [url]: URL de la imagen de perfil (sin cambios en este caso).
  /// - [facebook]: Enlace de Facebook del negocio.
  /// - [instagram]: Enlace de Instagram del negocio.
  /// - [whatsapp]: Número de WhatsApp del negocio.
  static Future<void> actualizarAppSinImagen({
    required String titulo,
    required String descripcion,
    required String telefono,
    required String direccion,
    required String horarioEntrada,
    required String horarioSalida,
    required String contactKey,
    required DatabaseReference databaseReference,
    required BuildContext context,
    required String url,
    required String facebook,
    required String instagram,
    required String whatsapp,
  }) async {
    try {
      if (titulo.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.black38,
            content: ListTile(
                leading: Icon(
                  Icons.backup_outlined,
                  color: Colors.white,
                ),
                title: Text(
                  'Campos actualizados exitosamente',
                  style: TextStyle(color: Colors.white),
                )),
            duration: Duration(seconds: 1),
          ),
        );
        Map<String, dynamic> actualizarNegocios = {
          'NombreNegocio': titulo,
          'DescripcionNegocio': descripcion,
          'NumeroTelefonico': telefono,
          'Domicilio': direccion,
          'HoraApertura': horarioEntrada,
          'HoraCierre': horarioSalida,
          'Url': url,
          'Facebook': facebook,
          'Instagram': instagram,
          'WhatsApps': whatsapp,
        };
        await databaseReference.child(contactKey).update(actualizarNegocios);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.black38,
            content: ListTile(
                leading: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                title: Text(
                  'Campo nombre no puede quedar vacio',
                  style: TextStyle(color: Colors.white),
                )),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      Exception(e); // Imprime el error en la consola para referencia

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black38,
          duration: const Duration(seconds: 1),
          content: ListTile(
            leading: Icon(
              Icons.warning_amber,
              color: Colors.amber.shade400,
            ),
            title: const Text(
              'Error al actualizar la información',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }
  }
}
