import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class AppData with ChangeNotifier {
  // App status

  String numMines = "5x5";
  String sizeBoard = "9x9";
  Random rand = Random();

  List<List<String>> board = [];
  bool gameIsOver = false;
  String gameWinner = '-';

  ui.Image? imagePlayer;
  ui.Image? imageOpponent;
  bool imagesReady = false;

void startGame(){
  board = [];

  //Instanciamos la matriz
  int numM = int.parse(numMines[0]);
  int sizeB = int.parse(sizeBoard[0]);
  for(int i=0; i<sizeB; ++i){
    List<String> row = [];
    for(int j=0; j<sizeB; ++j){
      row.add("");
    }
    board.add(row);
  }

  //Generamos bombas aleatoriamente
  for(int i=0; i<numM; ++i){
    while(true){
      int posX = rand.nextInt(sizeB);
      int posY = rand.nextInt(sizeB);
      if(board[posY][posX] != "."){
        //print("PosX: " + posX.toString() + " " + "PosY: " + posY.toString());
        board[posY][posX] = ".";
        break;
      }
    }
  }

  //Introducimos los numeros
  for(int i=0; i<sizeB; ++i){
    for(int j=0; j<sizeB; ++j){
      int cont = 0;
      if(i+1 < sizeB && j-1 > -1){// TOP-L
        if(board[i+1][j-1]=="."){
          ++cont;
        }
      }
      if(i+1 < sizeB){// TOP-C
        if(board[i+1][j]=="."){
          ++cont;
        }
      }
      if(i+1 < sizeB && j+1 < sizeB){// TOP-R
        if(board[i+1][j+1]=="."){
          ++cont;
        }
      }
      if(j-1 > -1){// CENTER-L
        if(board[i][j-1]=="."){
          ++cont;
        }
      }
      if(j+1 > sizeB){// CENTER-R
        if(board[i][j+1]=="."){
          ++cont;
        }
      } 
      if(i-1 < -1 && j-1 > -1){// BOT-L
        if(board[i-1][j-1]=="."){
          ++cont;
        }
      }
      if(i-1 < -1){// BOT-C
        if(board[i-1][j]=="."){
          ++cont;
        }
      }
      if(i-1 < -1 && j+1 > sizeB){// BOT-R
        if(board[i-1][j+1]=="."){
          ++cont;
        }
      }
      if(cont!=0){
        board[i][j] = cont;
      }
    }
  }

  board.forEach(print);
}



  void resetGame() {
    board = [
      ['-', '-', '-'],
      ['-', '-', '-'],
      ['-', '-', '-'],
    ];
    gameIsOver = false;
    gameWinner = '-';
  }

  // Fa una jugada, primer el jugador després la maquina
  void playMove(int row, int col) {
    startGame();
    if (board[row][col] == '-') {
      board[row][col] = 'X';
      checkGameWinner();
      if (gameWinner == '-') {
        machinePlay();
      }
    }
  }

  // Fa una jugada de la màquina, només busca la primera posició lliure
  void machinePlay() {
    bool moveMade = false;

    // Buscar una casella lliure '-'
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == '-') {
          board[i][j] = 'O';
          moveMade = true;
          break;
        }
      }
      if (moveMade) break;
    }

    checkGameWinner();
  }

  // Comprova si el joc ja té un tres en ratlla
  // No comprova la situació d'empat
  void checkGameWinner() {
    for (int i = 0; i < 3; i++) {
      // Comprovar files
      if (board[i][0] == board[i][1] &&
          board[i][1] == board[i][2] &&
          board[i][0] != '-') {
        gameIsOver = true;
        gameWinner = board[i][0];
        return;
      }

      // Comprovar columnes
      if (board[0][i] == board[1][i] &&
          board[1][i] == board[2][i] &&
          board[0][i] != '-') {
        gameIsOver = true;
        gameWinner = board[0][i];
        return;
      }
    }

    // Comprovar diagonal principal
    if (board[0][0] == board[1][1] &&
        board[1][1] == board[2][2] &&
        board[0][0] != '-') {
      gameIsOver = true;
      gameWinner = board[0][0];
      return;
    }

    // Comprovar diagonal secundària
    if (board[0][2] == board[1][1] &&
        board[1][1] == board[2][0] &&
        board[0][2] != '-') {
      gameIsOver = true;
      gameWinner = board[0][2];
      return;
    }

    // No hi ha guanyador, torna '-'
    gameWinner = '-';
  }

  // Carrega les imatges per dibuixar-les al Canvas
  Future<void> loadImages(BuildContext context) async {
    // Si ja estàn carregades, no cal fer res
    if (imagesReady) {
      notifyListeners();
      return;
    }

    // Força simular un loading
    await Future.delayed(const Duration(milliseconds: 500));

    Image tmpPlayer = Image.asset('assets/images/player.png');
    Image tmpOpponent = Image.asset('assets/images/opponent.png');

    // Carrega les imatges
    if (context.mounted) {
      imagePlayer = await convertWidgetToUiImage(tmpPlayer);
    }
    if (context.mounted) {
      imageOpponent = await convertWidgetToUiImage(tmpOpponent);
    }

    imagesReady = true;

    // Notifica als escoltadors que les imatges estan carregades
    notifyListeners();
  }

  // Converteix les imatges al format vàlid pel Canvas
  Future<ui.Image> convertWidgetToUiImage(Image image) async {
    final completer = Completer<ui.Image>();
    image.image.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener(
            (info, _) => completer.complete(info.image),
          ),
        );
    return completer.future;
  }
}