import 'dart:async';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transmission_app/model/async_ret.dart';
import 'package:transmission_app/model/global_vars.dart';
import 'package:transmission_app/model/torrent_info.dart';
import 'package:transmission_app/model/transmission_model.dart';
import 'package:transmission_app/services/transmission_service.dart';
import 'package:transmission_app/ui/dialog_helper.dart';
import 'package:transmission_app/ui/loading_view.dart';
import 'package:transmission_app/ui/toast_view.dart';

class TorrentsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TorrentPageState();
  }
}

class _TorrentPageState extends State<TorrentsPage> {
  TransmissionModel _model = TransmissionModel();
  String _textShow = 'Refreshing...';
  bool _isLoading = false;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _getTorrents();
    _timer = Timer.periodic(Duration(milliseconds: 2300), (timer) {
      _getTorrents(); //定时更新列表
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  getItem(Torrent tor) {
    var avatars = Container(
      margin: EdgeInsets.only(left: 0, top: 0),
      child: CircleAvatar(
          backgroundColor: Colors.white10,
          backgroundImage: AssetImage(tor.isDoneDownloading()
              ? 'assets/done.png'
              : 'assets/downloading.png')),
    );
    var row = Container(
      margin: EdgeInsets.all(0.0),
      child: Row(
        children: <Widget>[
          avatars,
          Expanded(
              child: Container(
            margin: EdgeInsets.only(left: 3.0),
            //height: 150.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  title: Text(tor.name),
                  subtitle: Text(tor.getStatus() +
                      '  |  ' +
                      tor.getSizeDownloaded() +
                      ' GB, up ' +
                      tor.getSizeUploaded() +
                      ' GB (Ratio ' +
                      tor.uploadRatio.toString() +
                      ') | Size ' +
                      tor.getSizeInGB() +
                      ' GB'),
                  trailing: _buildDelButton(context, tor),
                ),
                tor.errorString == ''
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('[D] ' +
                            (tor.rateDownload / 1024.0).toStringAsFixed(2) +
                            ' KB/s   ' +
                            '[U] ' +
                            (tor.rateUpload / 1024.0).toStringAsFixed(2) +
                            ' KB/s'),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Error: ' + tor.errorString,
                          style: TextStyle(color: Colors.red),
                        )),
                Divider(
                  height: 1,
                )
              ],
            ),
          ))
        ],
      ),
    );
    return Card(
      child: row,
    );
  }

  Widget _buildDelButton(BuildContext context, Torrent tor) {
    return IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.red,
        ),
        onPressed: () {
          DialogHelper dh = DialogHelper();
          dh.showActionDialog(
              context: context,
              title: "Delete！",
              contentMsg: "Confirm to delete【" + tor.name + "】？",
              onClose: (ret) {
                if (ret == DialogItemAction.confirm) {
                  WebInterface wi = WebInterface();
                  wi.removeTorrent(tor.id).then((AsyncReturn ret) {
                    setState(() {
                      if (ret.isSuccess) {
                        Toast.show('Delete success', context);
                        _getTorrents();
                      } else {
                        Toast.show('Delete failed:' + ret.message, context,
                            miliseconds: 2000);
                      }
                    });
                  });
                }
              });
        });
  }

  void _getTorrents() {
    setState(() {
      WebInterface wi = WebInterface();
      wi.getTorrents().then((ret) {
        setState(() {
          _isLoading = false;
        });
        if (ret.isSuccess) {
          onGotTorrents(ret.data);
        } else {
          Toast.show('Refresh failed:' + ret.message, context,
              miliseconds: 1500);
        }
      });
    });
  }

  void onGotTorrents(List<Torrent> tors) {
    setState(() {
      double totalSize = 0;
      double totalDownRate = 0;
      double totalUpRate = 0;
      for (var tor in tors) {
        totalSize += tor.getSizeInGBdouble();
        totalDownRate += tor.rateDownload;
        totalUpRate += tor.rateUpload;
      }
      _textShow = 'File Size Total 【' + totalSize.toStringAsFixed(2) + ' GB】\n';
      _textShow += '[D] speed: 【' +
          (totalDownRate / 1024.0).toStringAsFixed(2) +
          '】KB/s  ' +
          '[U] speed: 【' +
          (totalUpRate / 1024.0).toStringAsFixed(2) +
          '】KB/s';
      _model.torrents = tors;
    });
  }

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
            ),
            child: Center(
              child: SizedBox(
                width: 60.0,
                height: 60.0,
                child: CircleAvatar(
                  child: Text('Actions'),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(CommunityMaterialIcons.upload),
            title: Text('Upload Torrent'),
            onTap: () {
              Navigator.of(context).pop(); // 收起当前侧边
              Navigator.pushNamed(context, '/upload_torrent').then((value) {
                onRefresh();
              });
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(CommunityMaterialIcons.logout_variant),
            title: Text('Log out'),
            onTap: () {
              GlobalVariables.isAutoLogin = false;
              Navigator.of(context).pop(); // 收起当前侧边
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          Divider(),
          new ListTile(
            //退出按钮
            title: new Text('Close'),
            leading: new Icon(CommunityMaterialIcons.close_box_multiple),
            onTap: () => Navigator.of(context).pop(), //点击后收起侧边栏
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(GlobalVariables.title),
      ),
      body: ProgressDialog(
          loading: _isLoading,
          msg: "Getting torrents info...",
          child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _textShow,
                ),
                new Expanded(
                    child: new ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return getItem(_model.torrents[index]);
                  },
                  itemCount: _model.torrents.length,
                )),
              ],
            ),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          onRefresh();
        },
        tooltip: 'Refresh Page',
        child: Icon(Icons.autorenew),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void onRefresh() {
    setState(() {
      _textShow = 'Refreshing...';
      _isLoading = true;
    });
    _getTorrents();
  }
}
