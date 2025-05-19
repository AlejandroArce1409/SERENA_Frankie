import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarioMamalon extends StatefulWidget {
  @override
  _CalendarioMamalonState createState() => _CalendarioMamalonState();
}

class _CalendarioMamalonState extends State<CalendarioMamalon> {
  Map<DateTime, List<Map<String, dynamic>>> _events = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadEventsFromFirestore();
  }

  Future<void> _loadEventsFromFirestore() async {
    final snapshot = await _firestore.collection('events').get();
    final Map<DateTime, List<Map<String, dynamic>>> loadedEvents = {};

    for (var doc in snapshot.docs) {
      final date = _parseDate(doc.id);
      final List<dynamic> eventsFromDoc = doc.get('events');
      loadedEvents[date] = eventsFromDoc.map((e) => Map<String, dynamic>.from(e)).toList();
    }

    setState(() {
      _events = loadedEvents;
    });
  }

  DateTime _parseDate(String dateStr) {
    final parts = dateStr.split('-');
    return DateTime.utc(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day-$month-$year';
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  Future<void> _addEventForDay(DateTime day, String title, TimeOfDay startTime, TimeOfDay endTime) async {
    final key = DateTime.utc(day.year, day.month, day.day);
    final docId = _formatDate(key);

    final newEvent = {
      'title': title,
      'start': '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
      'end': '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
    };

    if (_events[key] != null) {
      _events[key]!.add(newEvent);
    } else {
      _events[key] = [newEvent];
    }

    await _firestore.collection('events').doc(docId).set({
      'events': _events[key],
    });

    setState(() {});
  }

  Future<void> _showAddEventDialog() async {
    final titleController = TextEditingController();
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Agregar evento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Título del evento'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                  if (picked != null) {
                    setState(() {
                      startTime = picked;
                    });
                  }
                },
                child: Text(
                    startTime == null ? 'Elegir hora de inicio' : 'Inicio: ${startTime!.format(context)}'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                  if (picked != null) {
                    setState(() {
                      endTime = picked;
                    });
                  }
                },
                child: Text(
                    endTime == null ? 'Elegir hora de fin' : 'Fin: ${endTime!.format(context)}'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                if (title.isNotEmpty && startTime != null && endTime != null && _selectedDay != null) {
                  _addEventForDay(_selectedDay!, title, startTime!, endTime!);
                  Navigator.pop(context);
                }
              },
              child: Text('Agregar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendario con eventos')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: (day) => _getEventsForDay(day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: _getEventsForDay(_selectedDay ?? _focusedDay)
                  .map((event) => ListTile(
                title: Text(event['title']),
                subtitle: Text('De ${event['start']} a ${event['end']}'),
              ))
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
