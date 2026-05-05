import 'dart:isolate';
import 'dart:math';

import '../models/board_state.dart';
import '../core/minimax.dart';

class GameController {
  BoardState board = BoardState();

  Future<void> botTurn({
    int depth = 1,
    double errorChance = 0.0,
  }) async {
    if (board.isGameOver()) return;

    final validMovesNow = board.getValidMoves();

    if (validMovesNow.isEmpty) return;

    final BoardState cloneBoard = board.copy();

    final Move bestMove = await Isolate.run(() {
      final random = Random();

      if (random.nextDouble() < errorChance) {
        final validMoves = cloneBoard.getValidMoves();

        if (validMoves.isNotEmpty) {
          validMoves.shuffle();
          return validMoves.first;
        }
      }

      final engine = MinimaxEngine();
      return engine.getBestMove(cloneBoard, depth);
    });

    board.makeMove(bestMove);
  }

  void resetGame() {
    board = BoardState();
  }
}