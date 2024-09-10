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
  List<Connection> searchConnections = [];
  late Set<String> categoryLetters;
  late Map<String, List<Connection>> connectionsByLetter;

  String? jwtToken;

  Function onFinishedLoading;
  bool finishedLoading = false;

  bool sortByFirstname = false;

  List<String> letters = List.generate(26, (index) => String.fromCharCode(65 + index));

  ConnectionController(this.authController, this.onFinishedLoading) {
    loadConnections();
  }

  void loadConnections() async {
    jwtToken = (await authController.getJwtToken())!;
    int userId = authController.currentUser.id!;

    List<Connection>? cons = await getConnections(jwtToken!, userId);
    if(cons == null) throw Exception("Failed to load user info");

    connections = cons;

    User user = authController.currentUser;
    if(sortByFirstname) {
      connections.sort((a,b) => a.getOtherUser(user).getFullName().compareTo(b.getOtherUser(user).getFullName()) );
    } else {
      connections.sort((a,b) => "${a.getOtherUser(user).lastname!} ${a.getOtherUser(user).firstname}".compareTo("${b.getOtherUser(user).lastname!} ${b.getOtherUser(user).firstname}") );
    }

    categoryLetters = getCategoryLetters();
    connectionsByLetter = getConnectionsByLetter();

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

  Set<String> getCategoryLetters() {
    Set<String> categoryLetters;

    User user = authController.currentUser;
    if(sortByFirstname) {
      categoryLetters = connections.map((c) => c.getOtherUser(user).firstname!.substring(0, 1)).toSet();
    } else {
      categoryLetters = connections.map((c) => c.getOtherUser(user).lastname!.substring(0, 1)).toSet();
    }

    return categoryLetters;
  }

  Map<String, List<Connection>> getConnectionsByLetter() {
    Map<String, List<Connection>> connectionsByLetter = {};

    User user = authController.currentUser;
    for (String letter in categoryLetters) {
      List<Connection> letterConnections;
      if(sortByFirstname) {
        letterConnections = connections.where((c) => c.getOtherUser(user).firstname!.startsWith(letter)).toList();
      } else {
        letterConnections = connections.where((c) => c.getOtherUser(user).lastname!.startsWith(letter)).toList();
      }

      connectionsByLetter[letter] = letterConnections;
    }

    return connectionsByLetter;
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

  int calculateOffsetToLetter(String letter) {
    int categoryHeight = 41 + 16 + 15;
    int connectionHeight = 72;

    int categoriesBefore = categoryLetters.toList().indexOf(letter);

    Connection firstConnectionOfCategory = connectionsByLetter[letter]!.first;
    User user = authController.currentUser;

    int connectionsBefore;
    if(sortByFirstname) {
      connectionsBefore = connections.where((c) => c.getOtherUser(user).getFullName().compareTo(firstConnectionOfCategory.getOtherUser(user).getFullName()) < 0).length;
    } else {
      connectionsBefore = connections.where((c) => "${c.getOtherUser(user).lastname!} ${c.getOtherUser(user).firstname}".compareTo("${firstConnectionOfCategory.getOtherUser(user).lastname!} ${firstConnectionOfCategory.getOtherUser(user).firstname}") < 0).length;
    }

    return categoriesBefore * categoryHeight + connectionsBefore * connectionHeight;
  }

  void filterConnectionsBySearchText(String input) {
    User user = authController.currentUser;

    input = input.toLowerCase(); // To make the search case-insensitive

    // Filter the contacts where the search string matches either the first or last name
    searchConnections = connections.where((c) {
      String fullName = c.getOtherUser(user).getFullName().toLowerCase();
      return fullName.contains(input);
    }).toList();

    // Sort the contacts by how well the full name matches the search string
    searchConnections.sort((a, b) {
      String fullNameA = a.getOtherUser(user).getFullName().toLowerCase();
      String fullNameB = b.getOtherUser(user).getFullName().toLowerCase();

      // Prioritize names that start with the search string
      bool startsWithA = fullNameA.startsWith(input);
      bool startsWithB = fullNameB.startsWith(input);

      if (startsWithA && !startsWithB) {
        return -1;
      } else if (!startsWithA && startsWithB) {
        return 1;
      } else {
        // If both start or neither start with the search string, sort alphabetically
        return fullNameA.compareTo(fullNameB);
      }
    });
  }
}