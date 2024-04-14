class User {
  int id;
  String name;
  String surname;
  String patronymic;
  String photo;
  String role;

  User(
      this.id, this.name, this.surname, this.patronymic, this.photo, this.role);

  factory User.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['first_name'].toString();
    final surname = json['last_name'].toString();
    final patronymic = json['patronymic'].toString();
    final role = json['role'].toString();

    String photo;
    if (json['photo'] == "string" || json['photo'] == null) {
      photo = "http://cdn1.flamp.ru/883f1acae9f3c27dda8d8e9a1ac92eb0.jpg";
    } else {
      photo = json['photo'];
    }

    final user = User(id, name, surname, patronymic, photo, role);
    return user;
  }
}
