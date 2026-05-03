import 'dart:math';
import 'package:flutter/material.dart';
import 'models/board_state.dart';
import 'controllers/game_controller.dart';

void main() {
  runApp(const LelempeunganApp());
}

class LelempeunganApp extends StatelessWidget {
  const LelempeunganApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameController _controller;
  int? _selectedFromIndex;
  bool _isBotThinking = false;
  int _botPlayerId = 0; // 0 berarti belum diinisialisasi
  int _currentLevel = 1;

  // Konfigurasi Level sesuai permintaanmu
  final Map<int, Map<String, dynamic>> _levelConfig = {
    1: {'depth': 1, 'error': 0.40},
    2: {'depth': 2, 'error': 0.25},
    3: {'depth': 2, 'error': 0.0},
    4: {'depth': 3, 'error': 0.1},
  };

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _controller = GameController();
    _selectedFromIndex = null;
    _isBotThinking = false;

    // Randomizer: Bot bisa jadi player 1 atau 2
    _botPlayerId = Random().nextBool() ? 1 : 2;

    // Jika bot dapat giliran pertama, langsung jalan setelah build selesai
    if (_botPlayerId == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _triggerBotTurn();
      });
    }
  }

  Future<void> _triggerBotTurn() async {
    if (_controller.board.isGameOver()) return;

    setState(() => _isBotThinking = true);

    // Ambil config berdasarkan level yang dipilih
    final config = _levelConfig[_currentLevel]!;

    // Panggil fungsi botTurn yang sudah fleksibel di GameController
    await _controller.botTurn(
      depth: config['depth'],
      errorChance: config['error'],
    );

    setState(() => _isBotThinking = false);
  }

  void _handleTap(int index) async {
    final board = _controller.board;

    // Proteksi: Jangan bisa klik jika game beres, giliran bot, atau bot lagi mikir
    if (board.isGameOver() || board.currentPlayer == _botPlayerId || _isBotThinking) return;

    bool moveSuccessful = false;
    Move? move;

    // FASE 1: Menaruh Bidak (Hingga 6 bidak di papan)
    if (board.turnCount < 6) {
    if (board.grid[index] == 0) {
      move = Move(toIndex: index);
      moveSuccessful = true;
    }
    }
    // FASE 2: Menggeser Bidak
    else {
    if (board.grid[index] == board.currentPlayer) {
      // Pilih bidak milik sendiri
      setState(() => _selectedFromIndex = index);
      return;
    }
    else if (_selectedFromIndex != null && board.grid[index] == 0) {
      // Cek koneksi titik (adjacency)
      List<int>? neighbors = BoardState.adjacentNodes[_selectedFromIndex!];
      if (neighbors != null && neighbors.contains(index)) {
        move = Move(fromIndex: _selectedFromIndex, toIndex: index);
        moveSuccessful = true;
      } else {
        // Klik luar jangkauan, batalkan seleksi
        setState(() => _selectedFromIndex = null);
      }
    }
    }

    if (moveSuccessful && move != null) {
      setState(() {
        _controller.board.makeMove(move!);
        _selectedFromIndex = null;
      });

      // Jika game belum beres, giliran bot otomatis jalan
      if (!board.isGameOver()) {
        await _triggerBotTurn();
      }
    }
  }

  Widget _buildLevelSelector() {
    return SegmentedButton<int>(
      segments: const [
        ButtonSegment(value: 1, label: Text('Lvl 1')),
        ButtonSegment(value: 2, label: Text('Lvl 2')),
        ButtonSegment(value: 3, label: Text('Lvl 3')),
        ButtonSegment(value: 4, label: Text('Lvl 4')),
      ],
      selected: {_currentLevel},
      onSelectionChanged: (newSelection) {
        setState(() => _currentLevel = newSelection.first);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final board = _controller.board;
    final winner = board.getWinner();
    final isHumanTurn = board.currentPlayer != _botPlayerId && !board.isGameOver();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lelempeungan Engine Test"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => _initializeGame()),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLevelSelector(),
            const SizedBox(height: 20),
            Text(
              "Kamu: Player ${(_botPlayerId == 1 ? 2 : 1)} | Bot: Player $_botPlayerId",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              winner != 0
                  ? "WINNER: PLAYER $winner"
                  : (isHumanTurn ? "Giliran Kamu!" : "Bot sedang berpikir..."),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: winner != 0 ? Colors.green : (isHumanTurn ? Colors.blue : Colors.red),
              ),
            ),
            const SizedBox(height: 30),
            // Board Container
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              width: 340,
              height: 340,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemCount: 9,
                itemBuilder: (context, index) {
                  int cellValue = board.grid[index];
                  bool isSelected = _selectedFromIndex == index;

                  return GestureDetector(
                    onTap: () => _handleTap(index),
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.orange : Colors.black12,
                          width: isSelected ? 4 : 1,
                        ),
                      ),
                      child: Center(
                        child: cellValue == 0
                            ? (board.turnCount >= 6 ? null : const Icon(Icons.add, color: Colors.black12))
                            : Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: cellValue == 1 ? Colors.blue : Colors.red,
                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            if (winner != 0)
              FilledButton.icon(
                onPressed: () => setState(() => _initializeGame()),
                icon: const Icon(Icons.replay),
                label: const Text("Main Lagi"),
              ),
          ],
        ),
      ),
    );
  }
}