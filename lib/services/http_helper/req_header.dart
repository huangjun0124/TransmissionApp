class RequestHeader {
  static Map<String, dynamic> GetHeaderMap() {
    return {
      "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36",
      "Accept": "application/json, text/javascript, */*; q=0.01",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept-Language": "zh,en;q=0.9,zh-TW;q=0.8,zh-CN;q=0.7",
      "Cache-Control": "max-age=0",
      "X-Requested-With": "XMLHttpRequest",
      "Upgrade-Insecure-Requests": 1,
      "Content-Type": "json"
    };
  }
}
