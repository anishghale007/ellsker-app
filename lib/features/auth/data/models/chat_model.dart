class Chat {
  final String imagePath;
  final String userName;
  final String message;
  final String messageTime;
  final bool hasUnreadMessage;
  final String? numberOfMessage;

  Chat({
    required this.imagePath,
    required this.userName,
    required this.message,
    required this.messageTime,
    required this.hasUnreadMessage,
    this.numberOfMessage,
  });
}

List<Chat> chatList = [
  Chat(
    imagePath: "assets/images/card_one.png",
    userName: "Rolê Leblon",
    message: "Guilherme: Marcamos para as 19?",
    messageTime: "23:15",
    hasUnreadMessage: true,
    numberOfMessage: "12",
  ),
  Chat(
    imagePath: "assets/images/card_two.png",
    userName: "Lollapalooza",
    message: "Lucas Costa: Bom dia! ☺️ ",
    messageTime: "19:03",
    hasUnreadMessage: true,
    numberOfMessage: "8",
  ),
  Chat(
    imagePath: "assets/images/card_three.png",
    userName: "Rolê Botafogo",
    message: "Robson: Amanhã tem niver da Patroa",
    messageTime: "13:18",
    hasUnreadMessage: true,
    numberOfMessage: "2",
  ),
  Chat(
    imagePath: "assets/images/card_four.png",
    userName: "Rolê Lapa",
    message: "Marcela: Eu ja fui nesse bar e foi...",
    messageTime: "Ontem",
    hasUnreadMessage: false,
  ),
  Chat(
    imagePath: "assets/images/card_five.png",
    userName: "Primavera Sound",
    message: "Você: Fechado",
    messageTime: "Ontem",
    hasUnreadMessage: false,
  ),
  Chat(
    imagePath: "assets/images/card_six.png",
    userName: "Tomorrowland",
    message: "Você: Partiu! 👍🏼 ",
    messageTime: "16-Dez",
    hasUnreadMessage: false,
  ),
];
