import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/game_audio.dart';
import '../services/player_profile_service.dart';

class PlayerProfileDialog extends StatefulWidget {
  const PlayerProfileDialog({super.key});

  @override
  State<PlayerProfileDialog> createState() => _PlayerProfileDialogState();
}

class _PlayerProfileDialogState extends State<PlayerProfileDialog> {
  final TextEditingController _nameController = TextEditingController();

  int _selectedAvatarIndex = 0;
  bool _isLoading = true;
  bool _isSaving = false;

  static const List<IconData> _avatarIcons = [
    Icons.person,
    Icons.sports_esports,
    Icons.shield,
    Icons.emoji_events,
    Icons.face,
    Icons.psychology_alt,
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final playerName = await PlayerProfileService.getPlayerName();
    final avatarIndex = await PlayerProfileService.getAvatarIndex();

    if (!mounted) return;

    setState(() {
      _nameController.text = playerName;
      _selectedAvatarIndex = avatarIndex.clamp(0, _avatarIcons.length - 1);
      _isLoading = false;
    });
  }

  Future<void> _selectAvatar(int index) async {
    await GameAudio.playClick();

    if (!mounted) return;

    setState(() {
      _selectedAvatarIndex = index;
    });
  }

  Future<void> _saveProfile() async {
    if (_isSaving) return;

    await GameAudio.playClick();

    final playerName = _nameController.text.trim().isEmpty
        ? PlayerProfileService.defaultName
        : _nameController.text.trim();

    setState(() {
      _isSaving = true;
    });

    await PlayerProfileService.saveProfile(
      playerName: playerName,
      avatarIndex: _selectedAvatarIndex,
    );

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    Navigator.of(context).pop(playerName);
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
        width: 340,
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
        child: _isLoading
            ? const SizedBox(
                height: 160,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFF8E8D2),
                  ),
                ),
              )
            : Column(
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
                      'Player Profile',
                      style: TextStyle(
                        color: Color(0xFFF8E8D2),
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7DDD0),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE0B36E),
                        width: 3,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 7,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      _avatarIcons[_selectedAvatarIndex],
                      color: const Color(0xFF5E6C55),
                      size: 46,
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: _nameController,
                    maxLength: 14,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF5B2D21),
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
                    ],
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: 'Player name',
                      hintStyle: TextStyle(
                        color: const Color(0xFF5B2D21).withOpacity(0.45),
                        fontWeight: FontWeight.w700,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFE7DDD0),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(
                          color: Color(0xFFE0B36E),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(
                          color: Color(0xFF6B7F4E),
                          width: 2.4,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Choose Avatar',
                      style: TextStyle(
                        color: Color(0xFFF8E8D2),
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      _avatarIcons.length,
                      (index) {
                        return _AvatarChoice(
                          icon: _avatarIcons[index],
                          isSelected: _selectedAvatarIndex == index,
                          onTap: () => _selectAvatar(index),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: _ProfileDialogButton(
                          label: 'CLOSE',
                          icon: Icons.close,
                          color: const Color(0xFF6A3927),
                          onTap: _closeDialog,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ProfileDialogButton(
                          label: _isSaving ? 'SAVING' : 'SAVE',
                          icon: Icons.check,
                          color: const Color(0xFF6B7F4E),
                          onTap: _saveProfile,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

class _AvatarChoice extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _AvatarChoice({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.08 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF6B7F4E)
                : const Color(0xFFE7DDD0),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFFFD15C)
                  : const Color(0xFFE0B36E),
              width: isSelected ? 2.4 : 1.6,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: isSelected
                ? const Color(0xFFF8E8D2)
                : const Color(0xFF5E6C55),
            size: 27,
          ),
        ),
      ),
    );
  }
}

class _ProfileDialogButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ProfileDialogButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_ProfileDialogButton> createState() => _ProfileDialogButtonState();
}

class _ProfileDialogButtonState extends State<_ProfileDialogButton> {
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