import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_simple_note/controller/note_controller.dart';
import 'package:my_simple_note/model/note.dart';

class EditNoteScreen extends StatefulWidget {
  final int? id;
  final String title;
  final String body;
  final String date;
  final Color color;

  const EditNoteScreen({
    super.key,
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.color,
  });

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late String title;
  late String body;
  late String selectedColor;
  final NoteController controller = NoteController();
  final FocusNode bodyFocusNode = FocusNode();

  late TextEditingController titleController;
  late TextEditingController bodyController;

  final Map<String, String> colorMeanings = {
    'red': 'Urgent',
    'yellow': 'Personal',
    'green': 'Work',
    'blue': 'General',
  };

  @override
  void initState() {
    super.initState();
    title = widget.title;
    body = widget.body;
    titleController = TextEditingController(text: title);
    bodyController = TextEditingController(text: body);
    selectedColor = _getColorName(widget.color);
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    bodyFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Edit Note", style: TextStyle(color: Colors.white, fontSize: 25.0)),
        centerTitle: true,
        backgroundColor: Colors.purple[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select Color:", style: TextStyle(fontSize: 16.0)),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: colorMeanings.keys.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _getColor(color),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedColor == color ? Colors.black : Colors.transparent,
                            width: 4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        colorMeanings[color]!,
                        style: const TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: titleController,
              onChanged: (value) => setState(() => title = value),
            ),
            TextField(
              focusNode: bodyFocusNode,
              decoration: InputDecoration(
                labelText: 'Body',
                alignLabelWithHint: true,
                border: bodyFocusNode.hasFocus ? InputBorder.none : const UnderlineInputBorder(),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              controller: bodyController,
              onChanged: (value) => setState(() => body = value),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String creationDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
          Note updatedNote = Note(
            id: widget.id,
            title: title,
            body: body,
            date: creationDate,
            color: selectedColor,
          );
          controller.updateNote(updatedNote);
          Navigator.pop(context, updatedNote);
          Navigator.popUntil(context, (route) => route.isFirst );
        },
        backgroundColor: Colors.red[300],
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Color _getColor(String colorName) {
    switch (colorName) {
      case 'red':
        return Colors.red;
      case 'yellow':
        return Colors.orange;
      case 'green':
        return Colors.green;
      case 'blue':
      default:
        return Colors.blue;
    }
  }

  String _getColorName(Color color) {
    if (color == Colors.red) return 'red';
    if (color == Colors.orange) return 'yellow';
    if (color == Colors.green) return 'green';
    return 'blue';
  }
}
