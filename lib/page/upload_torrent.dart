import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:transmission_app/model/async_ret.dart';
import 'package:transmission_app/model/tr_spaceinfo.dart';
import 'package:transmission_app/services/transmission_service.dart';
import 'package:transmission_app/ui/loading_view.dart';

class Tr_UploadPage extends StatefulWidget {
  String url = '';
  String path = '';

  TrSpaceInfoModel freeSpaceInfo;

  Tr_UploadPage({Key key, @required this.freeSpaceInfo}) : super(key: key) {
    path = freeSpaceInfo.path;
  }

  @override
  _Tr_UploadPageState createState() {
    return _Tr_UploadPageState();
  }
}

class _Tr_UploadPageState extends State<Tr_UploadPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, false);
          return Future.value(false);
        },
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Upload Torrent'),
            backgroundColor: Colors.purpleAccent,
          ),
          body: ProgressDialog(
              loading: _isUploading,
              msg: 'Uploading...',
              child: SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          obscureText: false, // true if you want password
                          decoration: InputDecoration(labelText: 'Enter URL:'),
                          onChanged: (String value) {
                            widget.url = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Destination Folder (' +
                                  widget.freeSpaceInfo.getSpaceGB() +
                                  ' GB Free)'),
                          controller: TextEditingController()
                            ..text = widget.freeSpaceInfo.path,
                          onChanged: (String value) {
                            widget.path = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RaisedButton(
                            child: Text('Upload'),
                            textColor: Colors.green,
                            onPressed: () {
                              onUploadClick(context);
                            })
                      ],
                    )),
              )),
        ));
  }

  void onUploadClick(context) {
    if (widget.url.trim() == "") {
      var snackBar = SnackBar(
          content: Text('Please input url！'),
          duration: Duration(milliseconds: 500));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }
    if (widget.path.trim() == "") {
      var snackBar = SnackBar(
          content: Text('Please input destination folder！'),
          duration: Duration(milliseconds: 500));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }
    setState(() {
      _isUploading = true;
    });
    WebInterface wi = WebInterface();
    wi.addTorrent(widget.path, widget.url).then((AsyncReturn ret) {
      var snackBar = SnackBar(
          content: Text(ret.isSuccess
              ? 'Upload Success！'
              : 'Upload Failed' + ret.message),
          duration: Duration(milliseconds: 1000));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      Navigator.pop(context, true);
    });
  }
}
