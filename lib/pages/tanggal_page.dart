import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';

class KalkulatorTanggalPage extends StatefulWidget {
  const KalkulatorTanggalPage({super.key});

  @override
  State<KalkulatorTanggalPage> createState() => _KalkulatorTanggalPageState();
}

class _KalkulatorTanggalPageState extends State<KalkulatorTanggalPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  static const Color deepPink = Color(0xFFFF69B4);
  static const Color softPink = Color(0xFFFFE4E1);
  static const Color cutePink = Color(0xFFFFB6C1);
  final Color darkText = Colors.brown[800]!;

  Map<String, String> _getZodiac(DateTime date) {
    int d = date.day;
    int m = date.month;
    if ((m == 3 && d >= 21) || (m == 4 && d <= 19)) return {'name': 'Aries', 'icon': '♈'};
    if ((m == 4 && d >= 20) || (m == 5 && d <= 20)) return {'name': 'Taurus', 'icon': '♉'};
    if ((m == 5 && d >= 21) || (m == 6 && d <= 20)) return {'name': 'Gemini', 'icon': '♊'};
    if ((m == 6 && d >= 21) || (m == 7 && d <= 22)) return {'name': 'Cancer', 'icon': '♋'};
    if ((m == 7 && d >= 23) || (m == 8 && d <= 22)) return {'name': 'Leo', 'icon': '♌'};
    if ((m == 8 && d >= 23) || (m == 9 && d <= 22)) return {'name': 'Virgo', 'icon': '♍'};
    if ((m == 9 && d >= 23) || (m == 10 && d <= 22)) return {'name': 'Libra', 'icon': '♎'};
    if ((m == 10 && d >= 23) || (m == 11 && d <= 21)) return {'name': 'Scorpio', 'icon': '♏'};
    if ((m == 11 && d >= 22) || (m == 12 && d <= 21)) return {'name': 'Sagittarius', 'icon': '♐'};
    if ((m == 12 && d >= 22) || (m == 1 && d <= 19)) return {'name': 'Capricorn', 'icon': '♑'};
    if ((m == 1 && d >= 20) || (m == 2 && d <= 18)) return {'name': 'Aquarius', 'icon': '♒'};
    return {'name': 'Pisces', 'icon': '♓'};
  }

  Map<String, dynamic> _getWetonData(DateTime date) {
    const pasaran = ['Pahing', 'Pon', 'Wage', 'Kliwon', 'Legi'];
    const hari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    const nHari = {'Senin': 4, 'Selasa': 3, 'Rabu': 7, 'Kamis': 8, 'Jumat': 6, 'Sabtu': 9, 'Minggu': 5};
    const nPasaran = {'Pahing': 9, 'Pon': 7, 'Wage': 4, 'Kliwon': 8, 'Legi': 5};

    final start = DateTime.utc(1900, 1, 1);
    final target = DateTime.utc(date.year, date.month, date.day);
    final diff = target.difference(start).inDays;

    String hName = hari[diff % 7];
    String pName = pasaran[diff % 5];
    int jumlahNeptu = (nHari[hName] ?? 0) + (nPasaran[pName] ?? 0);

    return {'full': "$hName $pName", 'neptu': jumlahNeptu};
  }

  String _formatHijri(DateTime date) {
    try {
      HijriCalendar.setLocal('en');
      final h = HijriCalendar.fromDate(DateTime(date.year, date.month, date.day));
      const bulanIndo = ["Muharram", "Safar", "Rabi'ul Awwal", "Rabi'ul Akhir", "Jumadil Awwal", "Jumadil Akhir", "Rajab", "Sya'ban", "Ramadhan", "Syawwal", "Dzulqa'dah", "Dzulhijjah"];
      return "${h.hDay} ${bulanIndo[h.hMonth - 1]} ${h.hYear} H";
    } catch (e) { return "Gagal menghitung"; }
  }

  Map<String, int> _calculateAge(DateTime birthDate, TimeOfDay time) {
    final now = DateTime.now();
    final birth = DateTime(birthDate.year, birthDate.month, birthDate.day, time.hour, time.minute);
    int y = now.year - birth.year;
    int m = now.month - birth.month;
    int d = now.day - birth.day;
    int h = now.hour - birth.hour;
    int min = now.minute - birth.minute;
    if (min < 0) { min += 60; h--; }
    if (h < 0) { h += 24; d--; }
    if (d < 0) { d += DateTime(now.year, now.month, 0).day; m--; }
    if (m < 0) { m += 12; y--; }
    return {'y': y, 'm': m, 'd': d, 'h': h, 'min': min};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softPink,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Kalkulator Tanggal ✨",
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
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
            _buildInputSection(),
            const SizedBox(height: 25),
            if (_selectedDate != null && _selectedTime != null) ...[
              _buildWetonCard(),
              _buildZodiacCard(),
              _buildResultCard("Kalender Hijriyah", _formatHijri(_selectedDate!), Icons.mosque_outlined),
              _buildAgeSection(),
            ] else
              _buildPlaceholder(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Text("Input Data Kelahiran", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: darkText)),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: Text(_selectedDate == null ? "Tanggal" : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: deepPink, side: const BorderSide(color: cutePink),
                    textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickTime,
                  icon: const Icon(Icons.access_time, size: 18),
                  label: Text(_selectedTime == null ? "Waktu" : _selectedTime!.format(context)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: deepPink, side: const BorderSide(color: cutePink),
                    textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildZodiacCard() {
    final zodiac = _getZodiac(_selectedDate!);
    return _buildResultCard("Zodiak", zodiac['name']!, Icons.star_border_rounded, trailingIcon: zodiac['icon']);
  }

  Widget _buildWetonCard() {
    final wetonData = _getWetonData(_selectedDate!);
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [cutePink, deepPink]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: deepPink.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hari & Weton", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
              Text(wetonData['full'], style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Text("Neptu", style: GoogleFonts.poppins(color: Colors.white, fontSize: 10)),
                Text("${wetonData['neptu']}", style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(String title, String value, IconData icon, {String? trailingIcon}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: softPink, child: Icon(icon, color: deepPink)),
        title: Text(title, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
        subtitle: Text(value, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: darkText)),
        trailing: trailingIcon != null ? Text(trailingIcon, style: const TextStyle(fontSize: 24)) : null,
      ),
    );
  }

  Widget _buildAgeSection() {
    final age = _calculateAge(_selectedDate!, _selectedTime!);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: Column(
        children: [
          Text("Detail Usia Saat Ini", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: darkText)),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 15, runSpacing: 15,
            children: [
              _ageCircle(age['y']!, "Thn"), _ageCircle(age['m']!, "Bln"),
              _ageCircle(age['d']!, "Hari"), _ageCircle(age['h']!, "Jam"),
              _ageCircle(age['min']!, "Menit"),
            ],
          ),
          const Divider(height: 40),
          Text("Dihitung berdasarkan waktu lahir", style: GoogleFonts.poppins(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _ageCircle(int value, String label) {
    return SizedBox(
      width: 50,
      child: Column(
        children: [
          Text("$value", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: deepPink)),
          Text(label, style: GoogleFonts.poppins(fontSize: 11, color: Colors.brown[400])),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      children: [
        const SizedBox(height: 50),
        Icon(Icons.auto_awesome, size: 80, color: cutePink.withOpacity(0.5)),
        const SizedBox(height: 10),
        Text("Pilih tanggal kelahiranmu di atas ✨", style: GoogleFonts.poppins(color: Colors.grey)),
      ],
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime(2100),
      builder: (context, child) => Theme(data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: cutePink)), child: child!),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context, initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: cutePink)), child: child!),
    );
    if (time != null) setState(() => _selectedTime = time);
  }
}