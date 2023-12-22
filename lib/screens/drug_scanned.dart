import 'package:flutter/material.dart';
import 'package:unicom_patient/database/user_info_repository.dart';
import 'package:unicom_patient/screens/medications_list_screen.dart';
import 'package:unicom_patient/utilities/locale_utils.dart';
import 'package:unicom_patient/widgets/buttons/primary_button.dart';

import '../entities/test_entities/medication.dart';

class DrugScannedScreen extends StatefulWidget {
  static String route = "/drug_scanned";
  const DrugScannedScreen({Key? key}) : super(key: key);

  @override
  State<DrugScannedScreen> createState() => _DrugScannedScreenState();
}

class _DrugScannedScreenState extends State<DrugScannedScreen> {
  late Medication _medication;
  late Medication _substitution;

  @override
  void didChangeDependencies() {
    Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (arguments.isEmpty){ return super.didChangeDependencies(); }

    if (arguments['medication'] != null){ _medication = arguments['medication'] as Medication; }
    if (arguments['substitution'] != null){ _substitution = arguments['substitution'] as Medication; }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleUtils.translate(context).drugScannedScreen_Appbar_Title),
        centerTitle: true
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildHeader(context),
            buildSubstitutionInfo(context),
            buildAddToListButton(context),
            // button on tap UserInfoRepository.addCorrelated(data['medication'], [substitution])
          ],
        ),
      ),
    );
  }

  Widget buildAddToListButton(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryButton(
          onPressed: (){
            UserInfoRepository.addCorrelated(_medication.id, [_substitution]).then((value) {
              Navigator.pushNamed(context, MedicationsListScreen.route);
            });
          },
          child: Text(
              LocaleUtils.translate(context).drugScannedScreen_Button_AddToList,
              style: const TextStyle(fontWeight: FontWeight.w600)
          ),
        ),
      ],
    );
  }
  Widget buildSubstitutionInfo(BuildContext context){
      return Container(
        constraints: BoxConstraints(
            minHeight: 220,
            minWidth: MediaQuery.of(context).size.width - 30*2,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.onSurfaceVariant, width: 3),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Expanded(
           child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 45.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("assets/images/placeholders/generic_drug.png", height: 60, width: 60, fit: BoxFit.fitHeight),
              Text(
                "${LocaleUtils.translate(context).commons_Name}: ",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                _substitution.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          ),
        ),
      );
  }

  Widget buildHeader(BuildContext context){
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Icon(
            Icons.check_circle_rounded,
            color: Colors.lightGreen,
            size: 60
          ),
          const SizedBox(height: 40),
          Text(
            LocaleUtils.translate(context).drugScannedScreen_Header_Text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600
            ),
          ),
        ],
      ),
    );
  }
}
