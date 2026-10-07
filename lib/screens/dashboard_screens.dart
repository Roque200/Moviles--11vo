import 'package:flutter/material.dart';
import 'package:moviles/components/global_values.dart';
import 'package:moviles/components/menu_circular.dart';

class DashboardScreens extends StatelessWidget {
  const DashboardScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      endDrawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('Jesus Roberto Perez Roque'),
              accountEmail: const Text(
                'jesus.roberto.perez.roque@itcelaya.com',
              ),
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
              title: const Text('Lista de Notas'),
              subtitle: const Text('App Notes'),
              leading: const Icon(Icons.note),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(context, "/note");
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
          ],
        ),
      ),
      floatingActionButton: MenuCircular(),
    );
  }
}
