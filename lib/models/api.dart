class API {
  final int code;
  final bool success;
  final String message;
  final data;

  API.fromJson(Map<String, dynamic> json) :
    code     = json["code"],
    success  = json["success"],
    message  = json["message"],
    data     = json["data"];
}
