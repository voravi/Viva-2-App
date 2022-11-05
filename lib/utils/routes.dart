import 'package:viva_two_final_app/views/mood_page.dart';

import '../../views/home_screen/page/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'appRoutes.dart';

Map<String, Widget Function(BuildContext)> routes = {
  AppRoutes().homePage: (context) => HomePage(mood: "Angry"),
  AppRoutes().moodPage: (context) => const MoodPage(),

};
