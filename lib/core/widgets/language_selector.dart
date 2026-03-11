import 'package:flutter/material.dart';
import 'package:agenda/core/utils/app_strings.dart';
import 'package:agenda/main.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.flag, size: 24), // Bandeirinha
      tooltip: AppStrings.tooltipAlterarIdioma,
      onSelected: (Locale locale) {
        MyApp.setLocale(context, locale);
        AppStrings.setLocale(locale); // Atualiza as strings estáticas
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
        PopupMenuItem<Locale>(
          value: Locale('pt', 'BR'),
          child: Text(AppStrings.idiomaPortugues),
        ),
        PopupMenuItem<Locale>(
          value: Locale('en', 'US'),
          child: Text(AppStrings.idiomaIngles),
        ),
        PopupMenuItem<Locale>(
          value: Locale('es', 'ES'),
          child: Text(AppStrings.idiomaEspanhol),
        ),
        PopupMenuItem<Locale>(
          value: Locale('ja', 'JP'),
          child: Text(AppStrings.idiomaJapones),
        ),
      ],
    );
  }
}