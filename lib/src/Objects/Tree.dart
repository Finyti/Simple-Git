import 'dart:typed_data';

import 'TreeData.dart';
import 'object_id.dart';

class Tree {
  final String typeName = 'tree';
  final Uint8List objectIdBytes;
  final TreeData data;

  Tree(this.objectIdBytes, this.data);

  Uint8List get getIdBytes => objectIdBytes;

  String getIdHashString() {
    return objectIdToHashString(objectIdBytes);
  }
}
