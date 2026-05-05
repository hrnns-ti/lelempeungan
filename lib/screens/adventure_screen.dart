import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import 'adventure_story_screen.dart';

class AdventureScreen extends StatefulWidget {
  const AdventureScreen({super.key});

  @override
  State<AdventureScreen> createState() => _AdventureScreenState();
}

class _AdventureScreenState extends State<AdventureScreen> {
  int _selectedChapterIndex = 0;

  static const List<_AdventureChapter> _chapters = [
    _AdventureChapter(
      number: 1,
      title: 'Chapter 1',
      subtitle: 'The Village Challenge',
      difficulty: 'EASY',
      badgeColor: Color(0xFF9AAC63),
      depth: 1,
      errorChance: 0.0,
      imagePath: 'assets/images/Chapter_1.png',
      botName: 'Ki Lurah Gaya',
      unlocked: true,
    ),
    _AdventureChapter(
      number: 2,
      title: 'Chapter 2',
      subtitle: 'The Mountain Path',
      difficulty: 'MEDIUM',
      badgeColor: Color(0xFFD2B35A),
      depth: 2,
      errorChance: 0.30,
      imagePath: 'assets/images/Chapter_2.png',
      botName: 'Juru Kunci Parahu',
      unlocked: true,
    ),
    _AdventureChapter(
      number: 3,
      title: 'Chapter 3',
      subtitle: 'The Keeper Puzzle',
      difficulty: 'HARD',
      badgeColor: Color(0xFFD98462),
      depth: 2,
      errorChance: 0.0,
      imagePath: 'assets/images/Chapter_3.png',
      botName: 'Ki Penjaga Papan',
      unlocked: true,
    ),
    _AdventureChapter(
      number: 4,
      title: 'Chapter 4',
      subtitle: 'The Final Alignment',
      difficulty: 'EXPERT',
      badgeColor: Color(0xFF9B7ED5),
      depth: 3,
      errorChance: 0.0,
      imagePath: 'assets/images/Chapter_4.png',
      botName: 'Ki Sepuh',
      unlocked: true,
    ),
    _AdventureChapter(
      number: 5,
      title: 'Chapter 5',
      subtitle: 'Coming Soon',
      difficulty: 'LOCKED',
      badgeColor: Color(0xFF7A6A60),
      depth: 3,
      errorChance: 0.0,
      imagePath: 'assets/images/Chapter_4.png',
      botName: 'Unknown',
      unlocked: false,
    ),
    _AdventureChapter(
      number: 6,
      title: 'Chapter 6',
      subtitle: 'Coming Soon',
      difficulty: 'LOCKED',
      badgeColor: Color(0xFF7A6A60),
      depth: 3,
      errorChance: 0.0,
      imagePath: 'assets/images/Chapter_4.png',
      botName: 'Unknown',
      unlocked: false,
    ),
  ];

