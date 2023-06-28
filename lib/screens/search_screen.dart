import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:unicom_patient/database/user_info_repository.dart';
import 'package:unicom_patient/entities/test_entities/medication.dart';
import 'package:unicom_patient/screens/medication_details_screen.dart';
import 'package:unicom_patient/themes/colors.dart';
import 'package:unicom_patient/utilities/fhir_utils.dart';
import 'package:unicom_patient/utilities/locale_utils.dart';

class SearchScreen extends StatefulWidget {
  static const String route = '/search';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Timer? _timer;
  List<Medication> suggestions = [];
  String searchInput = '';
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: searchInput);
    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
    super.initState();
  }
  @override
  void dispose() {
    if(_timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder inputBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(width: 2, color: Theme.of(context).colorScheme.outline),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(LocaleUtils.translate(context).searchScreen_Appbar_Title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                LocaleUtils.translate(context).searchScreen_Description,
                textAlign: TextAlign.center,
              ),
            ),
            TextField(
              controller: controller,
              onChanged: (value) {
                searchInput = value;
                if(_timer != null && _timer!.isActive) { return; }
                else {
                  _timer = Timer(const Duration(seconds: 1), () {
                      ApiFhir.getMedicationsByPrefix(searchInput).then(
                      //MedicationsRepository.getSuggest(searchInput).then(
                        (value) {
                          if (searchInput == '') return [];
                          setState((){ suggestions = value; });
                        }
                      );
                  });
                }
              },
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.search),
                enabledBorder: inputBorder,
                focusedBorder: inputBorder,
                hintText: LocaleUtils.translate(context).searchScreen_InputPlaceholder,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
            ),
            ...buildResultsList(context),
          ],
        ),
      ),
    );
  }

  List<Widget> buildResultsList(BuildContext context) {
    if(suggestions.isEmpty) {
      return [
        //Expanded(child: Center(child: Text("No match found")))
      ];

    } else {
      return <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Html(
              data: LocaleUtils.translate(context).searchScreen_ResultsFound(suggestions.length),
              style: {"body": Style(fontSize: FontSize.medium)}
            )
          ),
        ),

        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(height: 1, color: dividerColor),
            ),
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              Medication medication = suggestions[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Image.asset("assets/images/placeholders/generic_drug.png", height: 35, width: 35, fit: BoxFit.fitHeight,),
                title: Text(
                  medication.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                onTap: () async {
                  await ApiFhir.getMedication(medication.id).then(
                      (thisMedication) => Navigator.of(context).pushNamed(
                          MedicationDetailsScreen.route,
                          arguments: {
                            'medication': thisMedication,
                            'alreadyAdded': UserInfoRepository.userInfo.hasMedication(medication),
                          }
                      )
                  );

                }
              );
            },
          ),
        ),
      ];
    }
  }
}
