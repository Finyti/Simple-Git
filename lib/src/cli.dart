import 'dart:io';
import 'package:path/path.dart' as path;
import 'service.dart' as service;

const Map<String, void Function(List<String>)> functionsMap = {
  "init": initializeRepo,
};

// --- ENTRYPOINT

void runCommand(List<String> input) {
  validateInput(input);

  String command = input[0];
  List<String> arguments = input.sublist(1);
  if (input.length > 1) {
    input.getRange(1, input.length).toList();
  }

  functionsMap[command]!(arguments);
}

// --- MAIN FUNCTIONS

void initializeRepo(List<String> arguments) {
  String initLocation = Directory.current.path;
  if (!arguments.isEmpty) {
    initLocation = formulateGlobalPath(arguments.last, Directory.current.path);
  }

  service.init(initLocation);
}

// --- HELPERS

void validateInput(List<String> input) {
  if (isEmpty(input)) {
    throw ArgumentError(
      'No command provided. Try providing a valid command or type *ssm help*.',
    );
  }
  if (isInvalidCommand(input[0])) {
    throw ArgumentError('Unknown command ${input[0]}');
  }
}

bool isEmpty(List<String> input) {
  return input.length == 0;
}

bool isInvalidCommand(String command) {
  return !functionsMap.keys.contains(command);
}

/// The function checks, whether a path can be standalone.
/// If yes, it returns it unmodified.
/// If not, the function returns joined PWD and provided path.
String formulateGlobalPath(
  String userPath,
  String currentDirectory, {
  var pathContext = "",
  var operatingSystem = "",
}) {
  if (pathContext == "") {
    pathContext = path.context;
  }
  if (operatingSystem == "") {
    operatingSystem = Platform.operatingSystem;
  }

  if (operatingSystem == 'linux' || operatingSystem == 'macos') {
    if (userPath[0] == "/") {
      return userPath;
    }
  } else if (operatingSystem == 'windows') {
    RegExpMatch? match = RegExp(r'^[A-Za-z]:\\.*').firstMatch(userPath);
    if (match != null) {
      return userPath;
    }
  }
  return pathContext.join(currentDirectory, userPath);
}
