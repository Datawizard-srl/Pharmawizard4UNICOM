import 'dart:convert';

import 'package:fhir/r5.dart';
import 'package:unicom_patient/entities/test_entities/medication.dart' as app_medication;
import 'package:http/http.dart' as http;
import 'package:unicom_patient/utilities/locale_utils.dart';

class ResourcesNames {
  static const String medicinalProductDefinition = "MedicinalProductDefinition";
  static const String administrableProductDefinition = "AdministrableProductDefinition";
  static const String ingredient = "Ingredient";
  static const String regulatedAuthorization = "RegulatedAuthorization";
  static const String organization = "Organization";
}

class ApiFhir {
  late final String serverUrl;
  late final String substitutionUrl;

  static ApiFhir instance = ApiFhir();

  static init({required String serverUrl, required String substitutionUrl}){
    instance.serverUrl = serverUrl;
    instance.substitutionUrl = substitutionUrl;
  }

  static Uri getUri(String baseUrl, String endpoint, Map<String, dynamic>? queryParameters){
    List<String> url = baseUrl.split("://");
    String protocol = url[0];
    String serverUrl = url[1];
    if (protocol.toLowerCase() == 'https') {
      return Uri.https(serverUrl, endpoint, queryParameters);
    }
    return Uri.http(serverUrl, endpoint, queryParameters);

  }

  static Future<app_medication.Medication> getMedication(String id) async {
    var headers = {'Content-type': 'application/fhir+json'};

    var response = await http.get(getUri(instance.serverUrl, '/fhir/${ResourcesNames.medicinalProductDefinition}/$id', null), headers: headers);
    var jsonResource = jsonDecode(response.body);
    String? country = jsonResource['name'][0]['usage'][0]['country']['coding'][0]['display'];
    MedicinalProductDefinition medicinalProductDefinition = MedicinalProductDefinition.fromJson(jsonResource);

    response = await http.get(getUri(instance.serverUrl, '/fhir/${ResourcesNames.ingredient}', {'for': id}), headers: headers);
    Bundle ingredientSearchSet = Bundle.fromJson(jsonDecode(response.body));
    Ingredient ingredient = Ingredient.fromJson(ingredientSearchSet.entry![0].resource!.toJson());

    response = await http.get(getUri(instance.serverUrl, '/fhir/${ResourcesNames.administrableProductDefinition}', {'form-of': id}), headers: headers);
    Bundle administrableProductDefinitionSearchSet = Bundle.fromJson(jsonDecode(response.body));
    AdministrableProductDefinition administrableProductDefinition = AdministrableProductDefinition.fromJson(administrableProductDefinitionSearchSet.entry![0].resource!.toJson());

    response = await http.get(getUri(instance.serverUrl, '/fhir/${ResourcesNames.regulatedAuthorization}', {'subject': id}), headers: headers);
    Bundle regulatedAuthorizationSearchSet = Bundle.fromJson(jsonDecode(response.body));
    RegulatedAuthorization regulatedAuthorization = RegulatedAuthorization.fromJson(regulatedAuthorizationSearchSet.entry![0].resource!.toJson());

    response = await http.get(getUri(instance.serverUrl, '/fhir/${regulatedAuthorization.holder!.reference}', null), headers: headers);
    Organization organization = Organization.fromJson(jsonDecode(response.body));

    IngredientStrength ingredientStrength = ingredient.substance.strength![0];
    IngredientReferenceStrength? ingredientReferenceStrength = ingredientStrength.referenceStrength?[0];
    Ratio? ratio = ingredientStrength.concentrationRatio ?? ingredientReferenceStrength?.strengthRatio;

    String referenceStrength = "Unknown";
    if (ratio != null){
      referenceStrength = "${ratio.numerator?.value} ${ratio.numerator?.unit} / ";
      referenceStrength += "${ratio.denominator?.value} ${ratio.denominator?.unit}";
    }

    return app_medication.Medication.fromMap({
      'id': id,
      'mpid': medicinalProductDefinition.identifier?[0].value ?? 'Unknown',
      'name': medicinalProductDefinition.name[0].productName,
      'substanceName': ingredient.substance.code.concept?.coding![0].display ?? 'Unknown',
      'moietyName': '',
      'administrableDoseForm': medicinalProductDefinition.combinedPharmaceuticalDoseForm?.coding?[0].display ?? 'Unknown',
      'productUnitOfPresentation': administrableProductDefinition.unitOfPresentation?.coding?[0].display ?? 'Unknown',
      'routesOfAdministration': administrableProductDefinition.routeOfAdministration[0].code.coding?[0].display ?? 'Unknown',
      'referenceStrength': referenceStrength,
      'marketingAuthorizationHolderLabel': organization.name ?? 'Unknown',
      'country': country ?? 'Unknown',
    });

  }

  static Future<List<app_medication.Medication>> getMedicationsByPrefix(String prefix) async {
    var headers = {'Content-type': 'application/fhir+json'};

    var queryParameters = {'name': prefix};
    Uri uri = getUri(instance.serverUrl, '/fhir/${ResourcesNames.medicinalProductDefinition}', queryParameters);

    var response = await http.get(uri, headers: headers);
    var responseJson = jsonDecode(response.body);
    Bundle medicinalProductDefinitionSearchSet = Bundle.fromJson(responseJson);

    List<app_medication.Medication> ret = [];
    MedicinalProductDefinition mpd;
    for (var element in responseJson['entry']!) {
      if (element['resource'] == null) continue;
      var jsonResource = element['resource'];
      mpd = MedicinalProductDefinition.fromJson(jsonResource);
      String country = jsonResource['name'][0]['usage'][0]['country']['coding'][0]['display'];
      ret.add( app_medication.Medication(
          id: mpd.id!.toString(),
          mpid: mpd.identifier![0].value!,
          name: mpd.name[0].productName!,
          substanceName: '',
          moietyName: '',
          administrableDoseForm: mpd.combinedPharmaceuticalDoseForm!.coding![0].display!,
          productUnitOfPresentation: '',
          routesOfAdministration: '',
          referenceStrength: '',
          marketingAuthorizationHolderLabel: '',
          country: country,
      ));
    }
    return ret;
  }
}

