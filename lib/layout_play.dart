import 'package:cupertino_base/app_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'widget_tresratlla.dart';

class LayoutPlay extends StatefulWidget {
  const LayoutPlay({Key? key}) : super(key: key);

  @override
  LayoutPlayState createState() => LayoutPlayState();
}

class LayoutPlayState extends State<LayoutPlay> {
  @override
  Widget build(BuildContext context) {
    //AppData appData = Provider.of<AppData>(context, listen: true);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Consumer<AppData>(
          builder: (context, appData, child) {
            return Text("Flags: " + (int.parse(appData.numMines) - appData.numFlags).toString());
          },
        ),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        trailing: Consumer<AppData>(
          builder: (context, appData, child) {
            return Text("Time: " + appData.seconds.toString());
          },
        ),
      ),
      child: const SafeArea(
        child: WidgetTresRatlla(),
      ),
    );
  }
}
