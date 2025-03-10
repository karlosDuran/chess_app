import 'package:flutter/material.dart';

class DeadPiece extends StatelessWidget {
  final String imagePath;
  final bool isWhite;
  const DeadPiece({super.key, required this.imagePath, required this.isWhite});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity:
          0.5, // Ajusta este valor entre 0.0 y 1.0 para cambiar la transparencia.
      child: Image.asset(
        imagePath,
      ),
    );
  }
}
