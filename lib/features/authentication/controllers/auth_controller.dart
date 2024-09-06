import 'dart:ui';

import 'package:contact_app/features/authentication/models/user.dart';
import 'package:contact_app/utils/http/http_client.dart';
import 'package:contact_app/utils/logging/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthController {
  final storage = const FlutterSecureStorage();

  late User currentUser;
  bool? isAuthenticated;
  bool? isEmailVerified;

  Function(bool?) onAuthenticationChange;
  Function(bool?) onEmailVerificationChange;

  AuthController(this.onAuthenticationChange, this.onEmailVerificationChange) {
    checkAuthentication();
  }

  void checkAuthentication() async {
    String? jwtToken = await getJwtToken();

    // Not Logged in
    if(jwtToken == null) {
      isAuthenticated = false;
      onAuthenticationChange(isAuthenticated);
      return;
    }

    // Jwt token expired
    if(isTokenExpired(jwtToken)) {
      String? refreshToken = await getRefreshToken();
      if(refreshToken == null) {
        isAuthenticated = false;
        onAuthenticationChange(isAuthenticated);
        return;
      }

      String? newJwtToken = await refreshJwtToken(refreshToken);
      // refreshToken expired
      if(newJwtToken == null) {
        isAuthenticated = false;
        onAuthenticationChange(isAuthenticated);
        return;
      }

      jwtToken = newJwtToken;
    }

    User? user = await getAuthenticatedUser(jwtToken);
    if(user == null) {
      isAuthenticated = false;
      onAuthenticationChange(isAuthenticated);
      return;
    }

    currentUser = user;

    isEmailVerified = user.isEmailVerified;
    onEmailVerificationChange(isEmailVerified);

    isAuthenticated = true;
    onAuthenticationChange(isAuthenticated);
  }

  Future<String?> refreshJwtToken(String refreshToken) async {
    try {
      Map<String, dynamic> data = await HttpHelper.post("refreshToken", { 'token': refreshToken }, null);

      String jwtToken = data['accessToken'];
      await storeJwtToken(jwtToken);

      String newRefreshToken = data['refreshToken'];
      await storeRefreshToken(newRefreshToken);

      return jwtToken;
    } on Exception catch (_) {
      return null;
    }
  }

  Future<User?> getAuthenticatedUser(String jwtToken) async {
    try {
      Map<String, dynamic> data = await HttpHelper.get("users/getAuthenticated", jwtToken);

      User user = User.fromJson(data);

      return user;
    } on Exception catch (_) {
      return null;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      Map<String, dynamic> data = await HttpHelper.post(
          "auth/login",
          { 'email': email,
            'password': password},
          null);

      String jwtToken = data['accessToken'];
      await storeJwtToken(jwtToken);

      String refreshToken = data['refreshToken'];
      await storeRefreshToken(refreshToken);

      Map<String, dynamic> userData = data['userDetails'];
      currentUser = User.fromJson(userData);

      isEmailVerified = currentUser.isEmailVerified;
      onEmailVerificationChange(isEmailVerified);

      isAuthenticated = true;
      onAuthenticationChange(isAuthenticated);

      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<bool> register(String firstname, String lastname, String email, String password) async {
    try {
      Map<String, dynamic> data = await HttpHelper.post(
          "auth/register",
          { 'firstname': firstname,
            'lastname': lastname,
            'email': email,
            'password': password,},
          null);

      String jwtToken = data['accessToken'];
      await storeJwtToken(jwtToken);

      String refreshToken = data['refreshToken'];
      await storeRefreshToken(refreshToken);

      Map<String, dynamic> userData = data['userDetails'];
      currentUser = User.fromJson(userData);

      isEmailVerified = false;
      onEmailVerificationChange(isEmailVerified);

      isAuthenticated = true;
      onAuthenticationChange(isAuthenticated);

      return true;
    } on Exception catch (_) {
      return false;
    }

  }

  Future<void> storeJwtToken(String token) async {
    await storage.write(key: 'jwt_token', value: token);
  }

  Future<String?> getJwtToken() async {
    return await storage.read(key: 'jwt_token');
  }

  Future<void> storeRefreshToken(String token) async {
    await storage.write(key: 'refresh_token', value: token);
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: 'refresh_token');
  }

  Future<void> clearTokens() async {
    await storage.delete(key: 'refreshToken');
    await storage.delete(key: 'jwt_token');
  }

  bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }
}