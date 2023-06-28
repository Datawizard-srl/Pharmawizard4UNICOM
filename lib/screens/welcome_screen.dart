import 'dart:collection';

import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicom_patient/database/locations_repository.dart';
import 'package:unicom_patient/database/user_info_repository.dart';
import 'package:unicom_patient/entities/location.dart';
import 'package:unicom_patient/entities/test_entities/user_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:unicom_patient/themes/dropdowns.dart';
import 'package:unicom_patient/widgets/buttons/primary_button.dart';

import 'homepage_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const route = "/welcome";

  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    String welcomeString =
        AppLocalizations.of(context)!.welcomeScreen_Text; //.i18n();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildWelcomeHeaderPanel(context),
            buildWelcomeBodyPanel(context, welcomeString),
          ],
        ),
      ),
    );
  }

  Widget buildWelcomeHeaderPanel(context) {
    return SizedBox(
      height: 252,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(45.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 165, child: Image.asset('assets/images/logos/pharmawizard.png')),
                    SizedBox(width: 85, child: Image.asset('assets/images/logos/unicom.png')),
                  ],
                ),
              ),
            ),
            Center(
              child: Text(
                AppLocalizations.of(context)!.welcomeScreen_Title,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildWelcomeBodyPanel(BuildContext context, String welcomeString) {
    const Radius borderRadius = Radius.circular(30);

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadiusDirectional.only(
              topStart: borderRadius,
              topEnd: borderRadius,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow,
                offset: Offset.zero,
                spreadRadius: 0,
                blurRadius: 30,
              )
            ]),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    welcomeString,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  Consumer<UserInfo>(
                    builder: (context, userInfo, child) {
                      return BaseDropdown<Location>(
                        dropdownItems: LinkedHashMap.fromIterable(
                            LocationsRepository.availableLocations,
                            key: (location) => location,
                            value: (location) => Text(location.name)
                        ),
                        selected: userInfo.selectedLocation ?? LocationsRepository.getDeviceLocation(),
                        onChanged: (value) => userInfo.selectedLocation = value,
                      );
                    }
                  ),
                  Consumer<UserInfo>(
                      builder: (context, userInfo, child) {
                      return PrimaryButton(
                        onPressed: () async {
                          userInfo.languageSelected = true;
                          userInfo.selectedLocation ??= LocationsRepository.getDeviceLocation();
                          UserInfoRepository.save();
                          Navigator.popAndPushNamed(context, HomepageScreen.route);
                        },
                        child: Text(AppLocalizations.of(context)!.button_Next),
                      );
                    }
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
