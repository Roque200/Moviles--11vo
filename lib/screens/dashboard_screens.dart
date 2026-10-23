import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moviles/components/menu_circular.dart';

class DashboardScreens extends StatelessWidget {
  const DashboardScreens({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      endDrawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                user?.displayName ?? 'Jesus Roberto Perez Roque',
              ),
              accountEmail: Text(user?.email ?? 'Sin correo'),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person, size: 40),
              ),
            ),
            const Divider(color: Colors.grey, thickness: 1, height: 1),
            ListTile(
              title: const Text('Practica 1'),
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
                Navigator.pushNamed(context, '/note');
              },
            ),
            const Divider(color: Colors.grey, thickness: 1, height: 1),
            ListTile(
              title: const Text('Lista de Notas'),
              subtitle: const Text('App Notes Nube'),
              leading: const Icon(Icons.cloud),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(context, '/NotesNube');
              },
            ),
            const Divider(color: Colors.grey, thickness: 1, height: 1),
            ListTile(
              title: const Text('Cerrar Sesión'),
              subtitle: const Text('Regresar a la pantalla de inicio'),
              leading: const Icon(Icons.logout),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) return;
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            const Divider(color: Colors.grey, thickness: 1, height: 1),
          ],
        ),
      ),
      floatingActionButton: const MenuCircular(),
    );
  }
}
