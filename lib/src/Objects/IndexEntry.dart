import 'object_id.dart';

class IndexEntry {
  final String typeName = 'indexentry';
  List<int> objectIdBytes;

  int mode;
  List<int> pathLength;
  List<int> pathBytes;

  IndexEntry(this.objectIdBytes, this.mode, this.pathLength, this.pathBytes);

  List<int> get getIdBytes => objectIdBytes;

  String getIdHashString() {
    return objectIdToHashString(objectIdBytes);
  }
}
