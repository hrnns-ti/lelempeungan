import '';

class Move {
  final int? fromIndex;
  final int toIndex;

  Move({this.fromIndex, required this.toIndex});
}

class BoardState {
  List<int> grid;
  int currentPlayer, turnCount;

  // init boardnya (kalo gak ada history ya semua 3x3 itu jadi 0, kalo ada load initial grid)
  BoardState({
    List<int>? initialGrid,
    this.currentPlayer = 1,
    this.turnCount = 0
  }) : grid = initialGrid ?? List.filled(9, 0);

  // adjecent nodes, ibarat matriks 3x3 yang index 0-8(ada 9 titik) itu punya tetangga
  // [0,1,2] (contoh, 0 itu tetanggan ama 1,3, ama 4)
  // [3,4,5]
  // [6,7,8]
  static const Map<int, List<int>> adjacentNodes = {
    0: [1, 3, 4],
    1: [0, 2, 4],
    2: [1, 4, 5],
    3: [0, 4, 6],
    4: [0, 1, 2, 3, 5, 6, 7, 8],
    5: [2, 4, 8],
    6: [3, 4, 7],
    7: [4, 6, 8],
    8: [4, 5, 7]
  };

  // buat mastiin kondisi menang
  static const List<List<int>> winLines = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8],   // Horizontal
    [0, 3, 6], [1, 4, 7], [2, 5, 8],   // Vertikal
    [0, 4, 8], [2, 4, 6]               // Diagonal
  ];

  int getWinner() {
    for (var line in winLines) {
      int a = line[0];
      int b = line[1];
      int c = line[2];

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
    List<Move> moves = [];

    // Fase 1 (masing masing player gantian naruh bidaknya di tempat yang kosong)
    if (turnCount < 6) {
      for (int i = 0; i < 9; i++) {
        if (grid[i] == 0) {
          moves.add(Move(toIndex: i));
        }
      }
    }

    // Fase 2 (semua player udah naruh semua bidaknya, ganti jadi geser geser bidaknya cuy)
    else {
      for (int i = 0; i < 9; i++) {
        if (grid[i] == currentPlayer) {
          List<int> neighbors = adjacentNodes[i]!;
          
          for (int neighbor in neighbors) {
            if (grid[neighbor] == 0) {
              moves.add(Move(fromIndex: i, toIndex: neighbor));
            }
          }
        }
      }
    }
    return moves;
  }

  void makeMove(Move move) {
    // cek dulu ini fase 2 apa bukan
    if (move.fromIndex != null) {
      grid[move.fromIndex!] = 0;
    }

    grid[move.toIndex] = currentPlayer;
    currentPlayer = (currentPlayer == 1) ? 2 : 1;
    turnCount++;
  }

  void undoMove(Move move) {
    currentPlayer = (currentPlayer == 1) ? 2 : 1;
    turnCount--;

    // cek ini fase 2 kah?
    if (move.fromIndex != null) {
      grid[move.fromIndex!] = currentPlayer;
      grid[move.toIndex] = 0;
    } else {
      grid[move.toIndex] = 0;
    }
  }
}