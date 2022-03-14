class Animal {
  late int brinco;
  late String sexo, raca, origem, dataNascimento, dataAquisicao;
  late double preco, peso;

  Animal(this.brinco, this.peso, this.origem, this.dataAquisicao,
      this.dataNascimento, this.raca, this.sexo, this.preco);

  //converter objeto para map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'brinco': brinco,
      'peso': peso,
      'sexo': sexo,
      'raca': raca,
      'origem': origem,
      'dataNascimento': dataNascimento,
      'dataAquisicao': dataAquisicao,
      'preco': preco
    };
    return map;
  }

  //converter map para o objeto Animal
  Animal.fromMap(Map<String, dynamic> map) {
    brinco = map['brinco'];
    peso = map['peso'];
    sexo = map['sexo'];
    raca = map['raca'];
    origem = map['origem'];
    dataNascimento = map['dataNascimento'];
    dataAquisicao = map['dataAquisicao'];
    preco = map['preco'];
  }

  @override
  String toString() {
    return '$brinco, $peso, $origem, $dataAquisicao, $dataNascimento,$raca,$sexo, $preco';
  }
}
