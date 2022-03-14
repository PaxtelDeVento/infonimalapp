import 'package:flutter/material.dart';

IconButton info(context, text) {
  return IconButton(
    onPressed: () {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Row(children: [
            Image.asset('assets/images/confusedsheep.png',
                width: 60, height: 60),
            Text(
              'O QUE É ESTA TELA?',
              style: TextStyle(fontSize: 17),
              textAlign: TextAlign.justify,
            )
          ]),
          content: Text(
            text,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 20),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("ENTENDI"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
    icon: Icon(Icons.info),
  );
}

Center vazio() {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Nenhum animal foi cadastrado ainda \n    Clique em novo para adicioná-los',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Image.asset('assets/images/confusedsheep.png', width: 60, height: 60),
      ],
    ),
  );
}

Center vazioObito() {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Nenhum óbito registrado',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Image.asset('assets/images/happysheep.png', width: 60, height: 60),
      ],
    ),
  );
}

String infoLista =
    'Esta tela é responsável por mostras todos os animais adicionados e suas informações, com as opções de remover o animal individualmente (por óbito ou erro de brinco) e editar suas informações';

String infoAdicionar =
    'Esta tela é responsável por fazer o cadastro de novos animais do rebanho,onde é necessário informar o número do seu brinco, peso, seu sexo, sua raça, sua origem (se ela veio de reprodução ou foi comprada, e seu valor e data de aquisição caso tenha sido comprada), e a data de nascimento do animal';

String infoInicio =
    'Esta tela é o início do aplicativo, onde poderá ver algumas informações mais resumidaos sobre o rebanho ao todo';

String infoGraficos =
    'Esta tela é onde os gráficos são mantidos, para apresentar informações de maneira mais simples e eficaz';

String infoTabela =
    'Esta tela é onde os dados mais importantes são apresentados da maneira mais resumido e direta possível, para ver o rebanho ao todo individulamente e também podem ser ordenados por ordem alfabética ou numérica ao clicar nas colunas';

String infoEdit =
    'Esta tela é onde os dados do animal selecionado serão editados, apenas alteres os dados que deseja e clique no botão para salvar os dados, caso não queira modificar nada, clique novamente sem alterar nenhum dos campos ou apenas em cancelar';
