import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class PiramidPage extends StatefulWidget {
  const PiramidPage({super.key});

  @override
  State<PiramidPage> createState() => _PiramidPageState();
}

class _PiramidPageState extends State<PiramidPage> {
  TextEditingController sisi = TextEditingController();
  TextEditingController tinggi = TextEditingController();

  final Color cutePink = const Color(0xFFFFB6C1);
  final Color softPink = const Color(0xFFFFE4E1);
  final Color deepPink = const Color(0xFFFF69B4);

  double luas = 0;
  double volume = 0;
  bool sudahHitung = false;

  void hitung() {
    double? s = double.tryParse(sisi.text);
    double? t = double.tryParse(tinggi.text);

    if (s == null || t == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Masukkan angka yang bener ya manis~ ✨",
            style: GoogleFonts.poppins(),
          ),
        ),
      );
      return;
    }

    setState(() {
      luas = s * s;
      volume = (1 / 3) * luas * t;
      sudahHitung = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softPink,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Bangun Piramid ✨",
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
            // Kartu Input
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: cutePink.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(Icons.change_history_rounded, color: cutePink, size: 50),
                  const SizedBox(height: 10),
                  Text(
                    "Masukkan ukuran piramidnya ya~",
                    style: GoogleFonts.poppins(
                      color: Colors.brown[400],
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    sisi,
                    "Panjang Sisi Alas",
                    Icons.square_foot_rounded,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    tinggi,
                    "Tinggi Piramid",
                    Icons.height_rounded,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: hitung,
              icon: const Icon(Icons.auto_fix_high_rounded, color: Colors.white),
              label: Text(
                "HITUNG SEKARANG ✨",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: deepPink,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: const StadiumBorder(),
                elevation: 5,
              ),
            ),

            const SizedBox(height: 30),

            if (sudahHitung)
              Column(
                children: [
                  _buildResultCard(
                    "Luas Alas",
                    luas.toStringAsFixed(2),
                    Icons.aspect_ratio_rounded,
                  ),
                  const SizedBox(height: 15),
                  _buildResultCard(
                    "Volume",
                    volume.toStringAsFixed(2),
                    Icons.view_in_ar_rounded,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
      ],
      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: cutePink, fontSize: 13),
        prefixIcon: Icon(icon, color: cutePink),
        filled: true,
        fillColor: softPink.withValues(alpha: 0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildResultCard(String title, String value, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: cutePink, width: 2),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: softPink,
            child: Icon(icon, color: deepPink),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 11),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}