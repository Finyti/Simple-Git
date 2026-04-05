import 'BlobData.dart';
import 'object_id.dart';

class Blob {
  final String typeName = "blob";
  final List<int> objectIdBytes;
  final BlobData data;

  Blob(this.objectIdBytes, this.data);

  List<int> get getIdBytes => objectIdBytes;

  String getIdHashString() {
    return objectIdToHashString(objectIdBytes);
  }
}
