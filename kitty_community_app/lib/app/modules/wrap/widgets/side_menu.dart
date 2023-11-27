import 'package:flutter/material.dart';
import 'package:kitty_community_app/app/core/values/constants.dart';
import 'package:kitty_community_app/app/modules/wrap/widgets/side_menu_tile.dart';
import 'package:rive/rive.dart';
import 'package:sizer/sizer.dart';

import '../../../core/utils/helpers/rive_utils.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 40.w,
        height: 100.h,
        color: const Color(0xff17203a),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24.0, top: 32, bottom: 16),
                child: Text(
                  'BROWSER',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
                ),
              ),
              ...sideMenus
                  .map((e) => SideMenuTile(
                        menu: e,
                        onInit: (artboard) {
                          // print(e.artboard);
                          StateMachineController artboardController =
                              RiveUtils.getRiveController(artboard,
                                  stateMachineName: e.stateMachineName);
                          e.input = artboardController.findSMI("active") as SMIBool;
                        },
                        onPress: () {},
                        isActive: false,
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
