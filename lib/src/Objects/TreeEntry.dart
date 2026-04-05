import 'package:simple_git/src/Objects/GenericObject.dart';

class TreeEntry extends GenericObject {
  @override
  String typeName = "treeentry";

  int mode;
  String objectName;

  TreeEntry(super.objectIdBytes, this.mode, this.objectName);
  
}
