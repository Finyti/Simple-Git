import 'dart:typed_data';

import 'object_id.dart';

class TreeEntry {
  final String typeName = "treeentry";
  Uint8List objectIdBytes;

  int mode;
  String objectName;

  TreeEntry(this.objectIdBytes, this.mode, this.objectName);

  Uint8List get getIdBytes => objectIdBytes;

  String getIdHashString() {
    return objectIdToHashString(objectIdBytes);
  }
}
