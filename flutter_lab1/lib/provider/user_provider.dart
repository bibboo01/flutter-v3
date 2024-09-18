import 'package:flutter/material.dart';
import 'package:flutter_lab1/model/user_model.dart';

class UserProvider extends ChangeNotifier{
  String? _user;
  String? _accessToken;
  String? _refreshToken;

  String get user => _user!;
  String get accessToken => _accessToken!;
  String get refreshToken => _refreshToken!;

  void saveUser(userModel UserModel,Token token){
    _user = UserModel.userName;
    _accessToken = token.accessToken;
    _refreshToken = token.refreshToken;
  }
  
  void onLogout(){
    _user = null;
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }

  void updateAccessToken(String newtoken){
    _accessToken = newtoken;
    notifyListeners();
  }
}
