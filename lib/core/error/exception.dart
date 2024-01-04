class ServerException implements Exception {
  final String body;
  final int statusCode;
  const ServerException({
    required this.statusCode,
    required this.body,
  });
}
