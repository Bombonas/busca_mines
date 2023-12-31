import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class AppData with ChangeNotifier {
  // App status

  late Timer timer;
  int seconds = 0;
  String numMines = "5";
  int numFlags = 0;
  String sizeBoard = "9x9";
  Random rand = Random();
  int sBoard = 9;

  List<List<String>> board = [];
  bool gameIsOver = false;
  bool gameWinner = false;

  ui.Image? imageFlag;
  ui.Image? imageBomb;
  bool imagesReady = false;

  void startGame() {
    startTimer();
    seconds = 0;
    numFlags = 0;
    gameIsOver = false;
    board = [];

    //Instanciamos la matriz
    int numM = int.parse(numMines);
    int sizeB = int.parse(sizeBoard[0]);
    for (int i = 0; i < sizeB; ++i) {
      List<String> row = [];
      for (int j = 0; j < sizeB; ++j) {
        row.add(" ");
      }
      board.add(row);
    }

    //Generamos bombas aleatoriamente
    for (int i = 0; i < numM; ++i) {
      while (true) {
        int posX = rand.nextInt(sizeB);
        int posY = rand.nextInt(sizeB);
        if (board[posY][posX] != "B") {
          //print("PosX: " + posX.toString() + " " + "PosY: " + posY.toString());
          board[posY][posX] = "B";
          break;
        }
      }
    }

    //Introducimos los numeros
    for (int i = 0; i < sizeB; ++i) {
      for (int j = 0; j < sizeB; ++j) {
        int cont = 0;
        if (board[i][j] == " ") {
          if (i + 1 < sizeB && j - 1 >= 0) {
            // TOP-L
            if (board[i + 1][j - 1] == "B") {
              ++cont;
            }
          }
          if (i + 1 < sizeB) {
            // TOP-C
            if (board[i + 1][j] == "B") {
              ++cont;
            }
          }
          if (i + 1 < sizeB && j + 1 < sizeB) {
            // TOP-R
            if (board[i + 1][j + 1] == "B") {
              ++cont;
            }
          }
          if (j - 1 >= 0) {
            // CENTER-L
            if (board[i][j - 1] == "B") {
              ++cont;
            }
          }
          if (j + 1 < sizeB) {
            // CENTER-R
            if (board[i][j + 1] == "B") {
              ++cont;
            }
          }
          if (i - 1 >= 0 && j - 1 >= 0) {
            // BOT-L
            if (board[i - 1][j - 1] == "B") {
              ++cont;
            }
          }
          if (i - 1 >= 0) {
            // BOT-C
            if (board[i - 1][j] == "B") {
              ++cont;
            }
          }
          if (i - 1 >= 0 && j + 1 < sizeB) {
            // BOT-R
            if (board[i - 1][j + 1] == "B") {
              ++cont;
            }
          }
          if (cont != 0) {
            board[i][j] = cont.toString();
          }
        }
      }
    }

    board.forEach(print);
  }

  void showCells(int i, int j) {
    int sizeB = int.parse(sizeBoard[0]);
    // B: bomb, C: checked(empty cell), F: flag(wrong positioned), N: nice flag(nice positioned), i and j in matrix range
    if (i >= 0 &&
        j >= 0 &&
        i < sizeB &&
        j < sizeB &&
        board[i][j] != "B" &&
        board[i][j] != "C" &&
        board[i][j] != "F" &&
        board[i][j] != "N") {
      // No es una bomba ni una casilla ya vista ni una bandera
      if (board[i][j] == " ") {
        // Es una casilla hueca sin descubrir
        board[i][j] = "C";
        showCells(i + 1, j - 1); // TOP-L
        showCells(i + 1, j); // TOP-C
        showCells(i + 1, j + 1); // TOP-R
        showCells(i, j - 1); // CENTER-L
        showCells(i, j + 1); // CENTER-R
        showCells(i - 1, j - 1); // BOT-L
        showCells(i - 1, j); // BOT-C
        showCells(i - 1, j + 1); // BOT-R
      } else {
        // Es un numero
        if (board[i][j].length == 1) {
          board[i][j] += "C";
        }
      }
    }
  }

  void startTimer() {
    const oneSecond = const Duration(seconds: 1);
    timer = Timer.periodic(oneSecond, (Timer timer) {
      if (!gameIsOver) {
        seconds++;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  void setFlag(int row, int col) {
    if (board[row][col] == "B") {
      numFlags++;
      board[row][col] = "N";
    } else if (board[row][col] == " ") {
      numFlags++;
      board[row][col] = "F";
    } else if (["1", "2", "3", "4", "5", "6", "7", "8"]
        .contains(board[row][col])) {
      numFlags++;
      board[row][col] += "F";
    } else if (board[row][col] == "N") {
      numFlags--;
      board[row][col] = "B";
    } else if (board[row][col] == "F") {
      numFlags--;
      board[row][col] = " ";
    } else if (board[row][col].length > 1 && board[row][col][1] == "F") {
      numFlags--;
      board[row][col] = board[row][col][0];
    }
    notifyListeners();

    if (nicePlacedFlags() == int.parse(numMines)) {
      gameIsOver = true;
      gameWinner = true;
    }
  }

  void playMove(int row, int col) {
    if (board[row][col] == "B") {
      gameIsOver = true;
      gameWinner = false;
    } else {
      showCells(row, col);
    }
  }

  int nicePlacedFlags() {
    int sizeB = int.parse(sizeBoard[0]);
    int cont = 0;
    for (int i = 0; i < sizeB; ++i) {
      for (int j = 0; j < sizeB; ++j) {
        if (board[i][j] == "N") cont++;
      }
    }
    return cont;
  }

  // Comprova si el joc ja té un tres en ratlla
  // No comprova la situació d'empat
  // void checkGameWinner() {
  //   for (int i = 0; i < 3; i++) {
  //     // Comprovar files
  //     if (board[i][0] == board[i][1] &&
  //         board[i][1] == board[i][2] &&
  //         board[i][0] != '-') {
  //       gameIsOver = true;
  //       gameWinner = board[i][0];
  //       return;
  //     }

  //     // Comprovar columnes
  //     if (board[0][i] == board[1][i] &&
  //         board[1][i] == board[2][i] &&
  //         board[0][i] != '-') {
  //       gameIsOver = true;
  //       gameWinner = board[0][i];
  //       return;
  //     }
  //   }

  //   // Comprovar diagonal principal
  //   if (board[0][0] == board[1][1] &&
  //       board[1][1] == board[2][2] &&
  //       board[0][0] != '-') {
  //     gameIsOver = true;
  //     gameWinner = board[0][0];
  //     return;
  //   }

  //   // Comprovar diagonal secundària
  //   if (board[0][2] == board[1][1] &&
  //       board[1][1] == board[2][0] &&
  //       board[0][2] != '-') {
  //     gameIsOver = true;
  //     gameWinner = board[0][2];
  //     return;
  //   }

  //   // No hi ha guanyador, torna '-'
  //   gameWinner = '-';
  // }

  // Carrega les imatges per dibuixar-les al Canvas
  Future<void> loadImages(BuildContext context) async {
    // Si ja estàn carregades, no cal fer res
    if (imagesReady) {
      notifyListeners();
      return;
    }

    // Força simular un loading
    await Future.delayed(const Duration(milliseconds: 500));

    Image tmpFlag = Image.asset('assets/images/flag.png');
    Image tmpBomb = Image.asset('assets/images/bomb.png');

    // Carrega les imatges
    if (context.mounted) {
      imageFlag = await convertWidgetToUiImage(tmpFlag);
    }
    if (context.mounted) {
      imageBomb = await convertWidgetToUiImage(tmpBomb);
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