  void _openChapter(_AdventureChapter chapter) {
    if (!chapter.unlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chapter ini masih terkunci.'),
          backgroundColor: Color(0xFF7A4A2B),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),

        ),
      );
      return;
    }

    HapticFeedback.mediumImpact();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdventureStoryScreen(
          chapterNumber: chapter.number,
          chapterTitle: chapter.title,
          chapterSubtitle: chapter.subtitle,
          difficultyLabel: chapter.difficulty,
          badgeColor: chapter.badgeColor,
          botDepth: chapter.depth,
          botErrorChance: chapter.errorChance,
          imagePath: chapter.imagePath,
          botName: chapter.botName,        ),
      ),
    );
  }

  void _onChapterTap(int index) {
    HapticFeedback.selectionClick();

    final chapter = _chapters[index];

    if (!chapter.unlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chapter ini masih terkunci.'),
          backgroundColor: Color(0xFF7A4A2B),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _selectedChapterIndex = index;
    });
  }

  void _onStartAdventure() {
    final chapter = _chapters[_selectedChapterIndex];
    _openChapter(chapter);
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
              const _AdventureBackground(),
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
                                          child: const Text(
                                            'STORY MODE',
                                            style: TextStyle(
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

                              const SizedBox(height: 16),

                              _MapPreview(
                                selectedChapter:
                                _chapters[_selectedChapterIndex],
                              ),

                              const SizedBox(height: 14),

                              const _SectionTitle(title: 'STORY LINE'),

                              const SizedBox(height: 10),

                              Expanded(
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  radius: const Radius.circular(999),
                                  thickness: 4,
                                  child: ListView.separated(
                                    padding: const EdgeInsets.only(
                                      right: 4,
                                      bottom: 6,
                                    ),
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: _chapters.length,
                                    separatorBuilder: (_, __) =>
                                    const SizedBox(height: 8),
                                    itemBuilder: (context, index) {
                                      final chapter = _chapters[index];

                                      return _ChapterTile(
                                        chapter: chapter,
                                        selected:
                                        _selectedChapterIndex == index,
                                        onTap: () => _onChapterTap(index),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              const _LegendTitle(
                                title: 'DIFFICULTY LEGEND',
                              ),

                              const SizedBox(height: 10),

                              const Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 18,
                                runSpacing: 8,
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

                              const SizedBox(height: 18),

                              _StartAdventureButton(
                                label: 'START ADVENTURE',
                                onTap: _onStartAdventure,
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

class _MapPreview extends StatelessWidget {
  final _AdventureChapter selectedChapter;

  const _MapPreview({
    required this.selectedChapter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFF5D2413),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFB47A42),
          width: 1.4,
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
        borderRadius: BorderRadius.circular(9),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/Map.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  color: const Color(0xFF8B5B32),
                  child: const Center(
                    child: Icon(
                      Icons.map,
                      color: Color(0xFFF0D8B4),
                      size: 56,
                    ),
                  ),
                );
              },
            ),
            Container(
              color: Colors.black.withOpacity(0.08),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;

                final positions = <Offset>[
                  Offset(w * 0.32, h * 0.26), // Chapter 1
                  Offset(w * 0.40, h * 0.42), // Chapter 2
                  Offset(w * 0.46, h * 0.60), // Chapter 3
                  Offset(w * 0.60, h * 0.72), // Chapter 4
                  Offset(w * 0.50, h * 0.82), // Chapter 5
                  Offset(w * 0.40, h * 1.02), // Chapter 6
                ];

                return Stack(
                  children: List.generate(6, (index) {
                    final position = positions[index];
                    final isSelected = selectedChapter.number == index + 1;

                    return Positioned(
                      left: position.dx - 17,
                      top: position.dy - 17,
                      child: _MapNode(
                        number: index + 1,
                        selected: isSelected,
                        locked: index >= 4,
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MapNode extends StatelessWidget {
  final int number;
  final bool selected;
  final bool locked;

  const _MapNode({
    required this.number,
    required this.selected,
    required this.locked,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: selected ? 1.14 : 1.0,
      duration: const Duration(milliseconds: 160),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: locked ? const Color(0xFF5A5147) : const Color(0xFF8B4325),
          shape: BoxShape.circle,
          border: Border.all(
            color: selected
                ? const Color(0xFFF8E8D2)
                : const Color(0xFFD8A15C),
            width: selected ? 2.2 : 1.2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: locked
              ? const Icon(
            Icons.lock,
            color: Color(0xFFF8E8D2),
            size: 15,
          )
              : Text(
            '$number',
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

class _ChapterTile extends StatelessWidget {
  final _AdventureChapter chapter;
  final bool selected;
  final VoidCallback onTap;

  const _ChapterTile({
    required this.chapter,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = !chapter.unlocked;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
          child: Opacity(
            opacity: disabled ? 0.55 : 1,
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFD8A15C),
                      width: 1.2,
                    ),
                  ),
                  child: Icon(
                    disabled ? Icons.lock : Icons.temple_buddhist,
                    color: const Color(0xFFF0D8B4),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chapter.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        chapter.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFE0C7B0),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 64,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: chapter.badgeColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    chapter.difficulty,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  disabled ? Icons.lock : Icons.chevron_right,
                  color: const Color(0xFFF0D8B4),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StartAdventureButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _StartAdventureButton({
    required this.label,
    required this.onTap,
  });

  @override
  State<_StartAdventureButton> createState() => _StartAdventureButtonState();
}

class _StartAdventureButtonState extends State<_StartAdventureButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;

    setState(() {
      _pressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: 270,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: _pressed
                ? const Color(0xFF7A321C)
                : const Color(0xFF9B4D2D),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _pressed
                  ? const Color(0xFFF0D8B4)
                  : const Color(0xFFD8A15C),
              width: _pressed ? 2.4 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: _pressed ? 4 : 8,
                offset: Offset(0, _pressed ? 2 : 4),
              ),
            ],
          ),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFF8E8D2),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _AdventureBackground extends StatelessWidget {
  const _AdventureBackground();

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
        fontSize: 11,
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
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _AdventureChapter {
  final int number;
  final String title;
  final String subtitle;
  final String difficulty;
  final Color badgeColor;
  final int depth;
  final double errorChance;
  final String imagePath;
  final String botName;
  final bool unlocked;

  const _AdventureChapter({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.difficulty,
    required this.badgeColor,
    required this.depth,
    required this.errorChance,
    required this.imagePath,
    required this.botName,
    required this.unlocked,
  });
}