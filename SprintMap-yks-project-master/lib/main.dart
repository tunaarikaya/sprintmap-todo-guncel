import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sprintmap/mainwrapper.dart';
import 'package:sprintmap/features/profile/view/profile_view.dart';
import 'package:sprintmap/features/settings/view/settings_view.dart';
import 'package:sprintmap/to-do/providers/todo_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoProvider()),
      ],
      child: MaterialApp(
        title: 'SprintMap',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          snackBarTheme: const SnackBarThemeData(
            backgroundColor: CupertinoColors.darkBackgroundGray,
            contentTextStyle: TextStyle(color: CupertinoColors.white),
            actionTextColor: CupertinoColors.activeBlue,
          ),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('tr', 'TR'),
        ],
        locale: const Locale('tr', 'TR'),
        initialRoute: '/',
        routes: {
          '/': (context) => const MainWrapper(),
          '/profile': (context) => const ProfileView(),
          '/settings': (context) => const SettingsView(),
        },
      ),
    );
  }
}
