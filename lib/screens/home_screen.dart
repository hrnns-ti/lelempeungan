import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../services/game_audio.dart';
import '../widgets/custom_button.dart';
import '../widgets/settingan.dart';
import 'adventure_screen.dart';
import 'bot_setup_screen.dart';
import 'pvp_setup_screen.dart';
import '../widgets/player_profile_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Musik dimulai dari HomeScreen.
    // Tidak perlu dipanggil ulang di setiap screen.
    GameAudio.playBgm();
  }

  Future<void> _goToLocalMatch() async {
    GameAudio.playClick();

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PvpSetupScreen(),
      ),
    );
  }

  Future<void> _goToBotSetup() async {
    GameAudio.playClick();

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BotSetupScreen(),
      ),
    );
  }

  Future<void> _goToAdventure() async {
    GameAudio.playClick();

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AdventureScreen(),
      ),
    );
  }

  Future<void> _openSettings() async {
    GameAudio.playClick();

    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (context) => const SettingsDialog(),
    );

    if (!mounted) return;

    setState(() {});
  }

  Future<void> _openProfile() async {
    GameAudio.playClick();

    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (context) => const PlayerProfileDialog(),
    );

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Stack(
            children: [
              _buildBackgroundStripes(),
              _buildDecorativeClouds(),
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

                              const Icon(
                                Icons.temple_hindu_outlined,
                                color: AppColors.textTitle,
                                size: 60,
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'LELEMPEUNGAN',
                                style: TextStyle(
                                  color: AppColors.textTitle,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w200,
                                  letterSpacing: 6,
                                ),
                              ),
                              _buildDivider(),
                              const Text(
                                'Local Culture Of Sunda',
                                style: TextStyle(
                                  color: AppColors.textTitle,
                                  fontSize: 11,
                                  letterSpacing: 2,
                                ),
                              ),

                              const SizedBox(height: 40),

                              const Icon(
                                Icons.groups_outlined,
                                color: AppColors.frameColor,
                                size: 130,
                              ),

                              const SizedBox(height: 40),

                              CustomButton(
                                title: 'Local Match',
                                subtitle: '(Player vs Player)',
                                icon: const Icon(
                                  Icons.radio_button_checked,
                                  color: Colors.red,
                                  size: 35,
                                ),
                                onTap: _goToLocalMatch,
                              ),

                              CustomButton(
                                title: 'v. AI',
                                subtitle: 'Challenge The Bot Akang Greg',
                                icon: const Icon(
                                  Icons.smart_toy_outlined,
                                  color: AppColors.textTitle,
                                  size: 35,
                                ),
                                onTap: _goToBotSetup,
                              ),

                              CustomButton(
                                title: 'Lelempeungan Adventure',
                                subtitle: 'Story Mode',
                                icon: const Icon(
                                  Icons.menu_book,
                                  color: Colors.orangeAccent,
                                  size: 30,
                                ),
                                onTap: _goToAdventure,
                              ),

                              const Spacer(),

                              _buildBottomNav(),
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
    return const Stack(
      children: [
        Positioned(
          top: 60,
          left: -20,
          child: Icon(
            Icons.cloud_queue,
            color: Colors.white24,
            size: 80,
          ),
        ),
        Positioned(
          top: 150,
          right: -10,
          child: Icon(
            Icons.cloud_queue,
            color: Colors.white24,
            size: 100,
          ),
        ),
        Positioned(
          top: 400,
          left: -30,
          child: Icon(
            Icons.cloud_queue,
            color: Colors.white10,
            size: 120,
          ),
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

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
              color: AppColors.textTitle,
              size: 42,
            ),
            onPressed: _openProfile,
          ),
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: AppColors.textTitle,
              size: 38,
            ),
            onPressed: _openSettings,
          ),
        ],
      ),
    );
  }
}