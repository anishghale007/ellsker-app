// enum MessageType {
//   text('text'),
//   photo('photo');

//   final String type;

//   const MessageType(this.type);
// }

enum MessageType {
  text,
  photo,
  location,
  gif,
}

extension MessageTypeExtension on MessageType {
  String get name {
    switch (this) {
      case MessageType.text:
        return "text";
      case MessageType.photo:
        return "photo";
      case MessageType.location:
        return "location";
      case MessageType.gif:
        return "gif";
      default:
        return "";
    }
  }
}
