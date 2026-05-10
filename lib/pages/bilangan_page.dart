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
  String hasilPositifNegatif = ""; // Variabel baru

  final Color cutePink = const Color(0xFFFFB6C1);
  final Color softPink = const Color(0xFFFFE4E1);
  final Color deepPink = const Color(0xFFFF69B4);

  // Fungsi isPrima menggunakan BigInt agar akurat untuk angka besar
  bool isPrima(BigInt n) {
    if (n <= BigInt.one) return false;
    if (n == BigInt.from(2) || n == BigInt.from(3)) return true;
    if (n % BigInt.from(2) == BigInt.zero || n % BigInt.from(3) == BigInt.zero)
      return false;

    // Algoritma 6k +/- 1 untuk efisiensi dasar
    for (BigInt i = BigInt.from(5); i * i <= n; i += BigInt.from(6)) {
      if (n % i == BigInt.zero || n % (i + BigInt.from(2)) == BigInt.zero)
        return false;
    }
    return true;
  }

  void cekBilangan() {
    String input = angka.text.trim();
    if (input.isEmpty) return;

    // Gunakan BigInt untuk menghindari pembulatan otomatis pada angka > 16 digit
    BigInt? n = BigInt.tryParse(input);

    setState(() {
      if (n == null) {
        // Jika input bukan angka bulat (misal desimal atau teks)
        hasilGanjilGenap = "Bukan Bulat";
        hasilPrima = "N/A";
        hasilPositifNegatif = "Input Tidak Valid";
      } else {
        // 1. Cek Ganjil / Genap
        hasilGanjilGenap = (n % BigInt.from(2) == BigInt.zero)
            ? "Bilangan Genap"
            : "Bilangan Ganjil";

        // 2. Cek Prima
        hasilPrima = isPrima(n) ? "Bilangan Prima" : "Bukan Prima";

        // 3. Cek Positif / Negatif / Nol
        if (n > BigInt.zero) {
          hasilPositifNegatif = "Bilangan Positif";
        } else if (n < BigInt.zero) {
          hasilPositifNegatif = "Bilangan Negatif";
        } else {
          hasilPositifNegatif = "Angka Nol";
        }
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
          "Cek Bilangan Luas✨",
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
                    color: cutePink.withOpacity(0.3),
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
                    "Masukkan angka berapapun 💫\nSistem sekarang mendukung angka sangat besar!",
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
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                    decoration: InputDecoration(
                      hintText: "masukkan angka",
                      hintStyle: GoogleFonts.poppins(
                        color: cutePink.withOpacity(0.5),
                        fontSize: 15,
                      ),
                      filled: true,
                      fillColor: softPink.withOpacity(0.2),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
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
                    "Jenis Bilangan",
                    hasilPositifNegatif,
                    Icons.add_circle_outline_rounded,
                  ),
                  const SizedBox(height: 15),
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
