class EmptyDataException implements Exception {
  final String message;

  EmptyDataException(this.message);

  @override
  String toString() => message;
}
