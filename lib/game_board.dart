// ignore: unused_import
import 'dart:ffi'; // Importa la biblioteca FFI de Dart, aunque no se utiliza en este código.

import 'package:chess_app/components/piece.dart'; // Importa el componente de pieza de ajedrez.
import 'package:chess_app/components/square.dart'; // Importa el componente de cuadrado del tablero.
import 'package:chess_app/helper/helper_methods.dart'; // Importa métodos de ayuda.
import 'package:chess_app/values/colors.dart'; // Importa los valores de color utilizados en la aplicación.
import 'package:flutter/material.dart';

import 'components/dead_piece.dart'; // Importa el paquete de material de Flutter.

class GameBoard extends StatefulWidget {
  const GameBoard({super.key}); // Constructor del widget GameBoard.

  @override
  State<GameBoard> createState() =>
      _GameBoardState(); // Crea el estado asociado al widget.
}

class _GameBoardState extends State<GameBoard> {
  // Lista 2D donde cada posible posición contiene una pieza de ajedrez.
  late List<List<ChessPiece?>> board;

  // La pieza actualmente seleccionada en el tablero de ajedrez.
  // Si no hay ninguna seleccionada, es null.
  ChessPiece? selectedPiece;

  // Índice de fila de la pieza seleccionada.
  // Valor por defecto es -1, indicando que no se ha seleccionado nada.
  int selectedRow = -1;

  // Índice de columna de la pieza seleccionada.
  // Valor por defecto es -1, indicando que no se ha seleccionado nada.
  int selectedCol = -1;

  // lista de movimientos validos por pieza
  //cada movimiento es representado por una lista con row y column
  List<List<int>> validMoves = [];

  //lista de piezas que a tomado el jugador negro
  List<ChessPiece> whitePiecesTaken = [];

  //lista de piezas qqu a tomado el jugador privilegiado
  List<ChessPiece> blackPiecesTaken = [];

