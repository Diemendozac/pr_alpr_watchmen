
class Ticket {
  String plate;
  String userName;
  String ownerEmail;
  String requestEmail;
  DateTime timeStamp;
  bool isIngresing;
  Ticket({
    required this.plate,
    required this.userName,
    required this.ownerEmail,
    required this.requestEmail,
    required this.timeStamp,
    required this.isIngresing,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      plate: json["plate"],
      userName: json["userName"],
      ownerEmail: json["ownerEmail"],
      requestEmail: json["requestEmail"],
      timeStamp: json["timeStamp"],
      isIngresing: json["isIngresing"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plate': plate,
      'userName': userName,
      'ownerEmail': ownerEmail,
      'requestEmail': requestEmail,
      'timeStamp': timeStamp,
      'isIngresing': isIngresing,
    };
  }
}
