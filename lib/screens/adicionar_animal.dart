import 'package:flutter/material.dart';
import 'package:infonimalapp/helpers/helperVivos.dart';
import 'package:infonimalapp/models/animal.dart';

import '../info.dart';

class AdicionarAnimal extends StatefulWidget {
  @override
  AdicionarAnimalState createState() => AdicionarAnimalState();
}

class AdicionarAnimalState extends State<AdicionarAnimal> {
  DatabaseHelper db = DatabaseHelper();

  String alert = 'Esse campo não pode ser vazio!';

  int brinco = 0;
  double peso = 0;
  double preco = 0;
  String raca = 'Dorper';
  String origem = 'Reprodução';
  String sexo = 'Macho';
  DateTime? dateTimeAquisicao;
  DateTime? dateTimeNascimento;
  bool valid1 = false;
  bool valid2 = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<String> racas = <String>['Dorper', 'Santa Inês', 'Texel'];

  List<String> origens = <String>['Comprada', 'Reprodução'];

  List<String> sexos = <String>['Macho', 'Fêmea'];

  List<Animal> animais = <Animal>[];

  void validate() {
    if (formKey.currentState!.validate()) {
      print("validated");
    } else {
      print("not validated");
    }
  }

  @override
  void initState() {
    super.initState();

    getAnimais();
  }

  void getAnimais() {
    db.getAnimais().then((lista) {
      setState(() {
        animais = lista;
      });
    });
  }

  bool isInt(n) {
    if (int.tryParse(n) == null) {
      return false;
    } else {
      return true;
    }
  }

  bool jaExiste(brinco) {
    for (var i = 0; i < animais.length; i++) {
      if (animais[i].brinco == brinco) {
        return true;
      }
    }
    return false;
  }

