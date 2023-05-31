import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/core/utils/strings_manager.dart';
import 'package:internship_practice/features/auth/presentation/cubit/sign%20out/sign_out_cubit.dart';
import 'package:internship_practice/injection_container.dart';
import 'package:internship_practice/routes/router.gr.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SignOutCubit _bloc;

  Future<bool> _showExitPopup() async {
    return await showDialog(
      context: context,
      builder: (context) => BlocListener<SignOutCubit, SignOutState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is SignOutSuccess) {
            context.router.replace(const LoginRoute());
          } else if (state is SignOutFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                duration: const Duration(seconds: 5),
              ),
            );
          }
        },
        child: BlocProvider(
          create: (context) => _bloc,
          child: BlocBuilder<SignOutCubit, SignOutState>(
            builder: (context, state) {
              return AlertDialog(
                title: const Text('Logout from APP'),
                content: const Text('Are you sure you want to logout?'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigator.of(context).pop(true);
                      context.read<SignOutCubit>().signOut();
                    },
                    child: const Text('Yes'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _bloc = sl<SignOutCubit>();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _showExitPopup,
      child: AutoTabsScaffold(
        backgroundColor: ColorUtil.kPrimaryColor,
        routes: const [
          FestivalRouter(),
          ChatListRouter(),
          LocationRouter(),
          ProfileRouter(),
        ],
        bottomNavigationBuilder: (context, tabsRouter) {
          return Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(
                width: 0,
              ),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: ColorUtil.kSecondaryColor,
              selectedItemColor: Colors.white,
              unselectedItemColor: ColorUtil.kTertiaryColor,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: tabsRouter.activeIndex,
              onTap: tabsRouter.setActiveIndex,
              items: const [
                BottomNavigationBarItem(
                  tooltip: AppStrings.home,
                  label: AppStrings.home,
                  activeIcon: Icon(
                    Icons.window,
                  ),
                  icon: Icon(
                    Icons.window_outlined,
                  ),
                ),
                BottomNavigationBarItem(
                  tooltip: AppStrings.chat,
                  label: AppStrings.chat,
                  activeIcon: Icon(
                    Icons.message,
                  ),
                  icon: Icon(
                    Icons.message_outlined,
                  ),
                ),
                BottomNavigationBarItem(
                  tooltip: AppStrings.location,
                  label: AppStrings.location,
                  activeIcon: Icon(Icons.location_on),
                  icon: Icon(
                    Icons.location_on_outlined,
                  ),
                ),
                BottomNavigationBarItem(
                  tooltip: AppStrings.profile,
                  label: AppStrings.profile,
                  activeIcon: Icon(Icons.person),
                  icon: Icon(
                    Icons.person_outline_outlined,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
