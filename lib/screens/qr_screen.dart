import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:unicom_patient/entities/test_entities/medication.dart';
import 'package:unicom_patient/screens/qr_scan_screen.dart';
import 'package:unicom_patient/utilities/locale_utils.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:unicom_patient/widgets/buttons/primary_button.dart';

class QrScreen extends StatefulWidget {
  static const String route = '/qr_screen';

  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreen();
}

class _QrScreen extends State<QrScreen> {
  late Medication _medication;

  @override
  void didChangeDependencies() {
    Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (arguments.isEmpty){ return super.didChangeDependencies();}
    if (arguments['medication'] != null) _medication = arguments['medication'] as Medication;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(LocaleUtils.translate(context).medicationDetailsScreen_Appbar_Title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildHeader(context),
            QrImage(
              data: jsonEncode({"medication": _medication.id, "substitution": null}),
              version: QrVersions.auto,
              size: 300,
              backgroundColor: Colors.white,
            ),
            PrimaryButton(
              onPressed: () => Navigator.pushNamed(context, QrScanScreen.route),
              child: Text(
                LocaleUtils.translate(context).qrScreen_Info_Text,
                textAlign: TextAlign.center,
              ),
            )
          ]
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Center(
      child: Column(
          children:[
            Image.asset(
              "assets/images/placeholders/generic_drug.png",
              height: 60,
              width: 60,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                '${LocaleUtils.translate(context).commons_Name}:',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:10),
              child: Text(
                _medication.name,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ]
      ),
    );
  }
}