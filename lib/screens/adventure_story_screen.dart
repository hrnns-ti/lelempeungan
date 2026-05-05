import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import 'bot_match_screen.dart';

class AdventureStoryScreen extends StatelessWidget {
  final int chapterNumber;
  final String chapterTitle;
  final String chapterSubtitle;
  final String difficultyLabel;
  final Color badgeColor;
  final int botDepth;
  final double botErrorChance;
  final String imagePath;
  final String botName;

  const AdventureStoryScreen({
    super.key,
    required this.chapterNumber,
    required this.chapterTitle,
    required this.chapterSubtitle,
    required this.difficultyLabel,
    required this.badgeColor,
    required this.botDepth,
    required this.botErrorChance,
    required this.imagePath,
    required this.botName,
  });

  String get _storyModeTitle {
    return 'CHAPTER $chapterNumber STORY';
  }

  String get _imageTitle {
    switch (chapterNumber) {
      case 1:
        return 'Kampung Gaya';
      case 2:
        return 'Mount Tangkuban Parahu';
      case 3:
        return 'The Keeper Puzzle';
      case 4:
        return 'The Final Alignment';
      default:
        return 'Lelempengan Adventure';
    }
  }

  String get _storyText {
    switch (chapterNumber) {
      case 1:
        return 'In Kampung Gaya, the children of the village learn the ancient board game of Lelempengan from their elders. More than a game, Lelempengan is a lesson in patience, strategy, and togetherness. One day, the village keeper invites the young player to begin a journey through the heritage of Sunda. To continue, the player must win the first village challenge and prove an understanding of the game.';
      case 2:
        return 'After proving themselves in Kampung Gaya, the young players continue their journey toward Mount Tangkuban Parahu. Along the winding mountain path, they meet a guardian who teaches Lelempengan must be played with balance, courage, and careful thought. As the trail grows steeper, the players face a new challenge that tests their strategy and perseverance.';
      case 3:
        return 'The children visit the village keeper, who guards the wisdom of Lelempengan. He gives them a puzzle to solve using only six dots on the board. Every move has meaning, and every pattern teaches balance. By solving the keeper puzzle, the children discover that the deeper strategy behind the game is not just to win, but to think and respect each move.';
      case 4:
        return 'At the end of their journey, the children face the final alignment of Lelempengan. Under the guidance of the village elder, they must arrange the nine pieces in perfect harmony, showing patience, focus, and wisdom. This last challenge teaches that true mastery is not only about winning, but about understanding balance and respecting tradition.';
      default:
        return 'The journey of Lelempengan continues.';
    }
  }

  void _playChapter(BuildContext context) {
    HapticFeedback.mediumImpact();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BotMatchScreen(
          playerName: 'Player',
          botName: botName,
          botDepth: botDepth,
          botErrorChance: botErrorChance,
          difficultyLabel: difficultyLabel,
          levelTitle: 'Chapter $chapterNumber',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF1D1B1F),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Stack(
            children: [
              const _StoryBackground(),
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
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  _BackButtonCircle(
                                    onTap: () => Navigator.pop(context),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 9,
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
                                            'Lelempengan Adventure',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: AppColors.textTitle,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 7),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 5,
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
                                          child: Text(
                                            _storyModeTitle,
                                            style: const TextStyle(
                                              color: Color(0xFFF0D8B4),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 0.7,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 34),
                                ],
                              ),

                              const SizedBox(height: 18),

                              _ChapterImageCard(
                                imagePath: imagePath,
                                title: _imageTitle,
                              ),

                              const SizedBox(height: 16),

                              Expanded(
                                child: _StoryTextCard(
                                  chapterTitle: chapterTitle,
                                  chapterSubtitle: chapterSubtitle,
                                  difficultyLabel: difficultyLabel,
                                  badgeColor: badgeColor,
                                  storyText: _storyText,
                                  botName: botName,
                                ),
                              ),

                              const SizedBox(height: 16),

                              Row(
                                children: [
                                  Expanded(
                                    child: _BottomButton(
                                      label: 'BACK',
                                      onTap: () => Navigator.pop(context),
                                      filled: false,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    flex: 2,
                                    child: _BottomButton(
                                      label: 'PLAY CHAPTER',
                                      onTap: () => _playChapter(context),
                                      filled: true,
                                    ),
                                  ),
                                ],
                              ),
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
    );
  }
}

class _ChapterImageCard extends StatelessWidget {
  final String imagePath;
  final String title;

