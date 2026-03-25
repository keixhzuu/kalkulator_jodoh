import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TotalAngka extends StatefulWidget {
  const TotalAngka({super.key});

  @override
  State<TotalAngka> createState() => _TotalAngkaState();
}

class _TotalAngkaState extends State<TotalAngka> {
  TextEditingController angkaController = TextEditingController();
  int totalJumlah = 0;
  int jumlahDigit = 0;
  bool sudahHitung = false;

  final Color cutePink = const Color(0xFFFFB6C1);
  final Color softPink = const Color(0xFFFFE4E1);
  final Color deepPink = const Color(0xFFFF69B4);

  void hitung() {
    String inputRaw = angkaController.text.trim();

    if (inputRaw.isEmpty) {
      setState(() => sudahHitung = false);
      return;
    }

    if (RegExp(r'[^0-9]').hasMatch(inputRaw)) {
      _showErrorSnackBar("Hanya boleh angka ya manis! 🌸");
  
      String cleanText = inputRaw.replaceAll(RegExp(r'[^0-9]'), '');
      angkaController.text = cleanText;

      angkaController.selection = TextSelection.fromPosition(
        TextPosition(offset: cleanText.length),
      );
      return;
    }

    int sum = 0;
    for (int i = 0; i < inputRaw.length; i++) {
      sum += int.parse(inputRaw[i]);
    }

    setState(() {
      jumlahDigit = inputRaw.length;
      totalJumlah = sum;
      sudahHitung = true;
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softPink,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Analisis Angka ✨",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: cutePink.withAlpha(80),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(Icons.analytics_rounded, color: cutePink, size: 50),
                  const SizedBox(height: 15),
                  Text(
                    "Ketik angkamu, aku hitungin\njumlah digit & total penjumlahannya! 💫",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.brown[400],
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: angkaController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    onChanged: (value) => hitung(),
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                    decoration: InputDecoration(
                      hintText: "Contoh: 12345",
                      hintStyle: GoogleFonts.poppins(
                        color: cutePink.withAlpha(120),
                        fontSize: 16,
                      ),
                      filled: true,
                      fillColor: softPink.withAlpha(50),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            if (sudahHitung) ...[
              _buildResultCard(
                "HASIL PENJUMLAHAN 🧸", 
                "$totalJumlah", 
                "Nilai total semua digit ditambahkan",
                Icons.add_circle_outline_rounded,
              ),
              const SizedBox(height: 15),
              _buildResultCard(
                "JUMLAH DIGIT 🎀", 
                "$jumlahDigit", 
                "Banyaknya angka yang kamu ketik",
                Icons.pin_outlined,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(String title, String value, String desc, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cutePink, deepPink],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: deepPink.withAlpha(100),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white.withAlpha(230),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 42,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  desc,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.white.withAlpha(200),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, color: Colors.white.withAlpha(150), size: 50),
        ],
      ),
    );
  }
}