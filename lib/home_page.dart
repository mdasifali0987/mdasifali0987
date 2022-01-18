import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'db/db_helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// All todolist
  List<Map<String, dynamic>> _todolist = [];
  bool _isLoading = true;

  /// This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _todolist = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  /// This function will be triggered when the floating button is pressed
  /// It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      /// id == null -> create new item
      /// id != null -> update an existing item
      final existingJournal =
          _todolist.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
      _dateController.text = existingJournal['date'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,

                /// this will prevent the soft keyboard from covering the text fields
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Title', labelStyle: GoogleFonts.kanit()),
                    controller: _titleController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: GoogleFonts.kanit()),
                    controller: _descriptionController,
                  ),
                  TextFormField(
                    readOnly: true,
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.kanit(),
                      labelText: 'Date',
                    ),
                    onTap: () async {
                      await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2015),
                        lastDate: DateTime(2025),
                      ).then((selectedDate) {
                        if (selectedDate != null) {
                          _dateController.text =
                              DateFormat('yyyy-MM-dd').format(selectedDate);
                        }
                      });
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Save new journal
                      if (id == null) {
                        await _addItem();
                      }

                      if (id != null) {
                        await _updateItem(id);
                      }

                      // Clear the text fields
                      _titleController.text = '';
                      _descriptionController.text = '';
                      _dateController.text = '';

                      // Close the bottom sheet
                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? 'Create New' : 'Update'),
                  )
                ],
              ),
            ));
  }

// Insert a new journal to the database
  Future<void> _addItem() async {
    await SQLHelper.createItem(_titleController.text,
        _descriptionController.text, _dateController.text);
    _refreshJournals();
  }

  // Update an existing journal
  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(id, _titleController.text,
        _descriptionController.text, _dateController.text);
    _refreshJournals();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully deleted a journal!',
          style: GoogleFonts.kanit(
              color: Colors.teal, fontWeight: FontWeight.bold)),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'TODO.LIST',
          style: GoogleFonts.kanit(fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text('Sort by tilte'),
                      value: 1,
                      onTap: () async {
                        final sort_title = await SQLHelper.sortbytitle(
                            Dbconstant.COLOMN_TITLE);
                        setState(() {
                          _todolist = sort_title;
                        });
                      },
                    ),
                    PopupMenuItem(
                      child: Text(
                        'Sort by date',
                        style: GoogleFonts.kanit(),
                      ),
                      value: 2,
                      onTap: () async {
                        final sort_date =
                            await SQLHelper.sortbydate(Dbconstant.COLOMN_DATE);
                        setState(() {
                          _todolist = sort_date;
                        });
                      },
                    ),
                    PopupMenuItem(
                      child: Text('Sort by manual'),
                      value: 3,
                      onTap: () async {
                        /*final data2 =
                            await SQLHelper.getItemsss(Dbconstant.COLOMN_DATE);
                        setState(() {
                          _journals = data2;
                        });*/
                      },
                    )
                  ])
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : /*ReorderableListView.builder(
              itemBuilder: (context, index) {
                final itemskey = _journals[index];
                return Card(
                  key: ValueKey(itemskey),
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: FittedBox(
                            child: Text(
                          _journals[index]['date'],
                          style: GoogleFonts.kanit(fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    title: Text(_journals[index]['title'],style: GoogleFonts.kanit(fontWeight: FontWeight.bold,fontSize: 20)),
                    subtitle: Text(_journals[index]['description']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showForm(_journals[index]['id']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _deleteItem(_journals[index]['id']),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: _journals.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex = newIndex - 1;
                  }
                  final element = _journals.removeAt(oldIndex);
                  _journals.insert(newIndex, element);
                });
              }),*/
          ListView.builder(
              itemCount: _todolist.length,
              itemBuilder: (context, index) => Card(
                color: Color.fromARGB(
                    Random().nextInt(256),
                    Random().nextInt(256),
                    Random().nextInt(256),
                    Random().nextInt(256)),
                margin: const EdgeInsets.all(10),
                child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: FittedBox(
                            child: Text(
                          _todolist[index]['date'],
                          style: GoogleFonts.kanit(fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    title: Text(_todolist[index]['title'],style: GoogleFonts.kanit(fontWeight: FontWeight.bold,fontSize: 21),),
                    subtitle: Text(_todolist[index]['description']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showForm(_todolist[index]['id']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _deleteItem(_todolist[index]['id']),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(
          Icons.sort,
          color: Colors.white,
          size: 32,
        ),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
