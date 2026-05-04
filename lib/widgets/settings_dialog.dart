import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  // State untuk switch suara, bisa dihubungkan ke provider nanti
  bool _isMusicOn = true;
  bool _isSoundOn = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent, // Agar border buatan kita terlihat
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.buttonBg, // Cokelat medium sesuai tombol
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.buttonBorder, width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Dialog hanya setinggi kontennya
          children: [
            // Header Dialog
            const Text(
              "PENGATURAN",
              style: TextStyle(
                color: AppColors.textTitle,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 10),
            Container(height: 1, color: AppColors.textTitle.withOpacity(0.3)),
            const SizedBox(height: 20),

            // Pengaturan Musik
            _buildSettingRow(
              "Musik",
              Icons.music_note,
              _isMusicOn,
              (val) => setState(() => _isMusicOn = val),
            ),
            
            const SizedBox(height: 10),

            // Pengaturan Efek Suara
            _buildSettingRow(
              "Efek Suara",
              Icons.volume_up,
              _isSoundOn,
              (val) => setState(() => _isSoundOn = val),
            ),

            const SizedBox(height: 30),

            // Tombol Aksi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDialogButton("KEMBALI", Colors.grey, () => Navigator.pop(context)),
                _buildDialogButton("SIMPAN", Colors.green, () {
                  // Tambahkan logika simpan ke local storage di sini
                  Navigator.pop(context);
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow(String title, IconData icon, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.textTitle, size: 24),
            const SizedBox(width: 15),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.orangeAccent,
          activeTrackColor: AppColors.stripe3, // Pakai warna hijau tengah
        ),
      ],
    );
  }

  Widget _buildDialogButton(String label, Color color, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonBorder,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: color, width: 2),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}