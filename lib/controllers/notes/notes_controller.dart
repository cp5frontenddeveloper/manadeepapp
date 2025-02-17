import 'package:get/get.dart';

import '../../core/constants/db.dart';

class NotesController extends GetxController {
  final _notes = <Map<String, dynamic>>[].obs;
  final DatabaseHelper dbnote = DatabaseHelper();
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;
  List<Map<String, dynamic>> get notes => _notes;

  @override
  void onInit() {
    super.onInit();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      _isLoading.value = true;
      final notes = await dbnote.getNotes();
      _notes.assignAll(notes);
    } catch (e) {
      print('Error loading notes: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> addNote(String note) async {
    try {
      _isLoading.value = true;
      final id = await dbnote.insertNote(note);
      if (id != -1) {
        _notes.add({'id': id, 'note': note});
        Get.back();
      }
    } catch (e) {
      print('Error adding note: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> deleteNote(int index) async {
    try {
      final noteId = _notes[index]['id'] as int;
      await dbnote.deleteNote(noteId);
      _notes.removeAt(index);
    } catch (e) {
      print('Error deleting note: $e');
    }
  }
}
