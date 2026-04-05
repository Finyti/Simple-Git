import 'package:simple_git/src/Objects/GenericObject.dart';

class IndexEntry extends GenericObject {
  @override
  String typeName = 'indexentry';

  int mode;
  List<int> pathLength;
  List<int> pathBytes;

  IndexEntry(super.objectIdBytes, this.mode, this.pathLength, this.pathBytes);
}
