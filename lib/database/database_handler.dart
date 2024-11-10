import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:my_simple_note/model/note.dart';

class DatabaseHandler {

  // Initialize the database
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'notes.db'),
      onCreate: (database, version) async {
        await database.execute(
            '''CREATE TABLE notes(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                body TEXT NOT NULL,
                date TEXT NOT NULL,
                color TEXT NOT NULL)''',
        );
      },
      version: 1,
    );
  }

  // Create a note
  Future<int> insertNote(Note note) async {
    final Database db = await initializeDB();
    return await db.insert('notes', note.toMap());
  }

  // Retrieve all notes
  Future<List<Note>> retrieveNotes() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('notes');
    return queryResult.map((e) => Note.fromMap(e)).toList();
  }

  // Delete a note
  Future<int> deleteNote(int id) async {
    final Database db = await initializeDB();
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Retrieve all notes related to a certain label
  Future<List<Note>> retrieveNotesByLabel(String color) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query(
      'notes',
      where: 'color = ?',
      whereArgs: [color],
    );
    return queryResult.map((e) => Note.fromMap(e)).toList();
  }

  // Update a note
  Future<int> updateNote(Note note) async {
    final Database db = await initializeDB();
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> closeDB() async {
    final Database db = await initializeDB();
    await db.close();
  }
}
