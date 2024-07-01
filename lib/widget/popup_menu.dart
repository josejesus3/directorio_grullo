
import 'package:directorio_grullo/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/redes_sociales.dart';

class PopupMenu extends StatelessWidget {
  const PopupMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PopupMenuButton(
        elevation: 10,
        icon: const Icon(
          Icons.menu_outlined,
          size: 30,
        ),
        itemBuilder: (BuildContext context) => [
          
           PopupMenuItem(
            onTap: () {
              Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  const Login(),
                                  ),
                                  );
            },
            child: const Row(
              children: [
                
                Icon(Icons.person_rounded),
                Text('Editar'),
              ],
            ),
          ),
           PopupMenuItem(
            onTap: () => launcher('https://drive.google.com/file/d/1xh4iSZQIrks7JOxb7OzLgUu127WMzX4a/view?usp=sharing'),
            child: const Row(
              children: [
                Icon(Icons.play_circle_outlined),
                Text('Tutorial'),
              ],
            ),
          ),
          
         
        ],
      ),
    );
  }
}
