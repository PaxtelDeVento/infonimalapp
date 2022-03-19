import 'package:flutter/material.dart';
import 'package:infonimalapp/helpers/helperVivos.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../info.dart';

class Graficos extends StatefulWidget {
  @override
  _GraficosState createState() => _GraficosState();
}

class _GraficosState extends State<Graficos> {
  int? n = 0;

  int? machos = 0;
  int? femeas = 0;

  int? compra = 0;
  int? nasc = 0;

  int? dorper = 0;
  int? santa = 0;
  int? texel = 0;

  DatabaseHelper db = DatabaseHelper();

  late List<Sexo> chartDataSexo = <Sexo>[];
  late List<Raca> chartDataRaca = <Raca>[];
  late List<Origem> chartDataOrigem = <Origem>[];

  @override
  void initState() {
    super.initState();

    db.getAnimais().then((lista) {
      setState(() {
        n = lista.length;
      });
    });

    //definir os sexos
    Future.delayed(Duration.zero).then((value) async {
      await db.getMachos().then((x) async {
        setState(() {
          machos = x;
        });
        await db.getFemeas().then((x) {
          setState(() {
            femeas = x;
          });
          chartDataSexo = getChartDataSexo();
        });
      });
    });

    //definir as raças
    Future.delayed(Duration.zero).then((value) async {
      await db.getDorper().then((x) async {
        setState(() {
          dorper = x;
        });
        await db.getSanta().then((x) async {
          setState(() {
            santa = x;
          });
          await db.getTexel().then((x) {
            setState(() {
              texel = x;
            });
            chartDataRaca = getChartDataRaca();
          });
        });
      });
    });

    //definir as origens
    Future.delayed(Duration.zero).then((value) async {
      await db.getCompra().then((x) async {
        setState(() {
          compra = x;
        });
        await db.getNasc().then((x) {
          setState(() {
            nasc = x;
          });
          chartDataOrigem = getChartDataOrigem();
        });
      });
    });
  }

  List<Sexo> getChartDataSexo() {
    final List<Sexo> chartDataSexo = [
      Sexo('Machos', machos, Color(0xFF0052FF)),
      Sexo('Fêmeas', femeas, Color(0xFFEF71FF))
    ];
    return chartDataSexo;
  }

  List<Raca> getChartDataRaca() {
    final List<Raca> chartDataRaca = [
      Raca('Dorper', dorper, Color(0xFFff0000)),
      Raca('Santa Inês', santa, Color(0xFF000dff)),
      Raca('Texel', texel, Color(0xFF0a8501))
    ];
    return chartDataRaca;
  }

  List<Origem> getChartDataOrigem() {
    final List<Origem> chartDataOrigem = [
      Origem('Compradas', compra, Color(0xFFFFee00)),
      Origem('Reprodução', nasc, Color(0xFFFF9800))
    ];
    return chartDataOrigem;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Gráficos'),
          centerTitle: true,
          actions: [info(context, infoGraficos)],
          bottom: TabBar(
            indicatorColor: Colors.black,
            indicatorWeight: 5,
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(
                text: 'Sexo',
                icon: Icon(Icons.male),
              ),
              Tab(
                text: 'Raça',
                icon: Icon(Icons.animation),
              ),
              Tab(
                text: 'Origem',
                icon: Icon(Icons.star),
              )
            ],
          ),
        ),
        body: n == 0
            ? vazio()
            : TabBarView(children: [
                SfCircularChart(
                  title: ChartTitle(text: 'Divisão de sexos \n do rebanho'),
                  legend: Legend(
                      isVisible: true,
                      overflowMode: LegendItemOverflowMode.wrap),
                  series: <CircularSeries>[
                    PieSeries<Sexo, String>(
                        dataSource: chartDataSexo,
                        xValueMapper: (Sexo data, _) => data.sexo,
                        yValueMapper: (Sexo data, _) => data.n,
                        dataLabelSettings: DataLabelSettings(
                          connectorLineSettings: ConnectorLineSettings(
                              width: 2, type: ConnectorType.line),
                          isVisible: true,
                          showZeroValue: false,
                        ),
                        enableTooltip: true,
                        pointColorMapper: (Sexo data, _) => data.cor)
                  ],
                ),
                SfCircularChart(
                  title: ChartTitle(text: 'Divisão de raças \n do rebanho'),
                  legend: Legend(
                      isVisible: true,
                      overflowMode: LegendItemOverflowMode.wrap),
                  series: <CircularSeries>[
                    PieSeries<Raca, String>(
                        dataSource: chartDataRaca,
                        xValueMapper: (Raca data, _) => data.raca,
                        yValueMapper: (Raca data, _) => data.n,
                        dataLabelSettings: DataLabelSettings(
                          connectorLineSettings: ConnectorLineSettings(
                              width: 2, type: ConnectorType.line),
                          isVisible: true,
                          showZeroValue: false,
                        ),
                        enableTooltip: true,
                        pointColorMapper: (Raca data, _) => data.cor)
                  ],
                ),
                SfCircularChart(
                  title: ChartTitle(text: 'Divisão de origens \n do rebanho'),
                  legend: Legend(
                      isVisible: true,
                      overflowMode: LegendItemOverflowMode.wrap),
                  series: <CircularSeries>[
                    PieSeries<Origem, String>(
                        dataSource: chartDataOrigem,
                        xValueMapper: (Origem data, _) => data.origem,
                        yValueMapper: (Origem data, _) => data.n,
                        dataLabelSettings: DataLabelSettings(
                          connectorLineSettings: ConnectorLineSettings(
                              width: 2, type: ConnectorType.line),
                          isVisible: true,
                          showZeroValue: false,
                        ),
                        enableTooltip: true,
                        pointColorMapper: (Origem data, _) => data.cor)
                  ],
                ),
              ]),
      ),
    );
  }
}

class Sexo {
  late final String sexo;
  late final int? n;
  late final Color cor;
  Sexo(this.sexo, this.n, this.cor);
}

class Origem {
  late final String origem;
  late final int? n;
  late final Color cor;
  Origem(this.origem, this.n, this.cor);
}

class Raca {
  late final String raca;
  late final int? n;
  late final Color cor;
  Raca(this.raca, this.n, this.cor);
}
