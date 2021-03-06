import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:roullete/input_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roulette',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final AudioCache _audioCache;
  late AudioPlayer _audioPlayer;
  late AnimationController _controller;
  late CurvedAnimation _curvedAnimation;
  late double fromValue = 0;
  late double toValue = 0;
  int? result;
  var rewards = <int>[];
  var wheelCell = [
    1,
    6,
    5,
    4,
    6,
    2,
    3,
    6,
    5,
    4,
    6,
    1,
    6,
    5,
    4,
    6,
    2,
    3,
    6,
    5,
    4,
    6
  ];
  var price = ['1st', '2nd', '3rd', '4th', '5th', '6th'];
  var loading = false;

  @override
  void initState() {
    super.initState();

    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.LOOP);

    _audioCache = AudioCache(
      prefix: 'sound/',
      fixedPlayer: AudioPlayer(),
    );

    _set();
    _controller = AnimationController(
      animationBehavior: AnimationBehavior.preserve,
      vsync: this,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        playResultSound();

        SharedPreferences.getInstance().then((prefs) =>
            prefs.setInt("reward$result", prefs.getInt("reward$result")! - 1));

        setState(() {
          result = rewards.removeAt(0);
          loading = false;
        });
      }
    });

    _curvedAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.red,
      body: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 1000,
            height: 900,
            constraints: const BoxConstraints(minWidth: 1000, minHeight: 900),
            child: Stack(
              children: [
                Center(child: Image.asset('/images/ring.png')),
                Center(
                  child: Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 15),
                          RotationTransition(
                            turns: Tween(begin: fromValue, end: toValue)
                                .animate(_curvedAnimation),
                            child: Image.asset(
                              "/images/wheel.png",
                              width: 450,
                            ),
                          ),
                        ],
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Image.asset("/images/arrow.png", width: 28),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: FloatingActionButton(
                            backgroundColor: rewards.isNotEmpty && !loading
                                ? Colors.red
                                : Colors.grey,
                            onPressed:
                                rewards.isNotEmpty && !loading ? _spin : null,
                            tooltip: 'Spin',
                            child: const Text('Spin'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 150,
                  width: 320,
                  child: Visibility(
                    visible: result != null,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Column(
                      children: [
                        const Text(
                          'Congrats!',
                          style: TextStyle(fontSize: 40, color: Colors.white),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'You won the ',
                              style:
                                  TextStyle(fontSize: 32, color: Colors.white),
                            ),
                            Text(
                              result != null ? '${price[result! - 1]}' : '',
                              style:
                                  TextStyle(fontSize: 36, color: Colors.white),
                            ),
                            const Text(
                              ' prize',
                              style:
                                  TextStyle(fontSize: 32, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  child: Image.asset('/images/tree.png', width: 300),
                  alignment: Alignment.bottomRight,
                ),
                const SizedBox(height: 50),
                const Text(
                  '????????????:',
                  style: TextStyle(color: Colors.white),
                ),
                Row(
                  children: [
                    Text(
                      "??????: ${rewards.where((element) => element == 1).length}",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "??????: ${rewards.where((element) => element == 2).length}",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "??????: ${rewards.where((element) => element == 3).length}",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "??????: ${rewards.where((element) => element == 4).length}",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "??????: ${rewards.where((element) => element == 5).length}",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "??????: ${rewards.where((element) => element == 6).length}",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _reset,
            tooltip: 'Rest',
            child: const Icon(Icons.refresh),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  double rate = 4;

  void _spin() {
    _controller.duration = Duration(seconds: 5);
    setState(() {
      loading = true;
      _controller.reset();
      rewards.shuffle();
      fromValue = toValue;
      var cellSize = 1 / 22;
      var prize = wheelCell.indexOf(rewards[0]);
      toValue = toValue.ceil() +
          5 +
          cellSize * prize -
          (cellSize / 2) +
          (cellSize * (Random().nextInt(90) + 5) / 100) +
          1;

      result = null;
      _controller.forward();
      playSpin();
    });
  }

  Future<void> playSpin() async {
    _audioPlayer = await _audioCache.play('spin.mp3');
  }

  Future<void> playResultSound() async {
    _audioPlayer = await _audioCache.play('prize.m4a');
  }

  void _reset() {
    const InputDialog().show(context).then((value) => _set());
  }

  Future<void> _set() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    rewards.clear();
    try {
      for (var i = 1; i <= 6; i++) {
        for (var j = 1; j <= prefs.getInt("reward$i")!; j++) {
          rewards.add(i);
        }
      }
      setState(() {});
    } on Exception {
      debugPrint("Loading failed");
    }
  }
}
