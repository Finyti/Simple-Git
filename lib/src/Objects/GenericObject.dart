abstract class GenericObject {
  String typeName = 'object';
  List<int> objectIdBytes;

  GenericObject(this.objectIdBytes);

  List<int> get getIdBytes => objectIdBytes;

  String getIdHashString() {
    String buffer = "";

    for (int byte in objectIdBytes) {
      buffer += byte.toRadixString(16).padLeft(2, '0');
    }

    return buffer;
  }
}
