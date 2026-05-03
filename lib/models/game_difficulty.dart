enum GameLevel {
  easy(depth: 1, errorChance: 0.4),
  medium(depth: 2, errorChance: 0.1),
  hard(depth: 2, errorChance: 0.0),
  expert(depth: 3, errorChance: 0.0);

  final int depth;        // Seberapa jauh bot melihat langkah ke depan[cite: 1, 3]
  final double errorChance; // Peluang bot memilih langkah acak (0.0 - 1.0)

  const GameLevel({required this.depth, required this.errorChance});
}