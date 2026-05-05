import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/settingan.dart';
import 'pvp_setup_screen.dart';
import 'bot_setup_screen.dart';
import 'adventure_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          // Membatasi lebar agar tetap estetik di Web/Desktop (Hybrid)
          constraints: const BoxConstraints(maxWidth: 500),
          child: Stack(
            children: [
              // 1. Background Bergaris (Base Layer)
              _buildBackgroundStripes(),

              // 2. Elemen Dekoratif Awan (Sesuai Figma)
              _buildDecorativeClouds(),

              // 3. Konten Utama yang bisa di-scroll
              SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              const SizedBox(height: 30),
                              // Header: Ikon Atap & Judul
                              const Icon(
                                Icons.temple_hindu_outlined,
                                color: AppColors.textTitle,
                                size: 60,
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                "LELEMPEUNGAN",
                                style: TextStyle(
                                  color: AppColors.textTitle,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w200,
                                  letterSpacing: 6,
                                ),
                              ),
                              _buildDivider(),
                              const Text(
                                "Local Culture Of Sunda",
                                style: TextStyle(
                                  color: AppColors.textTitle,
                                  fontSize: 11,
                                  letterSpacing: 2,
                                ),
                              ),

                              const SizedBox(height: 40),
                              // Placeholder Gambar Karakter (Mockup Tengah)
                              const Icon(
                                Icons.groups_outlined,
                                color: AppColors.frameColor,
                                size: 130,
                              ),
                              const SizedBox(height: 40),

                              // Daftar Tombol Menu
                              CustomButton(
                                title: "Local Match",
                                subtitle: "(Player vs Player)",
                                icon: const Icon(
                                  Icons.radio_button_checked,
                                  color: Colors.red,
                                  size: 35,
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PvpSetupScreen(),
                                  ),
                                ),
                              ),

                              CustomButton(
                                title: "v. AI",
                                subtitle: "Challenge The Bot Akang Greg",
                                icon: const Icon(
                                  Icons.smart_toy_outlined,
                                  color: AppColors.textTitle,
                                  size: 35,
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const BotSetupScreen(),
                                  ),
                                ),
                              ),

                              CustomButton(
                                title: "Lelempeungan Adventure",
                                subtitle: "Story Mode",
                                icon: const Icon(
                                  Icons.menu_book,
                                  color: Colors.orangeAccent,
                                  size: 30,
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AdventureScreen(),
                                  ),
                                ),
                              ),

                              // Mendorong Bottom Bar ke bawah tanpa menyebabkan overflow
                              const Spacer(),

                              // 4. Bottom Navigation Berfungsi
                              _buildFunctionalBottomNav(context),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundStripes() {
    return Row(
      children: [
        Expanded(child: Container(color: AppColors.stripe1)),
        Expanded(child: Container(color: AppColors.stripe2)),
        Expanded(child: Container(color: AppColors.stripe3)),
        Expanded(child: Container(color: AppColors.stripe2)),
        Expanded(child: Container(color: AppColors.stripe1)),
      ],
    );
  }

  Widget _buildDecorativeClouds() {
    return Stack(
      children: const [
        Positioned(
          top: 60,
          left: -20,
          child: Icon(Icons.cloud_queue, color: Colors.white24, size: 80),
        ),
        Positioned(
          top: 150,
          right: -10,
          child: Icon(Icons.cloud_queue, color: Colors.white24, size: 100),
        ),
        Positioned(
          top: 400,
          left: -30,
          child: Icon(Icons.cloud_queue, color: Colors.white10, size: 120),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 8),
      height: 1,
      color: AppColors.textTitle.withOpacity(0.4),
    );
  }

  Widget _buildFunctionalBottomNav(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(
              Icons.volume_up_outlined,
              color: AppColors.textTitle,
              size: 35,
            ),
            onPressed: () => print("Mute/Unmute Suara"),
          ),
          IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
              color: AppColors.textTitle,
              size: 40,
            ),
            onPressed: () => print("Buka Profil Player"),
          ),
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: AppColors.textTitle,
              size: 35,
            ),
            onPressed: () {
              // Memunculkan pop-up settings yang sudah kita buat sebelumnya
              showDialog(
                context: context,
                builder: (context) => const SettingsDialog(),
              );
            },
          ),
        ],
      ),
    );
  }
}
