import 'package:flutter/material.dart';
import 'package:moviles/components/global_values.dart';

class DashboardScreens extends StatelessWidget {
  const DashboardScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('Jesus Roberto Perez Roque'),
              accountEmail: const Text('jesus.roberto.perez.roque@itcelaya.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://avatars.githubusercontent.com/u/12345678?v=4',
                ),
              ),
            ),
            const Divider(color: Colors.grey, thickness: 1, height: 1),
            ListTile(
              title: const Text('Pracctica 1'),
              subtitle: const Text('App practica 1 de la materia de Moviles 2'),
              leading: const Icon(Icons.home),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(color: Colors.grey, thickness: 1, height: 1),
            ListTile(
              title: const Text('Cambiar Tema'),
              subtitle: const Text('Modo oscuro o modo claro'),
              leading: const Icon(Icons.light_mode),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                //GlobalValues.banTheme.value = !GlobalValues.banTheme.value;
              },
            ),
            const Divider(color: Colors.grey, thickness: 1, height: 1),
            ListTile(
              title: const Text('Cerrar Sesión'),
              subtitle: const Text('Regresar a la pantalla de inicio'),
              leading: const Icon(Icons.logout),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                //Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            const Divider(color: Colors.grey, thickness: 1, height: 1),
          ]
        ) 
      ),
      appBar: AppBar(
        leading:Container(),
        title: const Text('Saliendo de casa'),
      ),
      body: const Center(
        child: Text('Un poder conlleva una gran responsabilidad!',
            style: TextStyle(fontSize: 24)),
      ),
    );
  }
}