  String dataCertas(String data) {
    String dia = data.substring(8, 10);
    String mes = data.substring(5, 7);
    String ano = data.substring(0, 4);

    data = dia + "/" + mes + "/" + ano;
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        title: Text('Cadastrar nova ' + raca + ' ' + sexo),
        centerTitle: true,
        actions: [info(context, infoAdicionar)],
      ),
      body: Container(
        child: Form(
          //autovalidateMode: AutovalidateMode.always,
          key: formKey,
          child: ListView(children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Valor Inválido";
                                } else if (int.parse(value) <= 0) {
                                  return "Brinco não pode ser 0";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {
                                if (value != '') {
                                  brinco = int.parse(value);
                                }
                              },
                              style: TextStyle(fontSize: 20),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: 'Brinco',
                                  filled: true,
                                  fillColor: Colors.white,
                                  errorStyle: TextStyle(color: Colors.red),
                                  border: OutlineInputBorder(),
                                  hintText: ("Brinco"),
                                  prefixIcon: Icon(Icons.local_offer)),
                            ),
                          ),
                          Text('  '),
                          Flexible(
                            child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Valor Inválido";
                                  } else if (double.parse(value) <= 0) {
                                    return "Peso não pode ser 0";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) {
                                  if (value != '') {
                                    peso = double.parse(value);
                                  }
                                },
                                style: TextStyle(fontSize: 20),
                                decoration: InputDecoration(
                                    labelText: 'Peso',
                                    filled: true,
                                    errorStyle: TextStyle(color: Colors.red),
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    hintText: ("Peso"),
                                    prefixIcon: Icon(Icons.monitor_weight)),
                                keyboardType: TextInputType.number),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          prefixIcon: sexo == "Macho"
                              ? Icon(
                                  Icons.male,
                                  color: Colors.blue,
                                )
                              : Icon(
                                  Icons.female,
                                  color: Colors.pink,
                                ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(5.0),
                            ),
                          ),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            sexo = newValue!;
                          });
                        },
                        value: sexo,
                        items: sexos.map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(fontSize: 20),
                                ));
                          },
                        ).toList(),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.animation),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(5.0),
                            ),
                          ),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            raca = newValue!;
                          });
                        },
                        value: raca,
                        items: racas.map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(fontSize: 20),
                                ));
                          },
                        ).toList(),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          prefixIcon: origem == "Reprodução"
                              ? Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                )
                              : Icon(
                                  Icons.attach_money_rounded,
                                  color: Colors.green,
                                ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            origem = newValue!;
                          });
                        },
                        value: origem,
                        items: origens.map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if (origem != "Reprodução")
                        TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Preço não pode ser 0";
                              } else if (int.parse(value) <= 0) {
                                return "Não pode ser 0";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              if (value != '') {
                                preco = double.parse(value);
                              }
                            },
                            style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                                filled: true,
                                errorStyle: TextStyle(color: Colors.red),
                                fillColor: Colors.white,
                                border: OutlineInputBorder(),
                                hintText: ("Digite o preço do animal"),
                                prefixIcon: Icon(
                                  Icons.attach_money_rounded,
                                  color: Colors.green,
                                )),
                            keyboardType: TextInputType.number),
                      SizedBox(
                        height: 34,
                      ),
                      if (origem != "Reprodução")
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            style: ButtonStyle(
                                backgroundColor: dateTimeAquisicao == null
                                    ? MaterialStateProperty.all(
                                        Colors.red.shade700)
                                    : MaterialStateProperty.all(
                                        Colors.green.shade700)),
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2010),
                                lastDate: DateTime(2025),
                                locale: Localizations.localeOf(context),
                              ).then((date) {
                                setState(() {
                                  dateTimeAquisicao = date;
                                });
                              });
                            },
                            icon: Icon(Icons.date_range),
                            label: Text(
                              dateTimeAquisicao == null
                                  ? 'Selecionar data de aquisição'
                                  : 'Aquisição: ' +
                                      dataCertas(dateTimeAquisicao.toString()),
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor: dateTimeNascimento == null
                                  ? MaterialStateProperty.all(
                                      Colors.red.shade700)
                                  : MaterialStateProperty.all(
                                      Colors.green.shade700)),
                          onPressed: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2010),
                                    lastDate: DateTime(2040))
                                .then((date) {
                              setState(() {
                                dateTimeNascimento = date;
                              });
                            });
                          },
                          icon: Icon(Icons.date_range),
                          label: Text(
                            dateTimeNascimento == null
                                ? 'Selecionar data de nascimento'
                                : 'Nasceu: ' +
                                    dataCertas(dateTimeNascimento.toString()),
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Builder(builder: (context) {
                        return Container(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              //verificar se o brinco ja existe no banco de dados
                              if (jaExiste(brinco)) {
                                final sb = SnackBar(
                                    content: Text('Este brinco já existe'),
                                    duration: Duration(seconds: 3));
                                ScaffoldMessenger.of(context).showSnackBar(sb);
                                valid1 = false;
                              } else {
                                valid1 = true;
                              }

                              //verificar se a data de nascimento foi preenchida
                              if (dateTimeNascimento == null) {
                                final sb = SnackBar(
                                    content: Text(
                                        'Data de nascimento não preenchida'),
                                    duration: Duration(seconds: 3));
                                ScaffoldMessenger.of(context).showSnackBar(sb);
                                valid2 = false;
                              } else {
                                valid2 = true;
                              }

                              bool valid3 = true;
                              if (origem == 'Comprada') {
                                if (dateTimeAquisicao == null) {
                                  final sb = SnackBar(
                                      content: Text(
                                          'Data de aquisição não preenchida'),
                                      duration: Duration(seconds: 3));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(sb);
                                  valid3 = false;
                                } else {
                                  valid3 = true;
                                }
                              }

                              //apenas prosseguir se o brinco não existe e a data de nascimento foi preenchida
                              if (valid1 && valid2 && valid3) {
                                if (formKey.currentState!.validate()) {
                                  late String dataAquisicao;
                                  if (origem == 'Comprada') {
                                    dataAquisicao = dataCertas(
                                        dateTimeAquisicao.toString());
                                  } else {
                                    dataAquisicao = '';
                                  }

                                  String dataNascimento =
                                      dataCertas(dateTimeNascimento.toString());

                                  Animal a = Animal(
                                      brinco,
                                      peso,
                                      origem,
                                      dataAquisicao,
                                      dataNascimento,
                                      raca,
                                      sexo,
                                      preco);
                                  db.insertAnimal(a);

                                  final sb = SnackBar(
                                      content: Text('Animal Adicionado'),
                                      duration: Duration(seconds: 1));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(sb);

                                  getAnimais();
                                  if (jaExiste(brinco)) {
                                    valid1 = false;
                                  }
                                } else {
                                  final sb = SnackBar(
                                      content:
                                          Text('Existem campos incorretos'),
                                      duration: Duration(seconds: 2));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(sb);
                                }
                              }
                            },
                            icon: Icon(Icons.save),
                            label: Text(
                              'Salvar',
                              style: TextStyle(fontSize: 20),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.green.shade700),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
