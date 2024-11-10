import 'package:my_simple_note/model/note.dart';
import '../database/database_handler.dart';

class NoteController {
  final DatabaseHandler databaseHandler = DatabaseHandler();

  // Fetch all notes from the database
  Future<List<Note>> fetchNotes(String query) async {
    List<Note> notes = await databaseHandler.retrieveNotes();
    return notes.where((note) => note.title.toLowerCase().contains(query.toLowerCase())).toList();
  }

  // Insert note into database
  Future<void> insertNote(Note note) async {
    await databaseHandler.insertNote(note);
  }

  // Delete note in the database
  Future<void> deleteNote(int id) async {
    await databaseHandler.deleteNote(id);
  }

  // Update a note in the database
  Future<void> updateNote(Note note) async {
    await databaseHandler.updateNote(note);
  }

  // Retrieve a note by label
  Future<List<Note>> fetchNotesByLabel(String color) async {
    List<Note> notes = await databaseHandler.retrieveNotesByLabel(color);
    return notes;
  }



}
