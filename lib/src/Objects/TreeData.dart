import 'TreeEntry.dart';

class TreeData {
  int payloadSize;
  List<TreeEntry> entries;

  TreeData(this.payloadSize, this.entries);

  void addEntries(List<TreeEntry> newEntries) {
    entries.addAll(newEntries);
  }

  void deleteEntry(int index) {
    entries.removeAt(index);
  }

  TreeEntry getEntry(int index) {
    return entries[index];
  }
}