  //a boolean to indicate quien va, si los negros o blancos
  bool isWhiteTurn = true;
  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];
  bool checkStatus = false;
  //posicicon inicial del rey, seguir siguiendolo

  List<int>?
      enPassantVulnerable; // Guardará las coordenadas [fila, columna] del peón vulnerable.

  // Inicializa el tablero.
  @override
  void initState() {
    super.initState(); // Llama al método initState de la clase base.
    _initializeBoard(); // Llama al método para inicializar el tablero.
  }

  void _initializeBoard() {
    // Inicializa las piezas en sus posiciones correspondientes.
    List<List<ChessPiece?>> newBoard = List.generate(
        8,
        (index) => List.generate(
            8, (index) => null)); // Crea un nuevo tablero vacío de 8x8.

    // Posición de los peones negros.
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = ChessPiece(
          type: ChessPieceType.pawn, // Tipo de pieza: peón.
          isWhite: false, // Indica que es negro.
          imagePath:
              "lib/images/black-pawn.png"); // Ruta de la imagen del peón negro.
    }

    // Posición de los peones blancos.
    for (int i = 0; i < 8; i++) {
      newBoard[6][i] = ChessPiece(
          type: ChessPieceType.pawn, // Tipo de pieza: peón.
          isWhite: true, // Indica que es blanco.
          imagePath:
              "lib/images/white-pawn.png"); // Ruta de la imagen del peón blanco.
    }

    // Posición de las torres negras.
    newBoard[0][0] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: false,
        imagePath: "lib/images/black-rook.png");

    newBoard[0][7] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: false,
        imagePath: "lib/images/black-rook.png");

    // Posición de las torres blancas.
    newBoard[7][0] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: true,
        imagePath: "lib/images/white-rook.png");

    newBoard[7][7] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: true,
        imagePath: "lib/images/white-rook.png");

    // Posición de los caballos negros.
    newBoard[0][1] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: false,
        imagePath: "lib/images/black-knight.png");

    newBoard[0][6] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: false,
        imagePath: "lib/images/black-knight.png");

    // Posición de los caballos blancos.
    newBoard[7][1] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: true,
        imagePath: "lib/images/white-knight.png");

    newBoard[7][6] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: true,
        imagePath: "lib/images/white-knight.png");

    // Posición de los alfiles negros.
    newBoard[0][2] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: false,
        imagePath: "lib/images/black-bishop.png");

    newBoard[0][5] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: false,
        imagePath: "lib/images/black-bishop.png");

    // Posición de los alfiles blancos.
    newBoard[7][2] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: true,
        imagePath: "lib/images/white-bishop.png");

    newBoard[7][5] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: true,
        imagePath: "lib/images/white-bishop.png");

    // Posición de la reina negra.
    newBoard[0][3] = ChessPiece(
        type: ChessPieceType.queen,
        isWhite: false,
        imagePath: "lib/images/black-queen.png");

    // Posición de la reina blanca.
    newBoard[7][3] = ChessPiece(
        type: ChessPieceType.queen,
        isWhite: true,
        imagePath: "lib/images/white-queen.png");

    // Posición del rey negro.
    newBoard[0][4] = ChessPiece(
        type: ChessPieceType.king,
        isWhite: false,
        imagePath: "lib/images/black-king.png");

    // Posición del rey blanco.
    newBoard[7][4] = ChessPiece(
        type: ChessPieceType.king,
        isWhite: true,
        imagePath: "lib/images/white-king.png");

    board =
        newBoard; // Asigna el nuevo tablero inicializado a la variable board.
  }

  // Método que se llama cuando el usuario selecciona una pieza.
  void pieceSelected(int row, int col) {
    setState(() {
      // Verifica si no hay ninguna pieza seleccionada y si hay una pieza en la casilla clicada.
      if (selectedPiece == null && board[row][col] != null) {
        // Si no hay pieza seleccionada (selectedPiece es null) y hay una pieza en la casilla (board[row][col] no es null),
        // entonces seleccionamos la pieza en esa casilla.
        if (board[row][col]!.isWhite == isWhiteTurn) {
          selectedPiece = board[row][
              col]; // Almacena la pieza seleccionada en la variable selectedPiece.
          selectedRow =
              row; // Almacena la fila de la pieza seleccionada en selectedRow.
          selectedCol =
              col; // Almacena la columna de la pieza seleccionada en selectedCol.
        }
      }

// Si ya hay una pieza seleccionada, verifica si la nueva casilla clicada tiene una pieza del mismo color.
      else if (board[row][col] != null &&
          board[row][col]!.isWhite == selectedPiece!.isWhite) {
        // Aquí estamos comprobando dos cosas:
        // 1. Si hay una pieza en la nueva casilla (board[row][col] no es null).
        // 2. Si la pieza en la nueva casilla es del mismo color que la pieza ya seleccionada (isWhite).

        selectedPiece = board[row]
            [col]; // Almacena la nueva pieza seleccionada en selectedPiece.
        selectedRow =
            row; // Almacena la fila de la nueva pieza seleccionada en selectedRow.
        selectedCol =
            col; // Almacena la columna de la nueva pieza seleccionada en selectedCol.
      }

      //si hayuna pieza sleccionada y elegimos un square que es valido se mueve ahi

      else if (selectedPiece != null &&
          validMoves.any((element) => element[0] == row && element[1] == col)) {
        movePiece(row, col);
      }
      //cuando seleccionas una pieza, muestra los movimientos validos
      validMoves = calculateRealValidMoves(
          selectedRow, selectedCol, selectedPiece, true);
    });
  }

  bool canCastle(bool isWhiteKing, bool isKingSide) {
    // Posiciones iniciales del rey y las torres
    List<int> kingPosition =
        isWhiteKing ? whiteKingPosition : blackKingPosition;
    int row = kingPosition[0];
    int kingCol = kingPosition[1];
    int rookCol = isKingSide ? 7 : 0;

    // Verifica que el rey y la torre no se hayan movido
    if (board[row][kingCol]?.type != ChessPieceType.king ||
        board[row][rookCol]?.type != ChessPieceType.rook ||
        board[row][kingCol]?.hasMoved == true ||
        board[row][rookCol]?.hasMoved == true) {
      return false;
    }

    // Verifica que las casillas entre el rey y la torre estén vacías
    int direction = isKingSide ? 1 : -1;
    for (int col = kingCol + direction; col != rookCol; col += direction) {
      if (board[row][col] != null) {
        return false;
      }
    }

    // Verifica que el rey no pase por casillas atacadas
    for (int col = kingCol; col != kingCol + 2 * direction; col += direction) {
      // Simula el movimiento del rey
      if (simulatedMoveIsSafe(board[row][kingCol]!, row, kingCol, row, col)) {
        continue;
      } else {
        return false; // Si alguna posición está en jaque, no es válido
      }
    }

    return true; // Si todas las verificaciones se pasan, el enroque es válido
  }

  //calcular raw movimientos validos
  List<List<int>> calculateRawValidMoves(int row, int col, ChessPiece? piece) {
    List<List<int>> candidateMoves = [];

    if (piece == null) {
      return [];
    }
    //las direcciones son diferentes dependiendo del color
    int direction = piece.isWhite ? -1 : 1;

    switch (piece.type) {
      case ChessPieceType.pawn:
        // Pueden moverse hacia adelante si no hay nada en la casilla.
        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);
        }

        // Pueden moverse 2 casillas hacia adelante si están en la posición inicial.
        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null &&
              board[row + direction][col] == null) {
            candidateMoves.add([row + 2 * direction, col]);
          }
        }

        // Pueden capturar diagonalmente a la izquierda.
        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col - 1]);
        }

        // Pueden capturar diagonalmente a la derecha.
        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col + 1]);
        }

        // Movimiento "En Passant"
        if (enPassantVulnerable != null &&
            row == (piece.isWhite ? 3 : 4) && // Fila correcta para "En Passant"
            (col - 1 == enPassantVulnerable![1] ||
                col + 1 == enPassantVulnerable![1])) {
          candidateMoves.add([row + direction, enPassantVulnerable![1]]);
        }

        break;

      case ChessPieceType.rook:
        //horizontal y vertical too ez
        var directions = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1] // right
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves
                    .add([newRow, newCol]); //para matar ponerse bellacoso
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.knight:
        // se puede mover a 8 lugares pq se mueve en L
        var knightMoves = [
          [-2, -1], // arriba 2 izquierda 1
          [-2, 1], // arriba 2 derecha 1
          [-1, -2], // arriba 1 izquierda 2
          [-1, 2], // arriba 1 derecha 2
          [1, -2], //abajo 1 izquierda 2
          [1, 2], //abajo 1 derecha 2
          [2, -1], //abajo 2 izquierda 1
          [2, 1] // adivina
        ];
        for (var move in knightMoves) {
          var newRow = row + move[0];
          var newCol = col + move[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]); //matar a la vrg
            }
            continue;
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;
      case ChessPieceType.bishop:
        var directions = [
          [-1, -1],
          [-1, 1],
          [1, -1],
          [1, 1],
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves
                    .add([newRow, newCol]); //para matar ponerse bellacoso
              }
              break; // es el mismo color, simio no mata simio
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }

        break;
      case ChessPieceType.queen:
        var directions = [
          [-1, 0],
          [1, 0],
          [0, -1],
          [0, 1],
          [-1, -1],
          [-1, 1],
          [1, -1],
          [1, 1],
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves
                    .add([newRow, newCol]); //para matar ponerse bellacoso
              }
              break; // es el mismo color, simio no mata simio
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.king:
        var directions = [
          [-1, 0],
          [1, 0],
          [0, -1],
          [0, 1],
          [-1, -1],
          [-1, 1],
          [1, -1],
          [1, 1],
        ];

        for (var direction in directions) {
          var newRow = row + direction[0];
          var newCol = col + direction[1];

          if (!isInBoard(newRow, newCol)) continue;

          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
            continue;
          }

          candidateMoves.add([newRow, newCol]);
        }

        // Verificar enroque corto (hacia la derecha)
        if (!piece.hasMoved && canCastle(piece.isWhite, true)) {
          candidateMoves.add([row, col + 2]);
        }

        // Verificar enroque largo (hacia la izquierda)
        if (!piece.hasMoved && canCastle(piece.isWhite, false)) {
          candidateMoves.add([row, col - 2]);
        }
        break;
    }
    return candidateMoves;
  }

