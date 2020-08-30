class APIResponse<T>{
  T data;
  bool error;
  String errmessage;

  APIResponse({this.data,this.errmessage,this.error=false});
}