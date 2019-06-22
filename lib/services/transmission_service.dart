import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:transmission_app/model/async_ret.dart';
import 'package:transmission_app/model/global_vars.dart';
import 'package:transmission_app/model/torrent_info.dart';

import 'http_helper/http_dio.dart';

class WebInterface {
  static String _sessionId = "";

  String _getBase64Encode(String strIn) {
    var bytes = utf8.encode(strIn);
    var base64Str = base64.encode(bytes);
    return base64Str;
  }

  void _refreshHeader() {
    var url = GlobalVariables.userInfo.url;
    if (!url.startsWith('http://')) {
      url = 'http://' + url;
    }
    if (url.endsWith('/transmission/web/')) {
      url = url.replaceAll('/transmission/web/', '');
    }
    if (url.endsWith('/transmission')) {
      url = url.replaceAll('/transmission', '');
    }
    GlobalVariables.userInfo.url = url;

    dio.options.headers["Referer"] =
        GlobalVariables.userInfo.url + "/transmission/web/";
    dio.options.headers["Accept"] =
        "application/json, text/javascript, */*; q=0.01";
    dio.options.headers["X-Requested-With"] = "XMLHttpRequest";
    dio.options.headers["Content-Type"] = "json";
    dio.options.headers["Origin"] = GlobalVariables.userInfo.url;
    dio.options.headers["Host"] = GlobalVariables.userInfo.url;
    String ssr = _getBase64Encode(GlobalVariables.userInfo.userName +
        ':' +
        GlobalVariables.userInfo.passWord);
    dio.options.headers["Authorization"] = "Basic " + ssr;
    dio.options.headers["X-Transmission-Session-Id"] = _sessionId;
  }

  Future<AsyncReturn> getSession() async {
    AsyncReturn model = AsyncReturn();
    Response response;
    _refreshHeader();
    try {
      response = await dio.post(
          GlobalVariables.userInfo.url + "/transmission/rpc",
          data: {"method": "session-get"});
    } on DioError catch (error) {
      if (error.response.statusCode == 409) {
        response = error.response;
        _sessionId =
            response.headers["x-transmission-session-id"][0]; // first login
      } else if (error.response.statusCode == 401) {
        model.isSuccess = false;
        model.message = 'UserName and Password incorrect!';
      } else {
        model.isSuccess = false;
        model.message = error.toString();
        if (error.response != null) {
          model.message += error.response.statusMessage;
        }
        model.data = error;
      }
    }
    if (response != null) {
      model.isSuccess = true;
      model.data = response.data;
    }
    return model;
  }

  Future<AsyncReturn> removeTorrent(int id) async {
    AsyncReturn model = AsyncReturn();
    Response response;
    _refreshHeader();
    try {
      response = await dio
          .post(GlobalVariables.userInfo.url + "/transmission/rpc", data: {
        "method": "torrent-remove",
        "arguments": {
          "delete-local-data": true,
          "ids": [id]
        }
      });
    } on DioError catch (error) {
      model.isSuccess = false;
      model.message = error.toString();
      if (error.response != null) {
        model.message += error.response.statusMessage;
      }
      model.data = error;
    }
    if ((response.data as Map<String, dynamic>)["result"] == "success") {
      model.isSuccess = true;
      model.data = response.data;
    }
    return model;
  }

  Future<AsyncReturn> getTorrents() async {
    AsyncReturn model = AsyncReturn();
    List<Torrent> torList = new List<Torrent>();
    Response response;
    _refreshHeader();
    var jsonData = {
      "method": "torrent-get",
      "arguments": {
        "fields": [
          "id",
          "addedDate",
          "name",
          "totalSize",
          "error",
          "errorString",
          "eta",
          "isFinished",
          "isStalled",
          "leftUntilDone",
          "metadataPercentComplete",
          "peersConnected",
          "peersGettingFromUs",
          "peersSendingToUs",
          "percentDone",
          "queuePosition",
          "rateDownload",
          "rateUpload",
          "recheckProgress",
          "seedRatioMode",
          "seedRatioLimit",
          "sizeWhenDone",
          "status",
          "trackers",
          "downloadDir",
          "uploadedEver",
          "uploadRatio",
          "webseedsSendingToUs",
          "downloadedEver"
        ]
      }
    };
    try {
      response = await dio.post(
          GlobalVariables.userInfo.url + "/transmission/rpc",
          data: jsonData);
    } on DioError catch (error) {
      model.isSuccess = false;
      model.message = error.toString();
      if (error.response != null) {
        model.message += error.response.statusMessage;
      }
      model.data = error;
    }

    var torrents = ((response.data as Map<String, dynamic>)["arguments"]
        as Map<String, dynamic>)["torrents"] as List;
    for (Map<String, dynamic> json in torrents) {
      var torrent = new Torrent.fromJson(json);
      torList.add(torrent);
    }
    torList.sort((Torrent a, Torrent b) {
      return a.status - b.status;
    });
    model.data = torList;
    model.isSuccess = true;
    return model;
  }
}
