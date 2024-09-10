import 'package:contact_app/common/widgets/appbar.dart';
import 'package:contact_app/common/widgets/list_tiles/connection_tile.dart';
import 'package:contact_app/features/authentication/controllers/auth_controller.dart';
import 'package:contact_app/features/connections/controllers/connection_controller.dart';
import 'package:contact_app/features/connections/widgets/header_search_container.dart';
import 'package:contact_app/features/contact/controllers/contact_controller.dart';
import 'package:contact_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../common/widgets/list_tiles/user_profile_tile.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/logging/logger.dart';

class HomeView extends StatefulWidget {
  final AuthController authController;

  HomeView({super.key, required this.authController});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final ConnectionController connectionController;
  late final ContactController contactController;

  @override
  void initState() {
    super.initState();

    connectionController = ConnectionController(widget.authController, () => setState(() { }));
    contactController = ContactController(widget.authController, () => setState(() { }));
  }

  double _topWidth = 135;
  String _seatchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primary,
      body: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  height: _topWidth,
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _topWidth = constraints.maxHeight - 100;
                          });
                        },
                        child: UserProfileTile(
                            user: widget.authController.currentUser,
                            imageUrl: contactController.getProfileImageUrl(),
                            jwtToken: contactController.jwtToken,
                            trailingWidget: IconButton(onPressed: () {}, icon: const Icon(Iconsax.setting, color: CustomColors.white)),
                            onPressed: () {}),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        setState(() {
                          _topWidth = 135;
                        }),
                    child: Container(
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                          color: HelperFunctions.isDarkMode(context) ? CustomColors.black : CustomColors.white,
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(Sizes.borderRadiusLg), topRight: Radius.circular(Sizes.borderRadiusLg))
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Container(
                                height: 3,
                                width: 50,
                                color: HelperFunctions.isDarkMode(context) ? CustomColors.darkerGrey : CustomColors.grey,
                              ),
                          ),

                          // Search
                          const SearchContainer(
                              text: 'Search Contacts',
                          ),

                          // Filter

                          // Kontakte
                          Expanded(
                            child: connectionController.finishedLoading ? ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                shrinkWrap: true,
                                itemCount: connectionController.connections.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ConnectionTile(user: connectionController.getUserAtIndex(index), imageUrl: connectionController.getProfileImageUrl(connectionController.connections[index]), jwtToken: connectionController.jwtToken, onPressed: () {});
                                }
                            ) : const Text("Loading")
                          )
                        ],
                      )
                    ),
                  ),
                )
              ],
            );
          }
      ),
    );
  }
}

