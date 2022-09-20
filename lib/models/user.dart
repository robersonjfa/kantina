class User {
  int _id;
  String _name;
  String _email;
  String _password;

  // construtor
  User(this._id, this._name, this._email, this._password);

  // setter para o id
  set id(int id) => _id = id;

  // getters para todos
  int get id => _id;
  String get name => _name;
  String get email => _email;
  String get password => _password;

  // para usarmos nos inserts/updates
  Map<String, dynamic> toMap() {
    return {'name': _name, 'email': _email, 'password': _password};
  }
}
