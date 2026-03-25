import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  final Stopwatch stopwatch = Stopwatch();
  Timer? timer;
  List<String> laps = [];

  final Color cutePink = const Color(0xFFFFB6C1);
  final Color softPink = const Color(0xFFFFE4E1);
  final Color deepPink = const Color(0xFFFF69B4);

  // LOGIKA BARU: Format Jam:Menit:Detik:MS
  String formatTime(int totalMilliseconds) {
    int hundreds = (totalMilliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate(); // Tambahan Jam

    String hoursStr = hours.toString().padLeft(2, "0");
    String minutesStr = (minutes % 60).toString().padLeft(2, "0");
    String secondsStr = (seconds % 60).toString().padLeft(2, "0");
    String milliStr = (hundreds % 100).toString().padLeft(2, "0");

    return "$hoursStr:$minutesStr:$secondsStr:$milliStr";
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
        laps.add(formatTime(stopwatch.elapsedMilliseconds));
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
    String displayTime = formatTime(stopwatch.elapsedMilliseconds);

    return Scaffold(
      backgroundColor: softPink,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Stopwatch ✨",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
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
              width: 270, // Sedikit diperlebar agar format HH:MM:SS:ms muat
              height: 270,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: cutePink.withAlpha(120),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(color: cutePink, width: 8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.timer_outlined, color: cutePink, size: 35),
                  const SizedBox(height: 10),
                  Text(
                    displayTime,
                    style: GoogleFonts.poppins(
                      fontSize: 36, // Ukuran disesuaikan agar format jam muat rapi
                      fontWeight: FontWeight.w800,
                      color: Colors.brown[700],
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    "jam : mnt : dtk : ms",
                    style: GoogleFonts.poppins(
                      color: Colors.brown[300],
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionButton(onPressed: start, label: "Mulai", icon: Icons.play_arrow_rounded, color: Colors.green[300]!),
              const SizedBox(width: 12),
              _buildActionButton(onPressed: stop, label: "Stop", icon: Icons.stop_rounded, color: deepPink),
              const SizedBox(width: 12),
              _buildActionButton(onPressed: reset, label: "Reset", icon: Icons.refresh_rounded, color: Colors.orange[300]!),
              const SizedBox(width: 12),
              _buildActionButton(onPressed: lap, label: "Lap", icon: Icons.flag_rounded, color: Colors.blue[300]!),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: laps.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: cutePink.withAlpha(80)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Lap ${index + 1}",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.brown[400]),
                      ),
                      Text(
                        laps[index],
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.brown[700]),
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

  Widget _buildActionButton({required VoidCallback onPressed, required String label, required IconData icon, required Color color}) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
            elevation: 4,
          ),
          child: Icon(icon, color: Colors.white, size: 26),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.brown[600]),
        ),
      ],
    );
  }
}