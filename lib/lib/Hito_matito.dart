import 'dart:async';
import 'package:flutter/material.dart';

class HitoMatito extends StatefulWidget {
  @override
  _HitoMatitoState createState() => _HitoMatitoState();
}

class _HitoMatitoState extends State<HitoMatito> {
  static const int workDuration = 25 * 60;
  static const int shortBreakDuration = 5 * 60;
  static const int longBreakDuration = 15 * 60;

  int _remainingSeconds = workDuration;
  int _pomodoroCount = 0;
  bool _isRunning = false;
  bool _isWorking = true;

  Timer? _timer;

  void _startTimer() {
    if (_timer != null) return;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _handleSessionEnd();
      }
    });

    setState(() => _isRunning = true);
  }

  void _handleSessionEnd() {
    _pauseTimer();

    if (_isWorking) {
      _pomodoroCount++;
      if (_pomodoroCount % 4 == 0) {
        _startBreak(longBreakDuration, "Descanso largo");
      } else {
        _startBreak(shortBreakDuration, "Descanso corto");
      }
    } else {
      _startWork();
    }
  }

  void _startWork() {
    setState(() {
      _isWorking = true;
    _startTimer();
    _remainingSeconds = workDuration;
  });
    _showMessage("¡It's time to chamba!");
  }

  void _startBreak(int duration, String type) {
    setState(() {
      _isWorking = false;
      _remainingSeconds = duration;
    });
    _startTimer();
    _showMessage("¡$type!");
  }

  void _pauseTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _pauseTimer();
    setState(() {
      _remainingSeconds = workDuration;
      _pomodoroCount = 0;
      _isWorking = true;
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 2)),
    );
  }

  @override
  void dispose() {
    _pauseTimer();
    super.dispose();
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
        title: const Text("Hora Hitomon", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF311B92), Color(0xFF880E4F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isWorking ? "Trabajo" : "Descanso",
                  style: TextStyle(fontSize: 32, color: Colors.white70),
                ),
                SizedBox(height: 20),
                Text(
                  _formatTime(_remainingSeconds),
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _isRunning ? null : _startTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text("Iniciar", style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _isRunning ? _pauseTimer : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: Text("Pausar", style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _resetTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text("Reiniciar", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Pomodoros completados: $_pomodoroCount",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
