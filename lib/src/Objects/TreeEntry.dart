import 'dart:typed_data';



class TreeEntry {
  final String typeName = "treeentry";
  Uint8List objectIdBytes;

  int mode;
  String objectName;

  TreeEntry(this.objectIdBytes, this.mode, this.objectName);

  Uint8List get getIdBytes => objectIdBytes;


}
