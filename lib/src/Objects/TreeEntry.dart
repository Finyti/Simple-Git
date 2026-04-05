import 'object_id.dart';

class TreeEntry {
  final String typeName = "treeentry";
  List<int> objectIdBytes;

  int mode;
  String objectName;

  TreeEntry(this.objectIdBytes, this.mode, this.objectName);

  List<int> get getIdBytes => objectIdBytes;

  String getIdHashString() {
    return objectIdToHashString(objectIdBytes);
  }
}
