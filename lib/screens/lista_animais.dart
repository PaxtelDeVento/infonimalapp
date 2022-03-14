import 'package:flutter/material.dart';
import 'package:infonimalapp/helpers/helper.dart';
import 'package:infonimalapp/helpers/helperObito.dart';
import 'package:infonimalapp/models/animal.dart';
import 'package:infonimalapp/screens/adicionar_animal.dart';
import 'package:infonimalapp/screens/edit_animal.dart';

import '../info.dart';

class ListaAnimais extends StatefulWidget {
  @override
  ListaAnimaisState createState() => ListaAnimaisState();
}

class ListaAnimaisState extends State<ListaAnimais> {
  DatabaseHelperObito dbo = DatabaseHelperObito();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Seus animais'),
        centerTitle: true,
        actions: [info(context, infoLista)],
      ),
      body: Container(
        child: Lista(),
      ),
    );
  }
}

class Lista extends StatefulWidget {
  @override
  ListaState createState() => ListaState();
}

class ListaState extends State<Lista> {
  String f = "Fêmea";

  List<Animal> animais = <Animal>[];
  List<Animal> animaisO = <Animal>[];
  DatabaseHelper db = DatabaseHelper();
  DatabaseHelperObito dbo = DatabaseHelperObito();
  AdicionarAnimalState aa = AdicionarAnimalState();

  @override
  void initState() {
    super.initState();

    //adicionar os regitros na lista
    formarLista();
    formarListaObito();
  }

  void formarLista() {
    db.getAnimais().then((lista) {
      setState(() {
        animais = lista;
      });
    });
  }

  void formarListaObito() {
    dbo.getAnimais().then((lista) {
      setState(() {
        animaisO = lista;
      });
    });
  }

  //cada item da lista de animais da propriedade
  @override
  Widget build(BuildContext context) {
    return animais.length == 0
        ? vazio()
        : ListView.builder(
            itemBuilder: (context, index) {
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(animais[index].raca +
                        " " +
                        animais[index].brinco.toString()),
                    subtitle: Text("Origem: " +
                        animais[index].origem +
                        "\nAquis: " +
                        animais[index].dataAquisicao +
                        "\nNasc: " +
                        animais[index].dataNascimento +
                        "\nPreço: R\$" +
                        animais[index].preco.toString() +
                        "\nPeso: " +
                        animais[index].peso.toString() +
                        'Kg'),
                    isThreeLine: true,
                    leading: Container(
                      child: animais[index].sexo == f
                          ? Icon(
                              Icons.female,
                              size: 50,
                              color: Colors.pink,
                            )
                          : Icon(
                              Icons.male,
                              size: 50,
                              color: Colors.blue,
                            ),
                    ),
                    trailing: Container(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              Animal a = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditAnimal(
                                          animais[index].brinco,
                                          animais[index].peso,
                                          animais[index].origem,
                                          animais[index].dataAquisicao,
                                          animais[index].dataNascimento,
                                          animais[index].raca,
                                          animais[index].sexo,
                                          animais[index].preco)));
                              db.updateAnimal(a);
                              formarLista();
                            },
                            icon: Icon(Icons.edit),
                            color: Colors.blue,
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Row(children: [
                                    Image.asset('assets/images/sadsheep.png',
                                        width: 60, height: 60),
                                    Text(
                                      'Porque deseja excluí-lo?',
                                      style: TextStyle(fontSize: 16),
                                    )
                                  ]),
                                  content: Text(
                                      "A ação seguinte removerá o animal para sempre (muito tempo) esta é uma ação irreversível!",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(
                                        "ÓBITO",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        String dataO = aa.dataCertas(
                                            DateTime.now().toString());
                                        Animal a = Animal(
                                            animais[index].brinco,
                                            animais[index].peso,
                                            animais[index].origem,
                                            dataO,
                                            animais[index].dataNascimento,
                                            animais[index].raca,
                                            animais[index].sexo,
                                            animais[index].preco);
                                        dbo.insertAnimal(a);
                                        db.deleteAnimal(animais[index].brinco);
                                        final sb = SnackBar(
                                            content: Text('Óbito'),
                                            duration: Duration(seconds: 1));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(sb);
                                        Navigator.of(context).pop();
                                        formarLista();
                                      },
                                    ),
                                    TextButton(
                                        child: Text('ERRADO'),
                                        onPressed: () {
                                          db.deleteAnimal(
                                              animais[index].brinco);
                                          final sb = SnackBar(
                                              content: Text('Animal Excluído'),
                                              duration: Duration(seconds: 1));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(sb);
                                          Navigator.of(context).pop();
                                          formarLista();
                                        }),
                                    TextButton(
                                      child: Text("CANCELAR"),
                                      onPressed: () {
                                        //Put your code here which you want to execute on Cancel button click.
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: animais.length,
          );
  }
}
