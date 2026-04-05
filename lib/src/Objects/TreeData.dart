import 'package:simple_git/src/Objects/GenericObject.dart';

import 'TreeEntry.dart';

class TreeData extends GenericObject {
  @override
  String typeName = 'tree';

  int payloadSize;
  List<TreeEntry> entries;

  TreeData(super.objectIdBytes, this.payloadSize, this.entries);

  void addEntries(List<TreeEntry> newEntries) {
    entries.addAll(newEntries);
  }

  void deleteEntry(int index) {
    entries.remove(index);
  }

  TreeEntry getEntry(int index) {
    return entries[index];
  }
}