  const _ChapterImageCard({
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 245,
      decoration: BoxDecoration(
        color: const Color(0xFF5D2413),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD8A15C),
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  color: const Color(0xFF8B5B32),
                  child: const Center(
                    child: Icon(
                      Icons.image,
                      color: Color(0xFFF0D8B4),
                      size: 56,
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 10,
              left: 50,
              right: 50,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCC49B).withOpacity(0.86),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: const Color(0xFF8E5D2F),
                    width: 1,
                  ),
                ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF5B321C),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryTextCard extends StatelessWidget {
  final String chapterTitle;
  final String chapterSubtitle;
  final String difficultyLabel;
  final Color badgeColor;
  final String storyText;
  final String botName;

  const _StoryTextCard({
    required this.chapterTitle,
    required this.chapterSubtitle,
    required this.difficultyLabel,
    required this.badgeColor,
    required this.storyText,
    required this.botName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF4E2BF),
            Color(0xFFEBCB91),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFD8A15C),
          width: 1.6,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Divider(
                  color: Color(0xFFB98752),
                  thickness: 1.1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  chapterTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF3F2215),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Expanded(
                child: Divider(
                  color: Color(0xFFB98752),
                  thickness: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            chapterSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF4F2D1D),
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _StoryChip(
                label: 'Story',
                color: const Color(0xFFEAD4AD),
                textColor: const Color(0xFF6B3E23),
                borderColor: const Color(0xFFBC8B55),
              ),
              _StoryChip(
                label: 'Opponent: $botName',
                color: const Color(0xFFEAD4AD),
                textColor: const Color(0xFF6B3E23),
                borderColor: const Color(0xFFBC8B55),
              ),
              _StoryChip(
                label: difficultyLabel,
                color: badgeColor,
                textColor: Colors.white,
                borderColor: badgeColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8E8CD).withOpacity(0.72),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFFC99863),
                  width: 1,
                ),
              ),
              child: Scrollbar(
                thumbVisibility: true,
                radius: const Radius.circular(999),
                thickness: 3,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    storyText,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Color(0xFF4A2818),
                      fontSize: 13,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Local Culture of Sunda',
            style: TextStyle(
              color: Color(0xFF8B6A4B),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final Color borderColor;

  const _StoryChip({
    required this.label,
    required this.color,
    required this.textColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _BottomButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool filled;

  const _BottomButton({
    required this.label,
    required this.onTap,
    required this.filled,
  });

  @override
  State<_BottomButton> createState() => _BottomButtonState();
}

class _BottomButtonState extends State<_BottomButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;

    setState(() {
      _pressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.filled
        ? const Color(0xFF9B4D2D)
        : const Color(0xFF5D2413);

    final pressedColor = widget.filled
        ? const Color(0xFF7A321C)
        : const Color(0xFF4A180D);

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 90),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: _pressed ? pressedColor : color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
              _pressed ? const Color(0xFFF0D8B4) : const Color(0xFFD8A15C),
              width: _pressed ? 2.2 : 1.6,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: _pressed ? 4 : 7,
                offset: Offset(0, _pressed ? 2 : 4),
              ),
            ],
          ),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFF8E8D2),
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _StoryBackground extends StatelessWidget {
  const _StoryBackground();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
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
            Positioned(
              top: 0,
              left: 0,
              child: _CornerMark(top: true, left: true),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: _CornerMark(top: true, left: false),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: _CornerMark(top: false, left: true),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: _CornerMark(top: false, left: false),
            ),
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
      onTap: onTap,
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