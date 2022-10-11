import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wordlyx/Pages/Game.dart';
import 'package:wordlyx/Utils/PersonalColors.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:wordlyx/Widgets/Wordlyx.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  
  Future<String> loadWords() async {
    return await rootBundle.loadString('assets/words.txt');
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    PersonalColors clr = PersonalColors();

    return SafeArea(
      child: Scaffold(

        body: Container(
          color: clr.darkGray,
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Center(child: Wordlyx(clr: clr)),
              ),

              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Let's start playing",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.normal,
                        color: clr.white
                      ),
                    ),

                    const SizedBox(height: 35,),

                    InkWell(
                      onTap: () async {
                        String words = await loadWords();
                        List<String> l = words.split('\n');
                        // for (int i = 0; i < l.length; i++) {
                        //   print("$i --- ${l[i]}");
                        // }

                        Random random = Random();
                        int rand = random.nextInt(l.length); 

                        // ignore: use_build_context_synchronously
                        Navigator.pushAndRemoveUntil(
                          context, 
                          MaterialPageRoute(builder: (context)=> Game(word: l[rand],)), 
                          (route) => false
                        );
                      },
                      child: Container(
                        // color: clr.white,
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: clr.white,
                        ),
                              
                        child: Icon(
                          Icons.play_arrow_rounded,
                          size: 60,
                          color: clr.darkGray,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
    
    
      ),
    );
  }
}