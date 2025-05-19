import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TengoAmsiedad extends StatefulWidget {
  const TengoAmsiedad({Key? key}) : super(key: key);

  @override
  State<TengoAmsiedad> createState() => _TengoAmsiedadState();
}

class _TengoAmsiedadState extends State<TengoAmsiedad> {
  int _counter = 0;
  double _imageSize = 150.0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String docId = 'contadorGlobal';

  @override
  void initState() {
    super.initState();
    _loadCounterFromFirestore();
  }

  Future<void> _loadCounterFromFirestore() async {
    try {
      final snapshot = await _firestore.collection('contadores').doc(docId).get();
      if (snapshot.exists && snapshot.data()?['valor'] != null) {
        setState(() {
          _counter = snapshot['valor'];
          _imageSize = 150.0 + _counter * 2;
        });
      }
    } catch (e) {
      print('Error al cargar contador: $e');
    }
  }

  Future<void> _saveCounterToFirestore() async {
    try {
      await _firestore.collection('contadores').doc(docId).set({'valor': _counter});
    } catch (e) {
      print('Error al guardar contador: $e');
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      _imageSize += 2;
      if (_counter == 50) _imageSize = 150.0;
    });
    _saveCounterToFirestore();
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
      _imageSize = 150.0;
    });
    _saveCounterToFirestore();
  }

  @override
  Widget build(BuildContext context) {
    final String imagePath = _counter >= 50
        ? 'assets/bonk.png'
        : 'assets/Cheems.png';

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.black87],
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          title: const Text("Contador de amsiedad", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.red],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Haz presionado este botón tantas veces por tu amsiedad:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                '$_counter',
                style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Image.asset(
                imagePath,
                width: _imageSize,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _incrementCounter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text('Sumar'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _resetCounter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text('Reiniciar'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
