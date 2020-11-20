class Messaggio {

  String messaggio;
  String isPaziente;
  String data;

  Messaggio(this.messaggio, this.isPaziente,this.data) {}

  Map<String, dynamic> toJson() {
    return {
      'messaggio': this.messaggio,
      'isPaziente': this.isPaziente,
      'data': this.data,
    };
  }

  String toString() {
    return "Messaggio: " + this.messaggio + ", isPaziente: " + this.isPaziente +", Data: "+ this.data;
  }
}
