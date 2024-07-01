// Importaciones necesarias
import 'package:directorio_grullo/Screens/Screens_View/galeria_carrusel.dart';
import 'package:directorio_grullo/widget/tabbar_unidades_economicas.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home/principal.dart';
import '../../providers/favoritos_provider.dart';
import '../../services/posicion_distancia_gps.dart';

import 'package:shared_preferences/shared_preferences.dart';

// Widget para mostrar detalles de una unidad económica
class UnidadesEconomicas extends StatefulWidget {
  final String title;
  final String imagen;
  final String descripcion;
  final String? galeriaUrl;
  final String direccion;
  final String horario;
  final String numeroTelefonico;
  final double? endLatitude;
  final double? endLongitude;
  final String? url;
  final String? facebook;
  final String? instagram;
  final String? numeroWhatsApp;

  const UnidadesEconomicas({
    super.key,
    required this.title,
    required this.imagen,
    required this.descripcion,
    this.galeriaUrl,
    required this.direccion,
    required this.horario,
    required this.numeroTelefonico,
    this.url,
    this.facebook,
    this.instagram,
    this.endLatitude,
    this.endLongitude,
    this.numeroWhatsApp,
  });

  @override
  State<UnidadesEconomicas> createState() => _UnidadesEconomicasState();
}

// Estado del widget UnidadesEconomicas
class _UnidadesEconomicasState extends State<UnidadesEconomicas>
    with TickerProviderStateMixin {
  bool _favoriteRed = false;
  bool _backboton = true;
  int _calculandoDistancia = 0;
  String distance = '';
  List<String> galeria = [];
  late FavoritosProvider favoritosProvider;

  // Inicialización del estado
  @override
  initState() {
    super.initState();
    favoritosProvider = context.read<FavoritosProvider>();
    _calcularDistancia();

    // Recupera el estado de favorito al inicio
    _cargarFavorito();
  }

  // Construcción del widget
  @override
  Widget build(BuildContext context) {
    galeria.addAll((widget.galeriaUrl ?? '')
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(','));
    TabController tabController = TabController(length: 3, vsync: this);
    return WillPopScope(
      onWillPop: () async {
        _backboton == true
            ? Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (BuildContext context) => const Principal(),
                ),
              )
            : _backboton = false;

        return _backboton;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    // Imagen de fondo
                    widget.url != ''
                        ? Image.network(
                            widget.url!,
                            width: double.infinity,
                            height: 380,
                            fit: BoxFit.cover,
                          )
                        : const Positioned(
                            top: 115,
                            left: 110,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 130,
                                ),
                                Text(
                                  'Sin portada/actualizar perfil',
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                          ),
                    // Botón de retroceso
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  const Principal()),
                        );
                      },
                      icon: Icon(Icons.arrow_back_ios_new_rounded,
                          size: 35,
                          color:
                              widget.url != '' ? Colors.white : Colors.black),
                    ),
                    // Espacio para la imagen y detalles
                    Padding(
                      padding: const EdgeInsets.only(top: 350),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(35),
                            topRight: Radius.circular(35),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Detalles de la unidad económica
                            Padding(
                              padding: const EdgeInsets.only(top: 8, left: 10),
                              child: ListTile(
                                title: Text(
                                  widget.title,
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w300),
                                  maxLines: 3,
                                ),
                                subtitle: Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.orange,
                                      size: 25,
                                    ),
                                    Text(
                                      _calculandoDistancia == 0
                                          ? 'Calculando....'
                                          : _calculandoDistancia == 1
                                              ? distance
                                              : distance,style:const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w300) ,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            // Pestañas para descripción, galería, y contacto
                            TabBar(
                              controller: tabController,
                              tabs: const [
                                Tab(icon: Icon(Icons.description_outlined)),
                                Tab(icon: Icon(Icons.photo_outlined)),
                                Tab(icon: Icon(Icons.contact_phone_outlined)),
                              ],
                            ),
                            // Contenido de las pestañas
                            Expanded(
                              child: TabBarView(
                                  controller: tabController,
                                  children: [
                                    DescripcionTabBar(
                                      descripcion: widget.descripcion,
                                    ),
                                    widget.galeriaUrl == ''
                                        ? const Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('No hay imagen existente'),
                                                Icon(
                                                  Icons
                                                      .image_not_supported_outlined,
                                                  size: 28,
                                                )
                                              ],
                                            ),
                                          )
                                        : GaleriaCarrusel(
                                            urls: galeria,
                                          ),
                                    ContactoWidget(
                                      facebook: widget.facebook,
                                      instagram: widget.instagram,
                                      numeroWhatsApp: widget.numeroWhatsApp,
                                      direccion: widget.direccion,
                                      horario: widget.horario,
                                      numeroTelefonico: widget.numeroTelefonico,
                                    ),
                                  ]),
                            )
                          ],
                        ),
                      ),
                    ),
                    // Botón de favorito
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _favoriteRed = !_favoriteRed;
                            _guardarFavorito(_favoriteRed);
                            favoritosProvider.marcaFavoritos(widget.title);
                          });
                        },
                        icon: Icon(
                          _favoriteRed
                              ? Icons.favorite
                              : Icons.favorite_outline_sharp,
                          size: 40,
                          color: _favoriteRed
                              ? Colors.red.shade600
                              : widget.url != ''
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _calcularDistancia() {
    if (widget.endLatitude == 0 && widget.endLongitude == 0) {
      _calculandoDistancia = 1;
      distance = 'Sin Cordenadas';
    } else {
      askGpsAccess(context, widget.endLatitude!, widget.endLongitude!)
          .then((double result) {
        setState(() {
          _calculandoDistancia = 2;
          if (result >= 1000.0) {
            result = result * 1 / 1000;
            distance = '${result.toStringAsFixed(2)} Km';
          } else {
            distance = '${result.toStringAsFixed(2)} Mts';
          }
        });
      });
    }
  }

  // Función para cargar el estado de favorito desde SharedPreferences
  void _cargarFavorito() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteRed = prefs.getBool(widget.title) ?? false;
    });
  }

  // Función para guardar el estado de favorito en SharedPreferences
  void _guardarFavorito(bool favorito) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(widget.title, favorito);
  }
}
