import 'dart:io';
import 'package:path/path.dart' as path;

void createFolder(String targetPath, String name) {
  try {
    new Directory(path.join(targetPath, name)).create(recursive: true);
  } catch (err) {
    print("Cant create folder structure for $targetPath \n Error: $err");
  }
}

void createFile(String targetPath, String name, {var content = ''}) {
  try {
    new File(path.join(targetPath, name)).createSync(recursive: true);
    if (content != '') {
      File(path.join(targetPath, name)).writeAsStringSync(content);
    }
  } catch (err) {
    print("Cant create file for $targetPath \n Error: $err");
  }
}

dynamic readFile(String targetPath, String name) {
  dynamic fileContent = '';
  return fileContent;
}

void writeFile(String targetPath, String name, var newContent) {
  if (newContent is String) {
    File(path.join(targetPath, name)).writeAsString(newContent);
  } else {
    File(path.join(targetPath, name)).writeAsBytes(newContent);
  }
}

bool doesPathExist(String targetPath) {
  return isADirectory(targetPath) || isAFile(targetPath);
}

bool isADirectory(String targetPath) {
  return Directory(targetPath).existsSync();
}

bool isAFile(String targetPath) {
  return Directory(targetPath).existsSync();
}
