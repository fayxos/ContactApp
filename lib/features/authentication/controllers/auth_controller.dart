
import 'package:contact_app/features/authentication/models/user.dart';
import 'package:contact_app/features/authentication/views/verify_email.dart';
import 'package:contact_app/features/connections/views/home_view.dart';
import 'package:contact_app/utils/http/http_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


import '../../../utils/logging/logger.dart';
import '../views/login.dart';

class AuthController {
  final storage = const FlutterSecureStorage();

  late User currentUser;
  bool? isAuthenticated;
  bool? isEmailVerified;

  AuthController() {
    checkAuthentication();
  }

  void goToView() {
    if(isAuthenticated == null) return;

    if(!isAuthenticated!) {
      Get.offAll(() => LoginView(authController: this));
    } else if(isEmailVerified == null || !isEmailVerified!) {
      Get.offAll(() => VerifyEmailView(authController: this));
    } else {
      Get.offAll(() => const HomeView());
    }
  }

  void checkAuthentication() async {
    String? jwtToken = await getJwtToken();

    // Not Logged in
    if(jwtToken == null) {
      isAuthenticated = false;
      return;
    }

    // Jwt token expired
    if(isTokenExpired(jwtToken)) {
      String? refreshToken = await getRefreshToken();
      if(refreshToken == null) {
        isAuthenticated = false;
        return;
      }

      String? newJwtToken = await refreshJwtToken(refreshToken);
      // refreshToken expired
      if(newJwtToken == null) {
        isAuthenticated = false;
        return;
      }

      jwtToken = newJwtToken;
    }

    User? user = await getAuthenticatedUser(jwtToken);
    if(user == null) {
      isAuthenticated = false;
      return;
    }

    currentUser = user;

    isEmailVerified = user.emailVerified;
    isAuthenticated = true;
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

      isAuthenticated = true;
      isEmailVerified = currentUser.emailVerified;
      if(isEmailVerified == null || !isEmailVerified!) {
        Get.offAll(() => VerifyEmailView(authController: this,));
        return true;
      }

      Get.offAll(() => const HomeView());

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

      isAuthenticated = true;
      isEmailVerified = false;
      Get.offAll(() => VerifyEmailView(authController: this,));
      return true;
    } on Exception catch (_) {
      return false;
    }

  }

  Future<void> logout() async {
    try {
      int userId = currentUser.id!;
      String jwtToken = (await getJwtToken())!;

      Map<String, dynamic> data = await HttpHelper.post(
          "users/$userId/logout",
          {},
          jwtToken);
    } on Exception catch (_) { }

    clearTokens();
    isAuthenticated = false;
    isEmailVerified = false;

    Get.offAll(() => LoginView(authController: this,));
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