class ServerErrorException implements Exception {
  String errorMessage;

  ServerErrorException(this.errorMessage);
}
