// Importaciones necesarias
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../services/redes_sociales.dart';
import '../services/select_image.dart';
import '../services/subir_img_galeria.dart';
/*
Este código contiene widgets para mostrar y registrar información sobre una unidad económica, 
incluyendo descripción, galería de imágenes y datos de contacto. Cada widget cumple una 
función específica en la interfaz de usuario. 
Si tienes alguna pregunta o necesitas aclaraciones adicionales, estoy aquí para ayudar.
*/

// Widget para mostrar la descripción en la pestaña correspondiente
class DescripcionTabBar extends StatelessWidget {
  final String descripcion;
  const DescripcionTabBar({super.key, required this.descripcion});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: Text(
        descripcion,
        style: const TextStyle(fontSize: 17.0),
        maxLines: 10,
        textAlign: TextAlign
            .justify, // Puedes ajustar el estilo según tus preferencias
      ),
    );
  }
}

// Widget para registrar la descripción
class RegistroDescripcion extends StatelessWidget {
  final TextEditingController? textFieldDescripcion;

  const RegistroDescripcion({
    super.key,
    this.textFieldDescripcion,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Flexible(
            child: TextField(
              controller: textFieldDescripcion,
              maxLines: 9,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                  fontSize:
                      17.0), // Puedes ajustar el estilo según tus preferencias
            ),
          ),
        ],
      ),
    );
  }
}

// Widget para gestionar la galería de imágenes
class GaleriaImagen extends StatefulWidget {
  final String contactKey;
  final List<String>? galeriaUrl;

  const GaleriaImagen({
    Key? key,
    required this.contactKey,
    this.galeriaUrl,
  }) : super(key: key);

  @override
  State<GaleriaImagen> createState() => _GaleriaImagenState();
}

List<File> imagenes = [];


class _GaleriaImagenState extends State<GaleriaImagen> {
  @override
  Widget build(BuildContext context) {
    int cantidad=imagenes.length+widget.galeriaUrl!.length;

    return WillPopScope(
      onWillPop: () async {
        imagenes = [];
        botonExit ? Navigator.of(context).pop() : botonExit = false;

        return botonExit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Seleccionar imagen'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              imagenes = [];
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          children: [
            cantidad==3
            ?const Text('Limites alcanzado')
            :ElevatedButton(
              onPressed: () async {
                final XFile? image = await selectImage();
                if (image != null) {
                  setState(() {
                    
                    imagenes.add(File(image.path));
                   
                    // También podrías agregar la imagen a widget.galeriaUrl si lo necesitas
                  });
                } 
                
              },
              child:
              const Text('Agregar imagenes'),
            ),
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                itemCount: widget.galeriaUrl!.length + imagenes.length,
                itemBuilder: (context, index) {
                  if (index < widget.galeriaUrl!.length) {
                    // Mostrar desde widget.galeriaUrl
                    return Dismissible(
                        key: Key(widget.galeriaUrl.toString()),
                        background: Container(
                          color: Colors.red.shade300,
                          alignment: Alignment.centerLeft,
                          child: const Row(
                            children: [
                              Icon(
                                Icons.delete_forever_outlined,
                                color: Colors.white,
                              ),
                              Text('Eliminar Imagen')
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Image.network(
                            widget.galeriaUrl![index].trim(),
                            width: 380,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            widget.galeriaUrl!.removeAt(index);
                            actualizarUrl(
                                contactKey: widget.contactKey,
                                context: context,
                                galeriaUrl: widget.galeriaUrl);
                          });
                        });
                  } else {
                    // Mostrar desde imagenes
                    const SizedBox(
                      height: 20,
                    );
                    final localIndex = index - widget.galeriaUrl!.length;
                    return Dismissible(
                      key: Key(imagenes.toString()),
                      background: Container(
                        color: Colors.red.shade300,
                        alignment: Alignment.centerLeft,
                        child: const Row(
                          children: [
                            Icon(
                              Icons.delete_forever_outlined,
                              color: Colors.white,
                            ),
                            Text('Eliminar Imagen')
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Image.file(
                          imagenes[localIndex],
                          width: 380,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          imagenes.removeAt(localIndex);
                          const SnackBar(
                            content: Text('Imagen eliminada'),
                          );
                        });
                      },
                    );
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (imagenes.isNotEmpty) {
                  subirImgGaleria(
                      imagenes: imagenes,
                      contactKey: widget.contactKey,
                      context: context,
                      galeriaUrl: widget.galeriaUrl);
                } else {
                  actualizarUrl(
                      contactKey: widget.contactKey,
                      context: context,
                      galeriaUrl: widget.galeriaUrl);
                }
              },
              child: const Text('Subir imágenes'),
            )
          ],
        ),
      ),
    );
  }
}

class GaleriaSinUrl extends StatefulWidget {
  final String contactKey;
  const GaleriaSinUrl({super.key, required this.contactKey});

