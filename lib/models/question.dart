class Question {

  Question({
    required this.id,
    required this.content,
    required this.rightAnswer,
    this.propositions,
    this.image,
  });

  int id;
  String content;
  String rightAnswer;
  List<String>? propositions;
  String? image;
}