//calcular los REALES
  List<List<int>> calculateRealValidMoves(
      int row, int col, ChessPiece? piece, bool checkSimulation) {
    List<List<int>> realValideMoves = [];
    List<List<int>> candidateMoves = calculateRawValidMoves(row, col, piece);

    //despues hay que filtrar si hay king chek}
    if (checkSimulation) {
      for (var move in candidateMoves) {
        int endRow = move[0];
        int endCol = move[1];

        //esto va a ver si el proximo movimiento es safe
        if (simulatedMoveIsSafe(piece!, row, col, endRow, endCol)) {
          realValideMoves.add(move);
        }
      }
    } else {
      realValideMoves = candidateMoves;
    }
    return realValideMoves;
  }

  void showPromotionDialog(int row, int col, ChessPiece piece) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Selecciona una pieza de promoción'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var type in [
                ChessPieceType.queen,
                ChessPieceType.rook,
                ChessPieceType.bishop,
                ChessPieceType.knight
              ])
                GestureDetector(
                  onTap: () {
                    setState(() {
                      board[row][col] = ChessPiece(
                        type: type,
                        isWhite: piece.isWhite,
                        imagePath:
                            "lib/images/${piece.isWhite ? 'white' : 'black'}-${type.name}.png",
                      );
                      board[selectedRow][selectedCol] = null;
                      selectedPiece = null;
                      selectedRow = -1;
                      selectedCol = -1;
                    });
                    Navigator.pop(context);
                    isWhiteTurn = !isWhiteTurn;
                  },
                  child: Image.asset(
                    "lib/images/${piece.isWhite ? 'white' : 'black'}-${type.name}.png",
                    width: 50,
                    height: 50,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

// mover la piezas
  void movePiece(int newRow, int newCol) {
    //si el spot tenia un enemigo
    if (board[newRow][newCol] != null) {
      //añadir captura
      var capturedPiece = board[newRow][newCol];
      if (capturedPiece!.isWhite) {
        whitePiecesTaken.add(capturedPiece);
      } else {
        blackPiecesTaken.add(capturedPiece);
      }
    }
    // Manejar "En Passant"
    if (selectedPiece!.type == ChessPieceType.pawn &&
        enPassantVulnerable != null &&
        newRow ==
            (selectedPiece!.isWhite
                ? 2
                : 5) && // Fila de destino para "En Passant"
        newCol == enPassantVulnerable![1]) {
      // Captura "En Passant"
      board[enPassantVulnerable![0]][enPassantVulnerable![1]] =
          null; // Elimina al peón capturado
    }
    // ver si la que se mueve es rey
    if (selectedPiece!.type == ChessPieceType.king &&
        (newCol == selectedCol + 2 || newCol == selectedCol - 2)) {
      bool isKingSide = newCol == selectedCol + 2;
      int rookCol = isKingSide ? 7 : 0;
      int newRookCol = isKingSide ? newCol - 1 : newCol + 1;

      // Mueve la torre en el enroque
      board[selectedRow][newRookCol] = board[selectedRow][rookCol];
      board[selectedRow][rookCol] = null;
      //marcar pq sino puedes hacer enroque varias veces
      board[selectedRow][newRookCol]!.hasMoved = true;
    }
    if (selectedPiece!.type == ChessPieceType.king) {
      //update donde puede moverse el rey
      if (selectedPiece!.isWhite) {
        whiteKingPosition = [newRow, newCol];
        board[selectedRow][selectedCol]!.hasMoved = true;
      } else {
        blackKingPosition = [newRow, newCol];
        board[selectedRow][selectedCol]!.hasMoved = true;
      }
    }
    if (selectedPiece != null &&
        selectedPiece!.type == ChessPieceType.pawn &&
        (newRow == 0 || newRow == 7)) {
      // Pasar la pieza seleccionada al diálogo
      showPromotionDialog(newRow, newCol, selectedPiece!);
      return;
    }
    //mover la pieza y quitar el antiguo
    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    // Marcar peones vulnerables a "En Passant"
    if (selectedPiece!.type == ChessPieceType.pawn &&
        ((selectedPiece!.isWhite && newRow == selectedRow - 2) ||
            (!selectedPiece!.isWhite && newRow == selectedRow + 2))) {
      enPassantVulnerable = [newRow, newCol]; // Marcar el peón como vulnerable
    } else {
      enPassantVulnerable = null; // Reiniciar si no aplica
    }

    //ver si el rey esta siendo atacado
    if (isKingInCheck(!isWhiteTurn)) {
      checkStatus = true;
    } else {
      checkStatus = false;
    }

    //clear selection
    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    });
    //check if es jaque despues del turno
    if (isCheckMate(!isWhiteTurn)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("jaque mate"),
          actions: [
            TextButton(
              onPressed: resetGame,
              child: const Text("jugar de nuevo"),
            ),
          ],
        ),
      );
    }

    // cambiar de turno
    isWhiteTurn = !isWhiteTurn;
  }

  //esta en jaque el rey?
  bool isKingInCheck(bool isWhiteKing) {
    //get de position of the king
    List<int> kingPosition =
        isWhiteKing ? whiteKingPosition : blackKingPosition;

    //checar si algun enemigo esta atacando al rey
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing) {
          continue;
        }

        List<List<int>> pieceValidMoves =
            calculateRealValidMoves(i, j, board[i][j], false);

        //checar si el rey esta en los movimientos validos
        if (pieceValidMoves.any((move) =>
            move[0] == kingPosition[0] && move[1] == kingPosition[1])) {
          return true;
        }
      }
    }
    return false;
  }

