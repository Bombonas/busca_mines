import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart'; // per a 'CustomPainter'
import 'app_data.dart';

// S'encarrega del dibuix personalitzat del joc
class WidgetTresRatllaPainter extends CustomPainter {
  final AppData appData;
  int colrow = 0;

  WidgetTresRatllaPainter(this.appData);

  // Dibuixa les linies del taulell
  void drawBoardLines(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5.0;

    String board = appData.sizeBoard;
    if (board == "9x9") {
      colrow = 9;
    } else {
      colrow = 15;
    }
    for (int i = 0; i < colrow; i++) {
      double vertical = i * (size.width / colrow);
      canvas.drawLine(
          Offset(vertical, 0), Offset(vertical, size.height), paint);
      double horizontal = i * (size.height / colrow);
      canvas.drawLine(
          Offset(0, horizontal), Offset(size.width, horizontal), paint);
    }
  }

  // Dibuixa la imatge centrada a una casella del taulell
  void drawImage(Canvas canvas, ui.Image image, double x0, double y0, double x1,
      double y1) {
    double dstWidth = x1 - x0;
    double dstHeight = y1 - y0;

    double imageAspectRatio = image.width / image.height;
    double dstAspectRatio = dstWidth / dstHeight;

    double finalWidth;
    double finalHeight;

    if (imageAspectRatio > dstAspectRatio) {
      finalWidth = dstWidth;
      finalHeight = dstWidth / imageAspectRatio;
    } else {
      finalHeight = dstHeight;
      finalWidth = dstHeight * imageAspectRatio;
    }

    double offsetX = x0 + (dstWidth - finalWidth) / 2;
    double offsetY = y0 + (dstHeight - finalHeight) / 2;

    final srcRect =
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dstRect = Rect.fromLTWH(offsetX, offsetY, finalWidth, finalHeight);

    canvas.drawImageRect(image, srcRect, dstRect, Paint());
  }

  void drawSquare(Canvas canvas, double x0, double y0, double x1, double y1){
    final paint = Paint()
      ..color = const ui.Color.fromARGB(255, 202, 202, 202)
      ..style = PaintingStyle.fill;
    final rect = Rect.fromPoints(Offset(x0, y0), Offset(x1, y1));
    canvas.drawRect(rect, paint);
  }

//ToDo: La funcion que dibuja los numeros
  void drawNumber(Canvas canvas, double x0, double y0, double x1, double y1, double x2, double y2, int number, double cellWidth){
    final paint = Paint()
      ..color = const ui.Color.fromARGB(255, 202, 202, 202)
      ..style = PaintingStyle.fill;
    final rect = Rect.fromPoints(Offset(x0, y0), Offset(x1, y1));
    canvas.drawRect(rect, paint);
    Color color = Colors.black;
    switch(number){
      case 1:
        color = ui.Color.fromARGB(255, 0, 183, 255);
        break;
      case 2:
        color = ui.Color.fromARGB(255, 9, 107, 0);
        break;
      case 3:
        color = ui.Color.fromARGB(255, 236, 0, 0);
        break;
      case 4:
        color = const ui.Color.fromARGB(255, 0, 14, 211);
        break;
      case 5:
        color = ui.Color.fromARGB(255, 126, 19, 0);
        break;
      case 6:
        color = ui.Color.fromARGB(255, 6, 187, 142);
        break;
      case 7:
        color = ui.Color.fromARGB(255, 0, 0, 0);
        break;
      case 8:
        color = ui.Color.fromARGB(255, 85, 85, 85);
        break;
    }

    final textStyle = TextStyle(
      color: color,
      fontSize: 64.0,
      fontWeight: FontWeight.bold,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: number.toString(), style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      maxWidth: cellWidth,
    );

    textPainter.paint(canvas, Offset(x2, y2));
  }

  void drawFlag(Canvas canvas, double x0, double y0, double x1, double y1){

    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5.0;

    canvas.drawLine(Offset(x0, y0), Offset(x1, y1), paint);
    var path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.height, size.width);
    path.close();
    canvas.drawPath(path, Paint()..color = Colors.green);
  }

  }

  // Dibuia una creu centrada a una casella del taulell
  void drawCross(Canvas canvas, double x0, double y0, double x1, double y1,
      Color color, double strokeWidth) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    canvas.drawLine(
      Offset(x0, y0),
      Offset(x1, y1),
      paint,
    );
    canvas.drawLine(
      Offset(x1, y0),
      Offset(x0, y1),
      paint,
    );
  }

  // Dibuixa un cercle centrat a una casella del taulell
  void drawCircle(Canvas canvas, double x, double y, double radius, Color color,
      double strokeWidth) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(Offset(x, y), radius, paint);
  }

  

  // Dibuixa el taulell de joc (creus i rodones)
  void drawBoardStatus(Canvas canvas, Size size) {
    // Dibuixar 'X' i 'O' del tauler
    double cellWidth = size.width / colrow;
    double cellHeight = size.height / colrow;

    for (int i = 0; i < colrow; i++) {
      for (int j = 0; j < colrow; j++) {
        if (appData.board[i][j] == 'C') {
          // Dibujamos los cuadros vacios
          double x0 = j * cellWidth+2.5;
          double y0 = i * cellHeight+2.5;
          double x1 = (j + 1) * cellWidth-2.5;
          double y1 = (i + 1) * cellHeight-2.5;

          drawSquare(canvas, x0, y0, x1, y1);
        } else if(appData.board[i][j].length > 1){
          double x0 = j * cellWidth+2.5;
          double y0 = i * cellHeight+2.5;
          double x1 = (j + 1) * cellWidth-2.5;
          double y1 = (i + 1) * cellHeight-2.5;
          double x2 = j * cellWidth + cellWidth*0.40;
          double y2 = i * cellHeight;

          drawNumber(canvas, x0, y0, x1, y1, x2, y2, int.parse(appData.board[i][j][0]), cellWidth);
        }
        else  {// if (appData.board[i][j] == 'O')
          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;
          double cX = x0 + (x1 - x0) / 2;
          double cY = y0 + (y1 - y0) / 2;
          double radius = (min(cellWidth, cellHeight) / 2) - 5;

          

        }
      }
    }
  }

  // Dibuixa el missatge de joc acabat
  void drawGameOver(Canvas canvas, Size size) {
    String message = "Has perdut :(";

    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: message, style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      maxWidth: size.width,
    );

    // Centrem el text en el canvas
    final position = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    // Dibuixar un rectangle semi-transparent que ocupi tot l'espai del canvas
    final bgRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.7) // Ajusta l'opacitat com vulguis
      ..style = PaintingStyle.fill;

    canvas.drawRect(bgRect, paint);

    // Ara, dibuixar el text
    textPainter.paint(canvas, position);
  }

  // Funció principal de dibuix
  @override
  void paint(Canvas canvas, Size size) {
    drawBoardLines(canvas, size);
    drawBoardStatus(canvas, size);
    if (!appData.gameWinner && appData.gameIsOver) {
      drawGameOver(canvas, size);
    }
  }

  // Funció que diu si cal redibuixar el widget
  // Normalment hauria de comprovar si realment cal, ara només diu 'si'
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
