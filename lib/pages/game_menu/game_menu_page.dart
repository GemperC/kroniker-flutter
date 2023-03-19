import 'package:firebase_auth/firebase_auth.dart';
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
  final user = FirebaseAuth.instance.currentUser!;
  late bool isDM;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.gameData.dm.id == user.uid) {
      setState(() {
        isDM = true;
      });
    } else {
      setState(() {
        isDM = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(widget.gameData.title,
                    style: Theme.of(context).textTheme.titleSmall),
              ),
              const SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  widget.gameData.imageUrl!,
                  height: 200,
                  width: MediaQuery.of(context).size.width * 0.85,
                  fit: BoxFit.cover,
                ),
              ),
              Text(widget.gameData.description,
                  style: Theme.of(context).textTheme.titleSmall),
              Text("$isDM", style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
        ),
      ),
    );
  }
}
