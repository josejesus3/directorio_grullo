import 'package:directorio_grullo/Screens/home/principal.dart';
import 'package:directorio_grullo/services/firebase_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class Categorias extends StatelessWidget {
  final String categorias;
  const Categorias({super.key, required this.categorias});

  @override
  Widget build(BuildContext context) {
    Query databaseReference =
        FirebaseDatabase.instance.ref().child('UnidadesEconomicas');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) {
                return const Principal();
              }),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 30,
          ),
        ),
      ),
      body: StreamBuilder(
          stream: databaseReference.onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data?.snapshot.value != snapshot) {
              return FirebaseAnimatedList(
                query: databaseReference,
                itemBuilder: (context, snapshot, animation, index) {
                  final String actividadComercial =
                      snapshot.child('ActividadComercial').value.toString();
                  if (actividadComercial
                      .toLowerCase()
                      .startsWith(categorias.toLowerCase())) {
                    return CustomFirebaseList(snapshot: snapshot);
                  } else {
                    return Container();
                  }
                },
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
