

class Vehicle {
  String plate;
  String brand;
  int model;
  String line;
  bool isOwner;

  Vehicle({
    required this.plate,
    required this.brand,
    required this.model,
    required this.line,
    required this.isOwner
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      plate: json["plate"],
      brand: json["brand"],
      model: json["model"],
      line: json["line"],
      isOwner: json['owner']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "plate": plate,
      "brand": brand,
      "model": model,
      "line": line,
      'owner': isOwner
    };
  }
}