// simular para ver si el movimiento es safe y no mandar el king a la muerte
  bool simulatedMoveIsSafe(
      ChessPiece piece, int startRow, int startCol, int endRow, int endCol) {
    //guardar el estado del board, por si no es safe volver a como estaba
    ChessPiece? originalDestinationPiece = board[endRow][endCol];

    //si la pieza es el rey save its current position and update the new one
    List<int>? originalKingPosition;
    if (piece.type == ChessPieceType.king) {
      originalKingPosition =
          piece.isWhite ? whiteKingPosition : blackKingPosition;

      //update the king position
      if (piece.isWhite) {
        whiteKingPosition = [endRow, endCol];
      } else {
        blackKingPosition = [endRow, endCol];
      }
    }
    //simulate the move
    board[endRow][endCol] = piece;
    board[startRow][startCol] = null;

    //checkar si nuestro rey esta bajo atake
    bool kingInCheck = isKingInCheck(piece.isWhite);

    //restaurar el board original
    board[endRow][endCol] = originalDestinationPiece;
    board[startRow][startCol] = piece;
    //if the piece was the king restore it  original position

    if (piece.type == ChessPieceType.king) {
      if (piece.isWhite) {
        whiteKingPosition = originalKingPosition!;
      } else {
        blackKingPosition = originalKingPosition!;
      }
    }
    //si el king esta en jaque = verdad, significa no safe move
    return !kingInCheck;
  }

  //checar el jaque mate
  bool isCheckMate(bool isWhiteKing) {
    //si el rey no esta en jaque para que moverle
    if (!isKingInCheck(isWhiteKing)) {
      return false;
    }
    //si hay un legarl move no es chacke mate
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        //skip empty squares and pieces the other color
        if (board[i][j] == null || board[i][j]!.isWhite != isWhiteKing) {
          continue;
        }

        List<List<int>> pieceValidMoves =
            calculateRealValidMoves(i, j, board[i][j], true);

        //si esta lista tiene algun valid move no has perdido
        if (pieceValidMoves.isNotEmpty) {
          return false;
        }
      }
    }

    //no hay movimientos legales ya valio verga
    return true;
  }

  //resetear el juego
  void resetGame() {
    Navigator.pop(context);
    _initializeBoard();
    checkStatus = false;
    whitePiecesTaken.clear();
    blackPiecesTaken.clear();
    whiteKingPosition = [7, 4];
    blackKingPosition = [0, 4];
    isWhiteTurn = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          backgroundColor, // Establece el color de fondo del tablero.
      body: Column(
        children: [
          // white pieces taken
          Expanded(
            child: GridView.builder(
              itemCount: whitePiecesTaken.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8),
              itemBuilder: (context, index) => DeadPiece(
                imagePath: whitePiecesTaken[index].imagePath,
                isWhite: true,
              ),
            ),
          ),
          //checar
          //Text(checkStatus ? "check" : "lol"),

          // centrar el chess board
          Expanded(
            flex: 3,
            child: GridView.builder(
                itemCount: 8 * 8, // Total de celdas en el tablero (64).
                physics:
                    const NeverScrollableScrollPhysics(), // Desactiva el desplazamiento del GridView.
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        8), // Define que el tablero tendrá 8 columnas.
                itemBuilder: (context, index) {
                  // Obtiene la posición de fila y columna de este cuadrado.
                  int row = index ~/ 8; // Calcula la fila.
                  int col = index % 8; // Calcula la columna.

                  // Verifica si el cuadrado es seleccionado.
                  bool isSelected = selectedRow == row && selectedCol == col;

                  bool isValidMove = false;
                  for (var position in validMoves) {
                    if (position[0] == row && position[1] == col) {
                      isValidMove = true;
                    }
                  }
                  return Square(
                    isWhite: isWhite(
                        index), // Determina si el cuadrado es blanco o negro.
                    piece: board[row][
                        col], // Asigna la pieza en la posición correspondiente.
                    isSelected:
                        isSelected, // Indica si el cuadrado está seleccionado.
                    isValidMove: isValidMove,
                    onTap: () => pieceSelected(row,
                        col), // Llama al método pieceSelected al tocar el cuadrado.
                  );
                }),
          ),
          //black pieces taken
          Expanded(
            child: GridView.builder(
              itemCount: blackPiecesTaken.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8),
              itemBuilder: (context, index) => DeadPiece(
                imagePath: blackPiecesTaken[index].imagePath,
                isWhite: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
