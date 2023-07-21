import 'package:foodbridge_project/screens/tabs_screen.dart';
import 'package:foodbridge_project/screens/log_in_&_auth/auth_screen.dart';
import 'package:foodbridge_project/widgets/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

const ColorScheme kColorScheme = ColorScheme(
  primary: Color(0xFF272643),
  secondary: Color(0xFF2C698D),
  tertiary: Color(0xFF53C6C6),
  surface: Color(0xFFFFFFFF),
  background: Color(0xFFE3F6F5),
  error: Colors.red, // Customize the error color if needed
  onPrimary: Colors.white, // Customize the onPrimary text color if needed
  onSecondary: Colors.white, // Customize the onSecondary text color if needed
  onSurface: Colors.black, // Customize the onSurface text color if needed
  onBackground: Colors.black, // Customize the onBackground text color if needed
  onError: Colors.white, // Customize the onError text color if needed
  brightness: Brightness.light, // Set the brightness of the color scheme
);

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Handling a background message: ${message.data['type']}");
}

Future main() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  WidgetsFlutterBinding.ensureInitialized();
  //await FirebaseAppCheck.instance.activate();
  await Firebase.initializeApp();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String title = 'Firebase Auth';

  @override
  Widget build(BuildContext context) => MaterialApp(
        scaffoldMessengerKey: Utils.messengerKey,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData().copyWith(
            useMaterial3: true,
            colorScheme: kColorScheme,
            appBarTheme: const AppBarTheme().copyWith(
              centerTitle: true,
              backgroundColor: kColorScheme.primary,
              foregroundColor: kColorScheme.onPrimaryContainer,
            ),
            cardTheme: const CardTheme().copyWith(
              color: kColorScheme.secondaryContainer,
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 5,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorScheme.primaryContainer,
              ),
            ),
            textTheme: ThemeData().textTheme.copyWith(
                  titleLarge: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  titleMedium: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  bodyMedium: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
            bottomSheetTheme: const BottomSheetThemeData().copyWith(
              backgroundColor: kColorScheme.onPrimaryContainer,
              //modalBackgroundColor: kColorScheme.onSecondaryContainer,
            )),
        home: const MainPage(),
      );
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong!'));
            } else if (snapshot.hasData) {
              return const TabsScreen();
            } else {
              return const AuthPage();
            }
          },
        ),
      );
}