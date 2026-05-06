import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import 'bot_match_screen.dart';
import '../services/game_audio.dart';
import '../services/player_profile_service.dart';

class BotSetupScreen extends StatefulWidget {
  const BotSetupScreen({super.key});

  @override
  State<BotSetupScreen> createState() => _BotSetupScreenState();
}

class _BotSetupScreenState extends State<BotSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  int _selectedLevel = 0;

  static const List<_BotLevel> _levels = [
    _BotLevel(
      number: 1,
      title: 'Level 1',
      subtitle: 'Tutorial Match',
      difficulty: 'EASY',
      badgeColor: Color(0xFF9AAC63),
      depth: 1,
      errorChance: 0.0,
    ),
    _BotLevel(
      number: 2,
      title: 'Level 2',
      subtitle: 'First Alignment',
      difficulty: 'MEDIUM',
      badgeColor: Color(0xFFD2B35A),
      depth: 2,
      errorChance: 0.30,
    ),
    _BotLevel(
      number: 3,
      title: 'Level 3',
      subtitle: 'Hidden Move',
      difficulty: 'HARD',
      badgeColor: Color(0xFFD98462),
      depth: 2,
      errorChance: 0.00,
    ),
    _BotLevel(
      number: 4,
      title: 'Level 4',
      subtitle: 'Royal Lelempeungan',
      difficulty: 'EXPERT',
      badgeColor: Color(0xFF9B7ED5),
      depth: 3,
      errorChance: 0.0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadPlayerProfile();
  }

  Future<void> _loadPlayerProfile() async {
    final playerName = await PlayerProfileService.getPlayerName();

    if (!mounted) return;

    if (_nameController.text.trim().isEmpty) {
      _nameController.text = playerName;
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }


  void _onStartGame() {
    FocusScope.of(context).unfocus();
    HapticFeedback.mediumImpact();
    GameAudio.playClick();

    final playerName = _nameController.text.trim().isEmpty
        ? 'Player'
        : _nameController.text.trim();

    final level = _levels[_selectedLevel];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BotMatchScreen(
          playerName: playerName,
          botName: 'Akang GREG',
          botDepth: level.depth,
          botErrorChance: level.errorChance,
          difficultyLabel: level.difficulty,
          levelTitle: level.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF1D1B1F),
      body: MediaQuery.removeViewInsets(
        context: context,
        removeBottom: true,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Stack(
                children: [
                  const _BackgroundStripes(),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF4D180C),
                              Color(0xFF692612),
                              Color(0xFF4A1308),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF9E5B2E),
                            width: 1.4,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 14,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            const Positioned.fill(
                              child: _CornerDecorations(),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      _BackButtonCircle(
                                        onTap: () => Navigator.pop(context),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF74311C),
                                                borderRadius:
                                                BorderRadius.circular(14),
                                                border: Border.all(
                                                  color: const Color(0xFFD8A15C),
                                                  width: 1.2,
                                                ),
                                              ),
                                              child: const Text(
                                                'Akang GREG',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: AppColors.textTitle,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 26,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF874122),
                                                borderRadius:
                                                BorderRadius.circular(999),
                                                border: Border.all(
                                                  color: const Color(0xFFD8A15C),
                                                  width: 1,
                                                ),
                                              ),
                                              child: const Text(
                                                'BOT MODE',
                                                style: TextStyle(
                                                  color: Color(0xFFF0D8B4),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w800,
                                                  letterSpacing: 0.7,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 36),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  Stack(
                                    children: [
                                      Container(
                                        width: 78,
                                        height: 78,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color(0xFFF0D8B4),
                                            width: 2,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.person,
                                          size: 44,
                                          color: Color(0xFFF0D8B4),
                                        ),
                                      ),
                                      const Positioned(
                                        right: 2,
                                        bottom: 2,
                                        child: Icon(
                                          Icons.edit_outlined,
                                          size: 18,
                                          color: Color(0xFFD8A15C),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  Container(
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 6,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: TextField(
                                      controller: _nameController,
                                      focusNode: _nameFocusNode,
                                      textInputAction: TextInputAction.done,
                                      onSubmitted: (_) {
                                        FocusScope.of(context).unfocus();
                                      },
                                      style: const TextStyle(
                                        color: Color(0xFF4B2A1C),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Enter your name...',
                                        hintStyle: const TextStyle(
                                          color: Color(0xFFA79083),
                                          fontWeight: FontWeight.w600,
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFFF1E7DD),
                                        contentPadding:
                                        const EdgeInsets.symmetric(
                                          horizontal: 18,
                                          vertical: 15,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 22),

                                  const _SectionTitle(title: 'LEVEL SELECT'),

                                  const SizedBox(height: 12),

                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0x332A0C05),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFFB47A42),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      children: List.generate(
                                        _levels.length,
                                            (index) {
                                          final level = _levels[index];
                                          final selected = _selectedLevel == index;

                                          return Padding(
                                            padding: EdgeInsets.only(
                                              bottom: index == _levels.length - 1
                                                  ? 0
                                                  : 8,
                                            ),
                                            child: _LevelCard(
                                              level: level,
                                              selected: selected,
                                              onTap: () {
                                                HapticFeedback.selectionClick();
                                                GameAudio.playClick();
                                                setState(() {
                                                  _selectedLevel = index;
                                                });
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 22),

                                  const _LegendTitle(
                                    title: 'DIFFICULTY LEGEND',
                                  ),

                                  const SizedBox(height: 12),

                                  const Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 20,
                                    runSpacing: 10,
                                    children: [
                                      _LegendItem(
                                        color: Color(0xFF9AAC63),
                                        label: 'Easy',
                                        shape: _LegendShape.circle,
                                      ),
                                      _LegendItem(
                                        color: Color(0xFFD2B35A),
                                        label: 'Medium',
                                        shape: _LegendShape.diamond,
                                      ),
                                      _LegendItem(
                                        color: Color(0xFFD98462),
                                        label: 'Hard',
                                        shape: _LegendShape.diamond,
                                      ),
                                      _LegendItem(
                                        color: Color(0xFF9B7ED5),
                                        label: 'Expert',
                                        shape: _LegendShape.diamond,
                                      ),
                                    ],
                                  ),

                                  const Spacer(),

                                  _StartGameButton(
                                    onTap: _onStartGame,
                                  ),

                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BackgroundStripes extends StatelessWidget {
  const _BackgroundStripes();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: ColoredBox(color: Color(0xFF2D1B14))),
        Expanded(child: ColoredBox(color: Color(0xFF4E342E))),
        Expanded(child: ColoredBox(color: Color(0xFF2E3D33))),
        Expanded(child: ColoredBox(color: Color(0xFF4E342E))),
        Expanded(child: ColoredBox(color: Color(0xFF2D1B14))),
      ],
    );
  }
}

class _CornerDecorations extends StatelessWidget {
  const _CornerDecorations();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: const [
            Positioned(top: 0, left: 0, child: _CornerMark(top: true, left: true)),
            Positioned(top: 0, right: 0, child: _CornerMark(top: true, left: false)),
            Positioned(bottom: 0, left: 0, child: _CornerMark(top: false, left: true)),
            Positioned(bottom: 0, right: 0, child: _CornerMark(top: false, left: false)),
          ],
        ),
      ),
    );
  }
}

class _CornerMark extends StatelessWidget {
  final bool top;
  final bool left;

  const _CornerMark({
    required this.top,
    required this.left,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 34,
      child: CustomPaint(
        painter: _CornerPainter(
          top: top,
          left: left,
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final bool top;
  final bool left;

  _CornerPainter({
    required this.top,
    required this.left,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFB47A42)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();

    if (top && left) {
      path.moveTo(size.width, 0);
      path.lineTo(8, 0);
      path.quadraticBezierTo(0, 0, 0, 8);
      path.lineTo(0, size.height);
    } else if (top && !left) {
      path.moveTo(0, 0);
      path.lineTo(size.width - 8, 0);
      path.quadraticBezierTo(size.width, 0, size.width, 8);
      path.lineTo(size.width, size.height);
    } else if (!top && left) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height - 8);
      path.quadraticBezierTo(0, size.height, 8, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(size.width, size.height - 8);
      path.quadraticBezierTo(
        size.width,
        size.height,
        size.width - 8,
        size.height,
      );
      path.lineTo(0, size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BackButtonCircle extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButtonCircle({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () {
        HapticFeedback.lightImpact();
        GameAudio.playClick();
        onTap();
      },
      child: Ink(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: const Color(0xFF7B3B21),
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFD8A15C),
            width: 1.3,
          ),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          size: 16,
          color: Color(0xFFF0D8B4),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: Color(0xFFB47A42),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFFF0D8B4),
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: Color(0xFFB47A42),
            thickness: 1,
          ),
        ),
      ],
    );
  }
}

class _LevelCard extends StatelessWidget {
  final _BotLevel level;
  final bool selected;
  final VoidCallback onTap;

  const _LevelCard({
    required this.level,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF7A321C)
                : const Color(0x22000000),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? const Color(0xFFF0D8B4)
                  : const Color(0xFFB47A42),
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFD8A15C),
                    width: 1.2,
                  ),
                ),
                child: Text(
                  '${level.number}',
                  style: const TextStyle(
                    color: Color(0xFFF0D8B4),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      level.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      level.subtitle,
                      style: const TextStyle(
                        color: Color(0xFFE0C7B0),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: level.badgeColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  level.difficulty,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendTitle extends StatelessWidget {
  final String title;

  const _LegendTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFFF0D8B4),
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 1,
      ),
    );
  }
}

enum _LegendShape {
  circle,
  diamond,
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final _LegendShape shape;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.shape,
  });

  @override
  Widget build(BuildContext context) {
    Widget marker;

    if (shape == _LegendShape.circle) {
      marker = Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      );
    } else {
      marker = Transform.rotate(
        angle: 0.785398,
        child: Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: color,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        marker,
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFE8D6C4),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _StartGameButton extends StatefulWidget {
  final VoidCallback onTap;

  const _StartGameButton({
    required this.onTap,
  });

  @override
  State<_StartGameButton> createState() => _StartGameButtonState();
}

class _StartGameButtonState extends State<_StartGameButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) return;

    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isPressed ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 90),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            width: 270,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: _isPressed
                  ? const Color(0xFF7A321C)
                  : const Color(0xFF9B4D2D),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _isPressed
                    ? const Color(0xFFF0D8B4)
                    : const Color(0xFFD8A15C),
                width: _isPressed ? 2.4 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: _isPressed ? 4 : 8,
                  offset: Offset(0, _isPressed ? 2 : 4),
                ),
              ],
            ),
            child: const Text(
              'START GAME',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFF8E8D2),
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BotLevel {
  final int number;
  final String title;
  final String subtitle;
  final String difficulty;
  final Color badgeColor;
  final int depth;
  final double errorChance;

  const _BotLevel({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.difficulty,
    required this.badgeColor,
    required this.depth,
    required this.errorChance,
  });
}