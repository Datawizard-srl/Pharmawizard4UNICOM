import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:unicom_patient/app_icons_icons.dart';
import 'package:unicom_patient/screens/medications_list_screen.dart';
import 'package:unicom_patient/screens/qr_scan_screen.dart';
import 'package:unicom_patient/screens/settings_screen.dart';


class HomepageScreen extends StatelessWidget {
  static const String route = '/home';
  const HomepageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context),
      backgroundColor: Theme.of(context).colorScheme.background,

      body: Container(
        decoration: buildBackgroundImage(),
        child: Column(
          children: [
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    children: [
                      buildButtonsRow(
                        context,
                        button1: HomepageButton(
                          icon: const Icon(Icons.access_alarms_sharp, size: 65),
                          onPressed: () {
                            Navigator.pushNamed(context, MedicationsListScreen.route);
                          },
                          child: Text(
                              AppLocalizations.of(context)!.homepageScreen_Button_Medication,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700
                              )
                          ),
                        ),

                        button2: HomepageButton(
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          icon: const Icon(AppIcons.qrcode, size: 65),
                          onPressed: () => Navigator.pushNamed(context, QrScanScreen.route),
                          child: Text(
                              AppLocalizations.of(context)!.homepageScreen_Button_QrCode,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700
                              )
                          ),
                        ),
                      ),
                      // buildButtonsRow(
                      //   context,
                      //   button1: HomepageButton(
                      //     backgroundColor: Colors.pinkAccent[100],
                      //     onPressed: () => Navigator.pushNamed(context, SettingsScreen.route),
                      //   ),
                      //   button2: HomepageButton(
                      //     backgroundColor: Colors.cyan,
                      //     onPressed: () => Navigator.pushNamed(context, SettingsScreen.route),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildButtonsRow(BuildContext context, {required Widget button1, required Widget button2} ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        button1,
        button2
      ],
    );
  }

  BoxDecoration buildBackgroundImage() {
    return const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/backgrounds/home_page.png",),
          opacity: 0.3,
          fit: BoxFit.fill,
        ),
      );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    Color transparent = const Color.fromRGBO(0, 0, 0, 0);

    return AppBar(
      toolbarHeight: 100,
      title: const Image(image: AssetImage("assets/images/logos/unicom.png")),
      backgroundColor: transparent,
      shadowColor: transparent,
      centerTitle: true,
      actions: <Widget>[
        Container(
          padding: const EdgeInsets.only(right: 50),
          child: IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.pushNamed(context, SettingsScreen.route);
            },
          ),
        )
      ],
    );
  }
}


class HomepageButton extends StatelessWidget {
  final Widget? child;
  final Icon? icon;
  final Color? backgroundColor;
  final VoidCallback onPressed;

  const HomepageButton({
    super.key,
    required this.onPressed,
    this.child,
    this.icon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    double dimension = 150;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        height: dimension,
        width: dimension,
        child: ElevatedButton(
          onPressed: onPressed,

          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
            shape: const CircleBorder(),
          ),

          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: icon,
                ),
                child ?? const Text(""),
              ],
            ),
          ),
        )
      ),
    );
  }
}

