import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_button.dart';

class PvpSetupScreen extends StatefulWidget {
  const PvpSetupScreen({super.key});

  @override
  State<PvpSetupScreen> createState() => _PvpSetupScreenState();
}

class _PvpSetupScreenState extends State<PvpSetupScreen> {
  final _p1Controller = TextEditingController();
  final _p2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Stack(
            children: [
              // Background Stripes agar konsisten dengan Home
              _buildBackground(),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        "MATCH SETUP",
                        style: TextStyle(
                          color: AppColors.textTitle,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 60),
                      
                      _buildInputGroup("PLAYER 1", _p1Controller, Colors.redAccent),
                      
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Text(
                          "VS",
                          style: TextStyle(
                            color: AppColors.textTitle,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      
                      _buildInputGroup("PLAYER 2", _p2Controller, Colors.blueAccent),
                      
                      const SizedBox(height: 80),
                      
                      CustomButton(
                        title: "PLAY",
                        subtitle: "Start Local Match",
                        icon: const Icon(Icons.play_arrow, color: Colors.white, size: 30),
                        onTap: () {
                          // Logic navigasi ke board temanmu
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Row(
      children: [
        Expanded(child: Container(color: AppColors.background)),
        Expanded(child: Container(color: const Color(0xFF4E342E))),
        Expanded(child: Container(color: const Color(0xFF2E3D33))),
        Expanded(child: Container(color: const Color(0xFF4E342E))),
        Expanded(child: Container(color: AppColors.background)),
      ],
    );
  }

  Widget _buildInputGroup(String label, TextEditingController controller, Color accent) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: accent, fontWeight: FontWeight.bold, letterSpacing: 2)),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black.withOpacity(0.3),
            hintText: "Enter Name",
            hintStyle: const TextStyle(color: Colors.white24),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: accent, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: accent, width: 3),
            ),
          ),
        ),
      ],
    );
  }
}