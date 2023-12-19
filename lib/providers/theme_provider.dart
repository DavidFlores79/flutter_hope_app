import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData currentTheme;
  // Orange	#fd7e14
  // Yellow	#ffc107
  // Green	#28a745
  // Teal	#20c997
  static Color lightColor = const Color(0xff343434);
  static Color darkColor = const Color(0xfff0ab00);
  static Color blueColor = const Color(0xff115c99);
  static Color redColor = const Color(0xffFF0000);
  static Color lightRed = const Color(0xffD11149);
  static Color aquaBlueColor = const Color(0xff3186a0);
  static Color whiteColor = Colors.white;
  static Color greyColor = const Color(0xff808080);
  static Color greenColor = const Color(0xff28a745);
  static Color tealColor = const Color(0xff17a2b8);

  ThemeProvider({
    required isDarkmode,
    lightColor = const Color(0xff343434),
    darkColor = const Color(0xfff0ab00),
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
