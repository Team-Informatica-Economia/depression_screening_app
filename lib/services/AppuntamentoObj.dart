class AppuntamentoObj {

  String giorno;
  String orario;


  AppuntamentoObj(this.giorno, this.orario) {}



  Map<String, dynamic> toJson() {
    return {
      'giorno': this.giorno,
      'orario': this.orario,
    };
  }

  String toString() {
    return "Giorno: " + this.giorno + ", Orario: " + this.orario;
  }
}
