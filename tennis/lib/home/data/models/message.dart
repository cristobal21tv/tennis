class Message {
  String? message;
  bool show;

  Message({
    this.message,
    required this.show,
  });

  // Método para convertir un mapa en una instancia de Booking
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      message: map['message'],
      show: map['show'],
    );
  }

  // Método para convertir una instancia de Booking en un mapa
  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'show': show,
    };
  }
}
