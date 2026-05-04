class Move {
  final int? fromIndex;
  final int toIndex;

  Move({
    this.fromIndex,
    required this.toIndex,
  });
}

class BoardState {
  List<int> grid;
  int currentPlayer;
  int turnCount;

  BoardState({
    List<int>? initialGrid,
    this.currentPlayer = 1,
    this.turnCount = 0,
  }) : grid = initialGrid ?? List.filled(9, 0);

  static const Map<int, List<int>> adjacentNodes = {
    0: [1, 3, 4],
    1: [0, 2, 4],
    2: [1, 4, 5],
    3: [0, 4, 6],
    4: [0, 1, 2, 3, 5, 6, 7, 8],
    5: [2, 4, 8],
    6: [3, 4, 7],
    7: [4, 6, 8],
    8: [4, 5, 7],
  };

  static const List<List<int>> winLines = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  bool get isPlacementPhase {
    return turnCount < 6;
  }

  int getWinner() {
    for (final line in winLines) {
      final a = line[0];
      final b = line[1];
      final c = line[2];

      if (grid[a] != 0 && grid[a] == grid[b] && grid[b] == grid[c]) {
        return grid[a];
      }
    }

    return 0;
  }

  bool isGameOver() {
    return getWinner() != 0;
  }

  List<Move> getValidMoves() {
    final List<Move> moves = [];

    if (isPlacementPhase) {
      for (int i = 0; i < 9; i++) {
        if (grid[i] == 0) {
          moves.add(Move(toIndex: i));
        }
      }

      return moves;
    }

    for (int i = 0; i < 9; i++) {
      if (grid[i] == currentPlayer) {
        for (final neighbor in adjacentNodes[i] ?? []) {
          if (grid[neighbor] == 0) {
            moves.add(
              Move(
                fromIndex: i,
                toIndex: neighbor,
              ),
            );
          }
        }
      }
    }

    return moves;
  }

  void makeMove(Move move) {
    if (move.fromIndex != null) {
      grid[move.fromIndex!] = 0;
    }

    grid[move.toIndex] = currentPlayer;
    currentPlayer = currentPlayer == 1 ? 2 : 1;
    turnCount++;
  }

  void undoMove(Move move) {
    currentPlayer = currentPlayer == 1 ? 2 : 1;
    turnCount--;

    if (move.fromIndex != null) {
      grid[move.fromIndex!] = currentPlayer;
      grid[move.toIndex] = 0;
    } else {
      grid[move.toIndex] = 0;
    }
  }

  BoardState copy() {
    return BoardState(
      initialGrid: List<int>.from(grid),
      currentPlayer: currentPlayer,
      turnCount: turnCount,
    );
  }
}