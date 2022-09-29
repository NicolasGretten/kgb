import 'dart:developer';

import 'package:flutter/material.dart';
import 'models/question.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const KGBapp());
}

class KGBapp extends StatelessWidget {
  const KGBapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KGB',
      theme: ThemeData(fontFamily: GoogleFonts.robotoFlex().fontFamily, primarySwatch: Colors.amber),
      home: const QuestionPage(title: 'KGB'),
    );
  }
}

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key, required this.title});

  final String title;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  List<Question> questionsList = [];

  int score = 0;

  @override
  void initState() {
    Question q1 = Question(id : 1, content: "C'est quoi ?", rightAnswer: "un oeuf", propositions: ["un oeuf", "un euf", "un woeuf", "un neuf"], image: "https://mapetiteassiette.com/wp-content/uploads/2020/09/oeuf-e1601281477516.jpg");
    Question q2 = Question(id : 2, content: "Quel est le nom d'hermione ?", rightAnswer: "Granger", propositions: ["Grange", "Grangy", "Ranger", "Granger"]);
    Question q3 = Question(id : 3, content: "Comment s'apelle le conducteur du magicobus ?", rightAnswer: "Eurn", propositions: ["Eurn", "Burn", "Erny", "Bernic"]);
    Question q4 = Question(id : 4, content: "Quelle est la première chambre d'harry ?", rightAnswer: "le placard sous l'escalier", propositions: ["le placard sous l'escalier", "les toilettes", "la baignoire", "la niche de molaire"]);
    Question q5 = Question(id : 5, content: "Comment se nomme l'école ?", rightAnswer: "poudlard", propositions: []);

    questionsList.add(q1);
    questionsList.add(q2);
    questionsList.add(q3);
    questionsList.add(q4);
    questionsList.add(q5);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
                widget.title,
            ),
            Text('Score : $score/${questionsList.length}'),
          ],
        ),
      ),
      body: ListView.builder(
          addRepaintBoundaries: false,
          padding: const EdgeInsets.all(16.0),
          itemCount: questionsList.length,
          itemBuilder: (context, i) {
           return QuestionCard(question: questionsList[i], incrementCounter: incrementCounter);
          }
      ));
  }

  void incrementCounter(){
    setState(() {
      score++;
    });
  }
}

class QuestionCard extends StatefulWidget {

  Question question;
  Function incrementCounter;
  // String content;
  // String rightAnswer;
  // List<String>? propositions;

  QuestionCard({Key? key, required this.question, required this.incrementCounter}) : super(key: key);

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {

  final responseController = TextEditingController();

  late String response = "";

  String state = "notAnswered";

  @override
  Widget build(BuildContext context) {
    log(response);
    return Card(
      color: colorsCard(),
      elevation: 10,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.question.content,
              style: const TextStyle(
              fontSize: 17,
                fontWeight: FontWeight.bold
            ),),
          ),
          widget.question.image != null ? Image.network(widget.question.image!) : Container(),
          widget.question.propositions!.isNotEmpty ? choice() : input(),
          buttonState(),
        ],
      ),
    );
  }

  Widget buttonState(){
    switch(state){
      case "wrong":
        return Padding(padding: const EdgeInsets.all(8),child: Text('réponse : ${widget.question.rightAnswer}'));
      case "notAnswered":
        return ElevatedButton(onPressed: () => submit(), child: const Text('Valider'));
        case "correct":
          return Container();
      default:
        return Container();
    }
  }

  Color colorsCard(){
    switch(state){
      case "notAnswered":
        return Colors.white;
      case "wrong":
        return Colors.red.shade200;
      case "correct":
        return Colors.green.shade200;
      default:
        return Colors.white;
    }
  }

  Object submit(){
    if(response.isEmpty && widget.question.propositions!.isEmpty){
      return showDialog(                //like that
          context: context,
          builder: (BuildContext context){
            return const AlertDialog(
              content: Text(
                  "Vous n'avez pas répondu à la question",
                  textAlign: TextAlign.center,
              ),
            );
          }
      );
    }
    else if(response.isEmpty && widget.question.propositions!.isNotEmpty){
      return showDialog(                //like that
          context: context,
          builder: (BuildContext context){
            return const AlertDialog(
              content: Text(
                "Vous n'avez pas choisis de réponse, veulliez sélectionner une réponse",
                textAlign: TextAlign.center,
              ),
            );
          }
      );
    }
    else if(response.isNotEmpty && widget.question.rightAnswer.toLowerCase() == response.toLowerCase()){
      setState(() {
        state = "correct";
        widget.incrementCounter();
      });
      // return showDialog(                //like that
      //     context: context,
      //     builder: (BuildContext context){
      //
      //       return const AlertDialog(
      //         content: Text(
      //           "Bonne réponse",
      //           textAlign: TextAlign.center,
      //         ),
      //       );
      //     }
      // );
    }
    else if(response.isNotEmpty && widget.question.rightAnswer.toLowerCase() != response.toLowerCase()){
      setState(() {
        state = "wrong";
      });
      // return showDialog(                //like that
      //     context: context,
      //     builder: (BuildContext context){
      //       return const AlertDialog(
      //         content: Text(
      //           "Mauvaise réponse",
      //           textAlign: TextAlign.center,
      //         ),
      //       );
      //     }
      // );
    }
    return Container();
  }

  Widget choice() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 8,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: ListView.builder(
          addRepaintBoundaries: false,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.question.propositions?.length,
          itemBuilder: (context, i){
            return Padding(
              padding: const EdgeInsets.all(4),
              child: checkBox(prop: widget.question.propositions![i], setResponse: setResponse, response: response),
            );
          },
        ),
      ),
    );
  }

  Widget input(){
    return Padding(
      padding: const EdgeInsets.all(18),
      child: TextFormField(
          controller: responseController,
              onChanged: (element) {
            setState(() {
              response = element.toString();
            });
    },
      ),
    );
  }

  void setResponse(r){
    log(r);
    setState(() {
      response = r;
    });
  }
}

class checkBox extends StatefulWidget {
  Function setResponse;
  String prop;
  String response;

  checkBox({Key? key, required this.setResponse, required this.prop, required this.response}) : super(key: key);

  @override
  State<checkBox> createState() => _checkBoxState();
}

class _checkBoxState extends State<checkBox> {

  bool state =  false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(widget.response.isEmpty){
          setState(() {
            state = true;
          });
          if(state){
            widget.setResponse(widget.prop);
          }
          else{
            widget.setResponse('');
          }
        }
      },
      child: Row(
        children: <Widget>[
          Checkbox(
            onChanged: (bool? value) {
              if(widget.response.isEmpty){
                setState(() {
                  state = true;
                });
                if(state){
                  widget.setResponse(widget.prop);
                }
                else{
                  widget.setResponse('');
                }
              }
            },
            value: state,
            activeColor: Colors.blueGrey,
          ),
          Text(
            widget.prop,
          ),
        ],
      ),
    );
  }
}




