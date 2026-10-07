import 'package:flutter/material.dart';
import 'package:moviles/database/notes_dao.dart';
import 'package:moviles/database/notes_database.dart';
import 'package:moviles/screens/add_note_screens.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late final NotesDB notesDB;
  late Future<List<NotesDao>> notesFuture;

  @override
  void initState() {
    super.initState();
    notesDB = NotesDB();
    notesFuture = notesDB.SELECT();
  }

  void _recargar() {
    setState(() {
      notesFuture = notesDB.SELECT();
    });
  }

  Future<void> _editarNota(NotesDao note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddNoteScreens(note: note)),
    );
    if (mounted) _recargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(' Lista de Notas')),
      body: FutureBuilder<List<NotesDao>>(
        future: notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Algo salió mal'));
          }

          final notes = snapshot.data ?? [];

          if (notes.isEmpty) {
            return const Center(child: Text('No hay notas'));
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Container(
                margin: EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 144, 201, 230),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: ListTile(
                  title: Text(note.title ?? ''),
                  subtitle: Text(note.content ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(note.dateNote ?? ''),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editarNota(note),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final eliminar = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Eliminar nota'),
                              content: const Text(
                                '¿Deseas eliminar esta nota?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Eliminar'),
                                ),
                              ],
                            ),
                          );

                          if (eliminar == true) {
                            await notesDB.DELETE(note.idNote!);
                            _recargar();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.note),
        onPressed: () =>
            Navigator.pushNamed(context, "/add").then((_) => _recargar()),
      ),
    );
  }
}
