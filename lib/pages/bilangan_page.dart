import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BilanganPage extends StatefulWidget {
  const BilanganPage({super.key});

  @override
  State<BilanganPage> createState() => _BilanganPageState();
}

class _BilanganPageState extends State<BilanganPage> {
  TextEditingController angka = TextEditingController();
  String hasilGanjilGenap = "";
  String hasilPrima = "";

  final Color cutePink = const Color(0xFFFFB6C1);
  final Color softPink = const Color(0xFFFFE4E1);
  final Color deepPink = const Color(0xFFFF69B4);

  bool isPrima(int n) {
    if (n <= 1) return false;
    for (int i = 2; i * i <= n; i++) {
      if (n % i == 0) return false;
    }
    return true;
  }

  void cekBilangan() {
    if (angka.text.isEmpty) return;

    double? n = double.tryParse(angka.text);
    if (n == null) return;

    setState(() {
      if (n % 1 != 0) {
        hasilGanjilGenap = "Bilangan Desimal";
        hasilPrima = "Bilangan Desimal";
      } else {
        int bil = n.toInt();
        hasilGanjilGenap = bil % 2 == 0 ? "Bilangan Genap" : "Bilangan Ganjil";
        hasilPrima = isPrima(bil) ? "Bilangan Prima" : "Bukan Prima";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softPink,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Cek Bilangan✨",
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
                    color: cutePink.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(Icons.auto_awesome_rounded, color: cutePink, size: 40),
                  const SizedBox(height: 10),
                  Text(
                    "Masukkan angka 💫\nCek ganjil, genap, atau prima~",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.brown[400],
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: angka,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                    decoration: InputDecoration(
                      hintText: "masukkan angka",
                      hintStyle: GoogleFonts.poppins(
                        color: cutePink.withValues(alpha: 0.5),
                        fontSize: 15,
                      ),
                      filled: true,
                      fillColor: softPink.withValues(alpha: 0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: cekBilangan,
              style: ElevatedButton.styleFrom(
                backgroundColor: deepPink,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: const StadiumBorder(),
                elevation: 5,
              ),
              child: Text(
                "CEK SEKARANG",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
            ),

            const SizedBox(height: 30),

            if (hasilGanjilGenap.isNotEmpty)
              Column(
                children: [
                  _buildResultCard(
                    "Status Ganjil/Genap",
                    hasilGanjilGenap,
                    Icons.looks_two_rounded,
                  ),
                  const SizedBox(height: 15),
                  _buildResultCard(
                    "Status Prima",
                    hasilPrima,
                    Icons.star_rounded,
                  ),
                ],
              ),
          ],
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
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 17,
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