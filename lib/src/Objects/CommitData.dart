class CommitData {
  int payloadSize;

  List<List<int>> parentsCommitId;
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
