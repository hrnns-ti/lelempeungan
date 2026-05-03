## Technical Documentation: Bot Logic & State Management

### 1. Arsitektur Pemrosesan (Isolate Flow)
Karena algoritma Minimax bersifat *CPU-bound* (berat pada prosesor), kita menggunakan **Worker Isolate** untuk mencegah *frame drop* pada UI thread.

*   **Input**: `BoardState` (dikloning untuk menghindari *shared memory error*), `depth`, dan `errorChance`.
*   **Process**: 
    1.  Cek `errorChance`. Jika tembus, jalankan `validMoves.shuffle()`.
    2.  Jika tidak, jalankan `MinimaxEngine.getBestMove()`.
*   **Output**: Objek `Move` tunggal yang dikirim kembali ke Main Thread melalui `Isolate.run`.

### 2. Kontrak Parameter `botTurn`
Fungsi `botTurn` adalah pintu masuk tunggal untuk semua aksi bot.

```dart
Future<void> botTurn({int depth = 1, double errorChance = 0.0})
```

| Parameter | Tipe | Rentang Nilai | Dampak Teknis |
| :--- | :--- | :--- | :--- |
| `depth` | `int` | `1 - 7` | Menentukan kedalaman rekursi pohon keputusan. Nilai `> 5` dapat menyebabkan delay respon > 1 detik pada device low-end. |
| `errorChance` | `double` | `0.0 - 1.0` | Probabilitas mengabaikan hasil Minimax. Digunakan untuk simulasi tingkat kesulitan "Easy". |

### 3. Logika Transisi Fase (State Consistency)
Bot secara otomatis mendeteksi fase permainan melalui properti `turnCount` pada objek `BoardState`:

*   **Fase 1 (Placement)**: `turnCount < 6`. Fungsi `getValidMoves()` hanya mengembalikan `Move` dengan `fromIndex: null`.
*   **Fase 2 (Movement)**: `turnCount >= 6`. Fungsi `getValidMoves()` akan memfilter bidak berdasarkan `currentPlayer` dan mencari titik kosong di `adjacentNodes`.

### 4. Evaluasi Heuristik (The Brain)
Jika kamu ingin mengubah cara bot memandang "posisi bagus", fokuslah pada fungsi `_evaluateBoard` di `minimax.dart`:

*   **Winning State**: Diberi bobot `1000` atau `-1000` (prioritas tertinggi).
*   **Center Control**: Index 4 (tengah) diberi bobot `50`. Ini karena secara topologi, index 4 memiliki 8 koneksi tetangga (terbanyak).
*   **Line Scoring**: Fungsi `_evaluateLines` memberikan bobot `20` untuk kondisi "hampir menang" (2 bidak sejajar dengan 1 lubang kosong).

### 5. Error Handling & Guardrails
1.  **GameOver Guard**: `botTurn` akan langsung melakukan *return* jika `board.isGameOver()` bernilai `true`.
2.  **Move Validation**: Bot tidak akan pernah melakukan langkah ilegal karena ia hanya memilih dari *list* yang dihasilkan oleh `getValidMoves()`.
3.  **Late Initialization**: Selalu pastikan `_botPlayerId` diinisialisasi sebelum `build()` atau gunakan nilai *nullable* dengan pengecekan `null` di UI.