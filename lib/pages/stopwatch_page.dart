import 'package:flutter/material.dart';
import 'dart:async';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  final Stopwatch stopwatch = Stopwatch();
  Timer? timer;

  List<String> laps = [];

  // Variabel offset untuk memulai dari 59 menit
  // 59 menit * 60 detik * 1000 milidetik
  final int offset59Minutes = 59 * 60 * 1000;

  final Color cutePink = const Color(0xFFFFB6C1);
  final Color softPink = const Color(0xFFFFE4E1);
  final Color deepPink = const Color(0xFFFF69B4);

  String formatTime(int totalMilliseconds) {
    // Logika baru untuk mendukung menit yang bertambah dari 59
    int hundreds = (totalMilliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();

    int minutes = (seconds / 60).truncate();
    int finalSeconds = seconds % 60;
    int finalMilli = hundreds % 100;

    String minutesStr = minutes.toString().padLeft(2, "0");
    String secondsStr = finalSeconds.toString().padLeft(2, "0");
    String milliStr = finalMilli.toString().padLeft(2, "0");

    return "$minutesStr:$secondsStr:$milliStr";

    /* Kode lama (dikomentari):
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, "0");
    String secondsStr = (seconds % 60).toString().padLeft(2, "0");
    String milliStr = (hundreds % 100).toString().padLeft(2, "0");

    return "$minutesStr:$secondsStr:$milliStr";
    */
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }

  void start() {
    if (!stopwatch.isRunning) {
      stopwatch.start();
      startTimer();
    }
  }

  void stop() {
    stopwatch.stop();
    timer?.cancel();
    setState(() {});
  }

  void reset() {
    stopwatch.reset();
    timer?.cancel();
    setState(() {
      laps.clear();
    });
  }

  void lap() {
    if (stopwatch.isRunning) {
      setState(() {
        // Menambahkan offset pada catatan lap agar sinkron dengan display
        int currentTime = stopwatch.elapsedMilliseconds + offset59Minutes;
        laps.add(formatTime(currentTime));
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Menambahkan offset pada waktu yang ditampilkan
    int currentTime = stopwatch.elapsedMilliseconds + offset59Minutes;
    String displayTime = formatTime(currentTime);

    return Scaffold(
      backgroundColor: softPink,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Stopwatch ✨",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: cutePink,
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: cutePink.withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(color: cutePink, width: 8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.timer_outlined, color: cutePink, size: 40),
                  const SizedBox(height: 10),
                  Text(
                    displayTime,
                    style: TextStyle(
                      fontSize:
                          38, // Sedikit diperkecil agar angka 100+ menit tetap muat
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[700],
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    "menit : detik : ms",
                    style: TextStyle(color: Colors.brown[300], fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionButton(
                onPressed: start,
                label: "Mulai",
                icon: Icons.play_arrow_rounded,
                color: Colors.green[300]!,
              ),
              const SizedBox(width: 15),
              _buildActionButton(
                onPressed: stop,
                label: "Stop",
                icon: Icons.stop_rounded,
                color: deepPink,
              ),
              const SizedBox(width: 15),
              _buildActionButton(
                onPressed: reset,
                label: "Reset",
                icon: Icons.refresh_rounded,
                color: Colors.orange[300]!,
              ),
              const SizedBox(width: 15),
              _buildActionButton(
                onPressed: lap,
                label: "Lap",
                icon: Icons.flag_rounded,
                color: Colors.blue[300]!,
              ),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemCount: laps.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 30,
                  ),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: cutePink),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Lap ${index + 1}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[700],
                        ),
                      ),
                      Text(
                        laps[index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[700],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(15),
            elevation: 5,
          ),
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.brown[600],
          ),
        ),
      ],
    );
  }
}
