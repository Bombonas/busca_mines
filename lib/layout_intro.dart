import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';

class LayoutIntro extends StatefulWidget {
  const LayoutIntro({Key? key}) : super(key: key);

  @override
  LayoutIntroState createState() => LayoutIntroState();
}

class LayoutIntroState extends State<LayoutIntro> {
  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Tres en ratlla"),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.gear_alt, size: 25.0),
          onPressed: () {
            Navigator.of(context).pushNamed('settings');
          },
        ),
      ),
      child: Column(
        children: <Widget>[
          // Ícona tipus 'videojoc'
          const Expanded(
              child: Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Icon(CupertinoIcons.game_controller, size: 100.0),
            ),
          )),
          Padding(
            padding: const EdgeInsets.all(20),
            child: CupertinoButton.filled(
              onPressed: () {
                appData.resetGame();
                Navigator.of(context).pushNamed('play');
              },
              child: const Text('Començar el joc'),
            ),
          )
        ],
      ),
    );
  }
}
