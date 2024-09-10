import 'dart:convert';

import 'package:contact_app/utils/logging/logger.dart';

import '../../../utils/constants/api_constants.dart';
import '../../../utils/http/http_client.dart';
import '../../authentication/controllers/auth_controller.dart';
import '../../authentication/models/user.dart';
import '../models/connection.dart';
import 'package:http/http.dart' as http;

class ConnectionController {
  AuthController authController;

  late List<Connection> connections;

  String? jwtToken;

  Function onFinishedLoading;
  bool finishedLoading = false;

  ConnectionController(this.authController, this.onFinishedLoading) {
    loadConnections();
  }

  void loadConnections() async {
    jwtToken = (await authController.getJwtToken())!;
    int userId = authController.currentUser.id!;

    List<Connection>? cons = await getConnections(jwtToken!, userId);
    if(cons == null) throw Exception("Failed to load user info");

    connections = cons;

    finishedLoading = true;

    onFinishedLoading();
  }

  String? getProfileImageUrl(Connection connection) {
    if(!finishedLoading) return null;

    int? userId = authController.currentUser.id;
    int connectionId = connection.id!;
    String url = "$apiBaseUrl/users/$userId/$connectionId/image";

    return url;
  }

  User getUserAtIndex(int index) {
    return connections[index].getOtherUser(authController.currentUser);
  }

  List<Connection> connectionListFromJson(String str) {
    final data = json.decode(str);
    return List<Connection>.from(data.map((x) {
      return Connection.fromJson(x);
    }));
  }

  Future<List<Connection>?> getConnections(String jwtToken, int userId) async {
    try {
      final response = await http.get(
            Uri.parse('$apiBaseUrl/users/$userId/connections'),
            headers: {'Authorization': 'Bearer $jwtToken'}
        );

      if(response.statusCode == 200) {
        List<Connection> cons = connectionListFromJson(const Utf8Decoder().convert(response.bodyBytes));

        return cons;

      } else {
        return null;
      }

    } on Exception catch (_) {
      LoggerHelper.info("error");
      return null;
    }
  }
}