import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:unicom_patient/database/locations_repository.dart';
import 'package:unicom_patient/database/user_info_repository.dart';
import 'package:unicom_patient/entities/location.dart';
import 'package:unicom_patient/entities/test_entities/user_info.dart';
import 'package:unicom_patient/themes/colors.dart';
import 'package:unicom_patient/themes/dropdowns.dart';


class SettingsScreen extends StatelessWidget {
  static const String route = "/settings";

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 30;
    const double verticalPadding = 22;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        leading: Center(
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              UserInfoRepository.save();
              Navigator.pop(context);
            },
          )
        ),
        title: Text(AppLocalizations.of(context)!.settingsScreen_Appbar_Title),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Consumer<UserInfo>(
          builder: (context, userPreferences, child) {
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: verticalPadding),
                  child: Divider(height: 1, color: dividerColor),
                ),

                buildSelectLanguage(context, userPreferences, horizontalPadding),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: verticalPadding),
                  child: Divider(height: 1, color: dividerColor),
                ),

                buildSelectDarkMode(context, userPreferences, horizontalPadding),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: verticalPadding),
                  child: Divider(height: 1, color: dividerColor),
                ),

                buildSelectFontSize(context, userPreferences, horizontalPadding),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: verticalPadding),
                  child: Divider(height: 1, color: dividerColor),
                ),
              ],
            );
          }
        ),
      ),
    );
  }

  Widget buildSelectDarkMode(BuildContext context, UserInfo userPreferences, double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppLocalizations.of(context)!.settingsScreen_Label_DarkMode),
          Switch(
            value: userPreferences.darkMode,
            onChanged: (value) => userPreferences.darkMode = value,
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget buildSelectLanguage(BuildContext context, UserInfo userInfo, double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: BaseDropdown<Location>(
        dropdownItems: LinkedHashMap.fromIterable(
            LocationsRepository.availableLocations,
            key: (e) => e,
            value: (e) => Text(e.name)
        ),
        selected: userInfo.selectedLocation,
        onChanged: (value) { userInfo.selectedLocation = value;},
      ),
    );
  }

  Widget buildSelectFontSize(BuildContext context, UserInfo userInfo, double horizontalPadding){
    const double baseFontSize = 28;
    const double dividerTickness = 2;

    ButtonStyle textButtonStyle = TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.center
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                style: textButtonStyle,
                onPressed: (){ userInfo.fontSize = -1; },
                child: const Text("A", style: TextStyle(fontSize: baseFontSize - 10))
              ),
              TextButton(
                style: textButtonStyle,
                  onPressed: (){ userInfo.fontSize = 0; },
                child: const Text("A", style: TextStyle(fontSize: baseFontSize))
              ),
              TextButton(
                style: textButtonStyle,
                onPressed: (){ userInfo.fontSize = 1; },
                child: const Text("A", style: TextStyle(fontSize: baseFontSize + 10))
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 16),
            child: Stack(
              children: [
                const Positioned.fill(child: Divider(color: Colors.grey, thickness: dividerTickness,)),
                SizedBox(
                  height: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      VerticalDivider(
                        width: 0,
                        thickness: dividerTickness,
                        indent: 0,
                        endIndent: 0,
                        color: Colors.grey,
                      ),
                      VerticalDivider(
                        width: 0,
                        thickness: dividerTickness,
                        indent: 0,
                        endIndent: 0,
                        color: Colors.grey,
                      ),
                      VerticalDivider(
                        width: 0,
                        thickness: dividerTickness,
                        indent: 0,
                        endIndent: 0,
                        color: Colors.grey,
                      ),
                    ]
                  ),
                ),
              ]
            ),
          ),
        ],
      )
    );
  }
}
