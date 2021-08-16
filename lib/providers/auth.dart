import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  String? _name;
  String? _email;
  String? _imageUrl;
  DateTime? _expiryDate;
  Timer? _authTimer;

  bool get isAuth => token != null;
  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId => _userId;
  String? get name => _name;
  String? get email => _email;
  String? get imageUrl => _imageUrl;

  Future<void> signin() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      if (googleAuth == null) return;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      await GoogleSignIn().signOut();
      final ft = await userCredential.user!.getIdTokenResult();
      _token = ft.token;
      _expiryDate = ft.expirationTime;
      _userId = userCredential.user!.uid;
      _name = userCredential.user!.displayName;
      _email = userCredential.user!.email;
      _imageUrl = userCredential.user!.photoURL;
      _autoLogout();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'name': _name,
        'email': _email,
        'userId': _userId,
        'imageUrl': _imageUrl,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      prefs.setString('userData', userData);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')!);
    final extractedExpiryDate =
        DateTime.parse(extractedUserData['expiryDate'] as String);
    if (extractedExpiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'] as String;
    _name = extractedUserData['name'] as String;
    _email = extractedUserData['email'] as String;
    _userId = extractedUserData['userId'] as String;
    _imageUrl = extractedUserData['imageUrl'] as String;
    _expiryDate = extractedExpiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
