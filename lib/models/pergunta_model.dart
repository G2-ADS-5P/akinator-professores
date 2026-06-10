/// Representa uma pergunta neutra do jogo.
///
/// As perguntas nunca citam nomes de professores e tratam apenas de
/// metodologia, recursos didáticos, áreas de conhecimento ou
/// características neutras e observáveis.
class PerguntaModel {
  final String id;
  final String texto;
  final String categoria;

  const PerguntaModel({
    required this.id,
    required this.texto,
    required this.categoria,
  });
}
