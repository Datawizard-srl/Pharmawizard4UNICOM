import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicom_patient/database/user_info_repository.dart';
import 'package:unicom_patient/entities/test_entities/medication.dart';
import 'package:unicom_patient/entities/test_entities/user_info.dart';
import 'package:unicom_patient/screens/medication_details_screen.dart';
import 'package:unicom_patient/screens/search_screen.dart';
import 'package:unicom_patient/screens/substitutions_list_screen.dart';
import 'package:unicom_patient/themes/colors.dart';
import 'package:unicom_patient/utilities/locale_utils.dart';
import 'package:unicom_patient/widgets/buttons/primary_button.dart';
import 'dart:math' as math;

class MedicationsListScreen extends StatefulWidget {
  static const String route = '/medications_list';
  const MedicationsListScreen({Key? key}) : super(key: key);

  @override
  State<MedicationsListScreen> createState() => _MedicationsListScreenState();
}

class _MedicationsListScreenState extends State<MedicationsListScreen> {
  List<Medication> medicationsList = UserInfoRepository.userInfo.medicationsList!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(LocaleUtils.translate(context).medicationsListScreen_Appbar_Title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Consumer<UserInfo>(builder: (context, userInfo, child) {
                return Expanded(
                  child: medicationsList.isEmpty
                    ? Center(
                        child: Text(
                          LocaleUtils.translate(context).medicationsListScreen_NoMedicine,
                          style: const TextStyle(fontSize: 20),
                        ),
                      )
                    : ListView.separated(
                        separatorBuilder: (context, index) => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Divider(height: 1, color: dividerColor),
                        ),
                        itemCount: medicationsList.length,
                        itemBuilder: (context, index) {
                          Medication medication = medicationsList[index];
                          List<Medication>? correlated = userInfo.correlated?[medication.id];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              leading: Image.asset("assets/images/placeholders/generic_drug.png", height: 35, width: 35, fit: BoxFit.fitHeight,),
                              trailing: Icon(
                                Icons.chevron_right,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              title: Text(
                                medication.name,
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle:
                                correlated == null || correlated.isEmpty
                                ? null
                                : TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      SubstitutionsListScreen.route,
                                      arguments: {"medication": medication}
                                    );
                                  },
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Transform.rotate(
                                          angle: math.pi/2,
                                          child: Icon(
                                            Icons.pause_circle_outline,
                                            color: Theme.of(context).colorScheme.onSurfaceVariant
                                          ),
                                        ),
                                        Text(
                                          LocaleUtils.translate(context).medicationsListScreen_RelatedDrugs,
                                          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                      ],
                                    )
                                  ),
                                ),
                              onTap: () => Navigator.pushNamed(context, MedicationDetailsScreen.route, arguments: {
                                'medication': medicationsList[index],
                                'alreadyAdded': UserInfoRepository.userInfo.hasMedication(medication),
                              }),
                            ),
                          );
                        },
                      ),
                );
              }
            ),
            PrimaryButton(
              onPressed: (){ Navigator.pushNamed(context, SearchScreen.route); },
              child: Text(LocaleUtils.translate(context).button_AddDrug))
          ],
        ),
      ),
    );
  }
}
