import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agenda/core/services/firestore_service.dart';
import 'package:agenda/core/models/cliente_model.dart';
import 'package:agenda/core/models/transacao_model.dart';
import 'package:agenda/core/utils/app_strings.dart';

class AdminNovaTransacaoView extends StatefulWidget {
  const AdminNovaTransacaoView({super.key});

  @override
  State<AdminNovaTransacaoView> createState() => _AdminNovaTransacaoViewState();
}

class _AdminNovaTransacaoViewState extends State<AdminNovaTransacaoView> {
  final _formKey = GlobalKey<FormState>();
  final _firestoreService = FirestoreService();
  
  String? _clienteUidSelecionado;
  final _valorBrutoController = TextEditingController();
  final _valorDescontoController = TextEditingController();
  final _valorLiquidoController = TextEditingController();
  String _metodoPagamento = 'pix';
  String _statusPagamento = 'pago';
  DateTime _dataPagamento = DateTime.now();
  
  List<Cliente> _clientes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarClientes();
    _valorBrutoController.addListener(_calcularLiquido);
    _valorDescontoController.addListener(_calcularLiquido);
  }

  @override
  void dispose() {
    _valorBrutoController.dispose();
    _valorDescontoController.dispose();
    _valorLiquidoController.dispose();
    super.dispose();
  }

  void _calcularLiquido() {
    double bruto = double.tryParse(_valorBrutoController.text.replaceAll(',', '.')) ?? 0.0;
    double desconto = double.tryParse(_valorDescontoController.text.replaceAll(',', '.')) ?? 0.0;
    double liquido = bruto - desconto;
    if (liquido < 0) liquido = 0;
    _valorLiquidoController.text = liquido.toStringAsFixed(2);
  }

  Future<void> _carregarClientes() async {
    // Busca a lista de clientes para o Dropdown
    final snapshot = await _firestoreService.getClientesAprovados().first;
    if (mounted) {
      setState(() {
        _clientes = snapshot;
        _isLoading = false;
      });
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_clienteUidSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppStrings.selecioneCliente)));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final transacao = TransacaoFinanceira(
        clienteUid: _clienteUidSelecionado!,
        valorBruto: double.parse(_valorBrutoController.text.replaceAll(',', '.')),
        valorDesconto: double.tryParse(_valorDescontoController.text.replaceAll(',', '.')) ?? 0.0,
        valorLiquido: double.parse(_valorLiquidoController.text.replaceAll(',', '.')),
        metodoPagamento: _metodoPagamento,
        statusPagamento: _statusPagamento,
        dataPagamento: _dataPagamento,
        criadoPorUid: FirebaseAuth.instance.currentUser?.uid ?? 'admin',
        dataCriacao: DateTime.now(),
      );

      await _firestoreService.salvarTransacao(transacao);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppStrings.transacaoRegistradaSucesso)));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppStrings.erro('$e'))));
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.novaTransacao),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  DropdownButtonFormField<String>(
                    key: ValueKey(_clienteUidSelecionado),
                    initialValue: _clienteUidSelecionado,
                    decoration: InputDecoration(labelText: AppStrings.clienteLabel, border: const OutlineInputBorder()),
                    items: _clientes.map((c) => DropdownMenuItem(value: c.uid, child: Text(c.nome))).toList(),
                    onChanged: (v) => setState(() => _clienteUidSelecionado = v),
                    validator: (v) => v == null ? AppStrings.requiredField : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _valorBrutoController,
                          decoration: InputDecoration(labelText: AppStrings.valorBrutoLabel, border: const OutlineInputBorder()),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: (v) => v!.isEmpty ? AppStrings.requiredField : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _valorDescontoController,
                          decoration: InputDecoration(labelText: AppStrings.descontoLabel, border: const OutlineInputBorder()),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _valorLiquidoController,
                    decoration: InputDecoration(labelText: AppStrings.valorLiquidoLabel, border: const OutlineInputBorder(), filled: true, fillColor: Colors.grey[200]),
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    key: ValueKey(_metodoPagamento),
                    initialValue: _metodoPagamento,
                    decoration: InputDecoration(labelText: AppStrings.metodoPagamentoLabel, border: const OutlineInputBorder()),
                    items: [
                      DropdownMenuItem(value: 'pix', child: Text(AppStrings.pix)),
                      DropdownMenuItem(value: 'dinheiro', child: Text(AppStrings.dinheiro)),
                      DropdownMenuItem(value: 'cartao', child: Text(AppStrings.cartao)),
                      DropdownMenuItem(value: 'pacote', child: Text(AppStrings.pacote)),
                    ],
                    onChanged: (v) => setState(() => _metodoPagamento = v!),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    key: ValueKey(_statusPagamento),
                    initialValue: _statusPagamento,
                    decoration: InputDecoration(labelText: AppStrings.statusLabel, border: const OutlineInputBorder()),
                    items: [
                      DropdownMenuItem(value: 'pendente', child: Text(AppStrings.pendente)),
                      DropdownMenuItem(value: 'pago', child: Text(AppStrings.pago)),
                      DropdownMenuItem(value: 'estornado', child: Text(AppStrings.estornado)),
                    ],
                    onChanged: (v) => setState(() => _statusPagamento = v!),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(AppStrings.dataPagamentoLabel(DateFormat('dd/MM/yyyy').format(_dataPagamento))),
                    trailing: const Icon(Icons.calendar_today),
                    shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _dataPagamento,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) setState(() => _dataPagamento = picked);
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _salvar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(AppStrings.registrarTransacao),
                  ),
                ],
              ),
            ),
    );
  }
}