import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:pbmuas/helpers/session_helper.dart';
import 'package:pbmuas/models/akun.dart';
import 'package:pbmuas/view_models/auth_v_model.dart';
import 'package:pbmuas/screens/splash_screen.dart';
import 'package:pbmuas/screens/widgets/panitia_navbar.dart';
import 'package:pbmuas/screens/widgets/peserta_navbar .dart';
import 'screens/screen.dart';
import 'screens/sign_in.dart';

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
//       home: const SplashScreen(),
//     );
//   }
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isLoggedIn = await SessionHelper.isLoggedIn();
  final akun = isLoggedIn ? await SessionHelper.getUser() : null;

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder:
          (context) => MultiProvider(
            providers: [ChangeNotifierProvider(create: (_) => AuthVModel())],
            child: MyApp(akun: akun),
          ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Akun? akun;
  const MyApp({super.key, required this.akun});

  @override
  Widget build(BuildContext context) {
    Widget homeWidget;

    if (akun == null) {
      homeWidget = const sign_in();
    } else {
      switch (akun!.roleAkunId) {
        case 1:
          homeWidget = const PanitiaScreen();
          break;
        case 2:
          homeWidget = const PesertaScreen();
          break;
        default:
          homeWidget = const sign_in();
      }
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: homeWidget,
      routes: {
        '/login': (context) => const sign_in(),
        '/panitia': (context) => const PanitiaScreen(),
        '/peserta': (context) => const PesertaScreen(),
      },
    );
  }
}
