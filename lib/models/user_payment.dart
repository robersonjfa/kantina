class UserPayment {
  int _id;
  int _userId;
  String _description;
  double _value;

  // construtor
  UserPayment(this._id, this._userId, this._description, this._value);
  int get id => this._id;

  set id(int value) => this._id = value;

  get userId => this._userId;

  set userId(value) => this._userId = value;

  get description => this._description;

  set description(value) => this._description = value;

  get value => this._value;

  set value(value) => this._value = value;

  // para usarmos nos inserts/updates
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'userId': _userId,
      'description': _description,
      'value': _value,
    };
  }

  factory UserPayment.fromMap(Map<String, dynamic> json) {
    return UserPayment(
        json['id'], json['userid'], json['description'], json['value']);
  }
  factory UserPayment.fromJson(Map<String, dynamic> json) {
    return UserPayment(
        json['id'], json['userid'], json['description'], json['value']);
  }
}
