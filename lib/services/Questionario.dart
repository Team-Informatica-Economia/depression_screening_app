class Questionario {

  String titoloPdf;
  String path;
  String punteggio;

  Questionario(this.titoloPdf, this.path, this.punteggio) {}



  Map<String, dynamic> toJson() {
    return {
      'titoloPdf': this.titoloPdf,
      'path': this.path,
      'punteggio': this.punteggio,
    };
  }

  String toString() {
    return "Titolo: " + this.titoloPdf + ", Path: " + this.path + ", Punteggio: " + this.punteggio;
  }
}
