import 'package:flutter/material.dart';
import 'package:kroniker_flutter/auth/google_auth.dart';
import 'package:kroniker_flutter/config/theme_model.dart';
import 'package:kroniker_flutter/utils/utils.dart';
import 'package:provider/provider.dart';
import 'index.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ThemeModel().loadTheme();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeModel(),
      child: const MyApp(),
    ),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: Utils.messengerKey,
        debugShowCheckedModeBanner: false,
        title: 'Kroniker',
        theme: Provider.of<ThemeModel>(context).currentTheme,
        home: const AuthNav(),
      ),
    );
  }
}
