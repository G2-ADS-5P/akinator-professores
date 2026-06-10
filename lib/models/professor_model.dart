/// Representa um professor candidato do jogo.
///
/// O campo [foto] é opcional: enquanto a foto não for fornecida,
/// a tela de resultado exibe um avatar com as iniciais do nome.
class ProfessorModel {
  final String id;
  final String nome;
  final String? foto;
  double pontos;

  ProfessorModel({
    required this.id,
    required this.nome,
    this.foto,
    this.pontos = 0,
  });

  void resetarPontos() {
    pontos = 0;
  }

  ProfessorModel copyWith({
    String? id,
    String? nome,
    String? foto,
    double? pontos,
  }) {
    return ProfessorModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      foto: foto ?? this.foto,
      pontos: pontos ?? this.pontos,
    );
  }
}
