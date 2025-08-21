import 'package:codexcrew/core/appshell.dart';
import 'package:codexcrew/core/nav_config.dart';
import 'package:codexcrew/firebase_options.dart';
import 'package:codexcrew/notifications.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: kIsWeb ? DefaultFirebaseOptions.web : null,
    );
  }

  await NotificationService().initialize();

  runApp(const CodexApp());
}



class CodexApp extends StatelessWidget {
  const CodexApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp.router(
      title: 'Codex Crew',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        textTheme: GoogleFonts.firaCodeTextTheme(Theme.of(context).textTheme),
        scaffoldBackgroundColor: Colors.black,
      ),
      routerConfig: RouterConfig.router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class RouterConfig {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: NavConfig.items
            .map(
              (item) => GoRoute(
                path: item.route,
                name: item.name,
                builder: (context, state) => item.page,
              ),
            )
            .toList(),
      ),
    ],
  );
}