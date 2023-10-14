import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String movieDbKey = dotenv.env['THE-MOVIEDB-KEY'] ?? 'No API key';
}
