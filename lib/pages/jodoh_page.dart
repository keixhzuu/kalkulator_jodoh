import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KalkulatorJodohPage extends StatefulWidget {
  const KalkulatorJodohPage({super.key});

  @override
  State<KalkulatorJodohPage> createState() => _KalkulatorJodohPageState();
}

class _KalkulatorJodohPageState extends State<KalkulatorJodohPage> {
  DateTime? _selectedDate;
  DateTime? _partnerDate;

  // Palette warna disamakan dengan Kalkulator Sugab
  final Color cutePink = const Color(0xFFFFB6C1);
  final Color softPink = const Color(0xFFFFE4E1);
  final Color deepPink = const Color(0xFFFF69B4);
  final Color darkText = Colors.brown[800]!;

  int _calculateNeptu(DateTime date) {
    const nHari = {1: 4, 2: 3, 3: 7, 4: 8, 5: 6, 6: 9, 7: 5};
    const pasaran = [9, 7, 4, 8, 5];

    final start = DateTime.utc(1900, 1, 1);
    final target = DateTime.utc(date.year, date.month, date.day);
    final diff = target.difference(start).inDays;

    int nilaiH = nHari[date.weekday] ?? 0;
    int nilaiP = pasaran[diff % 5];

    return nilaiH + nilaiP;
  }

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
      backgroundColor: softPink, // Pakai warna background utama
      appBar: AppBar(
        title: Text(
          "Love Compatibility ✨",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: cutePink, // Header disamakan dengan Kalkulator
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            Text(
              "Cek kecocokan wetonmu dengan si dia",
              style: GoogleFonts.poppins(color: Colors.brown[400], fontSize: 13),
            ),
            const SizedBox(height: 30),

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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.favorite_rounded,
                    color: deepPink,
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
                colorScheme: ColorScheme.light(primary: cutePink),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: softPink,
              child: Icon(icon, color: deepPink, size: 35),
            ),
            const SizedBox(height: 15),
            Text(
              label,
              style: GoogleFonts.poppins(
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
              style: GoogleFonts.poppins(
                color: date == null ? Colors.grey : deepPink,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: softPink,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Total Neptu: $total",
              style: GoogleFonts.poppins(
                color: deepPink,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 25),
          Text(
            "HASIL RAMALAN",
            style: GoogleFonts.poppins(
              letterSpacing: 2,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            hasil,
            style: GoogleFonts.poppins(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: deepPink,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
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
            color: deepPink.withOpacity(0.3),
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