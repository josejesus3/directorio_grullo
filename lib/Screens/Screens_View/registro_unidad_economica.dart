// Importaciones necesarias
import 'dart:io';
import 'package:directorio_grullo/services/actualizar_registros.dart';
import 'package:directorio_grullo/services/select_image.dart';
import 'package:directorio_grullo/widget/tabbar_unidades_economicas.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


/*Este código representa una pantalla de registro para una unidad económica, 
permitiendo la edición y actualización de información, la selección de imágenes y 
la gestión de pestañas para descripción, 
galería y detalles de contacto. Si tienes alguna pregunta específica sobre alguna 
parte del código, estoy aquí para ayudar.*/

// Widget para la pantalla de registro de unidad económica
class RegistroUnidadEconomica extends StatefulWidget {
  // Propiedades necesarias para la creación de la unidad económica
  final String title;
  final String? imagen;
  final String descripcion;
  final String direccion;
  final String horarioEntrada;
  final String horarioSalida;
  final String numeroTelefonico;
  final String url;
  final String? galeriaUrl;
  final String? facebook;
  final String? instagram;
  final String? whatsApp;
  final String contactKey;

  // Constructor que requiere las propiedades mencionadas
  const RegistroUnidadEconomica({
    super.key,
    required this.title,
    this.imagen,
    required this.descripcion,
    required this.direccion,
    required this.horarioEntrada,
    required this.horarioSalida,
    required this.numeroTelefonico,
    required this.contactKey,
    required this.url,
    this.facebook,
    this.instagram,
    this.whatsApp,
    this.galeriaUrl,
  });

  // Método para crear el estado del widget
  @override
  State<RegistroUnidadEconomica> createState() => _UnidadesEconomicasState();
}

