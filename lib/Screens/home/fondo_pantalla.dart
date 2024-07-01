
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'principal.dart';

class FondoPantalla extends StatefulWidget {
  const FondoPantalla({Key? key}) : super(key: key);

  @override
  State<FondoPantalla> createState() => _FondoPantallaState();
}

class _FondoPantallaState extends State<FondoPantalla> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 2),
      () => Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => const Principal(),
        ),(Route<dynamic> route)=> false
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color.fromRGBO(241, 192, 159, 1),
              Color.fromRGBO(241, 192, 159, 0.013),
            ],
          ),
        ),
        child: Center(child: _buildPortraitContent()),
      ),
    );
  }

  Widget _buildPortraitContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Image.asset('assets/kiosko.png'),
        const Spacer(),
        RichText(
          text: const TextSpan(
            style: TextStyle(
              color: Colors.black,
              fontSize: 35,
              fontWeight: FontWeight.w200,
            ),
            children: [
              TextSpan(text: '¡Tan fácil de\n  encontrar!'),
            ],
          ),
        ),
        const SizedBox(height: 35),
        const Spacer(),
        Expanded(child: Image.asset('assets/piePagina.png')),
      ],
    );
  }
}
