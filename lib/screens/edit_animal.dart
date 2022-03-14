import 'package:flutter/material.dart';

import 'package:infonimalapp/helpers/helper.dart';
import 'package:infonimalapp/models/animal.dart';
import 'package:infonimalapp/screens/adicionar_animal.dart';

import '../info.dart';

// ignore: must_be_immutable
class EditAnimal extends StatefulWidget {
  int brinco;
  String sexo, raca, origem, dataNascimento, dataAquisicao;
  double preco, peso;
  EditAnimal(this.brinco, this.peso, this.origem, this.dataAquisicao,
      this.dataNascimento, this.raca, this.sexo, this.preco);

  @override
  EditAnimalState createState() => EditAnimalState();
}

class EditAnimalState extends State<EditAnimal> {
  late int brinco;
  late String sexo, raca, origem, dataNascimento, dataAquisicao;
  late double preco, peso;

  bool change = false;

  DateTime? dateTimeAquisicao;
  DateTime? dateTimeNascimento;

  AdicionarAnimalState aa = AdicionarAnimalState();
  DatabaseHelper db = DatabaseHelper();

  //chave para validação de campos
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //listas das opções dos dropdownbuttonsa
  List<String> racas = <String>['Dorper', 'Santa Inês', 'Texel'];
  List<String> origens = <String>['Comprada', 'Reprodução'];
  List<String> sexos = <String>['Macho', 'Fêmea'];

  @override
  void initState() {
    super.initState();
    brinco = widget.brinco;
    peso = widget.peso;
    origem = widget.origem;
    dataAquisicao = widget.dataAquisicao;
    dataNascimento = widget.dataNascimento;
    raca = widget.raca;
    sexo = widget.sexo;
    preco = widget.preco;

    change = false;
  }

  void validate() {
    if (formKey.currentState!.validate()) {
      print("validated");
    } else {
      print("not validated");
    }
  }

  void setBrinco(brinco) {
    this.brinco = brinco;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(raca + " " + sexo),
        centerTitle: true,
        backgroundColor: Colors.red.shade900,
        actions: [info(context, infoEdit)],
      ),
      body: Container(
        child: Form(
          //autovalidateMode: AutovalidateMode.always,
          key: formKey,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            readOnly: true,
                            style: TextStyle(fontSize: 20),
                            controller: TextEditingController(text: '$brinco'),
                            decoration: InputDecoration(
                                labelText: 'Brinco',
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: TextStyle(color: Colors.black),
                                errorStyle: TextStyle(color: Colors.red),
                                border: OutlineInputBorder(),
                                hintText: ("Brinco"),
                                prefixIcon: Icon(Icons.local_offer)),
                          ),
                        ),
                        Text(' '),
                        Flexible(
                          child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Valor Inválido";
                                } else if (int.parse(value) <= 0) {
                                  return "Peso não pode ser 0";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {
                                if (value != '') {
                                  peso = double.parse(value);
                                  change = true;
                                }
                              },
                              controller: TextEditingController(text: '$peso'),
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
                    SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        prefixIcon: sexo == "Macho"
                            ? Icon(Icons.male, color: Colors.blue)
                            : Icon(Icons.female, color: Colors.pink),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(5.0),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          sexo = value!;
                          change = true;
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
                          change = true;
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
                            ? Icon(Icons.star, color: Colors.orange)
                            : Icon(Icons.attach_money_rounded,
                                color: Colors.green),
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
                          change = true;
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
                            } else if (double.parse(value) <= 0) {
                              return "Não pode ser 0";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            if (value != '') {
                              preco = double.parse(value);
                              change = true;
                            }
                          },
                          style: TextStyle(fontSize: 20),
                          controller: TextEditingController(text: '$preco'),
                          decoration: InputDecoration(
                              filled: true,
                              errorStyle: TextStyle(color: Colors.red),
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              hintText: ("Digite o preço do animal"),
                              prefixIcon: Icon(Icons.attach_money_rounded,
                                  color: Colors.green)),
                          keyboardType: TextInputType.number),
                    SizedBox(height: 5),
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
                                    lastDate: DateTime(2040))
                                .then((date) {
                              setState(() {
                                change = true;
                                dateTimeAquisicao = date;
                              });
                            });
                          },
                          icon: Icon(Icons.date_range),
                          label: Text(
                            dateTimeAquisicao == null
                                ? 'Nova data de aquisição'
                                : 'Aquisição: ' +
                                    aa.dataCertas(dateTimeAquisicao.toString()),
                            style: TextStyle(fontSize: 18),
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
                                ? MaterialStateProperty.all(Colors.red.shade700)
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
                              change = true;
                              dateTimeNascimento = date;
                            });
                          });
                        },
                        icon: Icon(Icons.date_range),
                        label: Text(
                          dateTimeNascimento == null
                              ? 'Nova data de nascimento'
                              : 'Nasceu: ' +
                                  aa.dataCertas(dateTimeNascimento.toString()),
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade600,
        onPressed: () {
          if (origem == 'Comprada' && dataAquisicao == '') {
            dataAquisicao = aa.dataCertas(dateTimeAquisicao.toString());
          } else {
            dataAquisicao = widget.dataAquisicao;
          }

          if (origem == 'Reprodução') {
            dataAquisicao = '';
          }

          if (dateTimeNascimento != null) {
            dataNascimento = aa.dataCertas(dateTimeNascimento.toString());
          } else {
            dataNascimento = widget.dataNascimento;
          }

          Animal a = new Animal(brinco, peso, origem, dataAquisicao,
              dataNascimento, raca, sexo, preco);
          String alert;

          if (change) {
            alert = 'Animal modificado';
          } else {
            alert = 'Nada mudou';
          }

          final sb =
              SnackBar(content: Text('$alert'), duration: Duration(seconds: 2));
          ScaffoldMessenger.of(context).showSnackBar(sb);

          Navigator.pop(context, a);
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
