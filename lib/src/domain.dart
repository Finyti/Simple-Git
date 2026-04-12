import 'package:simple_git/src/Objects/IndexData.dart';
import 'package:path/path.dart' as path;

class Domain {
  const Domain();

  List<String> validateAdditionToIndex(
    String root,
    List<String> filePaths,
    IndexData index, {
    final List<String> ignorePaths = const [],
  }) {
    List<String> addedPaths = index.getEntriesPaths();
    List<String> validatedFiles = [];
    for (String file in filePaths) {
      if (file.startsWith(path.join(root, ".ssm"))) {
        continue;
      }
      if (addedPaths.contains(file)) {
        continue;
      } else {
        validatedFiles.add(file);
      }
    }
    return validatedFiles;
  }
}
