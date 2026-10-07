class NotesDao {
  int? idNote;
  String? title;
  String? content;
  String? dateNote;

  NotesDao({this.idNote, this.title, this.content, this.dateNote});

  factory NotesDao.fromMap(Map<String, dynamic> note) {
    return NotesDao(
      idNote: note['idNote'],
      title: note['title'],
      content: note['content'],
      dateNote: note['dateNote'],
    );
  }
}
