import 'dart:typed_data';

class CommitData {
  int payloadSize;

  List<Uint8List> parentsCommitId;
  String author;
  String commiter;
  String message;

  CommitData(
    this.payloadSize,
    this.parentsCommitId,
    this.author,
    this.commiter,
    this.message,
  );
}
