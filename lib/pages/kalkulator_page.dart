import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KalkulatorPage extends StatefulWidget {
  const KalkulatorPage({super.key});

  @override
  State<KalkulatorPage> createState() => _KalkulatorPageState();
}

class _KalkulatorPageState extends State<KalkulatorPage> {
  String input = ""; 
  String hasil = "0"; 

  final Color cutePink = const Color(0xFFFFB6C1);
  final Color softPink = const Color(0xFFFFE4E1);
  final Color deepPink = const Color(0xFFFF69B4);

  void tekanTombol(String value) {
    setState(() {
      if ((value == "+" || value == "-") && 
          input.isNotEmpty && 
          (input.endsWith("+") || input.endsWith("-"))) {
        input = input.substring(0, input.length - 1) + value;
      } else {
        input += value;
      }
    });
  }

  void clear() {
    setState(() {
      input = "";
      hasil = "0";
    });
  }

  void hapusSatu() {
    setState(() {
      if (input.isNotEmpty) {
        input = input.substring(0, input.length - 1);
      }
    });
  }

  void hitung() {
    if (input.isEmpty) return;

    try {
      String ekspresi = input.replaceAll('-', '+-');
      List<String> parts = ekspresi.split('+');

      double total = 0;
      for (var part in parts) {
        if (part.trim().isNotEmpty) {
          total += double.parse(part.trim());
        }
      }

      setState(() {
        hasil = total % 1 == 0 ? total.toInt().toString() : total.toString();
      });
    } catch (e) {
      setState(() {
        hasil = "Error";
      });
    }
  }

  Widget tombol(String text, {Color? warna}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ElevatedButton(
          onPressed: () {
            if (text == "=") {
              hitung();
            } else if (text == "C") {
              clear();
            } else if (text == "DEL") {
              hapusSatu();
            } else {
              tekanTombol(text);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: warna ?? cutePink,
            padding: const EdgeInsets.symmetric(vertical: 22),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget baris(List<String> tombolList) {
    return Row(
      children: tombolList.map((t) {
        if (t == "+" || t == "-" || t == "=") {
          return tombol(t, warna: deepPink);
        } else if (t == "C" || t == "DEL") {
          return tombol(
            t,
            warna: t == "C" ? Colors.redAccent : Colors.orangeAccent,
          );
        }
        return tombol(t);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softPink,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Kalkulator Sugab ✨",
          style: GoogleFonts.poppins(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: cutePink,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    input.isEmpty ? "0" : input,
                    style: GoogleFonts.poppins(
                      fontSize: 24, 
                      color: Colors.brown[400],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    hasil,
                    style: GoogleFonts.poppins(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: Colors.brown[800],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                baris(["7", "8", "9", "C"]),
                baris(["4", "5", "6", "DEL"]),
                baris(["1", "2", "3", "-"]),
                baris(["0", ".", "+", "="]),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}