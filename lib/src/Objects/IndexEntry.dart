import 'dart:typed_data';



class IndexEntry {
  final String typeName = 'indexentry';
  Uint8List objectIdBytes;

  int mode;
  Uint8List pathLength;
  Uint8List pathBytes;

  IndexEntry(this.objectIdBytes, this.mode, this.pathLength, this.pathBytes);

  Uint8List get getIdBytes => objectIdBytes;


}
