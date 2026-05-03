import 'dart:isolate';
import 'dart:math';
import '../models/board_state.dart';
import '../core/minimax.dart';

class GameController {
  BoardState board = BoardState();

  Future<void> botTurn ({int depth = 1, double errorChance = 0.0}) async {
    if (board.isGameOver()) return;

    BoardState cloneBoard = _cloneBoard(board);

    Move bestMove = await Isolate.run(() {
      final random = Random();

      if (random.nextDouble() < errorChance) {
        List<Move> validMoves = cloneBoard.getValidMoves();
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
  BoardState _cloneBoard(BoardState board) {
    return BoardState(
      initialGrid: List.from(board.grid),
      currentPlayer: board.currentPlayer,
      turnCount: board.turnCount,
    );
  }
}