class AppuntamentoObj {

  String giorno;
  String mese;
  String anno;
  String giornoSettimana;
  String orario;


  AppuntamentoObj(this.giorno, this.mese,this.anno,this.giornoSettimana, this.orario) {}



  Map<String, dynamic> toJson() {
    return {
      'giorno': this.giorno,
      'mese': this.mese,
      'anno': this.anno,
      'giornoSettimana': this.giornoSettimana,
      'orario': this.orario,
    };
  }

  String toString() {
    return "Giorno: " + this.giorno+ "GiornoSettimana: " + this.giornoSettimana + ", Mese: " + this.mese + "Anno: " + this.anno + ", Orario: " + this.orario;
  }
}
