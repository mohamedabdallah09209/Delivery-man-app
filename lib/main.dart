import 'dart:io';
import 'package:app_delivary_task/helper/notification_helper.dart';
import 'package:app_delivary_task/utill/app_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app_delivary_task/localization/app_localization.dart';
import 'package:app_delivary_task/features/auth/providers/auth_provider.dart';
import 'package:app_delivary_task/commons/providers/localization_provider.dart';
import 'package:app_delivary_task/features/language/providers/language_provider.dart';
import 'package:app_delivary_task/commons/providers/location_provider.dart';
import 'package:app_delivary_task/features/order/providers/order_provider.dart';
import 'package:app_delivary_task/features/profile/providers/profile_provider.dart';
import 'package:app_delivary_task/features/splash/providers/splash_provider.dart';
import 'package:app_delivary_task/commons/providers/theme_provider.dart';
import 'package:app_delivary_task/features/order/providers/tracker_provider.dart';
import 'package:app_delivary_task/theme/dark_theme.dart';
import 'package:app_delivary_task/theme/light_theme.dart';
import 'package:app_delivary_task/features/splash/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'di_container.dart' as di;
import 'features/chat/providers/chat_provider.dart';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   Platform.isAndroid
     ? await  Firebase.initializeApp(
     options: const FirebaseOptions(
       apiKey: 'AIzaSyBA39xMnUe1ldzaPeq9MUmxTxmhUbuX9Lw',
       appId: '1:151590191214:android:f7236f78eba83052a5667f',
       messagingSenderId: '151590191214',
       projectId: 'emarket-e420c',
     ),
 )
     :await Firebase.initializeApp();
  ///firebase crashlytics
  if(!kIsWeb && defaultTargetPlatform == TargetPlatform.android){
    await FirebaseMessaging.instance.requestPermission();
  }
  await di.init();
  await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LanguageProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OrderProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ChatProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<TrackerProvider>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<LocationProvider>(context, listen: false).getUserLocation();
    List<Locale> locals = [];
    for (var language in AppConstants.languages) {
      locals.add(Locale(language.languageCode!, language.countryCode));
    }
    return MaterialApp(
      title: AppConstants.appName,
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).darkTheme ? dark : light,
      locale: Provider.of<LocalizationProvider>(context).locale,
      localizationsDelegates: const [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: locals,
      home: const SplashScreen(),
      builder: (context, widget) => MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)), child: widget!),
    );
  }
}


class Get {
  static BuildContext? get context => _navigatorKey.currentContext;
  static NavigatorState? get navigator => _navigatorKey.currentState;
}