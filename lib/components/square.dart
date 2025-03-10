import 'package:chess_app/components/piece.dart'; // Importa la clase ChessPiece que representa las piezas de ajedrez.
import 'package:chess_app/values/colors.dart'; // Importa los valores de color utilizados en la aplicación.
import 'package:flutter/material.dart'; // Importa el paquete de material de Flutter.

class Square extends StatelessWidget {
  final bool isWhite; // Indica si el cuadrado es blanco (true) o negro (false).
  final ChessPiece?
      piece; // La pieza de ajedrez que se encuentra en este cuadrado, puede ser null si no hay pieza.
  final bool
      isSelected; // Indica si el cuadrado está seleccionado (true) o no (false).
  final bool isValidMove;
  final void Function()? onTap; // Función que se ejecuta al tocar el cuadrado.

  // Constructor de la clase Square, que requiere los parámetros necesarios.
  const Square({
    super.key,
    required this.isWhite, // Requiere el color del cuadrado.
    required this.piece, // Requiere la pieza que puede estar en el cuadrado.
    required this.isSelected, // Requiere el estado de selección del cuadrado.
    required this.onTap, // Requiere la función que se ejecutará al tocar el cuadrado.
    required this.isValidMove,
  });

  @override
  Widget build(BuildContext context) {
    Color? squareColor; // Variable para almacenar el color del cuadrado.

    // Si el cuadrado está seleccionado, cambia el color a azul.
    if (isSelected) {
      squareColor = Colors.blue; // Color del cuadrado seleccionado.
    } else if (isValidMove) {
      squareColor = Colors.blue[300];
    }
    // Si no está seleccionado, establece el color según si es blanco o negro.
    else {
      squareColor = isWhite
          ? foregroundColor
          : backgroundColor; // Asigna el color correspondiente.
    }

    return GestureDetector(
      // Detecta toques en el cuadrado para permitir la selección de piezas.
      onTap: onTap, // Llama a la función onTap cuando se toca el cuadrado.
      child: Container(
        color: squareColor, // Establece el color del cuadrado.
        margin: EdgeInsets.all(isValidMove ? 6 : 0),
        child: piece != null // Verifica si hay una pieza en el cuadrado.
            ? Image.asset(
                piece!
                    .imagePath, // Carga la imagen de la pieza desde la ruta especificada.
                // Establece el color de la imagen según el color de la pieza.
              )
            : null, // Si no hay pieza, no se muestra nada.
      ),
    );
  }
}
