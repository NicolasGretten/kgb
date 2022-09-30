
import 'dart:convert';

class QuestionList {
  QuestionList({
    this.questions,
  });

  List<Question>? questions;

  factory QuestionList.fromJson(Map<String, dynamic> json) => QuestionList(
      questions: json["data"] == null ? null : List<Question>.from(json["data"].map((x) => Question.fromJson(x))));

  Map<String, dynamic> toJson() => {
    "questions": questions == null ? null : List<dynamic>.from(questions!.map((x) => x.toJson())),
  };
}

class Question {

  Question({
    required this.id,
    required this.content,
    required this.rightAnswer,
    required this.propositions,
    this.image,
  });

  dynamic id;
  String content;
  String rightAnswer;
  dynamic propositions;
  String? image;

  factory Question.fromRawJson(String str) => Question.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json["id"] == null ? null : json["id"],
    content: json["content"] == null ? null : json["content"],
    rightAnswer: json["rightAnswer"] == null ? null : json["rightAnswer"],
    image: json["image"] == null ? null : json["image"],
    propositions: json["propositions"] == null ? null : List<dynamic>.from(json["propositions"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "content": content == null ? null : content,
    "rightAnswer": rightAnswer == null ? null : rightAnswer,
    "image": image == null ? null : image,
    "propositions": propositions == null ? null : List<dynamic>.from(propositions!.map((x) => x)),
  };
}