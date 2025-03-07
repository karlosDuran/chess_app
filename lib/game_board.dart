// ignore: unused_import
import 'dart:ffi'; // Importa la biblioteca FFI de Dart, aunque no se utiliza en este código.

import 'package:chess_app/components/piece.dart'; // Importa el componente de pieza de ajedrez.
import 'package:chess_app/components/square.dart'; // Importa el componente de cuadrado del tablero.
import 'package:chess_app/helper/helper_methods.dart'; // Importa métodos de ayuda.
import 'package:chess_app/values/colors.dart'; // Importa los valores de color utilizados en la aplicación.
import 'package:flutter/material.dart'; // Importa el paquete de material de Flutter.

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
      // Solo selecciona si hay una pieza en la posición.
      if (board[row][col] != null) {
        selectedPiece = board[row][col]; // Almacena la pieza seleccionada.
        selectedRow = row; // Almacena la fila de la pieza seleccionada.
        selectedCol = col; // Almacena la columna de la pieza seleccionada.
      }

      //cuando seleccionas una pieza, muestra los movimientos validos
      validMoves =
          calculateRawValidMoves(selectedRow, selectedCol, selectedPiece);
    });
  }

  //calcular raw movimientos validos
  List<List<int>> calculateRawValidMoves(int row, int col, ChessPiece? piece) {
    List<List<int>> candidateMoves = [];

    //las direcciones son diferentes dependiendo del color
    int direction = piece!.isWhite ? -1 : 1;

    switch (piece.type) {
      case ChessPieceType.pawn:
        // pueden moverce adelante si no hay nada
        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);
        }
        //pueden moverse 2 adelantes si estan en la posicion inicial
        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null &&
              board[row + direction][col] == null) {
            candidateMoves.add([row + 2 * direction, col]);
          }
        }
        //pueden matar diagonalmente izquierda
        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isWhite) {
          candidateMoves.add([row + direction, col - 1]);
        }
        //pa la derehca
        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isWhite) {
          candidateMoves.add([row + direction, col + 1]);
        }

        break;
      case ChessPieceType.rook:
        break;
      case ChessPieceType.knight:
        break;
      case ChessPieceType.bishop:
        break;
      case ChessPieceType.queen:
        break;
      case ChessPieceType.king:
        break;
    }
    return candidateMoves;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          backgroundColor, // Establece el color de fondo del tablero.
      body: GridView.builder(
          itemCount: 8 * 8, // Total de celdas en el tablero (64).
          physics:
              const NeverScrollableScrollPhysics(), // Desactiva el desplazamiento del GridView.
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8), // Define que el tablero tendrá 8 columnas.
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
              isWhite:
                  isWhite(index), // Determina si el cuadrado es blanco o negro.
              piece: board[row]
                  [col], // Asigna la pieza en la posición correspondiente.
              isSelected:
                  isSelected, // Indica si el cuadrado está seleccionado.
              isValidMove: isValidMove,
              onTap: () => pieceSelected(row,
                  col), // Llama al método pieceSelected al tocar el cuadrado.
            );
          }),
    );
  }
}
