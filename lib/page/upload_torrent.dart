import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:transmission_app/model/async_ret.dart';
import 'package:transmission_app/model/tr_spaceinfo.dart';
import 'package:transmission_app/services/transmission_service.dart';
import 'package:transmission_app/ui/loading_view.dart';
import 'package:transmission_app/ui/toast_view.dart';

class Tr_UploadPage extends StatefulWidget {
  String path = '';

  Tr_UploadPage({Key key, @required this.path}) : super(key: key) {}

  @override
  _Tr_UploadPageState createState() {
    return _Tr_UploadPageState();
  }
}

class _Tr_UploadPageState extends State<Tr_UploadPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isRefreshing = true;
  String _refreshMsg = 'Getting Space info...';
  TrSpaceInfoModel freeSpaceInfo;
  String _url, _path;

  @override
  void initState() {
    freeSpaceInfo = TrSpaceInfoModel(path: widget.path, freeSpace: 0);
    _path = widget.path;
    super.initState();
    WebInterface wi = WebInterface();
    wi.getFreeSpaceInfo(widget.path).then((AsyncReturn model) {
      setState(() {
        _isRefreshing = false;
        _refreshMsg = '';
        if (model.isSuccess) {
          freeSpaceInfo = model.data;
        } else {
          Toast.show('Get space info failed:' + model.message, context,
              miliseconds: 1500);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Upload Torrent'),
      ),
      body: ProgressDialog(
          loading: _isRefreshing,
          msg: _refreshMsg,
          child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                // 输入法弹出键盘时，触摸空白区域收起输入法
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          obscureText: false, // true if you want password
                          decoration: InputDecoration(labelText: 'Enter URL:'),
                          onChanged: (String value) {
                            _url = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Destination Folder (' +
                                  freeSpaceInfo.getSpaceGB() +
                                  ' GB Free)'),
                          controller: TextEditingController()
                            ..text = freeSpaceInfo.path,
                          onChanged: (String value) {
                            _path = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RaisedButton(
                            child: Text('Upload'),
                            //textColor: Colors.green,
                            onPressed: () {
                              onUploadClick(context);
                            })
                      ],
                    )),
              ))),
    );
  }

  void onUploadClick(context) {
    if (_url.trim() == "") {
      var snackBar = SnackBar(
          content: Text('Please input url！'),
          duration: Duration(milliseconds: 500));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }
    if (_path.trim() == "") {
      var snackBar = SnackBar(
          content: Text('Please input destination folder！'),
          duration: Duration(milliseconds: 500));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }
    setState(() {
      _isRefreshing = true;
      _refreshMsg = 'uploading...';
    });
    WebInterface wi = WebInterface();
    wi.addTorrent(_path, _url).then((AsyncReturn ret) {
      setState(() {
        _isRefreshing = false;
        _refreshMsg = '';
      });
      var snackBar = SnackBar(
          content: Text(ret.isSuccess
              ? 'Upload Success！'
              : 'Upload Failed : ' + ret.message),
          duration: Duration(milliseconds: 1000));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      if (ret.isSuccess) {
        Navigator.pop(context, true);
      }
    });
  }
}
