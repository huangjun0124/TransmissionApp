class TrUser {
  String url;
  String userName;
  String passWord;

  TrUser({this.url, this.userName, this.passWord});

  TrUser.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        userName = json['userName'],
        passWord = json['passWord'];

  Map<String, dynamic> toJson() => {
        'url': url,
        'userName': userName,
        'passWord': passWord,
      };
}
