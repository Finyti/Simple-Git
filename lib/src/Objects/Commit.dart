import 'CommitData.dart';
import 'object_id.dart';

class Commit {
  final String typeName = 'commit';
  final List<int> objectIdBytes;
  final CommitData data;

  Commit(this.objectIdBytes, this.data);

  List<int> get getIdBytes => objectIdBytes;

  String getIdHashString() {
    return objectIdToHashString(objectIdBytes);
  }
}
