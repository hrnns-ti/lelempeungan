import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/game_audio.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  bool get _musicOn => GameAudio.isMusicEnabled;
  bool get _soundOn => GameAudio.isSoundEnabled;

  Future<void> _toggleMusic(bool value) async {
    await GameAudio.playClick();
    await GameAudio.setMusicEnabled(value);

    if (!mounted) return;
    setState(() {});
  }

  Future<void> _toggleSound(bool value) async {
    if (value) {
      await GameAudio.setSoundEnabled(true);
      await GameAudio.playClick();
    } else {
      await GameAudio.playClick();
      await GameAudio.setSoundEnabled(false);
    }

    if (!mounted) return;
    setState(() {});
  }

  Future<void> _closeDialog() async {
    await GameAudio.playClick();

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        decoration: BoxDecoration(
          color: const Color(0xFFC28B57),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: const Color(0xFFE0B36E),
            width: 4,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF8F5B3A),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                'Settings',
                style: TextStyle(
                  color: Color(0xFFF8E8D2),
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),

            const SizedBox(height: 22),

            _SettingTile(
              icon: _musicOn ? Icons.music_note : Icons.music_off,
              title: 'Music',
              value: _musicOn,
              onChanged: _toggleMusic,
            ),

            const SizedBox(height: 14),

            _SettingTile(
              icon: _soundOn ? Icons.volume_up : Icons.volume_off,
              title: 'Sound Effect',
              value: _soundOn,
              onChanged: _toggleSound,
            ),

            const SizedBox(height: 24),

            _DialogButton(
              label: 'CLOSE',
              icon: Icons.close,
              color: const Color(0xFF6A3927),
              onTap: _closeDialog,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 10, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE7DDD0),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF5E6C55),
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF8A4F2C),
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: const Color(0xFF6B7F4E),
            activeTrackColor: const Color(0xFFBFD3A6),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _DialogButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DialogButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_DialogButton> createState() => _DialogButtonState();
}

class _DialogButtonState extends State<_DialogButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) return;

    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : 1,
        duration: const Duration(milliseconds: 90),
        child: Container(
          height: 58,
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE0B36E),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: _isPressed ? 3 : 7,
                offset: Offset(0, _isPressed ? 2 : 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: const Color(0xFFF8E8D2),
                size: 20,
              ),
              const SizedBox(height: 3),
              Text(
                widget.label,
                style: const TextStyle(
                  color: Color(0xFFF8E8D2),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 