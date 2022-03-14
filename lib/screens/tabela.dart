import 'package:flutter/material.dart';
import 'package:infonimalapp/helpers/helper.dart';
import 'package:infonimalapp/helpers/helperObito.dart';
import 'package:infonimalapp/models/animal.dart';

import '../info.dart';

class Tabela extends StatefulWidget {
  const Tabela({Key? key}) : super(key: key);

  @override
  TabelaState createState() => TabelaState();
}

class TabelaState extends State<Tabela> {
  final columns = [
    'Brinco',
    'Raça',
    'Nascimento',
    'Peso',
    'Sexo',
  ];
  final columns2 = [
    'Brinco',
    'Raça',
    'Óbito',
    'Peso',
    'Sexo',
  ];

  int? sortColumnIndex;
  bool isAscending = false;

  DatabaseHelper db = DatabaseHelper();
  DatabaseHelperObito dbo = DatabaseHelperObito();

  List<Animal> animais = <Animal>[];
  List<Animal> animaisO = <Animal>[];

  void initState() {
    super.initState();

    db.initializeDatabase();

    getVivos();
    getObito();
  }

  void getVivos() {
    db.getAnimais().then((lista) {
      setState(() {
        animais = lista;
      });
    });
  }

  void getObito() {
    dbo.getAnimais().then((lista) {
      setState(() {
        animaisO = lista;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple.shade600,
          title: Text('Seus animais'),
          centerTitle: true,
          actions: [
            info(context, infoTabela),
            IconButton(
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Row(children: [
                      Image.asset('assets/images/confusedsheep.png',
                          width: 60, height: 60),
                      Text(
                        'EXCLUIR LISTA DE ÓBITOS?',
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.justify,
                      )
                    ]),
                    content: Text(
                      'Voce deseja excluir todos os registros da lista de óbito? algumas informações da tela inicial não estarão mais disponíveis',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 20),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text("CANCELAR"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                          onPressed: () {
                            DatabaseHelperObito dbo = DatabaseHelperObito();

                            dbo.deleteAllAnimals();
                            getObito();
                            final sb = SnackBar(
                                content: Text('Óbitos limpos'),
                                duration: Duration(seconds: 1));
                            ScaffoldMessenger.of(context).showSnackBar(sb);
                            Navigator.of(context).pop();
                          },
                          child: Text('EXCLUIR'))
                    ],
                  ),
                );
              },
              icon: Icon(Icons.delete),
            )
          ],
          bottom: TabBar(
            indicatorColor: Colors.black,
            indicatorWeight: 5,
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(
                text: 'Vivos',
                icon: Icon(Icons.star),
              ),
              Tab(text: 'Óbitos', icon: Icon(Icons.local_hospital)),
            ],
          ),
        ),
        body: TabBarView(children: [
          animais.length == 0
              ? vazio()
              : SingleChildScrollView(
                  child: DataTable(
                    sortAscending: isAscending,
                    sortColumnIndex: sortColumnIndex,
                    columns: getColumns(columns),
                    rows: getRows(animais),
                    dividerThickness: 1,
                    headingRowHeight: 40,
                    columnSpacing: 8,
                  ),
                ),
          animaisO.length == 0
              ? vazioObito()
              : SingleChildScrollView(
                  child: DataTable(
                    sortAscending: isAscending,
                    sortColumnIndex: sortColumnIndex,
                    columns: getColumns2(columns2),
                    rows: getRows2(animaisO),
                    dividerThickness: 1,
                    headingRowHeight: 40,
                    columnSpacing: 8,
                  ),
                )
        ]),
      ),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(label: Text(column), onSort: onSort))
      .toList();

  List<DataRow> getRows(List<Animal> animais) => animais.map((Animal animal) {
        final cells = [
          '   #' + animal.brinco.toString(),
          animal.raca,
          animal.dataNascimento,
          '' + animal.peso.toString() + ' Kg',
          animal.sexo,
        ];
        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      animais.sort((animal1, animal2) => compareString(
          ascending, animal1.brinco.toString(), animal2.brinco.toString()));
    } else if (columnIndex == 1) {
      animais.sort((animal1, animal2) =>
          compareString(ascending, animal1.raca, animal2.raca));
    } else if (columnIndex == 2) {
      animais.sort((animal1, animal2) => compareString(
          ascending, animal1.dataNascimento, animal2.dataNascimento));
    } else if (columnIndex == 3) {
      animais.sort((animal1, animal2) => compareString(
          ascending, animal1.peso.toString(), animal2.peso.toString()));
    } else if (columnIndex == 4) {
      animais.sort((animal1, animal2) =>
          compareString(ascending, animal1.sexo, animal2.sexo));
    }
    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  //----------------------------------------------------------------------------------------------------------------------------

  int compareString(bool ascending, String v1, String v2) =>
      ascending ? v1.compareTo(v2) : v2.compareTo(v1);

  List<DataColumn> getColumns2(List<String> columns) => columns
      .map((String column) => DataColumn(label: Text(column), onSort: onSort))
      .toList();

  List<DataRow> getRows2(List<Animal> animaisO) =>
      animaisO.map((Animal animaisO) {
        final cells = [
          '   #' + animaisO.brinco.toString(),
          animaisO.raca,
          animaisO.dataAquisicao,
          '' + animaisO.peso.toString() + ' Kg',
          animaisO.sexo,
        ];
        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells2(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  void onSort2(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      animaisO.sort((animal1, animal2) => compareString(
          ascending, animal1.brinco.toString(), animal2.brinco.toString()));
    } else if (columnIndex == 1) {
      animaisO.sort((animal1, animal2) =>
          compareString(ascending, animal1.raca, animal2.raca));
    } else if (columnIndex == 2) {
      animaisO.sort((animal1, animal2) => compareString(
          ascending, animal1.dataAquisicao, animal2.dataAquisicao));
    } else if (columnIndex == 3) {
      animaisO.sort((animal1, animal2) => compareString(
          ascending, animal1.peso.toString(), animal2.peso.toString()));
    } else if (columnIndex == 4) {
      animaisO.sort((animal1, animal2) =>
          compareString(ascending, animal1.sexo, animal2.sexo));
    }
    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }
}
