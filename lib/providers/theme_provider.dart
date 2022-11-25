import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData currentTheme;
  static Color lightColor = const Color.fromRGBO(55, 55, 55, 0.9);
  static Color darkColor = const Color.fromRGBO(240, 171, 0, 1);

  ThemeProvider({
    required isDarkmode,
    lightColor = const Color.fromRGBO(55, 55, 55, 0.9),
    darkColor = const Color.fromRGBO(240, 171, 0, 1),
  }) : currentTheme = isDarkmode
            ? ThemeData.dark().copyWith(
                appBarTheme: AppBarTheme(
                  backgroundColor: lightColor,
                ),
                floatingActionButtonTheme:
                    FloatingActionButtonThemeData(backgroundColor: darkColor),
                bottomNavigationBarTheme:
                    BottomNavigationBarThemeData(selectedItemColor: darkColor),
                switchTheme: SwitchThemeData(
                  thumbColor: MaterialStateProperty.all(darkColor),
                  trackColor: MaterialStateProperty.all(
                      const Color.fromRGBO(240, 171, 0, 0.5)),
                ),
              )
            : ThemeData.light().copyWith(
                appBarTheme: AppBarTheme(backgroundColor: lightColor),
                floatingActionButtonTheme:
                    FloatingActionButtonThemeData(backgroundColor: lightColor),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  selectedItemColor: lightColor,
                  unselectedItemColor: Colors.grey,
                ),
                switchTheme: SwitchThemeData(
                  thumbColor: MaterialStateProperty.all(lightColor),
                  trackColor: MaterialStateProperty.all(
                      const Color.fromRGBO(35, 35, 35, 0.5)),
                ),
              );

  setLightMode() {
    currentTheme = ThemeData.light().copyWith(
      appBarTheme: AppBarTheme(backgroundColor: lightColor),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: lightColor),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: lightColor,
        unselectedItemColor: Colors.grey,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(lightColor),
        trackColor:
            MaterialStateProperty.all(const Color.fromRGBO(35, 35, 35, 0.5)),
      ),
    );
    notifyListeners();
  }

  setDarkMode() {
    currentTheme = ThemeData.dark().copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: lightColor,
      ),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: darkColor),
      bottomNavigationBarTheme:
          BottomNavigationBarThemeData(selectedItemColor: darkColor),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(darkColor),
        trackColor:
            MaterialStateProperty.all(const Color.fromRGBO(240, 171, 0, 0.5)),
      ),
    );
    notifyListeners();
  }
}
