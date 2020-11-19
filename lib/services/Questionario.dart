class Questionario {

  String titoloPdf;
  String path;


  Questionario(this.titoloPdf, this.path) {}



  Map<String, dynamic> toJson() {
    return {
      'titoloPdf': this.titoloPdf,
      'path': this.path,
    };
  }

  String toString() {
    return "Titolo: " + this.titoloPdf + ", Path: " + this.path;
  }
}
