// enum MessageType {
//   text('text'),
//   photo('photo');

//   final String type;

//   const MessageType(this.type);
// }

enum MessageType {
  text,
  photo,
}

extension MessageTypeExtension on MessageType {
  String get name {
    switch (this) {
      case MessageType.text:
        return "text";
      case MessageType.photo:
        return "photo";
      default:
        return "";
    }
  }
}
