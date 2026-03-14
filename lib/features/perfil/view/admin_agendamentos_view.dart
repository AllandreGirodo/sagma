import 'package:flutter/material.dart';
import 'package:agenda/core/utils/app_strings.dart';

class AdminAgendamentosView extends StatelessWidget {
  const AdminAgendamentosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.administracaoAgendamentos)),
      body: Center(child: Text(AppStrings.telaAdministracao)),
    );
  }
}