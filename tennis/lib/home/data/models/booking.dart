class Booking {
  int? id;
  String court;
  String date;
  String userName;
  String? clima;

  Booking({
    this.id,
    required this.court,
    required this.date,
    required this.userName,
    required this.clima,
  });

  // Método para convertir un mapa en una instancia de Booking
  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      court: map['Court'],
      date: map['Date'],
      userName: map['UserName'],
      clima: map['clima'],
    );
  }

  // Método para convertir una instancia de Booking en un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Court': court,
      'Date': date,
      'UserName': userName,
      'clima': clima,
    };
  }
}
