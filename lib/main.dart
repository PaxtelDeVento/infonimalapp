import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:infonimalapp/app_widget.dart';
import 'package:infonimalapp/screens/adicionar_animal.dart';
import 'package:infonimalapp/screens/tabela.dart';
import 'package:infonimalapp/screens/graficos.dart';
import 'package:infonimalapp/screens/home_page.dart';
import 'package:infonimalapp/screens/lista_animais.dart';

import 'app_widget.dart';

void main() {
  runApp(MaterialApp(
    localizationsDelegates: [
      GlobalWidgetsLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
    ],
    supportedLocales: [Locale("pt", "BR")],
    debugShowCheckedModeBanner: false,
    home: AppWidget(),
  ));
}

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int currentIndex = 2;
  final screens = [
    ListaAnimais(),
    AdicionarAnimal(),
    HomePage(),
    Graficos(),
    Tabela(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          selectedItemColor: Colors.black,
          selectedFontSize: 15,
          selectedIconTheme: IconThemeData(size: 40),
          unselectedIconTheme: IconThemeData(size: 30),
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          items: [
            BottomNavigationBarItem(
                icon: currentIndex == 0
                    ? Icon(Icons.list, color: Colors.red)
                    : Icon(Icons.list, color: Colors.white),
                label: 'Animais',
                backgroundColor: Colors.grey[700]),
            BottomNavigationBarItem(
                icon: currentIndex == 1
                    ? Icon(Icons.add, color: Colors.green)
                    : Icon(Icons.add, color: Colors.white),
                label: 'Novo',
                backgroundColor: Colors.grey[700]),
            BottomNavigationBarItem(
                icon: currentIndex == 2
                    ? Icon(Icons.home, color: Colors.orange)
                    : Icon(Icons.home, color: Colors.white),
                label: 'Início',
                backgroundColor: Colors.grey[700]),
            BottomNavigationBarItem(
                icon: currentIndex == 3
                    ? Icon(Icons.pie_chart, color: Colors.blue)
                    : Icon(Icons.pie_chart, color: Colors.white),
                label: 'Gráficos',
                backgroundColor: Colors.grey[700]),
            BottomNavigationBarItem(
                icon: currentIndex == 4
                    ? Icon(Icons.table_chart, color: Colors.purple)
                    : Icon(Icons.table_chart, color: Colors.white),
                label: 'Tabela',
                backgroundColor: Colors.grey[700])
          ],
        ));
  }
}

BoxDecoration animais() {
  return new BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF00D0E1), Color(0xFF00B3FA)],
      begin: Alignment.topLeft,
      end: Alignment.topRight,
      stops: [0.0, 0.8],
      tileMode: TileMode.clamp,
    ),
  );
}
