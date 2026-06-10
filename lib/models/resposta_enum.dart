/// As cinco respostas obrigatórias do jogo.
enum RespostaEnum { sim, nao, naoSei, provavelmenteSim, provavelmenteNao }

/// Texto exibido na interface para cada resposta.
extension RespostaEnumLabel on RespostaEnum {
  String get label {
    if (this == RespostaEnum.sim) {
      return 'Sim';
    } else if (this == RespostaEnum.nao) {
      return 'Não';
    } else if (this == RespostaEnum.naoSei) {
      return 'Não sei';
    } else if (this == RespostaEnum.provavelmenteSim) {
      return 'Provavelmente sim';
    } else {
      return 'Provavelmente não';
    }
  }
}
