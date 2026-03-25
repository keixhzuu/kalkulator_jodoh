import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

import 'data_kelompok_page.dart';
import 'kalkulator_page.dart';
import 'bilangan_page.dart';
import 'total_angka_page.dart';
import 'stopwatch_page.dart';
import 'piramid_page.dart';
import 'login_page.dart';
import 'tanggal_page.dart';
import 'jodoh_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color cutePink = Color(0xFFFFB6C1);
  static const Color softPink = Color(0xFFFFE4E1);
  static const Color deepPink = Color(0xFFFF69B4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softPink,
      appBar: AppBar(
        title: Text(
          "Menu Utama ✨",
          style: GoogleFonts.poppins( // Ganti Font
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
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pilih Menu Favoritmu:",
              style: GoogleFonts.poppins( // Ganti Font
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown[600],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  menuButton(
                    context,
                    "Data Kelompok",
                    Icons.group_rounded,
                    DataKelompok(),
                  ),
                  menuButton(
                    context,
                    "Kalkulator",
                    Icons.calculate_rounded,
                    KalkulatorPage(),
                  ),
                  menuButton(
                    context,
                    "Cek Bilangan",
                    Icons.numbers_rounded,
                    BilanganPage(),
                  ),
                  menuButton(
                    context,
                    "Total Angka",
                    Icons.summarize_rounded,
                    TotalAngka(),
                  ),
                  menuButton(
                    context,
                    "Stopwatch",
                    Icons.timer_rounded,
                    StopwatchPage(),
                  ),
                  menuButton(
                    context,
                    "Piramid",
                    Icons.change_history_rounded,
                    PiramidPage(),
                  ),
                  menuButton(
                    context,
                    "Kalkulator Tanggal",
                    Icons.event_note_rounded,
                    const KalkulatorTanggalPage(),
                  ),
                  menuButton(
                    context,
                    "Cek Jodoh",
                    Icons.favorite_rounded,
                    const KalkulatorJodohPage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget menuButton(
    BuildContext context,
    String title,
    IconData icon,
    Widget page,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: cutePink.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: softPink,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: deepPink),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins( // Ganti Font
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Logout? 🥺",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold), // Ganti Font
        ),
        content: Text(
          "Yakin mau keluar dari aplikasi imut ini?",
          style: GoogleFonts.poppins(), // Ganti Font
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Batal",
              style: GoogleFonts.poppins(color: Colors.grey[600], fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: deepPink,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
              );
            },
            child: Text(
              "Ya, Keluar",
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}