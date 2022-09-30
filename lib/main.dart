import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kgb/questions/worldofwarcraft.dart';
import 'package:kgb/questions/harrypotter.dart';
import 'package:restart_app/restart_app.dart';
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
      theme: ThemeData(
          fontFamily: GoogleFonts.robotoFlex().fontFamily,
          primarySwatch: Colors.amber),
      home: const Hub(),
    );
  }
}

class Hub extends StatefulWidget {
  const Hub({Key? key}) : super(key: key);

  @override
  State<Hub> createState() => _HubState();
}

class _HubState extends State<Hub> {

  late QuestionList questions;

  Future<QuestionList> getHttp() async {
      var response = await Dio().get('https://ff8jexlq.directus.app/items/questions');
      var propositionsResponse = await Dio().get('https://ff8jexlq.directus.app/items/propositions');

      for(var i = 0; i < response.data['data'].length; i++){
        if(response.data['data'][i]['propositions'].length > 0){
          for(var j = 0; j < response.data['data'][i]['propositions'].length; j++){
            if(propositionsResponse.data['data'][(response.data['data'][i]['propositions'][j] - 1)]['id'] == response.data['data'][i]['propositions'][j]){
              response.data['data'][i]['propositions'][j] = propositionsResponse.data['data'][(response.data['data'][i]['propositions'][j] - 1)]['content'];
            }
          }
        }
      }

      return QuestionList.fromJson(response.data);
  }

  @override
  void initState() {
    getHttp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Quizz Hub',
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            _hubQuizzTile(
              Image.network(
                  'https://static.thenounproject.com/png/2185221-200.png'),
              'Harry Potter',
              'Etes-vous un vrai PotterHead ?',
              "Harry Potter Quizz",
              QuestionList.fromJson((HarryPotter.questions())),
            ),
            _hubQuizzTile(
              Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/e/eb/WoW_icon.svg/1200px-WoW_icon.svg.png'),
              'World Of Warcraft',
              'Aymeric viens jouer avec tes copains !',
              "WoW Quizz",
              QuestionList.fromJson((WorldOfWarcraft.questions())),
            ),
            FutureBuilder(
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if(snapshot.data == null){
                    return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(),
                        )
                    );
                  }
                  else{
                    return _hubQuizzTile(
                      Image.network(
                          'https://uxwing.com/wp-content/themes/uxwing/download/web-app-development/rest-api-icon.png'),
                      'API',
                      'les questions de l\'api !',
                      "API Quizz",
                      snapshot.data!,
                    );
                  }
                }
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  )
                );
              },
              future: getHttp(),
            ),
          ],
        ));
  }

  Widget _hubQuizzTile(Widget icon, String title, String subtitle,
      String questionPageTitle, QuestionList questions) {
    return Card(
      child: ListTile(
        leading: icon,
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_outlined),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QuestionPage(
                      title: questionPageTitle, questions: questions)));
        },
      ),
    );
  }
}

class QuestionPage extends StatefulWidget {
  QuestionPage({super.key, required this.title, required this.questions});

  final String title;
  QuestionList questions;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  List<Question> questionsList = [];
  bool reloadApp = false;

  void _restartApp() async {
    Restart.restartApp();
  }

  int score = 0;
  int error = 0;

  @override
  void initState() {
    if (widget.questions.questions!.isNotEmpty) {
      int id = 0;
      widget.questions.questions!.forEach((element) {
        if (element.image != null) {
          questionsList.add(Question(
              id: id,
              content: element.content.toString(),
              rightAnswer: element.rightAnswer.toString(),
              propositions: element.propositions,
              image: element.image.toString()));
        } else {
          questionsList.add(Question(
            id: id,
            content: element.content.toString(),
            rightAnswer: element.rightAnswer.toString(),
            propositions: element.propositions,
          ));
        }
      });
      id++;
    }
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
              return QuestionCard(
                  question: questionsList[i],
                  incrementCounter: incrementCounter,
                  addError: incrementError);
            }));
  }

  void incrementCounter() {
    setState(() {
      score++;
    });
  }

  void incrementError() {
    setState(() {
      error++;
    });
    gameOver();
  }

  void gameOver() {
    if (error == 3) {
      showDialog<void>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Center(child: Text('GAME OVER')),
            actions: <Widget>[
              TextButton(
                child: const Text('Retour au hub'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  Navigator.pop(context);
                  // _restartApp();
                },
              ),
            ],
          );
        },
      );
    }
  }
}

class QuestionCard extends StatefulWidget {
  Question question;
  Function incrementCounter;
  Function addError;

  QuestionCard(
      {Key? key,
      required this.question,
      required this.incrementCounter,
      required this.addError})
      : super(key: key);

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  final responseController = TextEditingController();

  late String response = "";

  String state = "notAnswered";

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorsCard(),
      elevation: 10,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.question.content,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          widget.question.image != null
              ? Image.network(widget.question.image!)
              : Container(),
          widget.question.propositions!.isNotEmpty ? choice() : input(),
          buttonState(),
        ],
      ),
    );
  }

  Widget buttonState() {
    switch (state) {
      case "wrong":
        return Padding(
            padding: const EdgeInsets.all(8),
            child: Text('réponse : ${widget.question.rightAnswer}'));
      case "notAnswered":
        return ElevatedButton(
            onPressed: () => submit(), child: const Text('Valider'));
      case "correct":
        return Container();
      default:
        return Container();
    }
  }

  Color colorsCard() {
    switch (state) {
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

  Object submit() {
    if (response.isEmpty && widget.question.propositions!.isEmpty) {
      return showDialog(
          //like that
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              content: Text(
                "Vous n'avez pas répondu à la question",
                textAlign: TextAlign.center,
              ),
            );
          });
    } else if (response.isEmpty && widget.question.propositions!.isNotEmpty) {
      return showDialog(
          //like that
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              content: Text(
                "Vous n'avez pas choisis de réponse, veulliez sélectionner une réponse",
                textAlign: TextAlign.center,
              ),
            );
          });
    } else if (response.isNotEmpty &&
        widget.question.rightAnswer.toLowerCase() == response.toLowerCase()) {
      setState(() {
        state = "correct";
        widget.incrementCounter();
      });
    } else if (response.isNotEmpty &&
        widget.question.rightAnswer.toLowerCase() != response.toLowerCase()) {
      setState(() {
        state = "wrong";
        widget.addError();
      });
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
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.all(4),
              child: checkBox(
                  prop: widget.question.propositions![i],
                  setResponse: setResponse,
                  response: response),
            );
          },
        ),
      ),
    );
  }

  Widget input() {
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

  void setResponse(r) {
    setState(() {
      response = r;
    });
  }
}

class checkBox extends StatefulWidget {
  Function setResponse;
  String prop;
  String response;

  checkBox(
      {Key? key,
      required this.setResponse,
      required this.prop,
      required this.response})
      : super(key: key);

  @override
  State<checkBox> createState() => _checkBoxState();
}

class _checkBoxState extends State<checkBox> {
  bool state = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.response.isEmpty) {
          setState(() {
            state = true;
          });
          if (state) {
            widget.setResponse(widget.prop);
          } else {
            widget.setResponse('');
          }
        }
      },
      child: Row(
        children: <Widget>[
          Checkbox(
            onChanged: (bool? value) {
              if (widget.response.isEmpty) {
                setState(() {
                  state = true;
                });
                if (state) {
                  widget.setResponse(widget.prop);
                } else {
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
