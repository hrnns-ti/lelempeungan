import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import 'local_match_screen.dart';

class PvpSetupScreen extends StatefulWidget {
  const PvpSetupScreen({super.key});

  @override
  State<PvpSetupScreen> createState() => _PvpSetupScreenState();
}

class _PvpSetupScreenState extends State<PvpSetupScreen> {
  final TextEditingController _p1Controller = TextEditingController();
  final TextEditingController _p2Controller = TextEditingController();

  final FocusNode _p1FocusNode = FocusNode();
  final FocusNode _p2FocusNode = FocusNode();

  @override
  void dispose() {
    _p1Controller.dispose();
    _p2Controller.dispose();
    _p1FocusNode.dispose();
    _p2FocusNode.dispose();
    super.dispose();
  }

  void _onBack() {
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }

  void _onPlayGame() {
    FocusScope.of(context).unfocus();

    final player1 = _p1Controller.text.trim().isEmpty
        ? 'Player 1'
        : _p1Controller.text.trim();

    final player2 = _p2Controller.text.trim().isEmpty
        ? 'Player 2'
        : _p2Controller.text.trim();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return LocalMatchScreen(
            player1Name: player1,
            player2Name: player2,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      body: MediaQuery.removeViewInsets(
        context: context,
        removeBottom: true,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Stack(
                children: [
                  const RepaintBoundary(
                    child: _StaticSetupBackground(),
                  ),

                  Align(
                    alignment: const Alignment(0, -0.28),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: _buildMainPanel(),
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

  Widget _buildMainPanel() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 54, 18, 26),
          decoration: BoxDecoration(
            color: const Color(0xFFBB8951),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: const Color(0xFFD8A15C),
              width: 4,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0xAA6C4128),
                blurRadius: 0,
                offset: Offset(0, 7),
              ),
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPlayerSection(
                title: 'Player 1',
                controller: _p1Controller,
                focusNode: _p1FocusNode,
                nextFocusNode: _p2FocusNode,
                number: '1',
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 22),
              _buildVsSection(),
              const SizedBox(height: 22),
              _buildPlayerSection(
                title: 'Player 2',
                controller: _p2Controller,
                focusNode: _p2FocusNode,
                nextFocusNode: null,
                number: '2',
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      label: 'BACK',
                      onTap: _onBack,
                      isPrimary: false,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildActionButton(
                      label: 'PLAY\nGAME',
                      onTap: _onPlayGame,
                      isPrimary: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Positioned(
          top: -26,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF935C3E),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                'Match Setup',
                style: TextStyle(
                  color: Color(0xFFF8E8D2),
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                  shadows: [
                    Shadow(
                      color: Colors.black45,
                      offset: Offset(0, 1),
                      blurRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerSection({
    required String title,
    required TextEditingController controller,
    required FocusNode focusNode,
    required FocusNode? nextFocusNode,
    required String number,
    required TextInputAction textInputAction,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.person,
              color: Colors.black,
              size: 28,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFF9F0E2),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    offset: Offset(0, 1),
                    blurRadius: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildInputBox(
          controller: controller,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
          hint: 'Name of $title',
          number: number,
          textInputAction: textInputAction,
        ),
      ],
    );
  }

  Widget _buildInputBox({
    required TextEditingController controller,
    required FocusNode focusNode,
    required FocusNode? nextFocusNode,
    required String hint,
    required String number,
    required TextInputAction textInputAction,
  }) {
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE7DDD0),
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF28E50),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  number,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(
                        color: Colors.white54,
                        offset: Offset(0.5, 0.5),
                        blurRadius: 0.5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                textInputAction: textInputAction,
                keyboardType: TextInputType.name,
                autocorrect: false,
                enableSuggestions: false,
                maxLength: 14,
                style: const TextStyle(
                  color: Color(0xFF5A3B2B),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                onSubmitted: (_) {
                  if (nextFocusNode != null) {
                    FocusScope.of(context).requestFocus(nextFocusNode);
                  } else {
                    FocusScope.of(context).unfocus();
                  }
                },
                decoration: InputDecoration(
                  counterText: '',
                  hintText: hint,
                  hintStyle: const TextStyle(
                    color: Color(0xFFA48F82),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.only(
                    left: 8,
                    right: 16,
                    top: 18,
                    bottom: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVsSection() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 4,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0D8BB),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFF9AE00),
                Color(0xFFFFB300),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Text(
            'VS',
            style: TextStyle(
              color: Color(0xFFD45616),
              fontSize: 18,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(
                  color: Color(0xFFFFE0A3),
                  offset: Offset(0, 1),
                  blurRadius: 0,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 4,
            margin: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0D8BB),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return _PressableGameButton(
      label: label,
      onTap: onTap,
      isPrimary: isPrimary,
    );
  }
}

class _StaticSetupBackground extends StatelessWidget {
  const _StaticSetupBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        Row(
          children: [
            Expanded(child: ColoredBox(color: Color(0xFF4D251B))),
            Expanded(child: ColoredBox(color: Color(0xFF5A311F))),
            Expanded(child: ColoredBox(color: Color(0xFF3A2D27))),
            Expanded(child: ColoredBox(color: Color(0xFF5A311F))),
            Expanded(child: ColoredBox(color: Color(0xFF4D251B))),
          ],
        ),
        Positioned(
          left: 18,
          top: 72,
          child: Icon(
            Icons.cloud_outlined,
            size: 90,
            color: Color(0x1AFFFFFF),
          ),
        ),
        Positioned(
          left: 145,
          top: 55,
          child: Icon(
            Icons.cloud_outlined,
            size: 65,
            color: Color(0x1AFFFFFF),
          ),
        ),
        Positioned(
          right: 100,
          top: 58,
          child: Icon(
            Icons.cloud_outlined,
            size: 75,
            color: Color(0x1AFFFFFF),
          ),
        ),
        Positioned(
          right: -10,
          top: 105,
          child: Icon(
            Icons.cloud_outlined,
            size: 85,
            color: Color(0x1AFFFFFF),
          ),
        ),
        Positioned(
          left: -10,
          bottom: 130,
          child: Icon(
            Icons.cloud_outlined,
            size: 95,
            color: Color(0x14FFFFFF),
          ),
        ),
        Positioned(
          right: -5,
          bottom: 115,
          child: Icon(
            Icons.cloud_outlined,
            size: 90,
            color: Color(0x14FFFFFF),
          ),
        ),
        Positioned(
          left: 132,
          top: 120,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFF5A78A8),
              shape: BoxShape.circle,
            ),
            child: SizedBox(width: 12, height: 12),
          ),
        ),
        Positioned(
          right: 140,
          top: 122,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFF7A4C3F),
              shape: BoxShape.circle,
            ),
            child: SizedBox(width: 12, height: 12),
          ),
        ),
      ],
    );
  }
}

class _PressableGameButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _PressableGameButton({
    required this.label,
    required this.onTap,
    required this.isPrimary,
  });

  @override
  State<_PressableGameButton> createState() => _PressableGameButtonState();
}

class _PressableGameButtonState extends State<_PressableGameButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) return;

    setState(() {
      _isPressed = value;
    });
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final gradient = widget.isPrimary
        ? const LinearGradient(
      colors: [
        Color(0xFF813B22),
        Color(0xFF9F512B),
        Color(0xFF7F381D),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    )
        : const LinearGradient(
      colors: [
        Color(0xFF4B251C),
        Color(0xFF5D2E20),
        Color(0xFF4A2218),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: _handleTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 90),
          curve: Curves.easeOut,
          height: 62,
          transform: Matrix4.translationValues(
            0,
            _isPressed ? 4 : 0,
            0,
          ),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: _isPressed ? 3 : 7,
                offset: Offset(0, _isPressed ? 2 : 5),
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFD39B57),
                width: 1.2,
              ),
            ),
            child: Center(
              child: AnimatedOpacity(
                opacity: _isPressed ? 0.75 : 1.0,
                duration: const Duration(milliseconds: 90),
                child: Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFF7E6C9),
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}