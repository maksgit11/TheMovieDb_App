import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:themovie_db/ui/theme/app_colors.dart';
import 'package:themovie_db/ui/widgets/app/my_app.dart';
import 'package:themovie_db/ui/widgets/app/my_app_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final model = MyAppModel();
  await model.chekAuth();
  final app = MyApp(model: model);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.mainDarkBlue,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color.fromARGB(255, 5, 22, 35),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(app);
}