  @override
  State<GaleriaSinUrl> createState() => _GaleriaSinUrlState();
}

bool botonExit = true;
List<File> imagenes1 = [];

class _GaleriaSinUrlState extends State<GaleriaSinUrl> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        imagenes1 = [];
        botonExit ? Navigator.of(context).pop() : botonExit = false;

        return botonExit;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              imagenes1 = [];
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Seleccionar imagen'),
        ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                final XFile? image = await selectImage();
                setState(() {
                  if (image == null) {
                  } else {
                    setState(() {
                      imagenes1.add(File(image.path));
                    });
                  }
                });
              },
              child: const Text('Agregar imagenes'),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: imagenes1.length,
                itemBuilder: (context, index) {
                  final imagen = imagenes1[index];
                  return Dismissible(
                    key: Key(imagen.toString()),
                    background: Container(
                      color: Colors.red.shade300,
                      alignment: Alignment.centerLeft,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.delete_forever_outlined,
                            color: Colors.white,
                            size: 50,
                          ),
                          Text('Eliminar Imagen')
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: Image.file(
                        imagenes1[index],
                        width: 380,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        imagenes1.removeAt(index);
                        const ScaffoldMessenger(
                            child: SnackBar(content: Text('Imagen Eliminada')));
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                subirImgGaleria(
                    imagenes: imagenes1,
                    contactKey: widget.contactKey,
                    context: context,
                    galeriaUrl: []);
              },
              child: const Text('Subir imágenes'),
            )
          ],
        ),
      ),
    );
  }
}

