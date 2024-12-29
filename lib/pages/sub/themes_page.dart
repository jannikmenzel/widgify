import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widgify/components/app_bar.dart';
import 'package:widgify/screens/home_screen.dart';
import 'package:widgify/styles/typography.dart';
import 'package:widgify/utils/theme_provider.dart';

class ThemesPage extends StatefulWidget {
  const ThemesPage({super.key});

  @override
  State<ThemesPage> createState() => _ThemesPageState();
}

class _ThemesPageState extends State<ThemesPage> {
  final List<Color> _availableColors = [
    Color(0xFF264653),
    Color(0xFF2a9d8f),
    Color(0xFFe9c46a),
    Color(0xFFf4a261),
    Color(0xFFe76f51),
  ];

  final List<String> _colorNames = [
    'Charcoal',
    'Persian Green',
    'Saffron',
    'Sandy Brown',
    'Burnt Sienna',
  ];

  String colorToHex(Color color) {
    int red = (color.r).toInt();
    int green = (color.g).toInt();
    int blue = (color.b).toInt();
    int alpha = (color.a).toInt();
    return '#${alpha.toRadixString(16).padLeft(2, '0')}'
        '${red.toRadixString(16).padLeft(2, '0')}'
        '${green.toRadixString(16).padLeft(2, '0')}'
        '${blue.toRadixString(16).padLeft(2, '0')}';
  }

  Color hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }

  Future<void> _applyColor(BuildContext context, Color color) async {
    final themeProviderPrimary = Provider.of<ThemeProviderPrimary>(context, listen: false);
    await themeProviderPrimary.setPrimaryColor(color);

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Themes',
        leadingIcon: Icons.arrow_back,
        onLeadingPressed: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Wähle eine Farbe für dein Theme:', style: AppTypography.headline),
            const SizedBox(height: 20),

            Column(
              children: List.generate(_availableColors.length, (index) {
                return GestureDetector(
                  onTap: () async {
                    final color = _availableColors[index];
                    await _applyColor(context, color);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _availableColors[index],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _colorNames[index],
                          style: AppTypography.body,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}