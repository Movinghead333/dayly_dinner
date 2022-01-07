import 'package:dayly_dinner/providers/main_data_provider.dart';
import 'package:dayly_dinner/screens/main_screen/main_screen.dart';
import 'package:dayly_dinner/services/database_service/database_service.dart';
import 'package:dayly_dinner/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DatabaseService databaseService = DatabaseService();
  await databaseService.initilizationDone();

  // Setup services singleton which allows access to all services everywhere in
  // the app
  Services.initialize(databaseService);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainDataProvider>(
      create: (context) => MainDataProvider(),
      child: MaterialApp(
        title: 'Dayly Dinner',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MainScreen(),
      ),
    );
  }
}
