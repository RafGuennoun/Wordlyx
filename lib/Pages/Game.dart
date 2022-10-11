
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parallax_rain/parallax_rain.dart';
import 'package:wordlyx/Pages/Home.dart';
import 'package:wordlyx/Utils/PersonalColors.dart';
import 'package:wordlyx/Widgets/Wordlyx.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class Game extends StatefulWidget {
  final String word;
  const Game({required this.word});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {

  final Key parallaxOne = GlobalKey();

  PersonalColors clr = PersonalColors();

  Future<String> loadWords() async {
    return await rootBundle.loadString('assets/words.txt');
  }

  List<Map> boxes = List<Map>.generate(5, (index) => {
      "letters" : List<String>.generate(5, (index) => '-', growable: false),
      "colors" : List<Color>.generate(5, (index) => Colors.white , growable: false),
    },
    growable: false
  );


  List<Map> keyboard = [
    {
      "letters" : ["A", "Z", "E", "R", "T", "Y", "U", "I", "O", "P"],
      "colors" : List<Color>.generate(10, (index) => Colors.white , growable: false),
    },

    {
      "letters" : ["Q", "S", "D", "F", "G", "H", "J", "K", "L", "M"],
      "colors" : List<Color>.generate(10, (index) => Colors.white , growable: false),
    },

    {
      "letters" : ["W", "X", "C", "V", "B", "N"],
      "colors" : List<Color>.generate(6, (index) => Colors.white , growable: false),
    }
  ];   

  void execute(int x, int y){
    print("x = $x ");
    print("y = $y ");

    setState(() {
      boxes[x]["colors"][y] = Colors.orange;
    });
  }

  // logic stuff

  int x = 0;
  int y = 0;

  bool correct = false;

  bool isLastX(){
    return x == 5;
  }

  bool isEmptyX(){
    return x == 0;
  }

  bool isLastY(){
    return y == 4;
  }

  incrementX(){
    if (isLastX() == false) {
      setState(() {
        x++;
      });
    }
  }

  decrementX(){
    if (!isEmptyX()) {
      setState(() {
        x--;
      });
    }
  }

  incrementY(){
    if (!isLastY()) {
      setState(() {
        y++;
        x=0;
      });
    }
  }

  fillBox(String letter, int x, int y){
    setState(() {
      boxes[y]['letters'][x] = letter;
    });
  }

  List getWordAsList(){
    List w = widget.word.split('');
    w.removeLast();
    for (int i = 0; i < w.length; i++) {
    }

    return w;
  }

  List getWordToCheck(int y){
    List c = [];
    for (int i = 0; i < 5; i++) {
      c.add(boxes[y]["letters"][i]);
    }
    return c;
  }

  correctLetter(int x, int y){
    setState(() {
      boxes[y]["colors"][x] = clr.green;
    });
  }

  possibleLetter(int x, int y){
    setState(() {
      boxes[y]["colors"][x] = clr.orange;

    });
  }

  uncorrectLetter(int x, int y){
    setState(() {
      boxes[y]["colors"][x] = Colors.grey;
    });
  }

  checkIsCorrectWord(List word, List test, int y){
    if (word.toString() == test.toString()) {
      setState(() {
        correct = true;
      });

      for (int i = 0; i < word.length; i++) {
        setState(() {
          correctLetter(i, y);
        });
      }


      
    } else {
      for (int i = 0; i < word.length; i++) {
        if (word[i] == test[i]) {
          setState(() {
            correctLetter(i, y);

          });
        } else {
          if (test.contains(word[i])) {
            possibleLetter(i,y);
          } else {
            uncorrectLetter(i, y);
          }
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;



    return SafeArea(
      child: Scaffold(

        body: Container(
          color: clr.darkGray,
          width: width,
          height: height,
          child: ParallaxRain(
             key: parallaxOne,
            dropColors: const [
              Colors.blueGrey
            ],
            trail: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
          
                      IconButton(
                        icon: Icon(
                          CupertinoIcons.refresh_thin,
                          size: 25,
                          color: clr.white,
                        ),
                        onPressed: (){
                          showCupertinoDialog(
                            context: context, 
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: const Text("Retry"),
                                content: const Text("Do you want to try another word ?"),
                                actions: [
                                  CupertinoButton(
                                    child: const Text("Cancel"), 
                                    onPressed: (){
                                      Navigator.pop(context);
                                    }
                                  ),
          
                                  CupertinoButton(
                                    child: const Text("Retry"), 
                                    onPressed: () async {
                                      String words = await loadWords();
                                      List<String> l = words.split('\n');
                                      Random random = Random();
                                      int rand = random.nextInt(l.length); 
          
                                      // ignore: use_build_context_synchronously
                                      Navigator.pushAndRemoveUntil(
                                        context, 
                                        MaterialPageRoute(builder: (context)=> Game(word: l[rand].toUpperCase(),)), 
                                        (route) => false
                                      );
                                    }
                                  )
                                ],
                              );
                            }
                          );
                
                        }, 
                      ),
          

                      IconButton(
                        icon: Icon(
                          CupertinoIcons.xmark,
                          size: 25,
                          color: clr.white,
                        ),
                        onPressed: (){
                          showCupertinoDialog(
                            context: context, 
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: const Text("Lave"),
                                content: const Text("Do you really want to leave your game ?"),
                                actions: [
                                  CupertinoButton(
                                    child: const Text("Cancel"), 
                                    onPressed: (){
                                      Navigator.pop(context);
                                    }
                                  ),
          
                                  CupertinoButton(
                                    child: const Text("Leave"), 
                                    onPressed: () {
          
                                      // ignore: use_build_context_synchronously
                                      Navigator.pushAndRemoveUntil(
                                        context, 
                                        MaterialPageRoute(builder: (context)=> const Home()), 
                                        (route) => false
                                      );
                                    }
                                  )
                                ],
                              );
                            }
                          );
                        }, 
                      ),
                    ],
                  ),
                ),
          
                Wordlyx(clr: clr),
          
                // Boxes
                SizedBox(
                  width: width*0.9,
                  height: width*0.9,
                  child: Center(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: boxes.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SizedBox(
                            width: width*0.9,
                            height: (width*0.9)/(boxes.length+1),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: boxes.length,
                              itemBuilder:(context, i) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: boxes[index]["colors"][i],
                                    ),
                                    width: (width*0.9)/(boxes.length+1),
                                    height: (width*0.9)/(boxes.length+1),
                                    child: Center(
                                      child: Text(
                                        boxes[index]["letters"][i],
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: clr.darkGray
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      } 
                      
                    ),
                  ),
                ),
          
                // Keyboard
                SizedBox(
                  width: width*0.9,
                  height: width*0.5,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: LettersLine(0, width, clr, x, y)
                      ),
                      Expanded(
                        flex: 1,
                        child: LettersLine(1, width, clr, x, y)
                      ),
                
                      
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // ! Valider
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: Icon(
                                  CupertinoIcons.checkmark_rectangle,
                                  size: 30,
                                  color: clr.white,
                                ),
                                onPressed: (){
                                  print("valider");
                                  if (isLastX()) {
                                    
                                    List word = getWordAsList(); 
                                    print("word = $word");
                                
                                    List test = getWordToCheck(y);
                                    print("test = $test");
          
                                    checkIsCorrectWord(word, test, y);
                                    print("correct == $correct");
                                    if (correct) {
                                      showCupertinoDialog(
                                        context: context, 
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: const Text("Congratulations"),
                                            content: const Text("Do you want to try another word ?"),
                                            actions: [
          
                                              CupertinoButton(
                                                child: const Text("Leave"), 
                                                onPressed: (){
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.pushAndRemoveUntil(
                                                    context, 
                                                    MaterialPageRoute(builder: (context)=> const Home()), 
                                                    (route) => false
                                                  );
                                                }
                                              ),
          
                                              CupertinoButton(
                                                child: const Text("Retry"), 
                                                onPressed: () async {
                                                  String words = await loadWords();
                                                  List<String> l = words.split('\n');
                                                  Random random = Random();
                                                  int rand = random.nextInt(l.length); 
          
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.pushAndRemoveUntil(
                                                    context, 
                                                    MaterialPageRoute(builder: (context)=> Game(word: l[rand].toUpperCase(),)), 
                                                    (route) => false
                                                  );
                                                }
                                              )
                                            ],
                                          );
                                        }
                                      );
                                    } else{
                                      if (isLastY()) {
                                        showCupertinoDialog(
                                          context: context, 
                                          builder: (context) {
                                            return CupertinoAlertDialog(
                                              title: const Text("Oups !"),
                                              content: Text("The word was -${widget.word}- good luck next time"),
                                              actions: [
          
                                                CupertinoButton(
                                                  child: const Text("Leave"), 
                                                  onPressed: (){
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.pushAndRemoveUntil(
                                                      context, 
                                                      MaterialPageRoute(builder: (context)=> const Home()), 
                                                      (route) => false
                                                    );
                                                  }
                                                ),
          
                                                CupertinoButton(
                                                  child: const Text("Retry"), 
                                                  onPressed: () async {
                                                    String words = await loadWords();
                                                    List<String> l = words.split('\n');
                                                    Random random = Random();
                                                    int rand = random.nextInt(l.length); 
          
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.pushAndRemoveUntil(
                                                      context, 
                                                      MaterialPageRoute(builder: (context)=> Game(word: l[rand].toUpperCase(),)), 
                                                      (route) => false
                                                    );
                                                  }
                                                )
                                              ],
                                            );
                                          }
                                        );
                                      } else {
                                        incrementY();
                                        
                                      }
                                    }
          
          
                                    
                                  } else{
                                    showCupertinoDialog(
                                      context: context, 
                                      builder: (context) {
                                        return CupertinoAlertDialog(
                                          title: const Text("Oups !"),
                                          content: const Text("Complete your word to check"),
                                          actions: [
                                            CupertinoButton(
                                              child: const Text("Cancel"), 
                                              onPressed: (){
                                                Navigator.pop(context);
                                              }
                                            ),
          
                                           
                                          ],
                                        );
                                      }
                                    );
                                  }
                                }, 
                              ),
                            ),
                      
                            Expanded(
                              flex: 4,
                              child: LettersLine(2, width, clr, x, y)
                            ),
                      
                            //! Supprimer
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: Icon(
                                  CupertinoIcons.delete_left,
                                  size: 30,
                                  color: clr.white,
                                ),
                                onPressed: (){
                                  print("supprimer");
                                  if (!isEmptyX()) {
                                    setState(() {
                                      decrementX();
                                      fillBox("-", x, y);
                                    });
                                  }
                                }, 
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );

  }

  SizedBox LettersLine(int line, double width, PersonalColors clr, int x, int y) {
    return SizedBox(
      width: width*0.9,
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: keyboard[line]['letters'].length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  print(keyboard[line]['letters'][index]);
                  if (!isLastX()) {
                    fillBox(keyboard[line]['letters'][index], x, y);
                    incrementX();
                    print("x = $x");
                    print("y = $y");
                  } else {
                    print("time to check ");
                    Scaffold.of(context).showSnackBar(const SnackBar(
                      content: Text('Press Enter to ceck your word'),
                      duration: Duration(seconds: 1),
                    ));
                  }

                },
                child: SizedBox(
                  width: width*0.5/10,
                  child: Center(
                    child: Text(
                      keyboard[line]['letters'][index],
                      style: TextStyle(
                        color: keyboard[line]['colors'][index],
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }


}

