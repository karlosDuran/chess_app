import 'package:chess_app/components/piece.dart';
import 'package:chess_app/values/colors.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  final bool isSelected;
  final void Function()? onTap;

  const Square(
      {super.key,
      required this.isWhite,
      required this.piece,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color? squareColor;

    //if selected, el color cambia
    if (isSelected) {
      squareColor = Colors.blue;
    }
    //else va a ser negro o blanco
    else {
      squareColor = isWhite ? foregroundColor : backgroundColor;
    }
    return GestureDetector(
      //para que las piesas puedan ser seleccionadas
      onTap: onTap,
      child: Container(
        color: squareColor,
        child: piece != null
            ? Image.asset(
                piece!.imagePath,
                color: piece!.isWhite ? Colors.white : Colors.black,
              )
            : null,
      ),
    );
  }
}
