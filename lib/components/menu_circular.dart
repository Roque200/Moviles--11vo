import 'package:flutter/material.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:moviles/components/global_values.dart';

class MenuCircular extends StatelessWidget {
  const MenuCircular({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularMenu(
      alignment: Alignment.bottomCenter,
      backgroundWidget: const Center(
        child: Text(
          'Opciones',
          style: TextStyle(
            color: Color.fromARGB(255, 204, 209, 55),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      toggleButtonColor: Colors.pink,
      items: [
        CircularMenuItem(
          icon: Icons.light_mode,
          color: Colors.green,
          onTap: () {
            GlobalValues.banTheme.value = 1;
          },
        ),
        CircularMenuItem(
          icon: Icons.dark_mode,
          color: const Color.fromARGB(255, 5, 74, 130),
          onTap: () {
            GlobalValues.banTheme.value = 0;
          },
        ),
        CircularMenuItem(
          icon: Icons.brightness_4,
          color: Colors.orange,
          onTap: () {
            GlobalValues.banTheme.value = 2;
          },
        ),
      ],
    );
  }
}
