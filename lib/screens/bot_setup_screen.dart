import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_button.dart';

class BotSetupScreen extends StatefulWidget {
  const BotSetupScreen({super.key});

  @override
  State<BotSetupScreen> createState() => _BotSetupScreenState();
}

class _BotSetupScreenState extends State<BotSetupScreen> {
  int _selectedLevel = 0;
  final List<Map<String, String>> _levels = [
    {"name": "Level 1", "diff": "EASY"},
    {"name": "Level 2", "diff": "MEDIUM"},
    {"name": "Level 3", "diff": "HARD"},
    {"name": "Level 4", "diff": "EXPERT"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Stack(
            children: [
              _buildBackgroundStripes(),
              SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    const Text("Akang GREG", style: TextStyle(color: AppColors.textTitle, fontSize: 26, fontWeight: FontWeight.bold)),
                    const Text("BOT MODE", style: TextStyle(color: Colors.white60, fontSize: 12)),
                    const SizedBox(height: 40),
                    
                    const Text("SELECT LEVEL", style: TextStyle(color: AppColors.textTitle, fontWeight: FontWeight.bold, letterSpacing: 2)),
                    const SizedBox(height: 20),
                    
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        itemCount: _levels.length,
                        itemBuilder: (context, index) {
                          bool isSelected = _selectedLevel == index;
                          return _buildLevelCard(index, isSelected);
                        },
                      ),
                    ),
                    
                    CustomButton(
                      title: "START GAME",
                      subtitle: "Challenge the Bot",
                      icon: const Icon(Icons.bolt, color: Colors.orangeAccent, size: 35),
                      onTap: () {
                        // Logic start game
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCard(int index, bool isSelected) {
    String diff = _levels[index]["diff"]!;
    return GestureDetector(
      onTap: () => setState(() => _selectedLevel = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6D4C41) : AppColors.buttonBg,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isSelected ? Colors.white : AppColors.buttonBorder,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            if (isSelected) const BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          title: Text(_levels[index]["name"]!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          trailing: _buildBadge(diff),
        ),
      ),
    );
  }

  Widget _buildBadge(String diff) {
    Color color = diff == "EASY" ? Colors.green : (diff == "MEDIUM" ? Colors.orange : Colors.red);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Text(diff, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildBackgroundStripes() {
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
}