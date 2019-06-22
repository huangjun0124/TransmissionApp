class AsyncReturn {
  String message;
  bool isSuccess;
  dynamic data;

  AsyncReturn({this.isSuccess = false, this.data, this.message = ''});
}
