import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:pbmuas/view_models/auth_v_model.dart';
import 'package:pbmuas/view_models/forum_v_model.dart';
import 'package:pbmuas/view_models/event_v_model.dart';
import 'package:pbmuas/screens/splash_screen.dart';
import 'package:pbmuas/screens/widgets/panitia_navbar.dart';
import 'package:pbmuas/screens/widgets/peserta_navbar .dart';
import 'screens/sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'EHO : Event Horeg Application',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         fontFamily: 'Arial',
//         primarySwatch: Colors.blue,
//       ),
//       home: const NavbarPanitia(),
//     );
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ysxfsmqemocaaaikneaa.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlzeGZzbXFlbW9jYWFhaWtuZWFhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyOTY4NzIsImV4cCI6MjA2Mjg3Mjg3Mn0.r_NkccmZzxek-8NgXthntP2vYsjS6Mo0vk8LOv7ZwxU',
  );
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder:
          (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => AuthVModel()),
              ChangeNotifierProvider(create: (_) => ForumVModel()),
              ChangeNotifierProvider(create: (_) => EventVModel()),

              ],
            child: MyApp(),
          ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: const NavbarPanitia(),
      routes: {
        '/login': (context) => const sign_in(),
        '/panitia': (context) => const NavbarPanitia(),
        '/peserta': (context) => const NavbarPeserta(),
      },
    );
  }
}