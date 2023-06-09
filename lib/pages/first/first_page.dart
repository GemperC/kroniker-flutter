import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kroniker_flutter/auth/google_auth.dart';
import 'package:kroniker_flutter/config/theme_model.dart';
import 'package:kroniker_flutter/pages/home/home_page.dart';
import 'package:provider/provider.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  late List<String> imagePaths;

  @override
  void initState() {
    super.initState();
    _initImages();
  }

  Future _initImages() async {
    final Map<String, dynamic> manifestContent =
        jsonDecode(await rootBundle.loadString('AssetManifest.json'));

    setState(() {
      imagePaths = manifestContent.keys
          .where((String key) => key.contains('gifs/'))
          .where((String key) => key.contains('.gif'))
          .toList();
    });
  }

  List<Widget> gifsWidgetList(List<String> imagePaths) {
    return imagePaths.map((item) {
      return Container(
        decoration: BoxDecoration(color: Colors.transparent),
        child: Image.asset(
          item,
          fit: BoxFit.fill,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Text(
                  "Kroniker",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              CarouselSlider(
                options: CarouselOptions(
                  viewportFraction: 1,
                  autoPlayCurve: Curves.fastLinearToSlowEaseIn,
                  autoPlayInterval: Duration(seconds: 4),
                  autoPlayAnimationDuration: Duration(milliseconds: 500),
                  autoPlay: true,
                  aspectRatio: 2,
                  height: 400,
                  enlargeCenterPage: false,
                ),
                items: gifsWidgetList(imagePaths),
              ),

              // FloatingActionButton(
              //   onPressed: () {
              //     Navigator.pushAndRemoveUntil(
              //         context,
              //         MaterialPageRoute(builder: (context) => const HomePage()),
              //         (Route<dynamic> route) => false);
              //   },
              //   tooltip: 'Increment',
              //   child: const Icon(Icons.add),
              // ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.only(bottom: 70),
                child: ElevatedButton(
                  onPressed: () async {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.googleLogin();
                  },
                  child: Container(
                    height: 58,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(FontAwesomeIcons.google),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Sign in with Google',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Provider.of<ThemeModel>(context, listen: false).toggleTheme();
        //   },
        //   tooltip: 'Increment',
        //   child: const Icon(Icons.add),
        // ),
      ),
    );
  }
}
