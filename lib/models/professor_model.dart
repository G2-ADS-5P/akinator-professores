/// Representa um candidato (professor) do jogo.
///
/// Durante o MVP os candidatos são fictícios (Professor 1, 2 e 3).
/// Os dados reais serão cadastrados somente na etapa final do projeto.
class ProfessorModel {
  final String id;
  final String nome;
  double pontos;

  ProfessorModel({required this.id, required this.nome, this.pontos = 0});

  void resetarPontos() {
    pontos = 0;
  }

  ProfessorModel copyWith({String? id, String? nome, double? pontos}) {
    return ProfessorModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      pontos: pontos ?? this.pontos,
    );
  }
}
