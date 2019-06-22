class TrSpaceInfoModel {
  String path;
  int freeSpace;

  TrSpaceInfoModel({this.path, this.freeSpace});

  String getSpaceGB() {
    double size = this.freeSpace / 1024.0 / 1024.0 / 1024.0;
    return size.toStringAsFixed(2);
  }
}
