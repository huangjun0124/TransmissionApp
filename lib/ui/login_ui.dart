import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _url, _userName, _password;
  bool _isObscure = true, _saveAccount = true;
  Color _passwordEyeColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // 输入法弹出键盘时，触摸空白区域收起输入法
              FocusScope.of(context).requestFocus(FocusNode());
            },
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
                ))));
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
              //TODO 执行登录方法
              print('email:$_userName , assword:$_password');
            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
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
      onSaved: (String value) => _password = value,
      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Input Password';
        }
        return null;
      },
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
      onSaved: (String value) => _url = value,
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
      onSaved: (String value) => _userName = value,
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
