import 'package:internship_practice/core/utils/assets_manager.dart';

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
    imagePath: ImageAssets.cardOne,
  ),
  Card(
    title: "Tomorrowland ",
    subtitle: "Itu",
    imagePath: ImageAssets.cardTwo,
  ),
  Card(
    title: "Lollapalooza",
    subtitle: "Interlagos",
    imagePath: ImageAssets.cardOne,
  ),
];

List<Card> rolesList = [
  Card(
    title: "Rolê Botafogo",
    subtitle: "Voluntários da Pátria",
    imagePath: ImageAssets.cardThree,
  ),
  Card(
    title: "Rolê Leblon ",
    subtitle: "Praça Cazuza",
    imagePath: ImageAssets.cardFour,
  ),
  Card(
    title: "Rolê Botafogo",
    subtitle: "Voluntários da Pátria",
    imagePath: ImageAssets.cardThree,
  ),
];

List<Card> festasList = [
  Card(
    title: "ISSO NÃO É UMA FESTA",
    subtitle: "Marina da Glória",
    imagePath: ImageAssets.cardFive,
  ),
  Card(
    title: "BALBVRDIA",
    subtitle: "Rio de Janeiro",
    imagePath: ImageAssets.cardSix,
  ),
  Card(
    title: "ISSO NÃO É UMA FESTA",
    subtitle: "Marina da Glória",
    imagePath: ImageAssets.cardFive,
  ),
];
