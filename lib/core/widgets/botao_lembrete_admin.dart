import 'package:flutter/material.dart';
import 'package:agenda/core/services/firestore_service.dart';
import 'package:agenda/core/utils/app_strings.dart';

class BotaoLembreteAdmin extends StatefulWidget {
  const BotaoLembreteAdmin({super.key});

  @override
  State<BotaoLembreteAdmin> createState() => _BotaoLembreteAdminState();
}

class _BotaoLembreteAdminState extends State<BotaoLembreteAdmin> {
  bool _isLoading = false;

  Future<void> _confirmarDisparo() async {
    final TextEditingController horasController = TextEditingController(text: '24');

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.dispararLembretes),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppStrings.confirmarDisparoLembretes),
            const SizedBox(height: 16),
            TextField(
              controller: horasController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppStrings.horasAntecedencia,
                border: OutlineInputBorder(),
                suffixText: AppStrings.horasUnidade,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppStrings.cancelButton),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(AppStrings.enviar),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      setState(() => _isLoading = true);
      try {
        final horas = int.tryParse(horasController.text) ?? 24;
        final resultado = await FirestoreService().dispararLembretes(horas: horas);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(resultado['mensagem'] ?? AppStrings.processoConcluido),
            backgroundColor: Colors.green,
          ));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppStrings.erroAoDisparar('$e')),
            backgroundColor: Colors.red,
          ));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _isLoading 
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
          : const Icon(Icons.notifications_active),
      tooltip: AppStrings.enviarLembretesManuais,
      onPressed: _isLoading ? null : _confirmarDisparo,
    );
  }
}
