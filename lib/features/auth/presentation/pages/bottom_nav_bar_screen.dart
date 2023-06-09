import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/core/utils/strings_manager.dart';
import 'package:internship_practice/features/auth/presentation/cubit/sign%20out/sign_out_cubit.dart';
import 'package:internship_practice/features/auth/presentation/cubit/user%20status/user_status_cubit.dart';
import 'package:internship_practice/features/chat/presentation/pages/chat_list_screen.dart';
import 'package:internship_practice/features/auth/presentation/pages/festival_screen.dart';
import 'package:internship_practice/features/chat/presentation/pages/chat_screen.dart';
import 'package:internship_practice/features/location/presentation/pages/location_screen.dart';
import 'package:internship_practice/features/notification/firebase_messaging/notifications_config.dart';
import 'package:internship_practice/features/profile/presentation/pages/profile_screen.dart';
import 'package:internship_practice/injection_container.dart';
import 'package:internship_practice/ui_pages.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen>
    with WidgetsBindingObserver {
  int _currentIndex = 0;
  late SignOutCubit _bloc;

  List<Widget> pages = [
    const FestivalScreen(),
    const ChatListScreen(),
    const LocationScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    requestPermission();
    initInfo();
    _bloc = sl<SignOutCubit>();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _bloc.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        context.read<UserStatusCubit>().setUserState(true);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        context.read<UserStatusCubit>().setUserState(false);
        break;
      default:
    }
  }

  Future<bool> _showExitPopup() async {
    return await showDialog(
      context: context,
      builder: (context) => BlocListener<SignOutCubit, SignOutState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is SignOutSuccess) {
            Navigator.pushReplacementNamed(context, kLoginScreenPath);
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

  void requestPermission() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    NotificationSettings notificationSettings =
        await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      log("User granted permission");
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log("User granted provisional permission");
    } else {
      log("User declined or has not granted persmission");
    }
  }

  initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) async {
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        remoteMessage.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: remoteMessage.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'ellsker_app',
        'ellsker_app',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,

        // ongoing: true,
      );
      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: const DarwinNotificationDetails(),
      );
      await flutterLocalNotificationsPlugin.show(
        0,
        remoteMessage.notification?.title,
        remoteMessage.notification?.body,
        notificationDetails,
        payload: remoteMessage.data['body'],
      );
      // checkRoute(remoteMessage);
    });

    // If the app is open in background (Not termainated)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      checkRoute(message);
    });
  }

  checkRoute(RemoteMessage message) async {
    var notificationDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationDetails!.didNotificationLaunchApp ||
        notificationDetails.notificationResponse == null) {
      if (message.data['conversationId'] != null) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                username: message.data['username'],
                userId: message.data['conversationId'],
                photoUrl: message.data['photoUrl'],
                token: message.data['token'],
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _showExitPopup,
      child: Scaffold(
        body: pages[_currentIndex],
        bottomNavigationBar: Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(
              width: 0,
            ),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: _onTap,
            currentIndex: _currentIndex,
            backgroundColor: ColorUtil.kSecondaryColor,
            selectedItemColor: Colors.white,
            unselectedItemColor: ColorUtil.kTertiaryColor,
            showSelectedLabels: false,
            showUnselectedLabels: false,
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
        ),
      ),
    );
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
