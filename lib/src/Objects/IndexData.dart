import 'dart:convert';

import 'IndexEntry.dart';

class IndexData {
  final List<IndexEntry> entries;

  IndexData(this.entries);

  int get getEntryCount => entries.length;
  List<IndexEntry> get getEntries => entries;

  void addEntries(List<IndexEntry> newEntries) {
    entries.addAll(newEntries);
  }

  void deleteEntry(int index) {
    entries.removeAt(index);
  }

  IndexEntry getEntry(int index) {
    return entries[index];
  }

  List<String> getEntriesPaths() {
    List<String> entriesPaths = [
      for (final entry in entries) utf8.decode(entry.pathBytes),
    ];
    return entriesPaths;
  }
}
