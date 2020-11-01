class Message {
  final int id;
  final DateTime createdDate;
  final String type;
  final String title;
  final String text;
  final Map<String, dynamic> payload;

  Message({this.id, this.createdDate, this.type, this.title, this.text, this.payload});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      createdDate: DateTime.fromMicrosecondsSinceEpoch((json['created_date'] * 1000000).toInt()),
      type: json['type'],
      title: json['title'],
      text: json['text'],
      payload: json['payload'],
    );
  }

  String toString() {
    return this.title + ': ' + this.text + ', ' + this.payload.toString();
  }
}


enum AnswerTypeHint {
  NUMERICAL,
  TEXT
}

class FeedbackRequest {
  final int id;
  final DateTime createdDate;
  final DateTime deliveryDate;
  final String title;
  final String text;
  final List<String> options;  // can be null!
  final AnswerTypeHint answerTypeHint;

  FeedbackRequest({this.id, this.createdDate, this.deliveryDate, this.title, this.text, this.options, this.answerTypeHint});

  factory FeedbackRequest.fromJson(Map<String, dynamic> json) {
    return FeedbackRequest(
      id: json['id'],
      createdDate: DateTime.fromMicrosecondsSinceEpoch((json['created_date'] * 1000000).toInt()),
      deliveryDate: DateTime.fromMicrosecondsSinceEpoch((json['delivery_date'] * 1000000).toInt()),
      title: json['title'],
      text: json['text'],
      options: json['options'] == null ? null : List<String>.from(json['options']),
      answerTypeHint: json['answer_type_hint'] == 'txt' ? AnswerTypeHint.TEXT : AnswerTypeHint.NUMERICAL,
    );
  }

  String toString() {
    return this.title + ': ' + this.text + ', ' + this.options.toString();
  }
}
