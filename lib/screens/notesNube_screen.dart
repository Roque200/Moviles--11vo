// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
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
  late Stream<List<NotesDao>> notesStream;

  @override
  void initState() {
    super.initState();
    notesStream = firestoreNotes.streamNotes();
  }

  void _reintentar() {
    setState(() {
      notesStream = firestoreNotes.streamNotes();
    });
  }

  String _mensajeError(Object? error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return 'Firestore rechazó la lectura (permission-denied).\n'
              'Revisa las reglas de seguridad en la consola de Firebase.';
        case 'unavailable':
          return 'No hay conexión con Firestore. Revisa tu internet.';
        case 'not-found':
          return 'No existe la base de datos de Firestore en el proyecto.';
        default:
          return 'Error de Firestore (${error.code}): ${error.message}';
      }
    }
    return 'No se pudieron cargar las notas: $error';
  }

  Future<void> _editarNota(NotesDao note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddNoteScreens(note: note, cloudMode: true),
      ),
    );
  }

  Future<void> _eliminarNota(NotesDao note) async {
    final eliminar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar nota'),
        content: const Text('¿Deseas eliminar esta nota?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (!mounted || eliminar != true) return;

    final id = note.firestoreId;
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se encontró el ID de la nota.')),
      );
      return;
    }

    try {
      await firestoreNotes.deleteNote(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Nota eliminada')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo eliminar la nota: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Notas Nube')),
      body: StreamBuilder<List<NotesDao>>(
        stream: notesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, size: 48),
                    const SizedBox(height: 8),
                    Text(
                      _mensajeError(snapshot.error),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _reintentar,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final notes = snapshot.data!;

          if (notes.isEmpty) {
            return const Center(child: Text('No hay notas en la nube'));
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
                  title: Text(
                    note.title ?? '',
                    style: const TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    note.content ?? '',
                    style: const TextStyle(color: Colors.black87),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        note.dateNote ?? '',
                        style: const TextStyle(color: Colors.black87),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.black),
                        onPressed: () => _editarNota(note),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.black),
                        onPressed: () => _eliminarNota(note),
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
        child: const Icon(Icons.note_add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddNoteScreens(cloudMode: true),
            ),
          );
        },
      ),
    );
  }
}
