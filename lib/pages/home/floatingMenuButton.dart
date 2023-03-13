import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kroniker_flutter/pages/new_game/new_game_page.dart';

class FloatingMenuButton extends StatefulWidget {
  const FloatingMenuButton({super.key});

  @override
  State<FloatingMenuButton> createState() => _FloatingMenuButtonState();
}

class _FloatingMenuButtonState extends State<FloatingMenuButton>
    with TickerProviderStateMixin {
  var renderOverlay = true;
  var visible = true;
  var switchLabelPosition = false;
  var extend = false;
  var mini = false;
  var rmicons = false;
  var customDialRoot = false;
  var closeManually = false;
  var useRAnimation = true;
  var isDialOpen = ValueNotifier<bool>(false);
  var speedDialDirection = SpeedDialDirection.up;
  var buttonSize = const Size(56.0, 56.0);
  var childrenButtonSize = const Size(56.0, 56.0);
  var selectedfABLocation = FloatingActionButtonLocation.endDocked;
  var items = [
    FloatingActionButtonLocation.startFloat,
    FloatingActionButtonLocation.startDocked,
    FloatingActionButtonLocation.centerFloat,
    FloatingActionButtonLocation.endFloat,
    FloatingActionButtonLocation.endDocked,
    FloatingActionButtonLocation.startTop,
    FloatingActionButtonLocation.centerTop,
    FloatingActionButtonLocation.endTop,
  ];
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      // animatedIcon: AnimatedIcons.menu_close,
      // animatedIconTheme: IconThemeData(size: 22.0),
      // / This is ignored if animatedIcon is non null
      // child: Text("open"),
      // activeChild: Text("close"),
      icon: Icons.add,
      activeIcon: Icons.close,
      spacing: 3,
      mini: mini,
      openCloseDial: isDialOpen,
      childPadding: const EdgeInsets.all(5),
      spaceBetweenChildren: 4,
      dialRoot: customDialRoot
          ? (ctx, open, toggleChildren) {
              return ElevatedButton(
                onPressed: toggleChildren,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                ),
                child: const Text(
                  "Custom Dial Root",
                  style: TextStyle(fontSize: 17),
                ),
              );
            }
          : null,
      buttonSize:
          buttonSize, // it's the SpeedDial size which defaults to 56 itself
      // iconTheme: IconThemeData(size: 22),
      label:
          extend ? const Text("Open") : null, // The label of the main button.
      /// The active label of the main button, Defaults to label if not specified.
      activeLabel: extend ? const Text("Close") : null,

      /// Transition Builder between label and activeLabel, defaults to FadeTransition.
      // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
      /// The below button size defaults to 56 itself, its the SpeedDial childrens size
      childrenButtonSize: childrenButtonSize,
      visible: visible,
      direction: speedDialDirection,
      switchLabelPosition: switchLabelPosition,

      /// If true user is forced to close dial manually
      closeManually: closeManually,

      /// If false, backgroundOverlay will not be rendered.
      renderOverlay: renderOverlay,
      // overlayColor: Colors.black,
      // overlayOpacity: 0.5,
      onOpen: () => debugPrint('OPENING DIAL'),
      onClose: () => debugPrint('DIAL CLOSED'),
      useRotationAnimation: useRAnimation,
      tooltip: 'Open Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      // foregroundColor: Colors.black,
      // backgroundColor: Colors.white,
      // activeForegroundColor: Colors.red,
      // activeBackgroundColor: Colors.blue,
      elevation: 8.0,
      animationCurve: Curves.elasticInOut,
      isOpenOnStart: false,
      shape: customDialRoot
          ? const RoundedRectangleBorder()
          : const StadiumBorder(),
      // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      children: [
        SpeedDialChild(
            child: !rmicons ? const Icon(Icons.settings) : null,
            backgroundColor: Color.fromARGB(255, 123, 123, 123),
            foregroundColor: Colors.white,
            label: 'Settings',
            onTap: () {}),
        SpeedDialChild(
            child: !rmicons ? const Icon(FontAwesomeIcons.book) : null,
            backgroundColor: Color.fromARGB(255, 178, 82, 52),
            foregroundColor: Colors.white,
            label: 'Archive',
            onTap: () {}),
        SpeedDialChild(
            child:
                !rmicons ? const Icon(FontAwesomeIcons.rightToBracket) : null,
            backgroundColor: Color.fromARGB(255, 66, 48, 184),
            foregroundColor: Colors.white,
            label: 'Join Game',
            visible: true,
            onTap: () {}),
        SpeedDialChild(
            child: !rmicons ? const Icon(FontAwesomeIcons.plus) : null,
            backgroundColor: Color.fromARGB(255, 60, 182, 68),
            foregroundColor: Colors.white,
            label: 'New Game',
            visible: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewGamePage(),
                ),
              ).then((_) => setState(() {}));
            }),
        SpeedDialChild(
            child: !rmicons ? const Icon(FontAwesomeIcons.plus) : null,
            backgroundColor: Color.fromARGB(255, 181, 63, 63),
            foregroundColor: Colors.white,
            label: 'New Character',
            visible: true,
            onTap: () {}),
      ],
    );
  }
}