// Widget para mostrar información de contacto
class ContactoWidget extends StatelessWidget {
  final String direccion;
  final String horario;
  final String numeroTelefonico;
  final String? facebook;
  final String? instagram;
  final String? numeroWhatsApp;
  const ContactoWidget({
    super.key,
    required this.direccion,
    required this.horario,
    required this.numeroTelefonico,
    this.facebook,
    this.instagram,
    this.numeroWhatsApp,
  });
  @override
  Widget build(BuildContext context) {
    double title = 16;
    double subtitle = 15;
    double listas = 78;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          // Iconos de redes sociales

          // Número de teléfono
          _buildListTile(
            height: listas,
            leading: const Icon(
              Icons.phone,
              size: 25,
            ),
            title: Text(
              'Número de Teléfono',
              style: TextStyle(fontSize: title),
            ),
            subtitle: Text(
              numeroTelefonico,
              style: TextStyle(fontSize: subtitle),
            ),
            onTap: () {
              launchUrlString('tel:$numeroTelefonico');
            },
          ),

          // Dirección del negocio
          _buildListTile(
            height: listas,
            leading: const Icon(Icons.location_on, size: 25),
            title: Text(
              'Dirección del Negocio',
              style: TextStyle(fontSize: title),
            ),
            subtitle: Text(
              direccion,
              style: TextStyle(fontSize: subtitle),
            ),
          ),

          // Horario de entrada y salida
          _buildListTile(
            height: listas,
            leading: const Icon(Icons.access_time, size: 25),
            title: Text(
              'Horario de Entrada y Salida',
              style: TextStyle(fontSize: title),
            ),
            subtitle: Text(
              horario,
              style: TextStyle(fontSize: subtitle),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              facebook != ''
                  ? IconButton(
                      onPressed: () {
                        launcher(facebook!);
                      },
                      icon: Image.asset(
                        'assets/facebook.png',
                        width: 35,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(),
              instagram != ''
                  ? IconButton(
                      onPressed: () {
                        launcher(instagram!);
                      },
                      icon: Image.asset(
                        'assets/instagram.png',
                        width: 35,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(),
              numeroWhatsApp != ''
                  ? IconButton(
                      iconSize: 50,
                      onPressed: () {
                        launchUrlString('https://wa.me/52$numeroWhatsApp');
                      },
                      icon: Image.asset(
                        'assets/whatsapp_.png',
                        width: 35,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget para registrar información de contacto
class RegistroContacto extends StatelessWidget {
  final TextEditingController? textFieldtelefono;
  final TextEditingController? textFieldDireccion;
  final TextEditingController? textFieldHorarioEntrada;
  final TextEditingController? textFieldHorarioSalida;
  final TextEditingController? textFieldFacebook;
  final TextEditingController? textFieldInstagram;
  final TextEditingController? textFieldWhatsApp;

  const RegistroContacto({
    Key? key,
    this.textFieldtelefono,
    this.textFieldDireccion,
    this.textFieldHorarioEntrada,
    this.textFieldHorarioSalida,
    this.textFieldFacebook,
    this.textFieldInstagram,
    this.textFieldWhatsApp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          _buildListTile(
            leading: const Icon(Icons.phone, size: 25),
            title: const Text('Número de Teléfono'),
            subtitle: TextField(
              controller: textFieldtelefono,
              keyboardType: const TextInputType.numberWithOptions(),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(
                  r'[0-9\s]',
                )),
              ],
            ),
          ),
          _buildListTile(
            leading: const Icon(Icons.location_on, size: 25),
            title: const Text('Dirección del Negocio'),
            subtitle: TextField(
              controller: textFieldDireccion,
            ),
          ),
          _buildListTile(
            leading: const Icon(Icons.access_time, size: 25),
            title: const Text('Horario de Entrada'),
            subtitle: TextField(
              controller: textFieldHorarioEntrada,
            ),
          ),
          _buildListTile(
            leading: const Icon(Icons.access_time, size: 25),
            title: const Text('Horario de Salida'),
            subtitle: TextField(
              controller: textFieldHorarioSalida,
            ),
          ),
          _buildListTile(
            leading: const Icon(Icons.info_outline, size: 25),
            onTap: () {
              _showSnackBar(
                  context, 'Agregar enlace de Facebook de su perfil.');
            },
            title: const Text('Enlace Facebook'),
            subtitle: TextField(
              controller: textFieldFacebook,
              maxLines: 1,
            ),
          ),
          _buildListTile(
            leading: const Icon(Icons.info_outline, size: 25),
            onTap: () {
              _showSnackBar(
                  context, 'Agregar enlace de Instagram de su perfil.');
            },
            title: const Text('Enlace Instagram'),
            subtitle: TextField(
              controller: textFieldInstagram,
            ),
          ),
          _buildListTile(
            leading: const Icon(Icons.info_outline, size: 25),
            onTap: () {
              _showSnackBar(context, 'Agregar número de teléfono de WhatsApp.');
            },
            title: const Text('Numero WhatsApp'),
            subtitle: TextField(
              controller: textFieldWhatsApp,
              keyboardType: const TextInputType.numberWithOptions(),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9\s]'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildListTile({
  required Widget leading,
  required Widget title,
  required Widget subtitle,
  VoidCallback? onTap,
  double height = 76,
}) {
  return SizedBox(
    height: height,
    child: ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
    ),
  );
}

void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ),
  );
}
