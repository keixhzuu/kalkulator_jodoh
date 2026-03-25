import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class KalkulatorJodohPage extends StatefulWidget {
  const KalkulatorJodohPage({super.key});

  @override
  State<KalkulatorJodohPage> createState() => _KalkulatorJodohPageState();
}

class _KalkulatorJodohPageState extends State<KalkulatorJodohPage> {
  DateTime? _selectedDate;
  DateTime? _partnerDate;

  // Palette warna premium
  static const Color primaryPink = Color(0xFFFF85B3);
  static const Color secondaryPink = Color(0xFFFDE7F0);
  static const Color darkText = Color(0xFF4A4A4A);
  static const Color white = Colors.white;

  // LOGIK: Hitung Neptu Jowo
  int _calculateNeptu(DateTime date) {
    const nHari = {1: 4, 2: 3, 3: 7, 4: 8, 5: 6, 6: 9, 7: 5}; // Sen-Min
    const pasaran = [9, 7, 4, 8, 5]; // Pahing, Pon, Wage, Kliwon, Legi

    final start = DateTime.utc(1900, 1, 1);
    final target = DateTime.utc(date.year, date.month, date.day);
    final diff = target.difference(start).inDays;

    int nilaiH = nHari[date.weekday] ?? 0;
    int nilaiP = pasaran[diff % 5];

    return nilaiH + nilaiP;
  }

  // LOGIK: Kategori Ramalan
  String _cekCocok(int totalNeptu) {
    int hasil = totalNeptu % 8;
    switch (hasil) {
      case 1: return "Pegat";
      case 2: return "Ratu";
      case 3: return "Jodoh";
      case 4: return "Topo";
      case 5: return "Tinari";
      case 6: return "Padu";
      case 7: return "Sujanan";
      case 0: return "Pesthi";
      default: return "-";
    }
  }

  String _getDeskripsi(String hasil) {
    final deskripsi = {
      "Pegat": "Berisiko menghadapi rintangan atau masalah di masa depan.",
      "Ratu": "Pasangan harmonis, rezeki lancar, dan sangat disegani.",
      "Jodoh": "Kecocokan tinggi, saling melengkapi dan langgeng.",
      "Topo": "Awalnya mungkin sulit, tapi akan sukses dan bahagia di hari tua.",
      "Tinari": "Mudah mencari rezeki dan sering mendapat keberuntungan.",
      "Padu": "Sering beda pendapat, tapi cinta tetap menyatukan kalian.",
      "Sujanan": "Waspada rasa cemburu. Perlu komunikasi yang lebih kuat.",
      "Pesthi": "Hubungan yang sangat tenang, damai, rukun, dan tentram.",
    };
    return deskripsi[hasil] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryPink,
      appBar: AppBar(
        title: Text(
          "Love Compatibility ✨",
          style: GoogleFonts.poppins( // Ganti Font AppBar
            color: darkText,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: darkText),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          children: [
            Text(
              "Cek kecocokan wetonmu dengan si dia",
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 30),

            // Pembanding (Kamu vs Pasangan)
            Row(
              children: [
                Expanded(
                  child: _buildUserCard(
                    "Kamu",
                    _selectedDate,
                    Icons.face_3_rounded,
                    true,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.favorite_rounded,
                    color: primaryPink,
                    size: 30,
                  ),
                ),
                Expanded(
                  child: _buildUserCard(
                    "Si Dia",
                    _partnerDate,
                    Icons.face_6_rounded,
                    false,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            if (_selectedDate != null && _partnerDate != null) ...[
              _buildMatchResult(),
            ] else ...[
              _buildEmptyState(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(String label, DateTime? date, IconData icon, bool isUser) {
    return GestureDetector(
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(primary: primaryPink),
              ),
              child: child!,
            );
          },
        );
        if (d != null) {
          setState(() => isUser ? _selectedDate = d : _partnerDate = d);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: primaryPink.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: secondaryPink,
              child: Icon(icon, color: primaryPink, size: 35),
            ),
            const SizedBox(height: 15),
            Text(
              label,
              style: GoogleFonts.poppins( // Ganti Font Label
                fontWeight: FontWeight.bold,
                color: darkText,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              date == null
                  ? "Set Date"
                  : "${date.day}/${date.month}/${date.year}",
              style: GoogleFonts.poppins( // Ganti Font Tanggal
                color: date == null ? Colors.grey : primaryPink,
                fontSize: 12,
                fontWeight: date == null ? FontWeight.normal : FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchResult() {
    int neptu1 = _calculateNeptu(_selectedDate!);
    int neptu2 = _calculateNeptu(_partnerDate!);
    int total = neptu1 + neptu2;
    String hasil = _cekCocok(total);
    String desc = _getDeskripsi(hasil);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: secondaryPink,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Total Neptu: $total",
              style: GoogleFonts.poppins( // Ganti Font Total Neptu
                color: primaryPink,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 25),
          Text(
            "HASIL RAMALAN",
            style: GoogleFonts.poppins( // Ganti Font Label Hasil
              letterSpacing: 2,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            hasil,
            style: GoogleFonts.poppins( // Ganti Font Nama Hasil (Pegat, Jodoh, dll)
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: primaryPink,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins( // Ganti Font Deskripsi
              color: darkText, 
              fontSize: 14, 
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 25),
          const Divider(),
          const SizedBox(height: 10),
          Text(
            "*Hanya untuk hiburan semata ✨",
            style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.auto_awesome_outlined,
            size: 60,
            color: primaryPink.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 20),
          Text(
            "Lengkapi tanggal lahir kalian\nuntuk melihat hasil",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}