import 'storage.dart' as storage;

/// Function that orchestrates initialization of a repo on a specified path.
///
/// Args: [file-path: String]
///
/// Will do nothing in case of already existing repo on specified path.
/// Invalid path will result in Error.
void init(initLocation) {
  if (storage.isARepo(targetPath: initLocation)) {
    throw StateError("Path ${initLocation} is already a repository");
  }

  storage.setupRepository(initLocation);
}
