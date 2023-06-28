import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:unicom_patient/database/user_info_repository.dart';
import 'package:unicom_patient/entities/test_entities/medication.dart';
import 'package:unicom_patient/screens/medications_list_screen.dart';
import 'package:unicom_patient/screens/qr_screen.dart';
import 'package:unicom_patient/screens/substitutions_list_screen.dart';
import 'package:unicom_patient/utilities/locale_utils.dart';
import 'package:unicom_patient/widgets/buttons/primary_button.dart';


class MedicationDetailsScreen extends StatefulWidget {
  static const String route = '/medication_details';

  const MedicationDetailsScreen({super.key});

  @override
  State<MedicationDetailsScreen> createState() => _MedicationDetailsScreenState();
}

class _MedicationDetailsScreenState extends State<MedicationDetailsScreen> {
  late Medication _medication;
  late bool _alreadyAdded;
  late bool _isRelated;

  @override
  void didChangeDependencies() {
    Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (arguments.isEmpty){ return super.didChangeDependencies();}

    if (arguments['medication'] != null){
      _medication = arguments['medication'] as Medication;
    }
    if (arguments['alreadyAdded'] != null) {_alreadyAdded = arguments['alreadyAdded'];}
    else{_alreadyAdded = UserInfoRepository.userInfo.hasMedication(_medication);}

    _isRelated = false;
    if (arguments['isRelated'] != null) {_isRelated = arguments['isRelated'];}

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _isRelated
          ? LocaleUtils.translate(context).substitutionListScreen_Appbar_Title
          : LocaleUtils.translate(context).medicationDetailsScreen_Appbar_Title
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ListView(
                  children: [
                    buildHeader(context),
                    ...buildInformations(context),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                      child: Divider(height: 2, color: Theme.of(context).colorScheme.primary, ),
                    ),
                    ...buildSpecificInformations(context),
                  ],
                ),
              ),
            ),
            ...buildButtons(context),
          ],
        ),
      ),
    );
  }

  List<Widget> buildButtons(BuildContext context){
    if (!_isRelated){
      return [
        Column(
          verticalDirection: VerticalDirection.down,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _alreadyAdded
                ? buildGenerateQRAndRelatedButton(context)
                : buildAddDrugButton(context)
          ],
        )
      ];
    } else {
      return [];
    }
  }

  Widget buildGenerateQRAndRelatedButton(BuildContext context){
    List<Widget> buttons = [];
    if(UserInfoRepository.userInfo.correlated?[_medication.id] != null) {
      buttons.add(
        PrimaryButton(
          onPressed: () {
            Navigator.pushNamed(
                context,
                SubstitutionsListScreen.route,
                arguments: {"medication": _medication}
            );
          },
          backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
          child: Text(
              LocaleUtils.translate(context).medicationsListScreen_RelatedDrugs.toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.w600,
              )
          ),
        ),
      );
      buttons.add(const SizedBox(height: 10));
    }

    buttons.add(
      PrimaryButton(
        onPressed: () {
          Navigator.pushNamed(context, QrScreen.route, arguments: {'medication': _medication});
        },
        child: Text(LocaleUtils.translate(context).medicationsListScreen_GenerateQR),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: buttons,
    );
  }

  Widget buildAddDrugButton(BuildContext context) {
    return PrimaryButton(
      onPressed: (){
        UserInfoRepository.addMedications([_medication]);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: SizedBox(
                height: 300,
                child: AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.clear, color: Theme.of(context).colorScheme.onSurface),
                        )
                      ),
                    ],),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Center(child: PrimaryButton(
                        onPressed: (){ Navigator.popUntil(context, ModalRoute.withName(MedicationsListScreen.route)); },
                        child: Text(
                          LocaleUtils.translate(context).medicationDetailsScreen_Modal_Button_GoToList
                        ),
                      )),
                    )
                  ],
                  content: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 50),
                      child: Center(
                        child: Text(
                          LocaleUtils.translate(context).medicationDetailsScreen_Modal_DrugAdded_Text,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600
                          ),
                        )
                      ),
                    )
                  ),
                ),
              ),
            );
          }
        );
      },
      child: Text(LocaleUtils.translate(context).medicationDetailsScreen_Button_AddToList),
    );
  }
  
  Widget infoRow(String label, String text){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(

        children: [
          Text(
            "$label: ",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Flexible(
            child: Text(
              text.toUpperCase(),
              overflow: TextOverflow.visible,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
  List<Widget> buildInformations(BuildContext context) {
    return [
      Align(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            infoRow(LocaleUtils.translate(context).commons_Informations, ""),
            infoRow(LocaleUtils.translate(context).commons_Name, _medication.name),
            infoRow(LocaleUtils.translate(context).commons_SubstanceName, _medication.substanceName),
            infoRow(LocaleUtils.translate(context).commons_MoietyName, _medication.moietyName),
          ]
        ),
      )
    ];
  }

  Widget specificInfoRow(String label, String text){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.visible,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildSpecificInformations(BuildContext context) {
    return [
      Align(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            specificInfoRow(LocaleUtils.translate(context).commons_AdministrableDoseForm, _medication.administrableDoseForm),
            specificInfoRow(LocaleUtils.translate(context).commons_ProductUnitOfPresentation, _medication.productUnitOfPresentation),
            specificInfoRow(LocaleUtils.translate(context).commons_RoutesOfAdministration, _medication.routesOfAdministration),
            specificInfoRow(LocaleUtils.translate(context).commons_ReferenceStrength, _medication.referenceStrength),
            specificInfoRow(LocaleUtils.translate(context).commons_MarketingAuthorizationHolderLabel, _medication.marketingAuthorizationHolderLabel),
            specificInfoRow(LocaleUtils.translate(context).commons_Country, _medication.country),
          ]
        ),
      )
    ];
  }

  Widget buildHeader(BuildContext context) {
    return Center(
      child: Column(
          children:[
          Image.asset(
            "images/placeholders/generic_drug.png",
            height: 60,
            width: 60,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              '${LocaleUtils.translate(context).commons_Name}:',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:10, bottom: 35),
            child: Text(
              _medication.name,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          )
        ]
      ),
    );
  }
}