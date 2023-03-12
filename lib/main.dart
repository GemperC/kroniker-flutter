import 'package:flutter/material.dart';
import 'package:kroniker_flutter/config/theme.dart';
import 'package:kroniker_flutter/config/theme_model.dart';
import 'package:provider/provider.dart';
import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ThemeModel().loadTheme();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kroniker',
      theme: Provider.of<ThemeModel>(context).currentTheme,
      home: const FirstPage(title: 'Flutter Demo Home Page'),
    );
  }
}
