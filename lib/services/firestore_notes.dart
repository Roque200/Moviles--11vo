import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moviles/database/notes_dao.dart';

class FirestoreNotes {
  FirestoreNotes({FirebaseFirestore? firestore})
    : _notes = (firestore ?? FirebaseFirestore.instance).collection('notes');

  final CollectionReference<Map<String, dynamic>> _notes;

  Future<void> createNote(NotesDao note) async {
    await _notes.add(_noteData(note));
  }

  Future<void> updateNote(NotesDao note) async {
    final id = note.firestoreId;
    if (id == null || id.isEmpty) {
      throw ArgumentError('La nota no tiene un identificador de Firestore.');
    }

    await _notes.doc(id).update(_noteData(note));
  }

  Future<void> deleteNote(String id) async {
    if (id.isEmpty) {
      throw ArgumentError.value(id, 'id', 'No puede estar vacío.');
    }

    await _notes.doc(id).delete();
  }

  Future<List<NotesDao>> readNotes() async {
    final snapshot = await _notes.get();
    return snapshot.docs.map((document) {
      final data = document.data();
      return NotesDao(
        firestoreId: document.id,
        title: data['title'] as String?,
        content: data['content'] as String?,
        dateNote: data['dateNote'] as String?,
      );
    }).toList();
  }

  Map<String, dynamic> _noteData(NotesDao note) {
    return {
      'title': note.title ?? '',
      'content': note.content ?? '',
      'dateNote': note.dateNote ?? DateTime.now().toIso8601String().substring(0, 10),
    };
  }
}
