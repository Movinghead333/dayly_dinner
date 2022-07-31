import 'package:dayly_dinner/providers/main_data_provider.dart';
import 'package:dayly_dinner/screens/main_screen/main_screen.dart';
import 'package:dayly_dinner/services/database_service/database_service.dart';
import 'package:dayly_dinner/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('${DateTime.now().toString()} initializaing db');
  DatabaseService databaseService = DatabaseService();
  await databaseService.initilizationDone();
  debugPrint('${DateTime.now().toString()} initializaing db done');

  // Setup services singleton which allows access to all services everywhere in
  // the app
  Services.initialize(databaseService);

  runApp(MyApp());
}

// Colors
const Color kPrimary = Color(0xFF034ea2);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme =
        ColorScheme.fromSwatch(primarySwatch: Colors.purple).copyWith(
      secondary: Color(0xfff10080),
      background: Color(0xff222222),
      surface: Color(0xff444444),
    );

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        statusBarColor: colorScheme.primary));

    ThemeData darkTheme = ThemeData.dark().copyWith(
      colorScheme: colorScheme,
      bottomNavigationBarTheme:
          ThemeData.dark().bottomNavigationBarTheme.copyWith(
                backgroundColor:
                    Color.lerp(colorScheme.background, Colors.white, 0.1),
                selectedItemColor: colorScheme.secondary,
              ),
      scaffoldBackgroundColor: colorScheme.background,
    );

    return ChangeNotifierProvider<MainDataProvider>(
      create: (context) => MainDataProvider(),
      child: MaterialApp(
        title: 'Dayly Dinner',
        theme: darkTheme,
        darkTheme: darkTheme,
        home: MainScreen(),
      ),
    );
  }
}
