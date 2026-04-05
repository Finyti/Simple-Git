import 'package:simple_git/src/Objects/GenericObject.dart';

class BlobData extends GenericObject {
  @override
  String typeName = "blob";

  int payloadSize;
  BlobData(super.objectIdBytes, this.payloadSize);
}
