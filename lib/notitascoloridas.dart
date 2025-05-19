import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotitasColoridas extends StatefulWidget {
  @override
  _NotitasColoridasState createState() => _NotitasColoridasState();
}

class _NotitasColoridasState extends State<NotitasColoridas> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _labelController = TextEditingController();
  Color _selectedColor = Colors.yellow.shade100;

  final _firestore = FirebaseFirestore.instance;

  void _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final label = _labelController.text.trim();

    if (title.isEmpty && content.isEmpty) return;

    await _firestore.collection('notas').add({
      'title': title,
      'content': content,
      'label': label,
      'color': _selectedColor.value,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _titleController.clear();
    _contentController.clear();
    _labelController.clear();
    setState(() {
      _selectedColor = Colors.yellow.shade100;
    });
  }

  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Selecciona un color"),
        content: BlockPicker(
          pickerColor: _selectedColor,
          onColorChanged: (color) {
            setState(() {
              _selectedColor = color;
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.black87],
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: const Text("Notitas Pa Todo", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.red],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Título'),
                    ),
                    TextField(
                      controller: _contentController,
                      decoration: InputDecoration(labelText: 'Contenido'),
                      maxLines: 2,
                    ),
                    TextField(
                      controller: _labelController,
                      decoration: InputDecoration(labelText: 'Etiqueta'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Color:"),
                        ElevatedButton(
                          onPressed: _pickColor,
                          child: Text("Seleccionar color"),
                        ),
                        Spacer(),
                        ElevatedButton(
                          onPressed: _saveNote,
                          child: Text("Guardar"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('notas')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    final docs = snapshot.data!.docs;

                    return ListView(
                      children: docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final color = Color(data['color'] ?? 0xFFFFF59D);
                        return Card(
                          color: color,
                          margin: EdgeInsets.all(8),
                          child: ListTile(
                            title: Text(data['title'] ?? ''),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (data['content'] != null) Text(data['content']),
                                if (data['label'] != null && data['label'] != '')
                                  Chip(label: Text(data['label'])),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
