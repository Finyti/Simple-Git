String objectIdToHashString(List<int> objectIdBytes) {
  String buffer = "";

  for (int byte in objectIdBytes) {
    buffer += byte.toRadixString(16).padLeft(2, '0');
  }

  return buffer;
}
