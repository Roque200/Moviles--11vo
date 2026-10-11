// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:moviles/database/notes_dao.dart';
import 'package:moviles/screens/add_note_screens.dart';
import 'package:moviles/services/firestore_notes.dart';

class NotesNubeScreen extends StatefulWidget {
  const NotesNubeScreen({super.key});

  @override
  State<NotesNubeScreen> createState() => _NotesNubeScreenState();
}

class _NotesNubeScreenState extends State<NotesNubeScreen> {
  final FirestoreNotes firestoreNotes = FirestoreNotes();
  late Future<List<NotesDao>> notesFuture;

  @override
  void initState() {
    super.initState();
    notesFuture = firestoreNotes.readNotes();
  }

  void _recargar() {
    setState(() {
      notesFuture = firestoreNotes.readNotes();
    });
  }

  Future<void> _editarNota(NotesDao note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddNoteScreens(note: note, cloudMode: true),
      ),
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
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('No se pudieron cargar las notas: ${snapshot.error}'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _recargar,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
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
                margin: const EdgeInsets.all(9),
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

                          if (!context.mounted) return;
                          if (eliminar == true) {
                            final id = note.firestoreId;
                            if (id == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'No se encontró el ID de la nota.',
                                  ),
                                ),
                              );
                              return;
                            }
                            try {
                              await firestoreNotes.deleteNote(id);
                              if (mounted) _recargar();
                            } catch (error) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'No se pudo eliminar la nota: $error',
                                  ),
                                ),
                              );
                            }
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
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddNoteScreens(cloudMode: true),
            ),
          );
          if (mounted) _recargar();
        },
      ),
    );
  }
}
