class Contato {
  int id;
  String nome;
  String email;

  Contato(this.nome, this.email);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'nome': nome, 'email': email};
    return map;
  }

  Contato.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    email = map['email'];
  }

  // não é obrigatório esse override, mas não sei no que acarreta não fazer ele
  @override
  String toString() {
    return "Contato => (id: $id, nome: $nome, email: $email)";
  }
}
