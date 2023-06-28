import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicom_patient/database/locations_repository.dart';
import 'package:unicom_patient/database/user_info_repository.dart';
import 'package:unicom_patient/entities/test_entities/user_info.dart';
import 'package:unicom_patient/screens/drug_scanned.dart';

import 'package:unicom_patient/screens/homepage_screen.dart';
import 'package:unicom_patient/screens/medications_list_screen.dart';
import 'package:unicom_patient/screens/qr_scan_screen.dart';
import 'package:unicom_patient/screens/qr_screen.dart';
import 'package:unicom_patient/screens/search_screen.dart';
import 'package:unicom_patient/screens/settings_screen.dart';
import 'package:unicom_patient/screens/medication_details_screen.dart';
import 'package:unicom_patient/screens/substitutions_list_screen.dart';
import 'package:unicom_patient/screens/welcome_screen.dart';
import 'package:unicom_patient/settings/locale.dart';
import 'package:unicom_patient/themes/theme.dart';
import 'package:unicom_patient/themes/typography.dart';
import 'package:unicom_patient/utilities/fhir_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocationsRepository.init();
  await UserInfoRepository.fetch();

  ApiFhir.init(serverUrl: "https://jpa.unicom.datawizard.it", substitutionUrl: '');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // @override
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserInfoRepository.userInfo,
      child: Consumer<UserInfo>(builder: (context, userInfo, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Unicom Patient',
          // themes
          theme: getTheme(darkTheme: false, fontSize: userInfo.fontSize),
          darkTheme: getTheme(darkTheme: true, fontSize: userInfo.fontSize),
          themeMode: userInfo.darkMode ? ThemeMode.dark : ThemeMode.light,

          // locales
          supportedLocales: supportedLocales,
          locale: userInfo.locale,
          localizationsDelegates: localizationsDelegate,

          localeResolutionCallback: (locale, supportedLocales) {
            return supportedLocales.contains(locale)
                ? locale
                : defaultLocale;
          },

          // routes
          home: userInfo.languageSelected
              ? const HomepageScreen()
              : const WelcomeScreen(),


          routes: {
            WelcomeScreen.route: (context) => const WelcomeScreen(),
            HomepageScreen.route: (context) => const HomepageScreen(),
            SettingsScreen.route: (context) => const SettingsScreen(),
            QrScanScreen.route: (context) => const QrScanScreen(),
            MedicationsListScreen.route: (context) => const MedicationsListScreen(),
            SearchScreen.route: (context) => const SearchScreen(),
            MedicationDetailsScreen.route: (context) => const MedicationDetailsScreen(),
            QrScreen.route: (context) => const QrScreen(),
            SubstitutionsListScreen.route: (context) => const SubstitutionsListScreen(),
            DrugScannedScreen.route: (context) => const DrugScannedScreen(),
          },
        );
      }),
    );
  }
}
