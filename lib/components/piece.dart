// Enum que define los diferentes tipos de piezas de ajedrez.
enum ChessPieceType {
  pawn, // Peón
  rook, // Torre
  knight, // Caballo
  bishop, // Alfil
  queen, // Reina
  king // Rey
}

// Clase que representa una pieza de ajedrez.
class ChessPiece {
  final ChessPieceType type; // Tipo de la pieza (peón, torre, etc.).
  final bool isWhite; // Indica si la pieza es blanca (true) o negra (false).
  final String imagePath; // Ruta de la imagen que representa la pieza.
  bool hasMoved;
  // Constructor de la clase ChessPiece.
  ChessPiece({
    required this.type, // Tipo de pieza, requerido al crear una instancia.
    required this.isWhite, // Indica el color de la pieza, requerido al crear una instancia.
    required this.imagePath, // Ruta de la imagen, requerida al crear una instancia.
    this.hasMoved = false,
  });
}
