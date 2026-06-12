import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:agenda/core/services/firestore_service.dart';
import 'package:agenda/core/models/agendamento_model.dart';
import 'package:agenda/core/utils/app_strings.dart';
import 'package:agenda/core/utils/app_styles.dart';

class AdminFinanceiroView extends StatefulWidget {
  const AdminFinanceiroView({super.key});

  @override
  State<AdminFinanceiroView> createState() => _AdminFinanceiroViewState();
}

class _AdminFinanceiroViewState extends State<AdminFinanceiroView> {
  final FirestoreService _firestoreService = FirestoreService();
  int _anoSelecionado = DateTime.now().year;
  bool _exportandoPdf = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.configFinanceiro),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Agendamento>>(
        stream: _firestoreService.getAgendamentos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(AppStrings.semDadosFinanceiros));
          }

          final agendamentos = snapshot.data!;

          final agendamentosAno = agendamentos
              .where(
                (a) =>
                    a.status == 'aprovado' && a.dataHora.year == _anoSelecionado,
              )
              .toList();

          final Map<int, double> faturamentoMensal = {};
          for (int i = 1; i <= 12; i++) {
            faturamentoMensal[i] = 0.0;
          }
          for (var a in agendamentosAno) {
            final valor = a.valorFinal ?? a.valorOriginal ?? 0.0;
            faturamentoMensal[a.dataHora.month] =
                (faturamentoMensal[a.dataHora.month] ?? 0) + valor;
          }

          final List<BarChartGroupData> barGroups = [];
          double maxValor = 0;
          faturamentoMensal.forEach((mes, valor) {
            if (valor > maxValor) maxValor = valor;
            barGroups.add(
              BarChartGroupData(
                x: mes,
                barRods: [
                  BarChartRodData(
                    toY: valor,
                    color: AppColors.primary,
                    width: 16,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                ],
              ),
            );
          });

          final totalAnual = faturamentoMensal.values.reduce((a, b) => a + b);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.financeiroAnualTitulo,
                      style: AppStyles.title,
                    ),
                    DropdownButton<int>(
                      value: _anoSelecionado,
                      items: List.generate(
                        5,
                        (i) => DateTime.now().year - 2 + i,
                      )
                          .map(
                            (ano) => DropdownMenuItem(
                              value: ano,
                              child: Text(ano.toString()),
                            ),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _anoSelecionado = val!),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: maxValor > 0 ? maxValor * 1.2 : 10.0,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '${_getNomeMes(group.x)}\nR\$ ${rod.toY.toStringAsFixed(2)}',
                              const TextStyle(color: Colors.white),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  _getSiglaMes(value.toInt()),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  AppStrings.totalAnual(totalAnual.toStringAsFixed(2)),
                  style: AppStyles.title.copyWith(color: Colors.green),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _exportandoPdf
                        ? null
                        : () => _exportarPdf(faturamentoMensal, totalAnual),
                    icon: _exportandoPdf
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.picture_as_pdf),
                    label: Text(
                      _exportandoPdf
                          ? 'Gerando PDF...'
                          : 'Exportar Relatório PDF',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _exportarPdf(
    Map<int, double> faturamentoMensal,
    double totalAnual,
  ) async {
    setState(() => _exportandoPdf = true);

    try {
      final pdf = pw.Document();
      final formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Cabeçalho
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.green700,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'SAGMA — Relatório Financeiro',
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Ano: $_anoSelecionado   •   Gerado em: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                        style: const pw.TextStyle(
                          fontSize: 11,
                          color: PdfColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 24),

                // Tabela mensal
                pw.Text(
                  'Faturamento por Mês',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Table(
                  border: pw.TableBorder.all(
                    color: PdfColors.grey400,
                    width: 0.5,
                  ),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(2),
                    1: const pw.FlexColumnWidth(3),
                  },
                  children: [
                    // Cabeçalho da tabela
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.grey200,
                      ),
                      children: [
                        _celulaPdf('Mês', bold: true),
                        _celulaPdf('Faturamento', bold: true, alignRight: true),
                      ],
                    ),
                    // Linhas mensais
                    ...List.generate(12, (i) {
                      final mes = i + 1;
                      final valor = faturamentoMensal[mes] ?? 0.0;
                      final destaque = valor > 0;
                      return pw.TableRow(
                        decoration: pw.BoxDecoration(
                          color: destaque ? PdfColors.green50 : null,
                        ),
                        children: [
                          _celulaPdf(_getNomeMesPdf(mes)),
                          _celulaPdf(
                            formatoMoeda.format(valor),
                            alignRight: true,
                            bold: destaque,
                          ),
                        ],
                      );
                    }),
                    // Linha de total
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.green100,
                      ),
                      children: [
                        _celulaPdf('TOTAL ANUAL', bold: true),
                        _celulaPdf(
                          formatoMoeda.format(totalAnual),
                          bold: true,
                          alignRight: true,
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 32),
                pw.Divider(color: PdfColors.grey400),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Documento gerado automaticamente pelo SAGMA — Sistema de Agendamento e Gestão para Massoterapia.',
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.grey600,
                  ),
                ),
              ],
            );
          },
        ),
      );

      final bytes = await pdf.save();
      final nomeArquivo =
          'relatorio_financeiro_$_anoSelecionado.pdf';

      if (kIsWeb) {
        await SharePlus.instance.share(
          ShareParams(
            files: [
              XFile.fromData(
                Uint8List.fromList(bytes),
                mimeType: 'application/pdf',
                name: nomeArquivo,
              ),
            ],
            subject: 'Relatório Financeiro SAGMA $_anoSelecionado',
          ),
        );
      } else {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/$nomeArquivo');
        await file.writeAsBytes(bytes);
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(file.path)],
            subject: 'Relatório Financeiro SAGMA $_anoSelecionado',
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao gerar PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _exportandoPdf = false);
    }
  }

  pw.Widget _celulaPdf(
    String texto, {
    bool bold = false,
    bool alignRight = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: pw.Text(
        texto,
        textAlign: alignRight ? pw.TextAlign.right : pw.TextAlign.left,
        style: pw.TextStyle(
          fontSize: 11,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  String _getNomeMes(int mes) =>
      DateFormat('MMMM', 'pt_BR').format(DateTime(2023, mes));

  String _getNomeMesPdf(int mes) =>
      DateFormat('MMMM', 'pt_BR').format(DateTime(2023, mes));

  String _getSiglaMes(int mes) =>
      DateFormat('MMM', 'pt_BR').format(DateTime(2023, mes)).toUpperCase();
}
