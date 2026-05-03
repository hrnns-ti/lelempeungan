import 'dart:isolate';
import '../models/board_state.dart';
import '../core/minimax.dart';

class GameController {
  BoardState board = BoardState();
  MinimaxEngine engine = MinimaxEngine();

  void humanPlay(Move move) {
    board.makeMove(move);
    if (!board.isGameOver()) {
      playBotTurn();
    }
  }

  // Ini fungsi asinkron (berjalan di background)
  Future<void> playBotTurn() async {
    print("Bot sedang berpikir...");

    // Isolate gak boleh memori yang sama dengan Main Thread (biar gk freeze cuyy)
    BoardState clonedBoard = _cloneBoard(board);

    // Pindahin proses berat ke Isolate
    Move bestMove = await Isolate.run(() {
      MinimaxEngine backgroundEngine = MinimaxEngine();
      // Misal kita set kedalaman (depth) = 5
      return backgroundEngine.getBestMove(clonedBoard, 3); 
    });

    // Isolate selesai terus kirim jawaban (bestMove),
    board.makeMove(bestMove);

    print("Bot menaruh bidak di index: ${bestMove.toIndex}");
  }

  // Fungsi bantuan buat nyetak kembaran papan
  BoardState _cloneBoard(BoardState currentBoard) {
    return BoardState(
      initialGrid: List.from(currentBoard.grid),
      currentPlayer: currentBoard.currentPlayer,
      turnCount: currentBoard.turnCount,
    );
  }
}