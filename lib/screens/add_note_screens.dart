import 'package:flutter/material.dart';
import 'package:moviles/database/notes_dao.dart';
import 'package:moviles/database/notes_database.dart';
import 'package:moviles/services/firestore_notes.dart';

class AddNoteScreens extends StatefulWidget {
  final NotesDao? note;
  final bool cloudMode;

  const AddNoteScreens({super.key, this.note, this.cloudMode = false});

  @override
  State<AddNoteScreens> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNoteScreens> {
  late final NotesDB notesDB;
  final TextEditingController conTitle = TextEditingController();
  final TextEditingController conContent = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    notesDB = NotesDB();
    if (widget.note != null) {
      conTitle.text = widget.note!.title ?? '';
      conContent.text = widget.note!.content ?? '';
    }
  }

  @override
  void dispose() {
    conTitle.dispose();
    conContent.dispose();
    super.dispose();
  }

  Future<void> _guardarNota() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    final note = widget.note;
    final fecha =
        note?.dateNote ?? DateTime.now().toIso8601String().substring(0, 10);
    final updatedNote = NotesDao(
      idNote: note?.idNote,
      firestoreId: note?.firestoreId,
      title: conTitle.text.trim(),
      content: conContent.text.trim(),
      dateNote: fecha,
    );

    try {
      if (widget.cloudMode) {
        final firestoreNotes = FirestoreNotes();
        if (note == null) {
          await firestoreNotes.createNote(updatedNote);
        } else {
          await firestoreNotes.updateNote(updatedNote);
        }
      } else if (note == null) {
        await notesDB.INSERT({
          'title': updatedNote.title,
          'content': updatedNote.content,
          'dateNote': updatedNote.dateNote,
        });
      } else {
        await notesDB.UPDATE({
          'idNote': updatedNote.idNote,
          'title': updatedNote.title,
          'content': updatedNote.content,
          'dateNote': updatedNote.dateNote,
        });
      }

      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            note == null ? 'Se Acepto el Registro' : 'Se Actualizó la Nota',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(content: Text('No se pudo guardar la nota: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.note != null;

    final txtTitle = TextFormField(
      controller: conTitle,
      maxLength: 35,
      decoration: const InputDecoration(labelText: 'Título'),
    );
    final txtContent = TextField(
      maxLines: 5,
      controller: conContent,
      decoration: const InputDecoration(labelText: 'Contenido'),
    );
    const spacer = SizedBox(height: 5);
    final btnSave = ElevatedButton(
      onPressed: _isSaving ? null : _guardarNota,
      child: _isSaving
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(editando ? 'Actualizar Nota' : 'Insertar Nota'),
    );

    return Scaffold(
      appBar: AppBar(title: Text(editando ? 'Editar Nota' : 'Insertar Nota')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [txtTitle, spacer, txtContent, spacer, btnSave],
        ),
      ),
    );
  }
}
