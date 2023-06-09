enum MessageType {
  text('text'),
  photo('photo'),
  video('video'),
  location('location'),
  gif('gif'),
  audio('audio'),
  call('call');

  const MessageType(this.type);
  final String type;
}

extension MessageTypeExtension on String {
  MessageType toEnum() {
    switch (this) {
      case 'text':
        return MessageType.text;
      case 'photo':
        return MessageType.photo;
      case 'video':
        return MessageType.video;
      case 'location':
        return MessageType.location;
      case 'gif':
        return MessageType.gif;
      case 'audio':
        return MessageType.audio;
      case 'call':
        return MessageType.call;
      default:
        return MessageType.text;
    }
  }
}

// extension MessageTypeExtension on MessageType {
//   String get name {
//     switch (this) {
//       case MessageType.text:
//         return "text";
//       case MessageType.photo:
//         return "photo";
//       case MessageType.video:
//         return "video";
//       case MessageType.location:
//         return "location";
//       case MessageType.gif:
//         return "gif";
//       case MessageType.audio:
//         return "audio";
//       default:
//         return "";
//     }
//   }
// }
