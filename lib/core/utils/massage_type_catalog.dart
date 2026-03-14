import 'package:agenda/app_localizations.dart';

class MassageTypeCatalog {
  static const String relaxante = 'relaxante';
  static const String drenagemLinfatica = 'drenagem_linfatica';
  static const String terapeutica = 'terapeutica';
  static const String desportiva = 'desportiva';
  static const String pedrasQuentes = 'pedras_quentes';

  static const List<String> defaultIds = <String>[
    relaxante,
    drenagemLinfatica,
    terapeutica,
    desportiva,
    pedrasQuentes,
  ];

  static const Map<String, String> _legacyNameToId = <String, String>{
    'relaxante': relaxante,
    'massagem relaxante': relaxante,
    'relaxing massage': relaxante,

    'drenagem linfatica': drenagemLinfatica,
    'drenagem linfática': drenagemLinfatica,
    'massagem drenagem linfatica': drenagemLinfatica,
    'lymphatic drainage': drenagemLinfatica,

    'terapeutica': terapeutica,
    'terapêutica': terapeutica,
    'massagem terapeutica': terapeutica,
    'massagem terapêutica': terapeutica,
    'therapeutic massage': terapeutica,

    'desportiva': desportiva,
    'esportiva': desportiva,
    'massagem desportiva': desportiva,
    'sports massage': desportiva,

    'pedras quentes': pedrasQuentes,
    'massagem com pedras quentes': pedrasQuentes,
    'hot stone massage': pedrasQuentes,
  };

  static String normalizeId(String rawValue) {
    final normalized = rawValue.trim().toLowerCase();
    if (normalized.isEmpty) return '';

    if (defaultIds.contains(normalized)) {
      return normalized;
    }

    return _legacyNameToId[normalized] ?? normalized;
  }

  static List<String> normalizeIds(Iterable<dynamic> values) {
    final result = <String>[];
    for (final value in values) {
      final id = normalizeId(value.toString());
      if (id.isNotEmpty && !result.contains(id)) {
        result.add(id);
      }
    }
    return result;
  }

  static String localize(AppLocalizations localizations, String idOrLegacyName) {
    final id = normalizeId(idOrLegacyName);
    switch (id) {
      case relaxante:
        return localizations.massageTypeRelaxante;
      case drenagemLinfatica:
        return localizations.massageTypeDrenagemLinfatica;
      case terapeutica:
        return localizations.massageTypeTerapeutica;
      case desportiva:
        return localizations.massageTypeDesportiva;
      case pedrasQuentes:
        return localizations.massageTypePedrasQuentes;
      default:
        return idOrLegacyName;
    }
  }
}
