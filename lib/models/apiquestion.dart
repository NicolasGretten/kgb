import 'dart:convert';

class ApiQuestionList {
  ApiQuestionList({
    this.questions,
  });

  List<ApiQuestion>? questions;

  factory ApiQuestionList.fromJson(Map<String, dynamic> json) => ApiQuestionList(
      questions: json["data"] == null ? null : List<ApiQuestion>.from(json["data"].map((x) => ApiQuestion.fromJson(x))));

  Map<String, dynamic> toJson() => {
    "questions": questions == null ? null : List<dynamic>.from(questions!.map((x) => x.toJson())),
  };
}

class ApiQuestion {
  ApiQuestion({
    this.id,
    this.content,
    this.rightAnswer,
    this.image,
    this.serie,
    this.propositions,
  });

  int? id;
  String? content;
  String? rightAnswer;
  String? image;
  int? serie;
  List<dynamic>? propositions;

  factory ApiQuestion.fromRawJson(String str) => ApiQuestion.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ApiQuestion.fromJson(Map<String, dynamic> json) => ApiQuestion(
    id: json["id"] == null ? null : json["id"],
    content: json["content"] == null ? null : json["content"],
    rightAnswer: json["right_answer"] == null ? null : json["right_answer"],
    image: json["image"] == null ? null : json["image"],
    serie: json["serie"] == null ? null : json["serie"],
    propositions: json["propositions"] == null ? null : List<dynamic>.from(json["propositions"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "content": content == null ? null : content,
    "right_answer": rightAnswer == null ? null : rightAnswer,
    "image": image == null ? null : image,
    "serie": serie == null ? null : serie,
    "propositions": propositions == null ? null : List<dynamic>.from(propositions!.map((x) => x)),
  };
}
