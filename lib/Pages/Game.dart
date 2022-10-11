
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wordlyx/Utils/PersonalColors.dart';
import 'package:wordlyx/Widgets/Wordlyx.dart';

class Game extends StatefulWidget {
  final String word;
  const Game({required this.word});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {

  

  int x = 1;
  int y = 3;

  String alpha = "x";


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




  @override
  Widget build(BuildContext context) {
    
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    PersonalColors clr = PersonalColors();

    return SafeArea(
      child: Scaffold(

        // appBar: AppBar(
        //   backgroundColor: clr.darkGray,
        //   elevation: 0,
        //   actions: [
        //     IconButton(
        //       icon: const Icon(Icons.close),
        //       onPressed: (){
        //         print("Close the game");
        //         Navigator.pushAndRemoveUntil(
        //           context, 
        //           MaterialPageRoute(builder: (context)=> const Home()), 
        //           (route) => false
        //         );
        //       }, 
        //     )
        //   ],
        // ),
        
        body: Container(
          color: clr.darkGray,
          width: width,
          height: height,
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
                      onPressed: (){}, 
                    ),

                    IconButton(
                      icon: Icon(
                        CupertinoIcons.xmark,
                        size: 25,
                        color: clr.white,
                      ),
                      onPressed: (){}, 
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

              // Alphabet(alpha, 1, 2)

              // Keyboard
              SizedBox(
                width: width*0.9,
                height: width*0.5,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: LettersLine(0, width, clr)
                    ),
                    Expanded(
                      flex: 1,
                      child: LettersLine(1, width, clr)
                    ),
              
                    // LettersLine(2, 1, width, clr),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                              }, 
                            ),
                          ),
                    
                          Expanded(
                            flex: 4,
                            child: LettersLine(2, width, clr)
                          ),
                    
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
    );

  }

  SizedBox LettersLine(int line, double width, PersonalColors clr) {
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
              child: SizedBox(
                width: width*0.5/10,
                child: Center(
                  child: InkWell(
                    onTap: () {
                      print(keyboard[line]['letters'][index]);
                    },
                    child: Text(
                      keyboard[line]['letters'][index],
                      style: TextStyle(
                        color: keyboard[line]['colors'][index],
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                  )
                )
              ),
            );
          },
        ),
      ),
    );
  }

  TextButton Alphabet(String alphabet, int x, int y) {
    return TextButton(
      child: Text(alpha),
      onPressed: () => execute(x,y), 
    );
  }
}

