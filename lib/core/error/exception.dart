class ServerException implements Exception {
  ServerException({this.message, this.stack});

  final String? message;
  final StackTrace? stack;
}

class NetworkException implements Exception {
  NetworkException(
      {this.message = 'Please check your internet connection and try again'});

  final String message;
}

class BadRequestException implements Exception {
  BadRequestException({this.message});

  final String? message;
}
