import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DataKelompok extends StatelessWidget {
  const DataKelompok({super.key});

  static const Color cutePink = Color(0xFFFFB6C1);
  static const Color softPink = Color(0xFFFFE4E1);
  static const Color deepPink = Color(0xFFFF69B4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softPink,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Anggota Kelompok ✨",
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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.stars_rounded, size: 50, color: deepPink),
            const SizedBox(height: 10),
            Text(
              "Meet Our Team!",
              style: GoogleFonts.poppins( 
                fontSize: 22,
                fontWeight: FontWeight.w800, 
                color: Colors.brown[600],
              ),
            ),
            const SizedBox(height: 25),
            
            _buildMemberCard("Melania Intan Sagita", "123230005"),
            _buildMemberCard("Fadilah Nur Sabiyyah", "123230006"),
            _buildMemberCard("Miftah Sari Nurjana", "123230022"),
            _buildMemberCard("Salsabila Rizky Setyabudi", "123230210"),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberCard(String nama, String nim) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cutePink.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: softPink,
            child: Icon(Icons.face_retouching_natural_rounded, color: deepPink),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: GoogleFonts.poppins( 
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[700],
                  ),
                ),
                Text(
                  "NIM: $nim",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
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