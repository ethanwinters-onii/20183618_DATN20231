class Message {
  final String msg;
  final String read;
  final String told;
  final MType type;
  final String fromId;
  final String sent;

  Message(
      {required this.msg,
      required this.read,
      required this.told,
      required this.type,
      required this.fromId,
      required this.sent});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        msg: json["msg"] ?? "",
        read: json["read"] ?? "",
        told: json["told"] ?? "",
        type: json["type"].toString() == MType.image.name
            ? MType.image
            : MType.text,
        fromId: json["fromId"] ?? "",
        sent: json["sent"] ?? "",
      );
  
  Map<String, dynamic> toJson() => {
        "msg": msg,
        "read": read,
        "told": told,
        "type": type.name,
        "fromId": fromId,
        "sent": sent,
    };
}

enum MType { image, text }
