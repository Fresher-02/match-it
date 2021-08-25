import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MATCH-IT',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Map<String, bool> score = {};
  final Map choises = {
    '🍏': Colors.green,
    '🍅': Colors.red,
    '🍊': Colors.orange,
    '🍆': Colors.purple,
    '🥥': Colors.brown,
    '🍌': Colors.yellow,
  };
  int seed = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CHANCES ${score.length}/6'),
        backgroundColor: Colors.lightGreen,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh_rounded),
        onPressed: () {
          setState(() {
            score.clear();
            seed++;
          });
        },
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: choises.keys.map((emoji) {
              return Draggable<String>(
                data: emoji,
                child: Emoji(emoji: score[emoji] == true ? "☑️" : emoji),
                feedback: Emoji(emoji: emoji),
                childWhenDragging: Emoji(emoji: "☑️"),
              );
            }).toList(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: choises.keys.map((emoji) => buildTarget(emoji)).toList()
              ..shuffle(Random(seed)),
          )
        ],
      ),
    );
  }

  Widget buildTarget(emoji) {
    return DragTarget<String>(
      builder: (BuildContext context, List<String?> incoming, List rejected) {
        if (score[emoji] == true) {
          return Container(
            color: Colors.white,
            child: Text("CORRECT!!!"),
            alignment: Alignment.center,
            height: 80,
            width: 200,
          );
        } else {
          return Container(
            color: choises[emoji],
            alignment: Alignment.center,
            height: 80,
            width: 200,
          );
        }
      },
      onWillAccept: (data) => data == emoji,
      onAccept: (data) {
        setState(() {
          score[emoji] = true;
        });
      },
      onLeave: (data) {},
    );
  }
}

class Emoji extends StatelessWidget {
  final String emoji;

  const Emoji({Key? key, required this.emoji}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: 70,
        // padding: EdgeInsets.all(-1),
        child: Text(
          emoji,
          style: TextStyle(color: Colors.black, fontSize: 50),
        ),
      ),
    );
  }
}
