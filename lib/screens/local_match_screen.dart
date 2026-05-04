import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../models/board_state.dart';

class LocalMatchScreen extends StatefulWidget {
  final String player1Name;
  final String player2Name;

  const LocalMatchScreen({
    super.key,
    required this.player1Name,
    required this.player2Name,
  });

  @override
  State<LocalMatchScreen> createState() => _LocalMatchScreenState();
}

class _LocalMatchScreenState extends State<LocalMatchScreen> {
  late BoardState _board;
  late Timer _timer;

  int _elapsedSeconds = 0;
  int? _selectedIndex;

  bool _isPaused = false;
  bool _musicOn = true;
  bool _soundOn = true;

  static const int _totalPiecesPerPlayer = 3;

  @override
  void initState() {
    super.initState();
    _board = BoardState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        if (!mounted) return;

        if (!_isPaused && !_board.isGameOver()) {
          setState(() {
            _elapsedSeconds++;
          });
        }
      },
    );
  }

  void _resetGame() {
    HapticFeedback.mediumImpact();

    setState(() {
      _board = BoardState();
      _elapsedSeconds = 0;
      _selectedIndex = null;
      _isPaused = false;
    });
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get _currentPlayerName {
    return _board.currentPlayer == 1 ? widget.player1Name : widget.player2Name;
  }

  Color _playerColor(int playerId) {
    return playerId == 1
        ? const Color(0xFF8FA9C4)
        : const Color(0xFFC86A68);
  }

  int _placedPieces(int playerId) {
    return _board.grid.where((value) => value == playerId).length;
  }

  int _remainingPieces(int playerId) {
    final remaining = _totalPiecesPerPlayer - _placedPieces(playerId);
    return remaining < 0 ? 0 : remaining;
  }

  List<int> _winnerLine() {
    for (final line in BoardState.winLines) {
      final a = line[0];
      final b = line[1];
      final c = line[2];

      if (_board.grid[a] != 0 &&
          _board.grid[a] == _board.grid[b] &&
          _board.grid[b] == _board.grid[c]) {
        return line;
      }
    }

    return [];
  }

  List<int> _validDestinationIndexes() {
    if (_selectedIndex == null || _board.isPlacementPhase) {
      return [];
    }

    return _board
        .getValidMoves()
        .where((move) => move.fromIndex == _selectedIndex)
        .map((move) => move.toIndex)
        .toList();
  }

  void _handleNodeTap(int index) {
    if (_board.isGameOver()) return;

    HapticFeedback.selectionClick();

    if (_board.isPlacementPhase) {
      if (_board.grid[index] != 0) return;

      setState(() {
        _board.makeMove(Move(toIndex: index));
        _selectedIndex = null;
      });

      _checkGameState();
      return;
    }

    final currentPlayer = _board.currentPlayer;

    if (_selectedIndex == null) {
      if (_board.grid[index] == currentPlayer) {
        setState(() {
          _selectedIndex = index;
        });
      }
      return;
    }

    if (_selectedIndex == index) {
      setState(() {
        _selectedIndex = null;
      });
      return;
    }

    if (_board.grid[index] == currentPlayer) {
      setState(() {
        _selectedIndex = index;
      });
      return;
    }

    final isValidMove = _board.getValidMoves().any(
          (move) => move.fromIndex == _selectedIndex && move.toIndex == index,
    );

    if (!isValidMove) {
      HapticFeedback.heavyImpact();
      return;
    }

    setState(() {
      _board.makeMove(
        Move(
          fromIndex: _selectedIndex,
          toIndex: index,
        ),
      );
      _selectedIndex = null;
    });

    _checkGameState();
  }

  void _checkGameState() {
    final winner = _board.getWinner();

    if (winner != 0) {
      Future.delayed(
        const Duration(milliseconds: 250),
            () {
          if (!mounted) return;
          _showWinnerDialog(winner);
        },
      );
    }
  }

  void _showWinnerDialog(int winner) {
    final winnerName = winner == 1 ? widget.player1Name : widget.player2Name;

    HapticFeedback.heavyImpact();

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
            decoration: BoxDecoration(
              color: const Color(0xFFC28B57),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: const Color(0xFFE0B36E),
                width: 4,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.emoji_events,
                  color: Color(0xFFFFD15C),
                  size: 62,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Game Selesai',
                  style: TextStyle(
                    color: Color(0xFFF8E8D2),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '$winnerName menang',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: _DialogButton(
                        label: 'HOME',
                        icon: Icons.home,
                        color: const Color(0xFF5B2D21),
                        onTap: () {
                          Navigator.of(dialogContext).pop();
                          Navigator.of(context).popUntil(
                                (route) => route.isFirst,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DialogButton(
                        label: 'RESTART',
                        icon: Icons.refresh,
                        color: const Color(0xFF8B4A29),
                        onTap: () {
                          Navigator.of(dialogContext).pop();
                          _resetGame();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPauseDialog() {
    setState(() {
      _isPaused = true;
    });

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFC28B57),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: const Color(0xFFE0B36E),
                    width: 4,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8F5B3A),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Settings',
                        style: TextStyle(
                          color: Color(0xFFF8E8D2),
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    _SettingTile(
                      icon: Icons.music_note,
                      title: 'Music',
                      value: _musicOn,
                      onChanged: (value) {
                        setState(() {
                          _musicOn = value;
                        });
                        setDialogState(() {});
                      },
                    ),
                    const SizedBox(height: 14),
                    _SettingTile(
                      icon: Icons.volume_up,
                      title: 'Sound',
                      value: _soundOn,
                      onChanged: (value) {
                        setState(() {
                          _soundOn = value;
                        });
                        setDialogState(() {});
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _DialogButton(
                            label: 'HOME',
                            icon: Icons.home,
                            color: const Color(0xFF6A3927),
                            onTap: () {
                              Navigator.of(dialogContext).pop();
                              Navigator.of(context).popUntil(
                                    (route) => route.isFirst,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _DialogButton(
                            label: 'RESUME',
                            icon: Icons.play_arrow,
                            color: const Color(0xFF6B7F4E),
                            onTap: () {
                              Navigator.of(dialogContext).pop();
                              setState(() {
                                _isPaused = false;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _DialogButton(
                            label: 'RESET',
                            icon: Icons.refresh,
                            color: const Color(0xFF8B4A29),
                            onTap: () {
                              Navigator.of(dialogContext).pop();
                              _resetGame();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      if (!mounted) return;

      if (!_board.isGameOver()) {
        setState(() {
          _isPaused = false;
        });
      }
    });
  }

  void _showHint() {
    String message;

    if (_board.isPlacementPhase) {
      message = 'Pilih titik kosong untuk menaruh bidak $_currentPlayerName.';
    } else if (_selectedIndex == null) {
      message = 'Pilih salah satu bidak milik $_currentPlayerName.';
    } else {
      message = 'Pilih titik kosong yang terhubung dengan bidak terpilih.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF7A4A2B),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFFC28B57),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Cara Bermain',
            style: TextStyle(
              color: Color(0xFFF8E8D2),
              fontWeight: FontWeight.w900,
            ),
          ),
          content: const Text(
            'Setiap pemain memiliki 3 bidak. Pada fase awal, pemain bergantian menaruh bidak di titik kosong. Setelah semua bidak diletakkan, pemain menggeser bidaknya ke titik yang terhubung. Pemain yang berhasil membuat 3 bidak sejajar akan menang.',
            style: TextStyle(
              color: Colors.white,
              height: 1.45,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text(
                'Mengerti',
                style: TextStyle(
                  color: Color(0xFF5B2D21),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final winnerLine = _winnerLine();
    final validDestinationIndexes = _validDestinationIndexes();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Stack(
            children: [
              const _StaticGameBackground(),
              SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final boardSize =
                    constraints.maxWidth > 390 ? 372.0 : 342.0;

                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 12, 10, 18),
                          child: Column(
                            children: [
                              _buildTopSection(),
                              const SizedBox(height: 46),
                              // _buildTurnBanner(),
                              // const SizedBox(height: 18),
                              Center(
                                child: _buildBoardCard(
                                  boardSize: boardSize,
                                  winnerLine: winnerLine,
                                  validDestinationIndexes:
                                  validDestinationIndexes,
                                ),
                              ),
                              const SizedBox(height: 20),
                              _buildPieceDock(),
                              const SizedBox(height: 18),
                              _buildBottomActions(),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: _SettingsSquareButton(
            onTap: _showPauseDialog,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _PlayerProfileCard(
                name: widget.player1Name,
                panelColor: const Color(0xFF7FA6D3),
                pieceCount: _remainingPieces(1),
                isTurn: _board.currentPlayer == 1,
                alignLeft: true,
              ),
            ),
            const SizedBox(width: 10),
            _CenterVsSection(
              timeText: _formatTime(_elapsedSeconds),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _PlayerProfileCard(
                name: widget.player2Name,
                panelColor: const Color(0xFFD39274),
                pieceCount: _remainingPieces(2),
                isTurn: _board.currentPlayer == 2,
                alignLeft: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget _buildTurnBanner() {
  //   final phaseText = _board.isPlacementPhase ? 'Taruh Bidak' : 'Geser Bidak';
  //
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFA56E43),
  //       borderRadius: BorderRadius.circular(20),
  //       border: Border.all(
  //         color: const Color(0xFFD8A15C),
  //         width: 1.4,
  //       ),
  //     ),
  //     child: Text(
  //       'Giliran $_currentPlayerName - $phaseText',
  //       textAlign: TextAlign.center,
  //       style: const TextStyle(
  //         color: Color(0xFFF8E8D2),
  //         fontSize: 16,
  //         fontWeight: FontWeight.w800,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildBoardCard({
    required double boardSize,
    required List<int> winnerLine,
    required List<int> validDestinationIndexes,
  }) {
    return RepaintBoundary(
      child: Container(
        width: boardSize,
        height: boardSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/board_wood.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: const Color(0xFFAA7443),
                    );
                  },
                ),
              ),
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final size = constraints.maxWidth;
                    final nodes = _boardNodes(size);

                    return Stack(
                      children: [
                        CustomPaint(
                          size: Size(size, size),
                          painter: const _LelempeunganBoardPainter(),
                        ),
                        ...List.generate(9, (index) {
                          final value = _board.grid[index];
                          final position = nodes[index];
                          final isSelected = _selectedIndex == index;
                          final isWinnerNode = winnerLine.contains(index);
                          final isValidDestination =
                          validDestinationIndexes.contains(index);

                          return Positioned(
                            left: position.dx - 18,
                            top: position.dy - 18,
                            child: _BoardNode(
                              value: value,
                              color: value == 0
                                  ? Colors.transparent
                                  : _playerColor(value),
                              isSelected: isSelected,
                              isWinnerNode: isWinnerNode,
                              isValidDestination: isValidDestination,
                              onTap: () => _handleNodeTap(index),
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Offset> _boardNodes(double size) {
    const inset = 28.0;
    final left = inset;
    final right = size - inset;
    final top = inset;
    final bottom = size - inset;
    final centerX = size / 2;
    final centerY = size / 2;

    return [
      Offset(left, top),
      Offset(centerX, top),
      Offset(right, top),
      Offset(left, centerY),
      Offset(centerX, centerY),
      Offset(right, centerY),
      Offset(left, bottom),
      Offset(centerX, bottom),
      Offset(right, bottom),
    ];
  }

  Widget _buildPieceDock() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _PieceCluster(
          color: _playerColor(1),
          activeCount: _remainingPieces(1),
        ),
        _PieceCluster(
          color: _playerColor(2),
          activeCount: _remainingPieces(2),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SmallRoundButton(
          icon: Icons.lightbulb,
          onTap: _showHint,
          color: const Color(0xFFFFA35C),
          iconColor: const Color(0xFF6B3926),
        ),
        const SizedBox(width: 20),
        _SmallRoundButton(
          icon: Icons.question_mark,
          onTap: _showHelp,
          color: const Color(0xFFFFA35C),
          iconColor: const Color(0xFF6B3926),
        ),
      ],
    );
  }
}

class _StaticGameBackground extends StatelessWidget {
  const _StaticGameBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        Row(
          children: [
            Expanded(child: ColoredBox(color: Color(0xFF8A4D35))),
            Expanded(child: ColoredBox(color: Color(0xFFA47042))),
            Expanded(child: ColoredBox(color: Color(0xFF5E6854))),
            Expanded(child: ColoredBox(color: Color(0xFFA47042))),
            Expanded(child: ColoredBox(color: Color(0xFF8A4D35))),
          ],
        ),
        Positioned(
          left: -6,
          top: 62,
          child: Icon(
            Icons.cloud_outlined,
            size: 88,
            color: Color(0x2EF9E6C9),
          ),
        ),
        Positioned(
          left: 134,
          top: 52,
          child: Icon(
            Icons.cloud_outlined,
            size: 62,
            color: Color(0x26F9E6C9),
          ),
        ),
        Positioned(
          right: 84,
          top: 50,
          child: Icon(
            Icons.cloud_outlined,
            size: 64,
            color: Color(0x26F9E6C9),
          ),
        ),
        Positioned(
          right: -8,
          top: 114,
          child: Icon(
            Icons.cloud_outlined,
            size: 90,
            color: Color(0x22F9E6C9),
          ),
        ),
        Positioned(
          left: -10,
          bottom: 122,
          child: Icon(
            Icons.cloud_outlined,
            size: 96,
            color: Color(0x20C8E2D8),
          ),
        ),
        Positioned(
          right: -10,
          bottom: 112,
          child: Icon(
            Icons.cloud_outlined,
            size: 94,
            color: Color(0x20C8E2D8),
          ),
        ),
      ],
    );
  }
}

class _PlayerProfileCard extends StatelessWidget {
  final String name;
  final Color panelColor;
  final int pieceCount;
  final bool isTurn;
  final bool alignLeft;

  const _PlayerProfileCard({
    required this.name,
    required this.panelColor,
    required this.pieceCount,
    required this.isTurn,
    required this.alignLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      alignLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 86,
          height: 136,
          padding: const EdgeInsets.fromLTRB(6, 6, 6, 7),
          decoration: BoxDecoration(
            color: panelColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isTurn ? Colors.white : panelColor,
              width: isTurn ? 2.4 : 1.2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 58,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.black,
                  size: 38,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.circle,
                    size: 8,
                    color: Color(0xFFF8E8D2),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$pieceCount',
                    style: const TextStyle(
                      color: Color(0xFFF8E8D2),
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 1),
              const SizedBox(
                height: 13,
                child: Text(
                  'Pieces',
                  style: TextStyle(
                    color: Color(0xFFF8E8D2),
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 20,
                child: AnimatedOpacity(
                  opacity: isTurn ? 1 : 0,
                  duration: const Duration(milliseconds: 140),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD15C),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Text(
                        'TURN',
                        style: TextStyle(
                          color: Color(0xFF73411F),
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 104,
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF6F3F2B).withOpacity(0.78),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: const Color(0xFFD8A15C).withOpacity(0.55),
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: alignLeft ? TextAlign.left : TextAlign.right,
            style: const TextStyle(
              color: Color(0xFFF8E8D2),
              fontSize: 13,
              fontWeight: FontWeight.w800,
              shadows: [
                Shadow(
                  color: Colors.black45,
                  offset: Offset(0, 1),
                  blurRadius: 1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CenterVsSection extends StatelessWidget {
  final String timeText;

  const _CenterVsSection({
    required this.timeText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFB97A60),
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'VS',
              style: TextStyle(
                color: Color(0xFFF8E8D2),
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 82,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFA16B49),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFD8A15C),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              const Text(
                'Time',
                style: TextStyle(
                  color: Color(0xFFF8E8D2),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                timeText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BoardNode extends StatelessWidget {
  final int value;
  final Color color;
  final bool isSelected;
  final bool isWinnerNode;
  final bool isValidDestination;
  final VoidCallback onTap;

  const _BoardNode({
    required this.value,
    required this.color,
    required this.isSelected,
    required this.isWinnerNode,
    required this.isValidDestination,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = value == 0;

    Color fillColor;
    if (isEmpty && isValidDestination) {
      fillColor = const Color(0xFFFFD15C).withValues(alpha: 0.55);
    } else if (isEmpty) {
      fillColor = Colors.transparent;
    } else {
      fillColor = color;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 170),
        curve: Curves.easeOut,
        width: isSelected ? 44 : 40,
        height: isSelected ? 44 : 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: fillColor,
          border: Border.all(
            color: isWinnerNode
                ? const Color(0xFFFFD15C)
                : isSelected
                ? Colors.white
                : const Color(0xFFF8E8D2),
            width: isWinnerNode || isSelected ? 4 : 1.2,
          ),
          boxShadow: [
            if (!isEmpty)
              const BoxShadow(
                color: Colors.black38,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            if (isWinnerNode)
              const BoxShadow(
                color: Color(0xAAFFD15C),
                blurRadius: 14,
                spreadRadius: 2,
              ),
          ],
        ),
        child: value == 0
            ? null
            : Center(
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.30),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _PieceCluster extends StatelessWidget {
  final Color color;
  final int activeCount;

  const _PieceCluster({
    required this.color,
    required this.activeCount,
  });

  @override
  Widget build(BuildContext context) {
    final offsets = [
      const Offset(10, 16),
      const Offset(34, 8),
      const Offset(20, 36),
    ];

    return SizedBox(
      width: 96,
      height: 82,
      child: Stack(
        children: List.generate(3, (index) {
          final isActive = index < activeCount;

          return Positioned(
            left: offsets[index].dx,
            top: offsets[index].dy,
            child: Opacity(
              opacity: isActive ? 1 : 0.25,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.18),
                    width: 1.2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _LelempeunganBoardPainter extends CustomPainter {
  const _LelempeunganBoardPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const inset = 28.0;

    final left = inset;
    final right = size.width - inset;
    final top = inset;
    final bottom = size.height - inset;
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    final lineShadow = Paint()
      ..color = Colors.black.withValues(alpha: 0.18)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final linePaint = Paint()
      ..color = const Color(0xFFF8E8D2)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    void drawLine(Offset start, Offset end) {
      canvas.drawLine(
        start.translate(0, 2),
        end.translate(0, 2),
        lineShadow,
      );
      canvas.drawLine(start, end, linePaint);
    }

    drawLine(Offset(left, top), Offset(right, top));
    drawLine(Offset(right, top), Offset(right, bottom));
    drawLine(Offset(right, bottom), Offset(left, bottom));
    drawLine(Offset(left, bottom), Offset(left, top));

    drawLine(Offset(centerX, top), Offset(centerX, bottom));
    drawLine(Offset(left, centerY), Offset(right, centerY));

    drawLine(Offset(left, top), Offset(centerX, centerY));
    drawLine(Offset(right, top), Offset(centerX, centerY));
    drawLine(Offset(left, bottom), Offset(centerX, centerY));
    drawLine(Offset(right, bottom), Offset(centerX, centerY));
  }

  @override
  bool shouldRepaint(covariant _LelempeunganBoardPainter oldDelegate) {
    return false;
  }
}

class _SettingsSquareButton extends StatefulWidget {
  final VoidCallback onTap;

  const _SettingsSquareButton({
    required this.onTap,
  });

  @override
  State<_SettingsSquareButton> createState() => _SettingsSquareButtonState();
}

class _SettingsSquareButtonState extends State<_SettingsSquareButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) return;
    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1,
        duration: const Duration(milliseconds: 90),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF9D6947),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: _isPressed ? 3 : 6,
                offset: Offset(0, _isPressed ? 2 : 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.settings,
            color: Color(0xFFF8E8D2),
            size: 26,
          ),
        ),
      ),
    );
  }
}

class _SmallRoundButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final Color iconColor;

  const _SmallRoundButton({
    required this.icon,
    required this.onTap,
    this.color = const Color(0xFF8F5B3A),
    this.iconColor = const Color(0xFFF8E8D2),
  });

  @override
  State<_SmallRoundButton> createState() => _SmallRoundButtonState();
}

class _SmallRoundButtonState extends State<_SmallRoundButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) return;

    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.90 : 1,
        duration: const Duration(milliseconds: 90),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: _isPressed ? 3 : 6,
                offset: Offset(0, _isPressed ? 2 : 4),
              ),
            ],
          ),
          child: Icon(
            widget.icon,
            color: widget.iconColor,
            size: 26,
          ),
        ),
      ),
    );
  }
}

class _DialogButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DialogButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_DialogButton> createState() => _DialogButtonState();
}

class _DialogButtonState extends State<_DialogButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) return;

    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : 1,
        duration: const Duration(milliseconds: 90),
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE0B36E),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: _isPressed ? 3 : 7,
                offset: Offset(0, _isPressed ? 2 : 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: const Color(0xFFF8E8D2),
                size: 20,
              ),
              const SizedBox(height: 3),
              Text(
                widget.label,
                style: const TextStyle(
                  color: Color(0xFFF8E8D2),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 10, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE7DDD0),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF5E6C55),
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF8A4F2C),
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: const Color(0xFF6B7F4E),
            activeTrackColor: const Color(0xFFBFD3A6),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}