import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/models/agendamento_model.dart';

typedef OnDateSelected = void Function(DateTime date);

class CalendarColorPicker extends StatefulWidget {
  final DateTime initialDate;
  final Stream<List<Agendamento>> agendamentosStream;
  final OnDateSelected? onDateSelected;

  const CalendarColorPicker({
    super.key,
    required this.initialDate,
    required this.agendamentosStream,
    this.onDateSelected,
  });

  @override
  State<CalendarColorPicker> createState() => _CalendarColorPickerState();
}

class _CalendarColorPickerState extends State<CalendarColorPicker> {
  late DateTime _displayedMonth;
  Map<int, int> _counts = {};

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime(widget.initialDate.year, widget.initialDate.month, 1);
    widget.agendamentosStream.listen((lista) {
      _recomputeCounts(lista);
    });
  }

  void _recomputeCounts(List<Agendamento> lista) {
    final map = <int, int>{};
    for (final a in lista) {
      final d = a.dataHora;
      if (d.year == _displayedMonth.year && d.month == _displayedMonth.month) {
        map[d.day] = (map[d.day] ?? 0) + (a.status == 'cancelado' || a.status == 'cancelado_tardio' || a.status == 'recusado' ? 0 : 1);
      }
    }
    setState(() => _counts = map);
  }

  Color? _colorForCount(int count) {
    if (count <= 0) return null;
    if (count == 1) return Colors.green.shade600; // verde vivo
    if (count == 2) return Colors.blue.shade600; // azul
    if (count >= 3 && count <= 4) return Colors.yellow.shade700; // amarelo
    return Colors.red.shade600; // vermelho
  }

  void _prevMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstWeekday = DateTime(_displayedMonth.year, _displayedMonth.month, 1).weekday % 7; // 0=Sun
    final daysInMonth = DateUtils.getDaysInMonth(_displayedMonth.year, _displayedMonth.month);

    final weeks = <List<int?>>[];
    var week = List<int?>.filled(7, null);
    var day = 1;
    for (var i = 0; i < firstWeekday; i++) {
      week[i] = null;
    }
    for (var i = firstWeekday; i < 7; i++) {
      week[i] = day++;
    }
    weeks.add(week);
    while (day <= daysInMonth) {
      final w = List<int?>.filled(7, null);
      for (var i = 0; i < 7 && day <= daysInMonth; i++) {
        w[i] = day++;
      }
      weeks.add(w);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: _prevMonth, icon: const Icon(Icons.chevron_left)),
            Text(
              DateFormat.yMMMM(Localizations.localeOf(context).toString()).format(_displayedMonth),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            IconButton(onPressed: _nextMonth, icon: const Icon(Icons.chevron_right)),
          ],
        ),
        const SizedBox(height: 6),
        // Weekday headers
        Row(
          children: List.generate(7, (i) {
            final weekdayName = DateFormat.E(Localizations.localeOf(context).toString()).format(DateTime(2020, 1, i + 5));
            return Expanded(
              child: Center(child: Text(weekdayName, style: const TextStyle(fontSize: 12, color: Colors.grey))),
            );
          }),
        ),
        const SizedBox(height: 6),
        // Days
        Column(
          children: weeks.map((w) {
            return Row(
              children: w.map((dayNum) {
                return Expanded(
                  child: GestureDetector(
                    onTap: dayNum == null
                        ? null
                        : () {
                            final selected = DateTime(_displayedMonth.year, _displayedMonth.month, dayNum);
                            widget.onDateSelected?.call(selected);
                          },
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (dayNum != null && (_counts[dayNum] ?? 0) > 0)
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: _colorForCount((_counts[dayNum] ?? 0))!.withValues(alpha: 0.35),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            if (dayNum != null)
                              Text(
                                '$dayNum',
                                style: const TextStyle(fontSize: 14),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        // Legend (only circles inside the frame)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _legendCircle(Colors.green.shade600),
            const SizedBox(width: 8),
            _legendCircle(Colors.blue.shade600),
            const SizedBox(width: 8),
            _legendCircle(Colors.yellow.shade700),
            const SizedBox(width: 8),
            _legendCircle(Colors.red.shade600),
          ],
        ),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _legendCircle(Color color) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
