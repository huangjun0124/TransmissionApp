import 'package:flutter/material.dart';

class DialogHelper {
  void showActionDialog(
      {BuildContext context, String title, String contentMsg, onClose}) {
    var child = new AlertDialog(
        title: new Text(title),
        content: new Text(contentMsg),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Cancel"),
            onPressed: () {
              Navigator.pop(context, DialogItemAction.cancel);
            },
          ),
          new FlatButton(
            child: new Text("Confirm"),
            onPressed: () {
              Navigator.pop(context, DialogItemAction.confirm);
            },
          )
        ]);
    showDialog<DialogItemAction>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((DialogItemAction value) {
      // The value passed to Navigator.pop() or null.
      onClose(value);
    });
  }

  DialogItemAction showActionDialogWithInputChild(
      {BuildContext context, Widget child}) {
    DialogItemAction ret = DialogItemAction.undefined;
    showDialog<DialogItemAction>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((DialogItemAction value) {
      // The value passed to Navigator.pop() or null.
      ret = value;
    });
    return ret;
  }
}

enum DialogItemAction {
  undefined,
  cancel,
  confirm,
}
