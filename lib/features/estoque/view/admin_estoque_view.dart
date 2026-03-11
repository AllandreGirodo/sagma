import 'package:flutter/material.dart';
import 'package:agenda/core/services/firestore_service.dart';
import 'package:agenda/core/models/estoque_model.dart';
import 'package:agenda/core/utils/app_strings.dart';

class AdminEstoqueView extends StatelessWidget {
  const AdminEstoqueView({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.estoqueControle),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<ItemEstoque>>(
        stream: firestoreService.getEstoque(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text(AppStrings.erroGenerico('${snapshot.error}')));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final itens = snapshot.data ?? [];

          if (itens.isEmpty) {
            return Center(child: Text(AppStrings.estoqueVazio));
          }

          return ListView.builder(
            itemCount: itens.length,
            itemBuilder: (context, index) {
              final item = itens[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: item.quantidade > 5 ? Colors.green : Colors.red,
                    child: Text('${item.quantidade}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                  title: Text(item.nome),
                  subtitle: Text(item.consumoAutomatico 
                      ? AppStrings.estoqueBaixaAuto 
                      : AppStrings.estoqueControleManual),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _mostrarDialogo(context, firestoreService, item: item),
                  ),
                  onLongPress: () => firestoreService.excluirItemEstoque(item.id!),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        onPressed: () => _mostrarDialogo(context, firestoreService),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _mostrarDialogo(BuildContext context, FirestoreService service, {ItemEstoque? item}) {
    final nomeController = TextEditingController(text: item?.nome ?? '');
    final qtdController = TextEditingController(text: item?.quantidade.toString() ?? '0');
    bool consumoAuto = item?.consumoAutomatico ?? true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(item == null ? AppStrings.estoqueNovoItem : AppStrings.estoqueEditarItem),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nomeController,
                    decoration: InputDecoration(labelText: AppStrings.estoqueNomeProduto),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: qtdController,
                    decoration: InputDecoration(labelText: AppStrings.estoqueQuantidade),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  SwitchListTile(
                    title: Text(AppStrings.estoqueBaixaAutomatica),
                    subtitle: Text(AppStrings.estoqueDescontarAprovacao),
                    value: consumoAuto,
                    onChanged: (val) => setState(() => consumoAuto = val),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text(AppStrings.cancelButton)),
                ElevatedButton(
                  onPressed: () {
                    final novoItem = ItemEstoque(
                      id: item?.id,
                      nome: nomeController.text,
                      quantidade: int.tryParse(qtdController.text) ?? 0,
                      consumoAutomatico: consumoAuto,
                    );
                    service.salvarItemEstoque(novoItem);
                    Navigator.pop(context);
                  },
                  child: Text(AppStrings.salvar),
                ),
              ],
            );
          });
      },
    );
  }
}