import 'package:flutter/material.dart';
import 'package:moviles/database/notes_dao.dart';
import 'package:moviles/database/notes_database.dart';

class AddNoteScreens extends StatefulWidget {
  final NotesDao? note;

  const AddNoteScreens({super.key, this.note});

  @override
  State<AddNoteScreens> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNoteScreens> {
  late final NotesDB notesDB;
  final TextEditingController conTitle = TextEditingController();
  final TextEditingController conContent = TextEditingController();

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
    final note = widget.note;
    final int value;

    if (note == null) {
      final fecha = DateTime.now().toIso8601String().substring(0, 10);
      value = await notesDB.INSERT({
        "title": conTitle.text,
        "content": conContent.text,
        "dateNote": fecha,
      });
    } else {
      value = await notesDB.UPDATE({
        "idNote": note.idNote,
        "title": conTitle.text,
        "content": conContent.text,
        "dateNote": note.dateNote,
      });
    }

    if (!mounted) return;

    if (value > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            note == null ? 'Se Acepto el Registro' : 'Se Actualizó la Nota',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      Navigator.pop(context);
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
      onPressed: _guardarNota,
      child: Text(editando ? 'Actualizar Nota' : 'Insertar Nota'),
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
