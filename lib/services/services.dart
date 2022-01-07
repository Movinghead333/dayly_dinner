import 'package:dayly_dinner/services/database_service/database_service.dart';

class Services {
  static late DatabaseService databaseService;

  static initialize(DatabaseService databaseServiceInstance) {
    databaseService = databaseServiceInstance;
  }
}
