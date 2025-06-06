import 'package:flutter/foundation.dart';
import '../models/password_entry.dart';
import 'package:collection/collection.dart';

class PasswordProvider with ChangeNotifier {
  final List<PasswordEntry> _entries = [];

  List<PasswordEntry> get entries => _entries;

  void addEntry(PasswordEntry entry) {
    _entries.add(entry);
    notifyListeners();
  }

  void removeEntry(String id) {
    _entries.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  PasswordEntry? getEntryById(String id) {
    return _entries.firstWhereOrNull((e) => e.id == id);
  }
}
