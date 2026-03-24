import 'package:flutter/material.dart';
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
  static const Color accentBrown = Color(0xFF8D6E63);

  // FITUR BARU: Mendapatkan Zodiak
  Map<String, String> _getZodiac(DateTime date) {
    int d = date.day;
    int m = date.month;

    if ((m == 3 && d >= 21) || (m == 4 && d <= 19)) {
      return {'name': 'Aries', 'icon': '♈'};
    }
    if ((m == 4 && d >= 20) || (m == 5 && d <= 20)) {
      return {'name': 'Taurus', 'icon': '♉'};
    }
    if ((m == 5 && d >= 21) || (m == 6 && d <= 20)) {
      return {'name': 'Gemini', 'icon': '♊'};
    }
    if ((m == 6 && d >= 21) || (m == 7 && d <= 22)) {
      return {'name': 'Cancer', 'icon': '♋'};
    }
    if ((m == 7 && d >= 23) || (m == 8 && d <= 22)) {
      return {'name': 'Leo', 'icon': '♌'};
    }
    if ((m == 8 && d >= 23) || (m == 9 && d <= 22)) {
      return {'name': 'Virgo', 'icon': '♍'};
    }
    if ((m == 9 && d >= 23) || (m == 10 && d <= 22)) {
      return {'name': 'Libra', 'icon': '♎'};
    }
    if ((m == 10 && d >= 23) || (m == 11 && d <= 21)) {
      return {'name': 'Scorpio', 'icon': '♏'};
    }
    if ((m == 11 && d >= 22) || (m == 12 && d <= 21)) {
      return {'name': 'Sagittarius', 'icon': '♐'};
    }
    if ((m == 12 && d >= 22) || (m == 1 && d <= 19)) {
      return {'name': 'Capricorn', 'icon': '♑'};
    }
    if ((m == 1 && d >= 20) || (m == 2 && d <= 18)) {
      return {'name': 'Aquarius', 'icon': '♒'};
    }
    return {'name': 'Pisces', 'icon': '♓'};
  }

  Map<String, dynamic> _getWetonData(DateTime date) {
    const pasaran = ['Pahing', 'Pon', 'Wage', 'Kliwon', 'Legi'];
    const hari = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    const nHari = {
      'Senin': 4,
      'Selasa': 3,
      'Rabu': 7,
      'Kamis': 8,
      'Jumat': 6,
      'Sabtu': 9,
      'Minggu': 5,
    };
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
      final h = HijriCalendar.fromDate(
        DateTime(date.year, date.month, date.day),
      );
      const bulanIndo = [
        "Muharram",
        "Safar",
        "Rabi'ul Awwal",
        "Rabi'ul Akhir",
        "Jumadil Awwal",
        "Jumadil Akhir",
        "Rajab",
        "Sya'ban",
        "Ramadhan",
        "Syawwal",
        "Dzulqa'dah",
        "Dzulhijjah",
      ];
      return "${h.hDay} ${bulanIndo[h.hMonth - 1]} ${h.hYear} H";
    } catch (e) {
      return "Gagal menghitung";
    }
  }

  Map<String, int> _calculateAge(DateTime birthDate, TimeOfDay time) {
    final now = DateTime.now();
    final birth = DateTime(
      birthDate.year,
      birthDate.month,
      birthDate.day,
      time.hour,
      time.minute,
    );
    int y = now.year - birth.year;
    int m = now.month - birth.month;
    int d = now.day - birth.day;
    int h = now.hour - birth.hour;
    int min = now.minute - birth.minute;
    if (min < 0) {
      min += 60;
      h--;
    }
    if (h < 0) {
      h += 24;
      d--;
    }
    if (d < 0) {
      d += DateTime(now.year, now.month, 0).day;
      m--;
    }
    if (m < 0) {
      m += 12;
      y--;
    }
    return {'y': y, 'm': m, 'd': d, 'h': h, 'min': min};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softPink,
      appBar: AppBar(
        title: const Text(
          "Kalkulator Tanggal ✨",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: cutePink,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInputSection(),
            const SizedBox(height: 25),
            if (_selectedDate != null && _selectedTime != null) ...[
              _buildWetonCard(),
              _buildZodiacCard(), // Menampilkan Zodiak
              _buildResultCard(
                "Kalender Hijriyah",
                _formatHijri(_selectedDate!),
                Icons.mosque_outlined,
              ),
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Input Data Kelahiran",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: accentBrown,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: Text(
                    _selectedDate == null
                        ? "Tanggal"
                        : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: deepPink,
                    side: const BorderSide(color: cutePink),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickTime,
                  icon: const Icon(Icons.access_time, size: 18),
                  label: Text(
                    _selectedTime == null
                        ? "Waktu"
                        : _selectedTime!.format(context),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: deepPink,
                    side: const BorderSide(color: cutePink),
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
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: softPink,
          child: Text(zodiac['icon']!, style: const TextStyle(fontSize: 20)),
        ),
        title: const Text(
          "Zodiak",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        subtitle: Text(
          zodiac['name']!,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildWetonCard() {
    final wetonData = _getWetonData(_selectedDate!);
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [cutePink, deepPink]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Hari & Weton",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                wetonData['full'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  "Neptu",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                Text(
                  "${wetonData['neptu']}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(String title, String value, IconData icon) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: softPink,
          child: Icon(icon, color: deepPink),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildAgeSection() {
    final age = _calculateAge(_selectedDate!, _selectedTime!);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            "Analisis Umur Precise",
            style: TextStyle(fontWeight: FontWeight.bold, color: accentBrown),
          ),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ageCircle(age['y']!, "Thn"),
              _ageCircle(age['m']!, "Bln"),
              _ageCircle(age['d']!, "Hari"),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "Sudah hidup selama ${age['h']} jam dan ${age['min']} menit",
            style: const TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ageCircle(int value, String label) {
    return Column(
      children: [
        Text(
          "$value",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: deepPink,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: accentBrown)),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      children: [
        const SizedBox(height: 50),
        Icon(
          Icons.auto_awesome,
          size: 80,
          color: cutePink.withValues(alpha: 0.5),
        ),
        const SizedBox(height: 10),
        const Text(
          "Pilih tanggal kelahiranmu di atas ✨",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) setState(() => _selectedTime = time);
  }
}
