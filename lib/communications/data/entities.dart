class Message {
  final String title;
  final String subtitle;
  final Map<String, dynamic> data;

  Message({this.title, this.subtitle, this.data});

  String toString() {
    return this.title + ': ' + this.subtitle;
  }

}