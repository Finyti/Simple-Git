import 'TreeData.dart';
import 'object_id.dart';

class Tree {
  final String typeName = 'tree';
  final List<int> objectIdBytes;
  final TreeData data;

  Tree(this.objectIdBytes, this.data);

  List<int> get getIdBytes => objectIdBytes;

  String getIdHashString() {
    return objectIdToHashString(objectIdBytes);
  }
}
