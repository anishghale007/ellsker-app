class Card {
  final String title;
  final String subtitle;
  final String imagePath;

  Card({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });
}

List<Card> festivalList = [
  Card(
    title: "Lollapalooza",
    subtitle: "Interlagos",
    imagePath: "assets/images/card_one.png",
  ),
  Card(
    title: "Tomorrowland ",
    subtitle: "Itu",
    imagePath: "assets/images/card_two.png",
  ),
  Card(
    title: "Lollapalooza",
    subtitle: "Interlagos",
    imagePath: "assets/images/card_one.png",
  ),
];

List<Card> rolesList = [
  Card(
    title: "Rolê Botafogo",
    subtitle: "Voluntários da Pátria",
    imagePath: "assets/images/card_three.png",
  ),
  Card(
    title: "Rolê Leblon ",
    subtitle: "Praça Cazuza",
    imagePath: "assets/images/card_four.png",
  ),
  Card(
    title: "Rolê Botafogo",
    subtitle: "Voluntários da Pátria",
    imagePath: "assets/images/card_three.png",
  ),
];

List<Card> festasList = [
  Card(
    title: "ISSO NÃO É UMA FESTA",
    subtitle: "Marina da Glória",
    imagePath: "assets/images/card_five.png",
  ),
  Card(
    title: "BALBVRDIA",
    subtitle: "Rio de Janeiro",
    imagePath: "assets/images/card_six.png",
  ),
  Card(
    title: "ISSO NÃO É UMA FESTA",
    subtitle: "Marina da Glória",
    imagePath: "assets/images/card_five.png",
  ),
];
