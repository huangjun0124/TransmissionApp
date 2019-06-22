import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:transmission_app/model/global_vars.dart';
import 'package:transmission_app/model/user.dart';
import 'package:transmission_app/services/transmission_service.dart';
import 'package:transmission_app/ui/loading_view.dart';
import 'package:transmission_app/ui/toast_view.dart';
import 'package:transmission_app/util/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true, _saveAccount = true;
  Color _passwordEyeColor;
  bool _isInitialLoading = true;
  bool _isLoggingIn = false;
  TrUser _userInfo = TrUser(url: 'http://ip:port');

  @override
  void initState() {
    super.initState();
    _getSavedUserInfo();
  }

  _getSavedUserInfo() async {
    var user = await SharedPreferenceUtil.getUser();
    if (user != null) _userInfo = user;
    setState(() {
      _isInitialLoading = false;
    });
    if (_userInfo.passWord != null) {
      _doLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isInitialLoading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )
          : GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                // 输入法弹出键盘时，触摸空白区域收起输入法
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: ProgressDialog(
                  loading: _isLoggingIn,
                  msg: "Logging in...",
                  child: Form(
                      key: _formKey,
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 22.0),
                        children: <Widget>[
                          SizedBox(
                            height: kToolbarHeight,
                          ),
                          buildTitle(),
                          buildTitleLine(),
                          SizedBox(height: 70.0),
                          buildUrlTextField(),
                          SizedBox(height: 30.0),
                          buildUserNameTextField(),
                          SizedBox(height: 30.0),
                          buildPasswordTextField(context),
                          SizedBox(height: 30.0),
                          buildSaveAccount(),
                          SizedBox(height: 70.0),
                          buildLoginButton(context)
                        ],
                      )))),
    );
  }

  Align buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            'Login',
            style: Theme.of(context).primaryTextTheme.headline,
          ),
          color: Colors.black,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              ///Only all text field validates, will code reach here
              _formKey.currentState.save();
              _doLogin();
            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  _doLogin() async {
    setState(() {
      _isLoggingIn = true;
    });
    GlobalVariables.userInfo = _userInfo;
    WebInterface wi = WebInterface();
    wi.getSession().then((model) {
      setState(() {
        _isLoggingIn = false;
      });
      if (model.isSuccess) {
        Toast.show('Login success ', context, miliseconds: 600);
        // Navigate to next page
        if (_saveAccount) {
          SharedPreferenceUtil.saveUser(_userInfo);
        }
      } else {
        Toast.show('Login failed: ' + model.message, context,
            miliseconds: 3000);
      }
    });
  }

  SwitchListTile buildSaveAccount() {
    return SwitchListTile(
      value: _saveAccount,
      onChanged: (bool value) {
        setState(() {
          _saveAccount = value;
        });
      },
      title: Text('Auto Login'),
    );
  }

  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => _userInfo.passWord = value,
      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Input Password';
        }
        return null;
      },
      initialValue: _userInfo.passWord,
      decoration: InputDecoration(
          icon: new Icon(CommunityMaterialIcons.textbox_password,
              color: Colors.black),
          labelText: 'Password',
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _passwordEyeColor,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                  _passwordEyeColor = _isObscure
                      ? Colors.grey
                      : Theme.of(context).iconTheme.color;
                });
              })),
    );
  }

  TextFormField buildUrlTextField() {
    return TextFormField(
      decoration: InputDecoration(
        icon: new Icon(
          CommunityMaterialIcons.web,
          color: Colors.black,
        ),
        labelText: 'Transmission url',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Input Url';
        }
        return null;
      },
      onSaved: (String value) => _userInfo.url = value,
      initialValue: _userInfo.url,
    );
  }

  TextFormField buildUserNameTextField() {
    return TextFormField(
      decoration: InputDecoration(
        icon: new Icon(CommunityMaterialIcons.account, color: Colors.black),
        labelText: 'UserName',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Input UserName';
        }
        return null;
      },
      onSaved: (String value) => _userInfo.userName = value,
      initialValue: _userInfo.userName,
    );
  }

  Padding buildTitleLine() {
    return Padding(
      padding: EdgeInsets.only(left: 12.0, top: 4.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.black,
          width: 60.0,
          height: 2.0,
        ),
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Transmission',
        style: TextStyle(fontSize: 42.0),
      ),
    );
  }
}
