import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/auth/data/models/user_model.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(UserModelAdapter());
  }
  runApp(const TrekApp());
}