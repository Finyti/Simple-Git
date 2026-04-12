import 'dart:typed_data';

import 'CommitData.dart';


class Commit {
  final String typeName = 'commit';
  final Uint8List objectIdBytes;
  final CommitData data;

  Commit(this.objectIdBytes, this.data);

  Uint8List get getIdBytes => objectIdBytes;


}
