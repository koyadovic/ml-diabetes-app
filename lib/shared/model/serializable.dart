
class Serializable {

}


T deserialize<T extends Serializable>(Map<String, dynamic> json, T factory(Map<String, dynamic> data)) {
  return factory(json);
}
