import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData currentTheme;
  static Color lightColor = const Color.fromRGBO(35, 35, 35, 0.9);
  static Color darkColor = const Color.fromRGBO(240, 171, 0, 1);
  static Color blueColor = const Color.fromARGB(255, 17, 92, 153);
  static Color redColor = const Color.fromARGB(255, 255, 0, 0);
  static Color aquaBlueColor = const Color.fromARGB(255, 49, 134, 160);
  static Color whiteColor = Colors.white;

  ThemeProvider({
    required isDarkmode,
    lightColor = const Color.fromRGBO(35, 35, 35, 0.9),
    darkColor = const Color.fromRGBO(240, 171, 0, 1),
  }) : currentTheme = isDarkmode
            ? ThemeData.dark().copyWith(
                appBarTheme: AppBarTheme(
                  titleTextStyle: TextStyle(
                    color: ThemeProvider.whiteColor,
                    fontSize: 20,
                  ),
                  backgroundColor: lightColor,
                  iconTheme: IconThemeData(color: whiteColor),
                ),
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: darkColor,
                  foregroundColor: whiteColor,
                ),
                bottomNavigationBarTheme:
                    BottomNavigationBarThemeData(selectedItemColor: darkColor),
                switchTheme: SwitchThemeData(
                  thumbColor: MaterialStateProperty.all(darkColor),
                  trackColor: MaterialStateProperty.all(
                      const Color.fromRGBO(240, 171, 0, 0.5)),
                ),
                expansionTileTheme: ExpansionTileThemeData(
                  backgroundColor: Colors.grey.shade800,
                  textColor: darkColor,
                  iconColor: darkColor,
                ),

                // popupMenuTheme: const PopupMenuThemeData(
                //   color: Colors.white,
                // ),
              )
            : ThemeData.light().copyWith(
                appBarTheme: AppBarTheme(
                  titleTextStyle: TextStyle(
                    color: ThemeProvider.whiteColor,
                    fontSize: 20,
                  ),
                  backgroundColor: lightColor,
                  iconTheme: IconThemeData(color: whiteColor),
                ),
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: lightColor,
                  foregroundColor: whiteColor,
                ),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  selectedItemColor: lightColor,
                  unselectedItemColor: Colors.grey,
                ),
                switchTheme: SwitchThemeData(
                  thumbColor: MaterialStateProperty.all(lightColor),
                  trackColor: MaterialStateProperty.all(
                      const Color.fromRGBO(35, 35, 35, 0.5)),
                ),
                expansionTileTheme: ExpansionTileThemeData(
                  backgroundColor: Colors.grey.shade200,
                  textColor: lightColor,
                  iconColor: lightColor,
                ),
                // popupMenuTheme: const PopupMenuThemeData(
                //   color: Colors.black,
                // ),
              );

  setLightMode() {
    currentTheme = ThemeData.light().copyWith(
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
          color: ThemeProvider.whiteColor,
          fontSize: 20,
        ),
        backgroundColor: lightColor,
        iconTheme: IconThemeData(color: whiteColor),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: lightColor,
        foregroundColor: whiteColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: lightColor,
        unselectedItemColor: Colors.grey,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(lightColor),
        trackColor:
            MaterialStateProperty.all(const Color.fromRGBO(35, 35, 35, 0.5)),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        backgroundColor: Colors.grey.shade200,
        textColor: lightColor,
        iconColor: lightColor,
      ),
      // popupMenuTheme: const PopupMenuThemeData(
      //   color: Colors.black,
      // ),
    );
    notifyListeners();
  }

  setDarkMode() {
    currentTheme = ThemeData.dark().copyWith(
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
          color: ThemeProvider.whiteColor,
          fontSize: 20,
        ),
        backgroundColor: lightColor,
        iconTheme: IconThemeData(color: whiteColor),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkColor,
        foregroundColor: whiteColor,
      ),
      bottomNavigationBarTheme:
          BottomNavigationBarThemeData(selectedItemColor: darkColor),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(darkColor),
        trackColor:
            MaterialStateProperty.all(const Color.fromRGBO(240, 171, 0, 0.5)),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        backgroundColor: Colors.grey.shade800,
        textColor: darkColor,
        iconColor: darkColor,
      ),
      // popupMenuTheme: const PopupMenuThemeData(
      //   color: Colors.white,
      // ),
    );
    notifyListeners();
  }
}
