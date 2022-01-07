class Ingredient {
  final int id;
  final String name;
  final double storedAmount;
  final String measurementUnit;

  Ingredient({
    this.id = -1,
    required this.name,
    required this.storedAmount,
    required this.measurementUnit,
  });

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      'name': name,
      'storedAmount': storedAmount,
      'measurementUnit': measurementUnit,
    };

    if (id != -1) {
      map['id'] = id;
    }

    return map;
  }

  @override
  String toString() {
    return 'Ingredient{id: $id, name: $name, storedAmount: $storedAmount, measurementUnit: $measurementUnit}';
  }
}
