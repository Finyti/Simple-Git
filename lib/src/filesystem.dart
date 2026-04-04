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
    new File(path.join(targetPath, name)).create(recursive: true);
  } catch (err) {
    print("Cant create file for $targetPath \n Error: $err");
  }
}

dynamic readFile(String targetPath, String name) {
  dynamic fileContent = '';
  return fileContent;
}

void updateFile(String targetPath, String name, var newContent) {}

bool doesPathExist(String targetPath) {
  bool checkPathExistence = Directory(targetPath).existsSync();
  bool checkFileExistence = File(targetPath).existsSync();

  return checkPathExistence || checkFileExistence;
}
