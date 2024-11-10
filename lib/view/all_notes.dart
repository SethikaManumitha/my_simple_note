import 'package:flutter/material.dart';
import 'note_card.dart';
import 'create_note.dart';
import 'package:my_simple_note/controller/note_controller.dart';
import 'package:my_simple_note/model/note.dart';

class AllNotes extends StatefulWidget {
  const AllNotes({Key? key}) : super(key: key);

  @override
  _AllNotesState createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> {
  String searchQuery = "";
  List<Note> notes = [];
  final NoteController controller = NoteController();
  String? selectedSortOption;

  // Map colors to labels
  final Map<String, String> colorLabels = {
    'red': 'Urgent',
    'yellow': 'Personal',
    'green': 'Work',
    'blue': 'General',
  };

  @override
  void initState()  {
    super.initState();
    refreshNotes();
    print("loaded");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refreshNotes();
  }

  Future<void> refreshNotes() async {
    await fetchNotes();
  }

  // Fetch notes
  Future<void> fetchNotes() async {
    if (selectedSortOption != null && selectedSortOption != 'All') {
      notes = await controller.fetchNotesByLabel(selectedSortOption!);
    } else {
      notes = await controller.fetchNotes(searchQuery);
    }
    setState(() {});
  }

  bool isAscending = true;

  Future<void> sortNotes() async {
    notes.sort((a, b) => isAscending ? a.title.compareTo(b.title) : b.title.compareTo(a.title));
    setState(() {
      isAscending = !isAscending;
    });
  }

  // Update search query
  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
    fetchNotes();
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Column(
          children: [
            const Text("My Simple Notes", style: TextStyle(color: Colors.white, fontSize: 25.0)),
            Text("${notes.length} Notes", style: TextStyle(color: Colors.grey[400], fontSize: 14.0)),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.purple[700],
      ),
      body: RefreshIndicator(
        onRefresh: refreshNotes,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Search Notes',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: updateSearchQuery,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: selectedSortOption,
                    hint: Text("Filter By Label"),
                    items: <String>['All', 'red', 'yellow', 'green', 'blue'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(colorLabels[value] ?? value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSortOption = newValue;
                      });
                      refreshNotes();
                    },
                  ),

                  Row(
                    children: [
                      Text(isAscending ? "AZ" : "ZA"),
                      IconButton(
                        icon: Icon(
                          Icons.swap_vert,
                          color: isAscending ? Colors.black : Colors.blue,
                        ),
                        onPressed: () {
                          sortNotes();
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return NoteCard(
                    id: notes[index].id,
                    title: notes[index].title,
                    body: notes[index].body,
                    date: notes[index].date,
                    color: _getColorFromName(notes[index].color),
                    onDelete: refreshNotes,
                  );
                },
              ),

            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateNoteScreen()),
          );
          refreshNotes();
        },
        backgroundColor: Colors.red[300],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}