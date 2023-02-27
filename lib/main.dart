import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:monsalondz/providers/CategoriesProvider.dart';
import 'package:monsalondz/providers/HistouriqueLocal.dart';
import 'package:monsalondz/providers/SalonProvider.dart';
import 'package:monsalondz/providers/SearchPrivider.dart';
import 'package:provider/provider.dart';
import 'package:monsalondz/providers/AuthProvider.dart';
import 'package:monsalondz/root.dart';
import 'package:monsalondz/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';

SharedPreferences? prefs;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  prefs = await SharedPreferences.getInstance();
  easyConfig();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider(),),
        ChangeNotifierProvider(create: (context) => SearchProvider(),),
        ChangeNotifierProvider(create: (context) => CategoriesProvider()),
        ChangeNotifierProvider(create: (context) => HistoryProvider()),
        ChangeNotifierProvider(create: (context) => SalonProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
easyConfig(){
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..backgroundColor = primaryPro;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) =>
    MaterialApp(
      useInheritedMediaQuery: true,
      title: 'MonSalon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Rubik',
        splashFactory: InkRipple.splashFactory,
        splashColor: primary,
        iconTheme: IconThemeData(color: primary),
        useMaterial3: true,
        scrollbarTheme: const ScrollbarThemeData().copyWith(
          thumbColor: MaterialStateProperty.all(primary),
        ),
      ),
      home:  const Root(),
      builder: EasyLoading.init(),
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
