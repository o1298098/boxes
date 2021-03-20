class ResponseModel<T> {
  final int statusCode;
  final String message;
  final T result;
  final Map<String, dynamic> headers;
  ResponseModel({this.message, this.result, this.headers, this.statusCode});
  bool get success => [200, 201, 204].contains(statusCode);
}
