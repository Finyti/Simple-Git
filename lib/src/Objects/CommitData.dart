import 'package:simple_git/src/Objects/GenericObject.dart';

class CommitData extends GenericObject {
  @override
  String typeName = 'commit';

  int payloadSize;

  List<List<int>> parentsCommitId;
  String author;
  String commiter;
  String message;

  CommitData(
    super.objectIdBytes,
    this.payloadSize,
    this.parentsCommitId,
    this.author,
    this.commiter,
    this.message,
  );
}
