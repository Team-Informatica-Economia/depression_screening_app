class Users {

  String nome;
  String cognome;
  String email;

  Users(this.nome, this.cognome, this.email) {}

  Map<String, dynamic> toJson() {
    return {
      'nome': this.nome,
      'cognome': this.cognome,
      'email': this.email
    };
  }

  String toString() {
    return "Nome: " + this.nome + ", Cognome: " + this.cognome + ", Email: " + this.email;
  }
}
