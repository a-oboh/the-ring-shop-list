class ServerException implements Exception {
  ServerException({this.message});

  final String? message;
}

class InvalidException implements Exception {}

class BadRequestException implements Exception {
  BadRequestException({this.message});

  final String? message;
}
