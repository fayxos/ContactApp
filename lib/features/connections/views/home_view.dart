import 'package:contact_app/common/widgets/appbar.dart';
import 'package:contact_app/common/widgets/list_tiles/connection_tile.dart';
import 'package:contact_app/features/authentication/controllers/auth_controller.dart';
import 'package:contact_app/features/connections/controllers/connection_controller.dart';
import 'package:contact_app/features/connections/widgets/header_search_container.dart';
import 'package:contact_app/features/contact/controllers/contact_controller.dart';
import 'package:contact_app/utils/device/device_utility.dart';
import 'package:contact_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../common/widgets/list_tiles/user_profile_tile.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/logging/logger.dart';
import '../models/connection.dart';

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

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();

    super.dispose();
  }

  final _connectionScrollController = ScrollController();
  final _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  bool showContactView = false;
  bool showSearchView = false;
  bool showSearchField = false;
  bool showLetters = true;

  bool isAnimating = false;

  void _toContactView() {
    if(isAnimating) return;
    if(_searchFocusNode.hasFocus) FocusScope.of(context).unfocus();

    setState(() {
      showLetters = false;
      showSearchView = false;
      showSearchField = false;
      showContactView = true;
      _searchController.text = "";
    });

    isAnimating = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      isAnimating = false;
    });
  }

  void _toSearchView() {

    if(isAnimating) return;
    setState(() {
      showContactView = false;
      showSearchView = true;
    });

    isAnimating = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        showLetters = true;
      });
      isAnimating = false;
    });
  }

  void _toConnectionView() {
    if(isAnimating) return;
    if(_searchFocusNode.hasFocus) FocusScope.of(context).unfocus();

    setState(() {
      showContactView = false;
      showSearchField = false;
      showSearchView = false;
      _searchController.text = "";
    });

    isAnimating = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      if(!showContactView) {
        setState(() {
          showLetters = true;
        });
      }
      isAnimating = false;
    });
  }

  String _detectLetter(Offset position, double boxHeight) {
    List<String> alphabet = connectionController.letters;

    // Get the index of the letter based on the vertical position
    int letterIndex = (position.dy ~/ boxHeight);

    // Ensure the index is within the alphabet bounds
    if (letterIndex >= 0 && letterIndex < alphabet.length) {
       return alphabet[letterIndex];
    }

    return "";
  }

  void _moveToLetter(String letter) {
    if (!connectionController.categoryLetters.contains(letter)) return;

    int offset = connectionController.calculateOffsetToLetter(letter);

    if(offset < _connectionScrollController.position.maxScrollExtent) {
      _connectionScrollController.animateTo(offset + 0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _connectionScrollController.animateTo(_connectionScrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

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
                  height: showContactView ? (HelperFunctions.screenHeight() - 115) : showSearchView ? DeviceUtils.getAppBarHeight() : 135,
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      GestureDetector(
                        onTap: () {
                          _toContactView();
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
                  child: Stack(
                    children: [
                      Container(
                        width: constraints.maxWidth,
                        decoration: BoxDecoration(
                            color: HelperFunctions.isDarkMode(context) ? CustomColors.black : CustomColors.white,
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(Sizes.borderRadiusLg), topRight: Radius.circular(Sizes.borderRadiusLg))
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onPanUpdate: (details) {
                                if(details.delta.direction < 0) {
                                  if(showContactView) {
                                    _toConnectionView();
                                  } else {
                                    _toSearchView();
                                  }
                                } else {
                                  if(showSearchView) {
                                    _toConnectionView();
                                  } else {
                                    _toContactView();
                                  }
                                }
                              },
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: HelperFunctions.screenWidth(),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                                      child: Center(
                                        child: Container(
                                            height: 3,
                                            width: 50,
                                            color: HelperFunctions.isDarkMode(context) ? CustomColors.darkerGrey : CustomColors.grey,
                                          ),
                                      ),
                                    ),
                                  ),

                                  // Search
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Sizes.defaultSpace),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: showSearchField ? TextFormField(
                                            focusNode: _searchFocusNode,
                                            controller: _searchController,
                                            onChanged: (input) {
                                              connectionController.filterConnectionsBySearchText(input);
                                              setState(() { });
                                            },
                                            decoration: InputDecoration(
                                                prefixIcon: const Icon(Iconsax.search_normal),
                                                suffixIcon: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        showSearchField = false;
                                                      });
                                                    },
                                                    child: const Icon(Icons.close, color: CustomColors.white)),
                                                hintText: 'Search Contacts'),
                                          ) : SearchContainer(
                                            padding: EdgeInsets.zero,
                                            text: 'Search Contacts',
                                            onTap: () {
                                              _toSearchView();
                                              setState(() {
                                                showSearchField = true;
                                              });

                                              Future.delayed(const Duration(milliseconds: 100), () {
                                                if(context.mounted) FocusScope.of(context).requestFocus(_searchFocusNode);
                                              });
                                            }),
                                        ),

                                        if(showSearchView)
                                          IconButton(onPressed: () {
                                            _toConnectionView();
                                          }, icon: const Icon(Icons.arrow_downward, color: CustomColors.white)),

                                        if(showContactView)
                                          IconButton(onPressed: () {
                                            _toConnectionView();
                                          }, icon: const Icon(Icons.arrow_upward, color: CustomColors.white))
                                      ],
                                    ) ,
                                  )
                                ],
                              ),
                            ),

                            // Filter

                            // Kontakte
                            Expanded(
                              child: connectionController.finishedLoading ? Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: _searchController.text.isEmpty ? ListView.builder(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                    shrinkWrap: true,
                                    controller: _connectionScrollController,
                                    itemCount: connectionController.categoryLetters.length,
                                    itemBuilder: (BuildContext context, int index1) {
                                      return Column(
                                        children: [
                                          // Letter Header
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 15.0, top: 5, bottom: 5),
                                                child: Text(connectionController.categoryLetters.elementAt(index1), style: Theme.of(context).textTheme.headlineMedium!),
                                              ),
                                              const Spacer()
                                            ],
                                          ),

                                          const Padding(
                                            padding: EdgeInsets.only(left: 15),
                                            child: Divider(),
                                          ),

                                          ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              padding: EdgeInsets.zero,
                                              itemCount: connectionController.connectionsByLetter[connectionController.categoryLetters.elementAt(index1)]!.length,
                                              itemBuilder: (BuildContext context, int index2) {
                                                Connection connection = connectionController.connectionsByLetter[connectionController.categoryLetters.elementAt(index1)]![index2];

                                                return Column(
                                                  children: [
                                                    ConnectionTile(user: connection.getOtherUser(widget.authController.currentUser), imageUrl: connectionController.getProfileImageUrl(connection), jwtToken: connectionController.jwtToken, onPressed: () {}),

                                                    const Padding(
                                                      padding: EdgeInsets.only(left: 15),
                                                      child: Divider(),
                                                    ),
                                                  ],
                                                );
                                              }
                                          ),

                                          const SizedBox(height: 15,)
                                        ],
                                      );
                                    }
                                ) : ListView.builder(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: connectionController.searchConnections.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    Connection connection = connectionController.searchConnections[index];

                                    return Column(
                                      children: [
                                        ConnectionTile(user: connection.getOtherUser(widget.authController.currentUser), imageUrl: connectionController.getProfileImageUrl(connection), jwtToken: connectionController.jwtToken, onPressed: () {}),

                                        const Padding(
                                          padding: EdgeInsets.only(left: 15),
                                          child: Divider(),
                                        ),
                                      ],
                                    );
                                  }
                                ),
                              ) : const SizedBox()
                            )
                          ],
                        )
                      ),

                      if(showLetters)
                        Row(
                          children: [
                            const Spacer(),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onPanUpdate: (details) {
                                    String letter = _detectLetter(details.localPosition, 15);
                                    if(letter.isNotEmpty) _moveToLetter(letter);
                                  },
                                  onTapDown: (details) {
                                    String letter = _detectLetter(details.localPosition, 15);
                                    if(letter.isNotEmpty) _moveToLetter(letter);
                                  },
                                  child: Column(
                                    children: [
                                      for(String letter in connectionController.letters)
                                        GestureDetector(
                                            child: SizedBox(
                                              width: 15,
                                              height: 15,
                                              child: Text(letter, style: Theme.of(context).textTheme.labelSmall!),
                                            )
                                        )
                                    ],
                                  ),
                                )

                              ],
                            )
                          ],
                        )
                    ],
                  ),
                )
              ],
            );
          }
      ),
    );
  }
}

