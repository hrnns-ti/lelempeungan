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
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
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
  int _botPlayerId = 0; // Bot bisa jadi 1 atau 2

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _controller = GameController();
    _selectedFromIndex = null;
    _isBotThinking = false;
    
    // Randomizer: Tentukan bot jadi player 1 atau 2
    _botPlayerId = Random().nextBool() ? 1 : 2;

    // Jika bot dapat giliran pertama (Player 1), langsung jalan
    if (_botPlayerId == 1) {
      _triggerBotTurn();
    }
  }

  Future<void> _triggerBotTurn() async {
    if (_controller.board.isGameOver()) return;

    setState(() => _isBotThinking = true);
    await _controller.playBotTurn();
    setState(() => _isBotThinking = false);
  }

  void _handleTap(int index) async {
  final board = _controller.board;

  if (board.isGameOver() || board.currentPlayer == _botPlayerId || _isBotThinking) return;

  bool moveSuccessful = false;
  Move? move;

  // FASE 1: Taruh Bidak
  if (board.turnCount < 6) {
    if (board.grid[index] == 0) {
      move = Move(toIndex: index);
      moveSuccessful = true;
    }
  } 
  // FASE 2: Geser Bidak
  else {
    // Jika klik bidak sendiri, simpan sebagai 'asal'
    if (board.grid[index] == board.currentPlayer) {
      setState(() => _selectedFromIndex = index);
      return; // Berhenti di sini, tunggu klik tujuan
    } 
    
    // Jika sudah pilih asal, dan klik kotak kosong
    else if (_selectedFromIndex != null && board.grid[index] == 0) {
      // Validasi apakah kotak tujuan bertetangga dengan asal[cite: 2]
      List<int>? neighbors = BoardState.adjacentNodes[_selectedFromIndex!];
      if (neighbors != null && neighbors.contains(index)) {
        move = Move(fromIndex: _selectedFromIndex, toIndex: index);
        moveSuccessful = true;
      } else {
        // Jika klik tempat yang tidak terhubung, batalkan pilihan
        setState(() => _selectedFromIndex = null);
      }
    }
  }

  if (moveSuccessful && move != null) {
    setState(() {
      _controller.board.makeMove(move!);
      _selectedFromIndex = null; // Selalu reset setelah move sukses
    });

    if (!board.isGameOver()) {
      await _triggerBotTurn();
    }
  }
}

  @override
  Widget build(BuildContext context) {
    final board = _controller.board;
    final winner = board.getWinner();
    final isHumanTurn = board.currentPlayer != _botPlayerId && !board.isGameOver();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lelempeungan Test"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => _initializeGame()),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Kamu: Player ${(_botPlayerId == 1 ? 2 : 1)} | Bot: Player $_botPlayerId",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            winner != 0 
                ? "PEMENANG: PLAYER $winner" 
                : (isHumanTurn ? "Giliran Kamu!" : "Bot sedang berpikir..."),
            style: TextStyle(
              fontSize: 22, 
              fontWeight: FontWeight.bold,
              color: winner != 0 ? Colors.green : (isHumanTurn ? Colors.blue : Colors.red),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.brown[50],
                borderRadius: BorderRadius.circular(15),
              ),
              width: 320,
              height: 320,
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
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? Colors.orange : Colors.black12, 
                          width: isSelected ? 4 : 1,
                        ),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
                      ),
                      child: Center(
                        child: cellValue == 0 
                            ? (board.turnCount >= 6 ? null : const Icon(Icons.add, color: Colors.black12))
                            : Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: cellValue == 1 ? Colors.blue : Colors.red,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 40),
          if (winner != 0)
            ElevatedButton.icon(
              onPressed: () => setState(() => _initializeGame()),
              icon: const Icon(Icons.play_arrow),
              label: const Text("Main Lagi"),
            ),
        ],
      ),
    );
  }
}