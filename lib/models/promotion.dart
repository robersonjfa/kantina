class Promotion {
  int _id;
  String _product;
  String _value;
  String _startdate;
  String _enddate;

  // construtor
  Promotion(
      this._id, this._product, this._value, this._startdate, this._enddate);

  // setter para o id
  set id(int id) => _id = id;

  // getters para todos
  int get id => _id;
  String get product => _product;
  String get value => _value;
  String get startdate => _startdate;
  String get enddate => _enddate;

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(json['id'], json['product'], json['value'],
        json['startdate'], json['enddate']);
  }
}
