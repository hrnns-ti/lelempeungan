import 'dart:math';
import '../models/board_state.dart';

class MinimaxEngine {
  static const _infinity = 9999999;
  
  // intinya si bot ini pengen cari posisi/langkah terbaik
  Move getBestMove(BoardState currentBoard, int depth) {
    
    // tentuin mana bot mana player
    int botId = currentBoard.currentPlayer;
    int humanId = (botId == 1) ? 2 : 1;

    int bestScore = -_infinity;
    Move? bestMove;
    List<Move> validMoves = currentBoard.getValidMoves();

    for (Move move in validMoves) {
      currentBoard.makeMove(move);
      int score = _minimax(currentBoard, depth - 1, -_infinity, _infinity, false, botId, humanId);
      currentBoard.undoMove(move);

      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }
    return bestMove!;
  }

  int _minimax(BoardState board, int depth, int alpha, int beta, bool isMaximizing, int botId, int humanId) {
    if (depth == 0 || board.isGameOver()) {
      return _evaluateBoard(board, botId, humanId);
    }

    if (isMaximizing) {
      int maxEval = -_infinity;
      for (Move move in board.getValidMoves()) {
        board.makeMove(move);
        int eval = _minimax(board, depth - 1, alpha, beta, false, botId, humanId);
        board.undoMove(move);
        
        maxEval = max(maxEval, eval);
        alpha = max(alpha, eval);

        if (beta <= alpha) break;
      }
      return maxEval;
    } else {
      int minEval = _infinity;
      for (Move move in board.getValidMoves()) {
        board.makeMove(move);
        int eval = _minimax(board, depth - 1, alpha, beta, true, botId, humanId);
        board.undoMove(move);

        minEval = min(minEval, eval);
        beta = min(beta, eval);

        if (beta <= alpha) break;
      }
      return minEval;
    }
  }

  int _evaluateBoard(BoardState board, int botId, int humanId) {
    int winner = board.getWinner();
    if (winner == botId) {
      return 1000;
    } else if (winner == humanId) {
      return -1000;
    }

    int score = 0;
    
    if (board.grid[4] == botId) {
      score += 50;
    } else if (board.grid[4] == humanId) {
      score -= 50;
    }

    score += _evaluateLines(board, botId, humanId);

    return score;
  }

  int _evaluateLines(BoardState board, int botId, int humanId) {
    int lineScore = 0;

    for (var line in BoardState.winLines) {
      int botCount = 0, humanCount = 0, emptyCount = 0;
      for (int index in line) {
        if (board.grid[index] == botId) {
          botCount++;
        } else if ( board.grid[index] == humanId) {
          humanCount++;
        } else {
          emptyCount++;
        }

      }
      
      if (botCount == 2 && emptyCount == 1) {
        lineScore += 20;
      } else if (humanCount == 2 && emptyCount == 1) {
        lineScore -= 20;
      } else if ( botCount == 1 && emptyCount == 2) {
        lineScore += 5;
      } else if ( humanCount == 1 && emptyCount == 2) {
        lineScore -= 5;
      }
    }

    return lineScore;
  }
}
