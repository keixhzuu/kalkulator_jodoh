import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 
import '../pages/home_page.dart'; 

void main() {
  runApp(MaterialApp(home: LoginPage(), debugShowCheckedModeBanner: false));
}

class LoginController {
  final TextEditingController userLogin = TextEditingController();
  final TextEditingController passLogin = TextEditingController();

  void handleLogin(BuildContext context) {
    String username = userLogin.text;
    String password = passLogin.text;

    if (username.isEmpty || password.isEmpty) {
      _showSnackBar(
        context,
        "Username & password diisi dulu ya! 🌸",
        Colors.orangeAccent,
      );
      return;
    }

    if (username == "kalkulator" && password == "sugab") {
      _showSnackBar(
        context,
        "Berhasil masuk! Selamat datang ✨",
        Colors.pinkAccent,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      _showSnackBar(
        context,
        "Yah, username atau password salah 😭",
        Colors.redAccent,
      );
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins()), 
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final LoginController _auth = LoginController();

  final Color cutePink = const Color(0xFFFFB6C1);
  final Color softPink = const Color(0xFFFFE4E1);
  final Color deepPink = const Color(0xFFFF69B4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softPink,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: cutePink.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(Icons.favorite_rounded, size: 70, color: cutePink),
              ),
              const SizedBox(height: 25),
              Text(
                "Selamat Datang!",
                style: GoogleFonts.poppins( 
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[600],
                ),
              ),
              const SizedBox(height: 40),

              _buildInput(
                controller: _auth.userLogin,
                hint: "Username",
                icon: Icons.person_pin_rounded,
              ),
              const SizedBox(height: 15),

              _buildInput(
                controller: _auth.passLogin,
                hint: "Password",
                icon: Icons.auto_fix_high_rounded,
                isPass: true,
              ),
              const SizedBox(height: 30),

              GestureDetector(
                onTap: () => _auth.handleLogin(context),
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(colors: [cutePink, deepPink]),
                    boxShadow: [
                      BoxShadow(
                        color: deepPink.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "MASUK SEKARANG",
                      style: GoogleFonts.poppins( 
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPass = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPass,
        style: GoogleFonts.poppins(),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
          prefixIcon: Icon(icon, color: cutePink),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}