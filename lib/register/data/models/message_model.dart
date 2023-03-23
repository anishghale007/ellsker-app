class Message {
  final String imagePath;
  final String userName;
  final String message;
  final bool fromMe;

  Message({
    required this.imagePath,
    required this.userName,
    required this.message,
    required this.fromMe,
  });
}

List<Message> messageList = [
  Message(
    imagePath: "assets/images/chat_profile.png",
    userName: "Robert Silva",
    message:
        "Qual o bar que vocês preferem? Tem um na Av. Almirante Gomes que é ótimo.",
    fromMe: false,
  ),
  Message(
    imagePath: "assets/images/chat_profile.png",
    userName: "Alana Silva",
    message: "Boa noite  😃",
    fromMe: false,
  ),
  Message(
    imagePath: "assets/images/chat_profile.png",
    userName: "Alana Silva",
    message: "Olá, tudo bem? To bem animado pra esse rolê!",
    fromMe: true,
  ),
  Message(
    imagePath: "assets/images/chat_profile.png",
    userName: "Robert Silva",
    message: "🥳",
    fromMe: false,
  ),
  Message(
    imagePath: "assets/images/chat_profile.png",
    userName: "Robert Silva",
    message: "Alguém vai direto do trabalho?",
    fromMe: true,
  ),
  Message(
    imagePath: "assets/images/chat_profile.png",
    userName: "Alana Silva",
    message: "Eu vou",
    fromMe: false,
  ),
];
