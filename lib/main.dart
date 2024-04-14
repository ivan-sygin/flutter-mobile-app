import 'package:flutter/material.dart';
import 'package:sochi/controllers/start_controller.dart';
import 'package:sochi/storages/requests_storage.dart';
import 'package:sochi/storages/user_storage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserStorage>(create: (context) => UserStorage()),
        ChangeNotifierProvider<RequestStorage>(
            create: (context) => RequestStorage()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          final mq = MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0));
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },
        title: 'Контролируем цены вместе',
        themeMode: ThemeMode.system,
        home: Scaffold(body: startController(context)),
      ),
    );
  }
}
