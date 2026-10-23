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

  /// Escucha la colección en tiempo real: cualquier cambio en Firestore
  /// (desde la app o desde la consola) se refleja automáticamente.
  Stream<List<NotesDao>> streamNotes() {
    return _notes.snapshots().map(
      (snapshot) => snapshot.docs.map(_fromDocument).toList(),
    );
  }

  /// Lectura única de la colección.
  Future<List<NotesDao>> readNotes() async {
    final snapshot = await _notes.get();
    return snapshot.docs.map(_fromDocument).toList();
  }

  NotesDao _fromDocument(QueryDocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return NotesDao(
      firestoreId: document.id,
      title: _asText(data['title']),
      content: _asText(data['content']),
      dateNote: _asDate(data['dateNote']),
    );
  }

  /// Convierte cualquier valor a texto sin tronar si el tipo no es String.
  String _asText(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  /// Acepta la fecha como String o como Timestamp de Firestore.
  String _asDate(dynamic value) {
    if (value == null) return '';
    if (value is Timestamp) {
      return value.toDate().toIso8601String().substring(0, 10);
    }
    if (value is DateTime) {
      return value.toIso8601String().substring(0, 10);
    }
    return value.toString();
  }

  Map<String, dynamic> _noteData(NotesDao note) {
    return {
      'title': note.title ?? '',
      'content': note.content ?? '',
      'dateNote':
          note.dateNote ?? DateTime.now().toIso8601String().substring(0, 10),
    };
  }
}
