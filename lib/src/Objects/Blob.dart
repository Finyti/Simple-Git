import 'dart:typed_data';

import 'BlobData.dart';


class Blob {
  final String typeName = "blob";
  final Uint8List objectIdBytes;
  final BlobData data;

  Blob(this.objectIdBytes, this.data);

  Uint8List get getIdBytes => objectIdBytes;


}
