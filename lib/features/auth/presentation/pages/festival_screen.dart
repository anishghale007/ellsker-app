import 'package:flutter/material.dart';
import 'package:internship_practice/common/widgets/widgets.dart';
import 'package:internship_practice/core/utils/strings_manager.dart';
import 'package:internship_practice/features/auth/data/models/card_model.dart';
import 'package:internship_practice/features/auth/presentation/widgets/card_widget.dart';
import 'package:internship_practice/features/auth/presentation/widgets/header_widget.dart';

class FestivalScreen extends StatefulWidget {
  const FestivalScreen({Key? key}) : super(key: key);

  @override
  State<FestivalScreen> createState() => _FestivalScreenState();
}

class _FestivalScreenState extends State<FestivalScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff3B4171),
            Color(0xff1F1F40),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  SearchBarWidget(
                    hintText: AppStrings.searchByEventOrTour,
                    controller: _searchController,
                    onChanged: (value) {},
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const HeaderWidget(
                    header: AppStrings.festivals,
                  ),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: festivalList.length,
                      itemBuilder: (context, index) {
                        final data = festivalList[index];
                        return CardWidget(
                          title: data.title,
                          subtitle: data.subtitle,
                          imagePath: data.imagePath,
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const HeaderWidget(
                    header: AppStrings.roles,
                  ),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: rolesList.length,
                      itemBuilder: (context, index) {
                        final data = rolesList[index];
                        return CardWidget(
                          title: data.title,
                          subtitle: data.subtitle,
                          imagePath: data.imagePath,
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const HeaderWidget(
                    header: AppStrings.festas,
                  ),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: festasList.length,
                      itemBuilder: (context, index) {
                        final data = festasList[index];
                        return CardWidget(
                          title: data.title,
                          subtitle: data.subtitle,
                          imagePath: data.imagePath,
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
