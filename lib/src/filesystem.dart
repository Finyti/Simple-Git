import 'dart:io';
import 'dart:typed_data';
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
      writeFile(targetPath, name, content);
    }
  } catch (err) {
    print("Cant create file for $targetPath \n Error: $err");
  }
}

Uint8List readFile(String targetPath) {
  return File(targetPath).readAsBytesSync();
}

String readFileString(String targetPath) {
  return File(targetPath).readAsStringSync();
}

int getFileSize(String targetPath) {
  return File(targetPath).lengthSync();
}

void writeFile(String targetPath, String name, var newContent) {
  if (newContent is String) {
    File(path.join(targetPath, name)).writeAsString(newContent);
  } else if (newContent is Uint8List) {
    File(path.join(targetPath, name)).writeAsBytes(newContent.toList());
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
  return File(targetPath).existsSync();
}
