class Users {

  String nome;
  String cognome;
  String email;
  String statoCivile;
  String sesso;
  String scuola;
  String regione;
  String provincia;
  String eta;
  String uidPadre;


  Users(this.nome, this.cognome, this.email, this.uidPadre) {}

  Users.overloadedConstructor(String nome, String cognome, String email, String statoCivile,
      String sesso, String scuola, String regione, String provincia, String eta, String uidPadre) {
    this.nome = nome;
    this.cognome = cognome;
    this.email = email;
    this.statoCivile=statoCivile;
    this.sesso=sesso;
    this.scuola=scuola;
    this.regione=regione;
    this.provincia=provincia;
    this.eta=eta;
    this.uidPadre=uidPadre;
  }


  Map<String, dynamic> toJson() {
    return {
      'nome': this.nome,
      'cognome': this.cognome,
      'email': this.email,
      'uidPadre': this.uidPadre
    };
  }

  Map<String, dynamic> toJsonCompleto() {
    return {
      'nome': this.nome,
      'cognome': this.cognome,
      'email': this.email,
      'statoCivile':this.statoCivile,
      'sesso':this.sesso,
      'scuola':this.scuola,
      'regione':this.regione,
      'provincia':this.provincia,
      'eta':this.eta,
      'uidPadre': this.uidPadre
    };
  }

  String toString() {
    return "Nome: " + this.nome + ", Cognome: " + this.cognome + ", Email: " + this.email;
  }
}
