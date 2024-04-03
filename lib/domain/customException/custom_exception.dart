class ServerErrorException implements Exception {
  String errorMessage;
  int? statusCode;

  ServerErrorException({required this.errorMessage, this.statusCode});
}
