class User {
  int _id;
  String _name;
  String _email;
  String _password;
  double _latitude;
  double _longitude;
  String _photo;
  // _latitude, _longitude, _photo

  // construtor
  User(this._id, this._name, this._email, this._password, this._latitude,
      this._longitude, this._photo);

  // setter para o id
  set id(int id) => _id = id;

  // getters para todos
  int get id => _id;
  String get name => _name;
  String get email => _email;
  String get password => _password;
  double get latitude => _latitude;
  double get longitude => _longitude;
  String get photo => _photo;

  // para usarmos nos inserts/updates
  Map<String, dynamic> toMap() {
    return {
      'name': _name,
      'email': _email,
      'password': _password,
      'latitude': _latitude,
      'longitude': _longitude,
      'photo': _photo
    };
  }
}
