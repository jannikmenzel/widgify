import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widgify/screens/home_screen.dart';
import 'package:widgify/styles/theme.dart';
import 'package:widgify/utils/theme_provider.dart';
import 'package:widgify/utils/widget_preferences_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await initializeDateFormatting('de_DE', null);

  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;

  final themeProviderPrimary = ThemeProviderPrimary();
  await themeProviderPrimary.loadPrimaryColor();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProviderDarkmode(isDarkMode: isDarkMode)),
        ChangeNotifierProvider(create: (_) => themeProviderPrimary),
        ChangeNotifierProvider(create: (_) => WidgetPreferencesProvider()..loadPreferences()),  // Füge den WidgetPreferencesProvider hier hinzu
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProviderPrimary, ThemeProviderDarkmode>(
      builder: (context, themeProviderPrimary, themeProviderDarkmode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Widgify',
          themeMode: themeProviderDarkmode.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: lightTheme(themeProviderPrimary.primaryColor),
          darkTheme: darkTheme(themeProviderPrimary.primaryColor),
          home: HomeScreen(),
        );
      },
    );
  }
}