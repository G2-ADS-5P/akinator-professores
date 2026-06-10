import '../models/professor_model.dart';

/// ============================================================
/// DADOS PROVISÓRIOS — PONTO DE INTEGRAÇÃO FINAL
/// ============================================================
/// Os candidatos abaixo são FICTÍCIOS e existem apenas para
/// validar o fluxo do MVP (navegação, pontuação, confiança e
/// resultado). Nenhuma característica representa pessoas reais.
///
/// Quando o responsável do projeto enviar os dados oficiais:
/// 1. Substituir esta lista pelos professores reais.
/// 2. Calibrar as associações de pontuação no GameController
///    (métodos _responderXxx).
/// ============================================================
List<ProfessorModel> criarProfessores() {
  return [
    ProfessorModel(id: 'candidato_1', nome: 'Professor 1'),
    ProfessorModel(id: 'candidato_2', nome: 'Professor 2'),
    ProfessorModel(id: 'candidato_3', nome: 'Professor 3'),
  ];
}
