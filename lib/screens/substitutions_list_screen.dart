import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicom_patient/database/user_info_repository.dart';
import 'package:unicom_patient/screens/medication_details_screen.dart';
import 'package:unicom_patient/settings/flags.dart';
import 'package:unicom_patient/utilities/locale_utils.dart';

import '../entities/test_entities/medication.dart';
import '../entities/test_entities/user_info.dart';
import '../themes/colors.dart';

class SubstitutionsListScreen extends StatefulWidget {
  static String route = "/substitutions";
  const SubstitutionsListScreen({Key? key}) : super(key: key);

  @override
  State<SubstitutionsListScreen> createState() => _SubstitutionsListScreenState();
}

class _SubstitutionsListScreenState extends State<SubstitutionsListScreen> {
  late Medication _medication;
  late List<Medication> _substitutions;

  @override
  void didChangeDependencies() {
    Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (arguments.isEmpty){ return super.didChangeDependencies(); }

    if (arguments['medication'] != null){
      _medication = arguments['medication'] as Medication;
      _substitutions = UserInfoRepository.userInfo.correlated![_medication.id]!;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(LocaleUtils.translate(context).medicationsListScreen_Appbar_Title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            buildHeader(context),
            const SizedBox(height: 40),
            Expanded(child: buildSubstitutionList(context)),
          ],
        ),
      )
    );
  }

  Widget buildSubstitutionList(BuildContext context){
    return Consumer<UserInfo>(builder: (context, userInfo, child) {
      return ListView.separated(
        separatorBuilder: (context, index) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Divider(height: 1, color: dividerColor),
        ),
        itemCount: _substitutions.length,
        itemBuilder: (context, index) {
          Medication medication = _substitutions[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: Image.asset("assets/images/placeholders/generic_drug.png", height: 35, width: 35, fit: BoxFit.fitHeight,),
              trailing: getFlag(medication.country),
              title: Text(
                medication.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => Navigator.pushNamed(context, MedicationDetailsScreen.route, arguments: {
                'medication': _substitutions[index],
                'isRelated': true,
              }),
            ),
          );
        },
      );
    }
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
