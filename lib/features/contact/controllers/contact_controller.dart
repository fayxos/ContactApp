import 'package:contact_app/features/authentication/controllers/auth_controller.dart';
import 'package:contact_app/features/contact/models/contact_info.dart';
import 'package:contact_app/utils/constants/api_constants.dart';

import '../../../utils/http/http_client.dart';

class ContactController {
  AuthController authController;
  late ContactInfo userInfo;

  String? jwtToken;

  Function onFinishedLoading;
  bool finishedLoading = false;

  ContactController(this.authController, this.onFinishedLoading) {
    loadUserInfo();
  }

  void loadUserInfo() async {
    jwtToken = (await authController.getJwtToken())!;
    int userId = authController.currentUser.id!;

    ContactInfo? info = await getContactInfo(jwtToken!, userId);
    if(info == null) throw Exception("Failed to load user info");

    userInfo = info;

    finishedLoading = true;
    onFinishedLoading();
  }

  String? getProfileImageUrl() {
    if(!finishedLoading) return null;

    int? userId = userInfo.user!.id;
    String imageName = userInfo.imageUrls!.values.first[1];

    String url = "$apiBaseUrl/users/$userId/images/$imageName";

    return url;
  }

  Future<ContactInfo?> getContactInfo(String jwtToken, int userId) async {
    try {
      Map<String, dynamic> data = await HttpHelper.get("users/$userId/info", jwtToken);

      ContactInfo info = ContactInfo.fromJson(data);

      return info;
    } on Exception catch (_) {
      return null;
    }
  }
}