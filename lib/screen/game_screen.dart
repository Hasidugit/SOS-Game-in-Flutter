import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> displaySos = List.filled(150, "");
  List<int> completedSosIndexes = [];
  List<int> moveHistory = []; // List to keep track of moves
  String input = "S";
  bool aChance = true;
  int scoreA = 0;
  int scoreB = 0;
  int fillIndexCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SOS Game',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 4.0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: fillIndexCount != displaySos.length
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 100,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: aChance ? Colors.red : Colors.transparent,
                              border: Border.all(color: Colors.black),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "A player",
                                  style: aChance
                                      ? const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)
                                      : const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Score: $scoreA",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      aChance
                          ? Image.asset(
                              width: 80, height: 80, "image/writerr.png")
                          : const SizedBox(),
                      aChance
                          ? const SizedBox(width: 20)
                          : const SizedBox(
                              width: 80,
                            ),
                      aChance
                          ? const SizedBox(
                              width: 30,
                            )
                          : Image.asset(
                              width: 80, height: 80, "image/writer.png"),
                      Column(
                        children: [
                          Container(
                            width: 100,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: !aChance ? Colors.red : Colors.transparent,
                              border: Border.all(color: Colors.black),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "B player",
                                  style: !aChance
                                      ? const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)
                                      : const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Score: $scoreB",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _undoMove,
                          child: const Row(
                            children: [
                              Icon(Icons.undo),
                              Text("Undo"),
                            ],
                          ),
                        ),
                        const SizedBox(width: 5),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  content: const Column(
                                    children: [
                                      Text(
                                        "Do you Want to Restart Game ?",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: 120,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("No")),
                                        ),
                                        SizedBox(
                                          width: 120,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                _resetGame();
                                              },
                                              child: const Text("Yes")),
                                        ),
                                        const SizedBox(width: 5),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.restart_alt),
                              Text("Restart"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 400,
                    height: 40 * 14,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 10),
                        itemCount: displaySos.length,
                        itemBuilder: (context, index) {
                          final bool isCompletedSos =
                              completedSosIndexes.contains(index);
                          return GestureDetector(
                              onTap: () {
                                _tapped(index);
                              },
                              child: ClipOval(
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        isCompletedSos
                                            ? const Color.fromARGB(
                                                255, 23, 3, 237)
                                            : displaySos[index] != ""
                                                ? const Color.fromARGB(
                                                    255, 225, 218, 74)
                                                : Colors.white,
                                        Colors
                                            .transparent, // Use transparent to create glass effect
                                      ],
                                      stops: const [
                                        0.0,
                                        0.9
                                      ], // Adjust stops for gradient transition
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: const Offset(
                                            0, 5), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      displaySos[index],
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: isCompletedSos
                                            ? const Color.fromARGB(
                                                255, 246, 245, 243)
                                            : Colors
                                                .black87, // Adjust text color as needed
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                input = "S";
                              });
                            },
                            child: Container(
                              width: input == "S"
                                  ? 150
                                  : 80, // Change width based on input
                              height: input == "S"
                                  ? 55
                                  : 45, // Change height based on input
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 87, 80, 183),
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(25),
                                      topRight: Radius.circular(25))),
                              child: Center(
                                child: CircleAvatar(
                                    backgroundColor: input == "S"
                                        ? const Color.fromARGB(255, 67, 215, 9)
                                        : Colors.transparent,
                                    radius: input == "S" ? 23 : 17,
                                    child: Center(
                                      child: Text("S",
                                          style: TextStyle(
                                            fontSize: input == "S" ? 35 : 25,
                                          )),
                                    )),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                input = "O";
                              });
                            },
                            child: Container(
                              width: input == "O"
                                  ? 150
                                  : 80, // Change width based on input
                              height: input == "O" ? 55 : 45,
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 87, 80, 183),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(25),
                                      topLeft: Radius.circular(25))),
                              child: Center(
                                child: CircleAvatar(
                                    backgroundColor: input == "O"
                                        ? const Color.fromARGB(255, 67, 215, 9)
                                        : Colors.transparent,
                                    radius: input == "O" ? 23 : 17,
                                    child: Center(
                                      child: Text("O",
                                          style: TextStyle(
                                            fontSize: input == "O" ? 35 : 25,
                                          )),
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // ElevatedButton(
                  //   onPressed: _undoMove,
                  //   child: const Text("Undo"),
                  // )
                ],
              )
            : AlertDialog(
                title: const Text(
                  'Game Over',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                content: Text(
                  scoreA == scoreB
                      ? "Game Draw"
                      : scoreA > scoreB
                          ? "A is Winner"
                          : "B is Winner",
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      _resetGame();
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
      ),
    );
  }

  void _resetGame() {
    setState(() {
      // Reset game state
      displaySos = List.filled(150, "");
      completedSosIndexes = [];
      moveHistory = [];
      input = "S";
      aChance = true;
      scoreA = 0;
      scoreB = 0;
      fillIndexCount = 0;
    });
    Navigator.pop(context); // Close the dialog
  }

  String gameWinner() {
    if (scoreA > scoreB) {
      return "A";
    } else {
      return "B";
    }
  }

  void _tapped(int index) {
    if (input.isNotEmpty && displaySos[index].isEmpty) {
      setState(() {
        displaySos[index] = input;
        Logger().d('$input tapped at $index');
        int scoreIncrement = _checkPath(index);
        if (aChance) {
          scoreA += scoreIncrement;
        } else {
          scoreB += scoreIncrement;
        }

        // If no SOS was completed, change the turn
        if (scoreIncrement == 0) {
          aChance = !aChance;
        }

        // Add move to history
        moveHistory.add(index);

        input = "S";

        fillIndexCount++; // Increment fillIndexCount

        // Check if fillIndexCount reaches 3 to end the game
        if (fillIndexCount >= 6) {
          _showGameOverDialog(scoreA, scoreB);
        }
      });
    } else {
      Logger().e('Error: Invalid input or cell already filled.');
    }
  }

  int _checkPath(int index) {
    int row = index ~/ 10;
    int col = index % 10;
    int sosCount = 0;

    // Horizontal check
    if (col <= 7 && _isSOS(index, 1, 2)) {
      Logger().i("Horizontal SOS at $index");
      completeSOS(index, index + 1, index + 2);
      sosCount++;
    }
    // Vertical check
    if (row <= 7 && _isSOS(index, 10, 20)) {
      Logger().i("Vertical SOS at $index");
      completeSOS(index, index + 10, index + 20);
      sosCount++;
    }
    // Diagonal down-right check
    if (row <= 7 && col <= 7 && _isSOS(index, 11, 22)) {
      Logger().i("Diagonal down-right SOS at $index");
      completeSOS(index, index + 11, index + 22);
      sosCount++;
    }
    // Diagonal down-left check
    if (row <= 7 && col >= 2 && _isSOS(index, 9, 18)) {
      Logger().i("Diagonal down-left SOS at $index");
      completeSOS(index, index + 9, index + 18);
      sosCount++;
    }
    // Reverse Horizontal check
    if (col >= 2 && _isSOS(index, -1, -2)) {
      Logger().i("Reverse Horizontal SOS at $index");
      completeSOS(index, index - 1, index - 2);
      sosCount++;
    }
    // Reverse Vertical check
    if (row >= 2 && _isSOS(index, -10, -20)) {
      Logger().i("Reverse Vertical SOS at $index");
      completeSOS(index, index - 10, index - 20);
      sosCount++;
    }
    // Reverse Diagonal up-right check
    if (row >= 2 && col <= 7 && _isSOS(index, -9, -18)) {
      Logger().i("Reverse Diagonal up-right SOS at $index");
      completeSOS(index, index - 9, index - 18);
      sosCount++;
    }
    // Reverse Diagonal up-left check
    if (row >= 2 && col >= 2 && _isSOS(index, -11, -22)) {
      Logger().i("Reverse Diagonal up-left SOS at $index");
      completeSOS(index, index - 11, index - 22);
      sosCount++;
    }

    // Additional checks for SOS formation using input "O"
    if (input == "O") {
      // Vertical check
      if (row >= 2 &&
          displaySos[index - 10] == "S" &&
          displaySos[index] == "O" &&
          displaySos[index + 10] == "S") {
        Logger().i("Vertical SOS formed by input O at $index");
        completeSOS(index, index + 10, index - 10);
        sosCount++;
      }
      if (row >= 2 &&
          displaySos[index - 1] == "S" &&
          displaySos[index] == "O" &&
          displaySos[index + 1] == "S") {
        Logger().i("Horizontal SOS formed by input O at $index");
        completeSOS(index, index + 1, index - 1);
        sosCount++;
      }
      if (row >= 2 &&
          displaySos[index - 9] == "S" &&
          displaySos[index] == "O" &&
          displaySos[index + 9] == "S") {
        Logger().i("Diagonal SOS formed by input O at $index");
        completeSOS(index, index + 9, index - 9);
        sosCount++;
      }
      if (row >= 2 &&
          displaySos[index - 11] == "S" &&
          displaySos[index] == "O" &&
          displaySos[index + 11] == "S") {
        Logger().i("Diagonal SOS formed by input O at $index");
        completeSOS(index, index + 11, index - 11);
        sosCount++;
      }
    }

    return sosCount;
  }

  bool _isSOS(int index, int offset1, int offset2) {
    return displaySos[index] == "S" &&
        displaySos[index + offset1] == "O" &&
        displaySos[index + offset2] == "S";
  }

  void completeSOS(int a, int b, int c) {
    completedSosIndexes.addAll([a, b, c]);
    Logger().e(completedSosIndexes);
  }

  void _undoMove() {
    if (moveHistory.isNotEmpty) {
      setState(() {
        int lastMove = moveHistory.removeLast();
        displaySos[lastMove] = "";
        fillIndexCount--;

        // Check whose turn it was
        aChance = !aChance;

        // Recalculate scores and completed SOS indexes
        completedSosIndexes = [];
        scoreA = 0;
        scoreB = 0;

        for (int i = 0; i < displaySos.length; i++) {
          if (displaySos[i] != "") {
            int scoreIncrement = _checkPath(i);
            if (aChance) {
              scoreA += scoreIncrement;
            } else {
              scoreB += scoreIncrement;
            }

            // If no SOS was completed, change the turn
            if (scoreIncrement == 0) {
              aChance = !aChance;
            }
          }
        }
      });
    } else {
      Logger().e('No moves to undo.');
    }
  }

  void _showGameOverDialog(int a, int b) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog dismissal on tap outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Game Over',
              style: TextStyle(
                  fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ),
          content: SizedBox(
            height: 280,
            child: Column(
              children: [
                scoreA == scoreB
                    ? const Image(
                        width: 200,
                        height: 200,
                        image: AssetImage("image/draw.png"))
                    : scoreA > scoreB
                        ? const Row(
                            children: [
                              Image(
                                  width: 100,
                                  height: 150,
                                  image: AssetImage("image/win.png")),
                              Spacer(),
                              Image(
                                  width: 100,
                                  height: 200,
                                  image: AssetImage("image/lost.png"))
                            ],
                          )
                        : const Row(
                            children: [
                              Image(
                                  width: 100,
                                  height: 100,
                                  image: AssetImage("image/lost.png")),
                              Spacer(),
                              Image(
                                  width: 100,
                                  height: 200,
                                  image: AssetImage("image/win.png"))
                            ],
                          ),
                Row(
                  children: [
                    Text(
                      "A score:$a",
                      style: const TextStyle(
                          fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      "A score:$b",
                      style: const TextStyle(
                          fontSize: 19, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const Spacer(),
                Text(
                  scoreA == scoreB
                      ? "Game Draw"
                      : scoreA > scoreB
                          ? "A is Winner"
                          : "B is Winner",
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _resetGame();
              },
              child: const Text('Try Again'),
            ),
          ],
        );
      },
    );
  }
}
