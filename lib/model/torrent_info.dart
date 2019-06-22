class Torrent {
  int addedDate = 1560653279;
  String downloadDir;
  int error = 0;
  String errorString;
  int eta = -1;
  int id = 4;
  bool isFinished = false;
  bool isStalled = false;
  int leftUntilDone = 0;
  int metadataPercentComplete = 1;
  String name;
  int peersConnected = 2;
  int peersGettingFromUs = 2;
  int peersSendingToUs = 0;
  double percentDone = 1;
  int queuePosition = 0;
  // 下载速度
  int rateDownload = 0;
  // 上传速度
  int rateUpload = 16000;
  int recheckProgress = 0;
  int seedRatioLimit = 0;
  int seedRatioMode = 0;
  int sizeWhenDone = 7662993408;
  int status = 6;
  int totalSize = 7662993408;
  // 上传总数
  int uploadedEver = 1919740072;
  // 下载总数
  int downloadedEver = 1919740072;
  // 上传比率
  double uploadRatio = 0.2504;
  int webseedsSendingToUs = 0;

  Torrent.fromJson(Map<String, dynamic> json)
      : addedDate = json['addedDate'],
        downloadDir = json['downloadDir'],
        error = json['error'],
        errorString = json['errorString'],
        eta = json['eta'],
        id = json['id'],
        isFinished = json['isFinished'],
        isStalled = json['isStalled'],
        leftUntilDone = json['leftUntilDone'],
        metadataPercentComplete = json['metadataPercentComplete'],
        name = json['name'],
        peersConnected = json['peersConnected'],
        peersGettingFromUs = json['peersGettingFromUs'],
        peersSendingToUs = json['peersSendingToUs'],
        percentDone = double.parse(json['percentDone'].toString()),
        queuePosition = json['queuePosition'],
        rateDownload = json['rateDownload'],
        rateUpload = json['rateUpload'],
        recheckProgress = json['recheckProgress'],
        seedRatioLimit = json['seedRatioLimit'],
        seedRatioMode = json['seedRatioMode'],
        sizeWhenDone = json['sizeWhenDone'],
        status = json['status'],
        totalSize = json['totalSize'],
        uploadedEver = json['uploadedEver'],
        uploadRatio = double.parse(json['uploadRatio'].toString()),
        webseedsSendingToUs = json['webseedsSendingToUs'],
        downloadedEver = json['downloadedEver'];

  String getSizeInGB() {
    double size = this.totalSize / 1024.0 / 1024.0 / 1024.0;
    return size.toStringAsFixed(2);
  }

  double getSizeInGBdouble() {
    return this.totalSize / 1024.0 / 1024.0 / 1024.0;
  }

  String getSizeDownloaded() {
    double size = this.downloadedEver / 1024.0 / 1024.0 / 1024.0;
    return size.toStringAsFixed(2);
  }

  String getSizeUploaded() {
    double size = this.uploadedEver / 1024.0 / 1024.0 / 1024.0;
    return size.toStringAsFixed(2);
  }

  String getStatus() {
    switch (this.status) {
      case 0:
        return "Stopped";
      case 1:
        return "CheckWait";
      case 2:
        return "Check";
      case 3:
        return "DownloadWait";
      case 4:
        return "Download";
      case 5:
        return "SeedWait";
      case 6:
        return "Seed";
    }
  }

  bool isDoneDownloading() {
    switch (this.status) {
      case 5:
      case 6:
        return true;
    }
    return false;
  }

  String getAddDate() {
    var date = new DateTime.fromMillisecondsSinceEpoch(this.addedDate * 1000);
    return date.toString();
  }
}
