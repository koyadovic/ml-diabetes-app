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
      createdDate: DateTime.fromMicrosecondsSinceEpoch(json['created_date'] * 1000000),
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


class FeedbackRequest {
  final int id;
  final DateTime createdDate;
  final DateTime deliveryDate;
  final String title;
  final String text;
  final List<String> options;

  FeedbackRequest({this.id, this.createdDate, this.deliveryDate, this.title, this.text, this.options});

  factory FeedbackRequest.fromJson(Map<String, dynamic> json) {
    return FeedbackRequest(
      id: json['id'],
      createdDate: DateTime.fromMicrosecondsSinceEpoch(json['created_date'] * 1000000),
      deliveryDate: DateTime.fromMicrosecondsSinceEpoch(json['delivery_date'] * 1000000),
      title: json['title'],
      text: json['text'],
      options: List<String>.from(json['options']),
    );
  }

  String toString() {
    return this.title + ': ' + this.text + ', ' + this.options.toString();
  }
}
