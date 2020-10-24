class DiaMessage {
  final String title;
  final String subtitle;
  final Map<String, dynamic> data;

  DiaMessage({this.title, this.subtitle, this.data});

  String toString() {
    return this.title + ': ' + this.subtitle + ', ' + this.data.toString();
  }

}