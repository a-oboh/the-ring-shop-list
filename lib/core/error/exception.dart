class ServerException implements Exception {
  ServerException({this.message});

  final String? message;
}

class NetworkException implements Exception {
  NetworkException({this.message = 'Please check your internet connection'});

  final String message;
}

class BadRequestException implements Exception {
  BadRequestException({this.message});

  final String? message;
}
