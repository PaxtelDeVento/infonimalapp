import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infonimalapp/helpers/helperVivos.dart';
import 'package:infonimalapp/helpers/helperObito.dart';
import 'package:infonimalapp/info.dart';
import 'package:infonimalapp/models/animal.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int? countAnimais = 0;
  int? countAnimaisObito = 0;
  double? mediaPeso = 0;
  double? peso = 0;
  int? nasc = 0;
  int? compra = 0;
  double totalDays = 0;
  double totalDaysObito = 0;
  double mediaDays = 0;
  double mediaDaysObito = 0;

  DatabaseHelper db = DatabaseHelper();
  DatabaseHelperObito dbo = DatabaseHelperObito();

  List<Animal> animais = <Animal>[];

  @override
  void initState() {
    super.initState();

    dbo.aaa();
    db.aaa();

    //definir o número de animais na propriedade
    db.getAnimais().then((lista) {
      setState(() {
        countAnimais = lista.length;
      });
    });
    dbo.getAnimais().then((lista) {
      setState(() {
        countAnimaisObito = lista.length;
      });
    });

    //definir média dos pesos do animais
    db.getPeso().then((x) {
      setState(() {
        peso = x;
        if (peso != null) {
          mediaPeso = (peso! / countAnimais!);
        } else {
          mediaPeso = 0;
        }
      });
    });

    //definir número de animais fruto de reprodução
    db.getNasc().then((x) {
      setState(() {
        nasc = x;
      });
    });

    //definir número de animais fruto de compra
    db.getCompra().then((x) {
      setState(() {
        compra = x;
      });
    });

    //idade média dos animais vivos
    db.getAnimais().then((lista) {
      setState(() {
        for (var i = 0; i < lista.length; i++) {
          String dia = lista[i].dataNascimento.substring(0, 2);
          String mes = lista[i].dataNascimento.substring(3, 5);
          String ano = lista[i].dataNascimento.substring(6, 10);
          totalDays += diffDatas(ano, mes, dia);
        }
        if (totalDays > 0) {
          mediaDays = (totalDays / countAnimais!);
        }
      });
    });

    //idade médias dos animais mortos
    dbo.getAnimais().then((lista) {
      setState(() {
        for (var i = 0; i < lista.length; i++) {
          String dia = lista[i].dataNascimento.substring(0, 2);
          String mes = lista[i].dataNascimento.substring(3, 5);
          String ano = lista[i].dataNascimento.substring(6, 10);

          String diaO = lista[i].dataAquisicao.substring(0, 2);
          String mesO = lista[i].dataAquisicao.substring(3, 5);
          String anoO = lista[i].dataAquisicao.substring(6, 10);
          totalDaysObito += diffDatasObito(ano, mes, dia, anoO, mesO, diaO);
        }

        if (totalDaysObito > 0) {
          mediaDaysObito = (totalDaysObito / countAnimaisObito!);
        }
      });
    });
  }

  int diffDatasObito(String ano, String mes, String dia, String anoO,
      String mesO, String diaO) {
    final obito = DateTime(int.parse(ano), int.parse(mes), int.parse(dia));
    final nasc = DateTime(int.parse(anoO), int.parse(mesO), int.parse(diaO));

    print(nasc);
    print(obito);
    final diff = nasc.difference(obito).inDays;

    return diff;
  }

  int diffDatas(String ano, String mes, String dia) {
    final nasc = DateTime(int.parse(ano), int.parse(mes), int.parse(dia));
    final today = DateTime.now();
    final diff = today.difference(nasc).inDays;

    return diff;
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Seja Bem-Vindo'),
        centerTitle: true,
        actions: [info(context, infoInicio)],
      ),
      body: Container(
        color: Colors.grey[800],
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  color: Colors.orange,
                  height: 120,
                  width: deviceWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "NÚMERO TOTAL DE ANIMAIS NA PROPRIEDADE",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '$countAnimais',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 50),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.green.shade900,
                            Colors.green.shade400
                          ])),
                  height: 190,
                  width: 190,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "PESO MÉDIO DOS ANIMAIS",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25),
                      ),
                      Text(
                        mediaPeso == 0
                            ? '0 Kg'
                            : mediaPeso!.toStringAsFixed(1) + ' Kg',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 50),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.green.shade900,
                            Colors.green.shade400
                          ])),
                  height: 190,
                  width: 190,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "IDADE MÉDIA DOS ANIMAIS",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25),
                      ),
                      Text(
                        mediaDays == 0
                            ? '0d'
                            : mediaDays.toStringAsFixed(0) + 'd',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 50),
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.grey.shade800,
                            Colors.grey.shade400
                          ])),
                  height: 190,
                  width: 190,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "IDADE MÉDIA DE ÓBITO",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 23),
                      ),
                      Text(
                        mediaDaysObito == 0
                            ? '0d'
                            : mediaDaysObito.toStringAsFixed(0) + 'd',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 50),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.grey.shade800,
                            Colors.grey.shade400
                          ])),
                  height: 190,
                  width: 190,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "ÓBITOS",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 23),
                      ),
                      Text(
                        "$countAnimaisObito",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 50),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.green.shade900,
                            Colors.green.shade400
                          ])),
                  height: 190,
                  width: 190,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "NASCIMENTOS",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25),
                      ),
                      Text(
                        "$nasc",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 50),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.green.shade900,
                            Colors.green.shade400
                          ])),
                  height: 190,
                  width: 190,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "COMPRADAS",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25),
                      ),
                      Text(
                        "$compra",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 50),
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
