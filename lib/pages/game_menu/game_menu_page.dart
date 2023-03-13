import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:kroniker_flutter/backend/records/game_record.dart';

class GameMenuPage extends StatefulWidget {
  const GameMenuPage({
    super.key,
    required this.gameData,
  });

  final GameRecord gameData;

  @override
  State<GameMenuPage> createState() => _GameMenuPageState();
}

class _GameMenuPageState extends State<GameMenuPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
        ),
      ),
    );
  }
}
