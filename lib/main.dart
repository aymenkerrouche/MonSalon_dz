import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:monsalondz/providers/AppSettingsProvider.dart';
import 'package:monsalondz/providers/CategoriesProvider.dart';
import 'package:monsalondz/providers/HistouriqueLocal.dart';
import 'package:monsalondz/providers/SearchPrivider.dart';
import 'package:provider/provider.dart';
import 'package:monsalondz/providers/AuthProvider.dart';
import 'package:monsalondz/screens/root.dart';
import 'package:monsalondz/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'providers/GoogleSignIn.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

SharedPreferences? prefs;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GoogleSignInProvider(),),
        ChangeNotifierProvider(create: (context) => AuthProvider(),),
        ChangeNotifierProvider(create: (context) => SearchProvider(),),
        ChangeNotifierProvider(create: (context) => AppSettingsProvider(),),
        ChangeNotifierProvider(create: (context) => CategoriesProvider()),
        ChangeNotifierProvider(create: (context) => HistoryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) =>
    MaterialApp(
      title: 'MonSalon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Rubik',
        primaryColor: primary,
        iconTheme: IconThemeData(color: primary),
      ),
      home: ScrollConfiguration(
        behavior: MyBehavior(),
        child: const Root()
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr')
      ],
  );
}

class MyBehavior extends ScrollBehavior {

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}