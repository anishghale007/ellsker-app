import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/features/chat/presentation/bloc/conversation/conversation_bloc.dart';
import 'package:internship_practice/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:internship_practice/features/notification/controller/notification_controller.dart';
import 'package:internship_practice/core/utils/strings_manager.dart';
import 'package:internship_practice/features/auth/presentation/cubit/sign%20out/sign_out_cubit.dart';
import 'package:internship_practice/features/auth/presentation/cubit/user%20status/user_status_cubit.dart';
import 'package:internship_practice/features/notification/firebase_messaging/notifications_config.dart';
import 'package:internship_practice/features/notification/presentation/cubit/notification/notification_cubit.dart';
import 'package:internship_practice/injection_container.dart';
import 'package:internship_practice/routes/router.gr.dart';

class HomeScreen extends StatefulWidget implements AutoRouteWrapper {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotificationCubit>(
          create: (context) => sl<NotificationCubit>(),
        ),
        BlocProvider<ConversationBloc>(
          create: (context) => sl<ConversationBloc>(),
        ),
        BlocProvider<MessageCubit>(
          create: (context) => sl<MessageCubit>(),
        ),
      ],
      child: this,
    );
  }
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late SignOutCubit _bloc;
  String? myToken = "";

  @override
  void initState() {
    super.initState();
    requestPermission();
    initInfo();
    // initNotification();
    getToken();
    _bloc = sl<SignOutCubit>();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _bloc.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then(
      (token) {
        setState(() {
          myToken = token;
          log("MyToken: $myToken");
        });
      },
    );
  }

  initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) async {
      if (remoteMessage.notification != null) {
        if (remoteMessage.data['notificationType'] ==
            "missed call notification") {
          AwesomeNotifications().dismiss(1);
        } else if (remoteMessage.data['notificationType'] ==
            "call notification") {
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 1,
              channelKey: "ellsker_app",
              color: Colors.white,
              title: remoteMessage.notification!.title,
              body: remoteMessage.notification!.body,
              category: NotificationCategory.Call,
              wakeUpScreen: true,
              fullScreenIntent: true,
              autoDismissible: false,
              backgroundColor: Colors.orange,
            ),
            actionButtons: [
              NotificationActionButton(
                key: "ACCEPT",
                label: "Accept Call",
                color: Colors.green,
                autoDismissible: true,
              ),
              NotificationActionButton(
                key: "REJECT",
                label: "Reject Call",
                color: Colors.red,
                autoDismissible: true,
              ),
            ],
          );
          AwesomeNotifications().setListeners(
            onActionReceivedMethod: (receivedAction) =>
                NotificationController.onActionReceivedMethod(
              receivedAction,
              context: context,
              userId: remoteMessage.data['conversationId'],
              photoUrl: remoteMessage.data['photoUrl'],
              username: remoteMessage.data['username'],
              token: remoteMessage.data['token'],
              senderToken: myToken!,
            ),
          );
        } else {
          BigTextStyleInformation bigTextStyleInformation =
              BigTextStyleInformation(
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
        }
      }
      // checkRoute(remoteMessage);
    });

    // If the app is open in background (Not termainated)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      checkRoute(message);
      AwesomeNotifications().setListeners(
        onActionReceivedMethod: (receivedAction) =>
            NotificationController.onActionReceivedMethod(
          receivedAction,
          context: context,
          userId: message.data['conversationId'],
          photoUrl: message.data['photoUrl'],
          username: message.data['username'],
          token: message.data['token'],
          senderToken: myToken!,
        ),
      );
    });
  }

  checkRoute(RemoteMessage message) async {
    var notificationDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationDetails!.didNotificationLaunchApp ||
        notificationDetails.notificationResponse == null) {
      if (message.data['conversationId'] != null) {
        if (mounted) {
          context.router.push(
            ChatRoute(
              username: message.data['username'],
              userId: message.data['conversationId'], // other user's id
              photoUrl: message.data['photoUrl'],
              token: message.data['token'],
            ),
          );
        }
      }
    }
  }

  // initNotification() {
  //   NotificationConfig.initInfo(
  //     context,
  //     checkRoute,
  //     senderToken: myToken!,
  //   );
  // }

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