// Estado del widget para la pantalla de registro de unidad económica
class _UnidadesEconomicasState extends State<RegistroUnidadEconomica>
    with TickerProviderStateMixin {
  // Controladores para los campos de texto
  final TextEditingController _textFieldTitulo = TextEditingController();
  final TextEditingController _textFieldDescripcion = TextEditingController();
  final TextEditingController _textFieldTelefono = TextEditingController();
  final TextEditingController _textFieldDireccion = TextEditingController();
  final TextEditingController _textFieldhorarioEntrada =
      TextEditingController();
  final TextEditingController _textFieldhorarioSalida = TextEditingController();
  final TextEditingController _textFieldFacebook = TextEditingController();
  final TextEditingController _textFieldInstagram = TextEditingController();
  final TextEditingController _textFieldWhatsApp = TextEditingController();

  // Referencia a la base de datos de Firebase
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref('UnidadesEconomicas');

  // Variable para determinar si el campo de texto está habilitado
  bool isTextFieldEnabled = false;

  // Archivo de imagen para subir o actualizar
  File? imagenUpload;

  // URL de la imagen principal y URL de la galería de imágenes
  String? url1;

  List<String> galeria = [];
  // Inicialización del estado del widget
  @override
  void initState() {
    super.initState();

    galeria.addAll((widget.galeriaUrl ?? '')
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(','));
    // Establecer los valores iniciales de los controladores de texto
    _textFieldTitulo.text = widget.title;
    _textFieldDescripcion.text = widget.descripcion;
    _textFieldTelefono.text = widget.numeroTelefonico;
    _textFieldDireccion.text = widget.direccion;
    _textFieldhorarioEntrada.text = widget.horarioEntrada;
    _textFieldhorarioSalida.text = widget.horarioSalida;
    _textFieldFacebook.text = widget.facebook!;
    _textFieldInstagram.text = widget.instagram!;
    _textFieldWhatsApp.text = widget.whatsApp!;
  }

  // Método para construir la interfaz de usuario
  @override
  Widget build(BuildContext context) {
    // Controlador de pestañas para la descripción, galería y contacto
    TabController tabController = TabController(length: 3, vsync: this);

    // Estructura principal del widget
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  // Imagen principal de la unidad económica o imagen de carga
                  widget.url != ''
                      ? Image.network(
                          widget.url,
                          width: double.infinity,
                          height: 380,
                          fit: BoxFit.cover,
                        )
                      : Positioned(
                          left: 105,
                          top: 30,
                          child: Image.asset(
                            widget.imagen!,
                            width: 200,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                  imagenUpload != null
                      ? Image.file(
                          imagenUpload!,
                          width: double.infinity,
                          height: 380,
                          fit: BoxFit.cover,
                        )
                      : Container(),

                  // Botón para volver atrás y título de la unidad económica
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 35,
                      color: widget.url != ''
                          ? Colors.white
                          : imagenUpload != null
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),

                  // Espacio para la imagen
                  Padding(
                    padding: const EdgeInsets.only(top: 350),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Expanded(
                          child: Column(
                            children: [
                              // Título editable y botón de actualización
                              Padding(
                                padding: const EdgeInsets.only(top: 15, left: 35),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: TextFormField(
                                        style: const TextStyle(fontSize: 25),
                                        controller: _textFieldTitulo,
                                        decoration: const InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                            borderRadius:
                                                BorderRadius.horizontal(),
                                            borderSide:
                                                BorderSide(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Column(
                                      children: [
                                        IconButton(
                                          color: Colors.orange.shade500,
                                          onPressed: () {
                                            setState(() {
                                              url1 = widget.url;
                        
                                              if (imagenUpload != null) {
                                                // Si al menos una imagen está presente
                                                DatabaseOperations.actualizarApp(
                                                  titulo: _textFieldTitulo.text,
                                                  descripcion:
                                                      _textFieldDescripcion.text,
                                                  telefono:
                                                      _textFieldTelefono.text,
                                                  direccion:
                                                      _textFieldDireccion.text,
                                                  horarioEntrada:
                                                      _textFieldhorarioEntrada
                                                          .text,
                                                  horarioSalida:
                                                      _textFieldhorarioSalida
                                                          .text,
                                                  imagenUpload: imagenUpload!,
                                                  contactKey: widget.contactKey,
                                                  databaseReference:
                                                      databaseReference,
                                                  context: context,
                                                  url: url1!,
                                                  facebook: widget.facebook!,
                                                  instagram: widget.instagram!,
                                                  whatsapp:
                                                      _textFieldWhatsApp.text,
                                                );
                                              } else {
                                                // Si ninguna imagen está presente
                                                DatabaseOperations
                                                    .actualizarAppSinImagen(
                                                  titulo: _textFieldTitulo.text,
                                                  descripcion:
                                                      _textFieldDescripcion.text,
                                                  telefono:
                                                      _textFieldTelefono.text,
                                                  direccion:
                                                      _textFieldDireccion.text,
                                                  horarioEntrada:
                                                      _textFieldhorarioEntrada
                                                          .text,
                                                  horarioSalida:
                                                      _textFieldhorarioSalida
                                                          .text,
                                                  contactKey: widget.contactKey,
                                                  databaseReference:
                                                      databaseReference,
                                                  context: context,
                                                  url: url1!,
                                                  facebook:
                                                      _textFieldFacebook.text,
                                                  instagram:
                                                      _textFieldInstagram.text,
                                                  whatsapp:
                                                      _textFieldWhatsApp.text,
                                                );
                                              }
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.edit_document,
                                            size: 35,
                                          ),
                                        ),
                                        const Text('Actualizar'),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                              ),
                        
                              // Pestañas para descripción, galería y contacto
                              TabBar(
                                controller: tabController,
                                tabs: const [
                                  Tab(icon: Icon(Icons.description_outlined)),
                                  Tab(icon: Icon(Icons.photo_outlined)),
                                  Tab(icon: Icon(Icons.contact_phone_outlined)),
                                ],
                              ),
                        
                              // Contenido de las pestañas
                              SizedBox(
                                width: double.infinity,
                                height: 550,
                                child: TabBarView(
                                    controller: tabController,
                                    children: [
                                      // Pestaña de descripción
                                      RegistroDescripcion(
                                          textFieldDescripcion:
                                              _textFieldDescripcion),
                        
                                      // Pestaña de galería de imágenes
                                      Stack(
                                        children: [
                                          Positioned(
                                            top: 100,
                                            left: 150,
                                            child: Column(
                                              children: [
                                                const Text('Elegir Imagenes'),
                                                IconButton(
                                                  onPressed:
                                                      widget.galeriaUrl != ''
                                                          ? () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => GaleriaImagen(
                                                                        contactKey:
                                                                            widget
                                                                                .contactKey,
                                                                        galeriaUrl:
                                                                            galeria),
                                                                  ));
                                                            }
                                                          : () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        GaleriaSinUrl(
                                                                            contactKey:
                                                                                widget.contactKey),
                                                                  ));
                                                            },
                                                  icon: const Icon(
                                                    Icons
                                                        .add_photo_alternate_outlined,
                                                    size: 50,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                        
                                      // Pestaña de contacto
                                      RegistroContacto(
                                        textFieldDireccion: _textFieldDireccion,
                                        textFieldHorarioSalida:
                                            _textFieldhorarioSalida,
                                        textFieldHorarioEntrada:
                                            _textFieldhorarioEntrada,
                                        textFieldtelefono: _textFieldTelefono,
                                        textFieldFacebook: _textFieldFacebook,
                                        textFieldInstagram: _textFieldInstagram,
                                        textFieldWhatsApp: _textFieldWhatsApp,
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Botón para seleccionar y cargar imágenes
                  Positioned(
                    right: 10,
                    child: IconButton(
                        onPressed: () async {
                          final XFile? image = await selectImage();
                          setState(() {
                            if (image == null) {
                            } else {
                              setState(() {
                                imagenUpload = File(image.path);
                              });
                            }
                          });
                        },
                        icon: Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 30,
                          color: widget.url != ''
                              ? Colors.white
                              : imagenUpload != null
                                  ? Colors.white
                                  : Colors.black,
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}