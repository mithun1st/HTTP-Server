class Student {
  final String? id;
  final String? name;
  final String? dep;

  Student({required this.id, required this.name, required this.dep});

  Map toJson() {
    Map map = {
      'id': id,
      'name': name,
      'department': dep,
    };
    return map;
  }
}
