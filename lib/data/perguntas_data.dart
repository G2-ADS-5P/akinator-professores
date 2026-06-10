import '../models/pergunta_model.dart';

/// Banco de perguntas neutras do jogo.
///
/// Regras seguidas por todas as perguntas:
/// - nunca citam nomes de professores;
/// - são respeitosas e observáveis;
/// - tratam apenas de metodologia, recursos didáticos,
///   áreas de conhecimento ou características neutras.
class PerguntasData {
  static const areaPratica = PerguntaModel(
    id: 'area_pratica',
    texto:
        'Esse professor costuma usar muitos exemplos práticos durante a aula?',
    categoria: 'metodologia',
  );

  static const programacao = PerguntaModel(
    id: 'programacao',
    texto:
        'Esse professor costuma trabalhar com programação ou desenvolvimento de sistemas?',
    categoria: 'area',
  );

  static const codigoPratico = PerguntaModel(
    id: 'codigo_pratico',
    texto:
        'Esse professor costuma demonstrar código, comandos ou sistemas na prática?',
    categoria: 'pratica',
  );

  static const bancoDados = PerguntaModel(
    id: 'banco_dados',
    texto: 'Esse professor costuma trabalhar com banco de dados?',
    categoria: 'area',
  );

  static const laboratorio = PerguntaModel(
    id: 'laboratorio',
    texto: 'Esse professor costuma propor atividades em laboratório?',
    categoria: 'metodologia',
  );

  static const slides = PerguntaModel(
    id: 'slides',
    texto: 'Esse professor costuma usar slides com frequência?',
    categoria: 'recurso',
  );

  static const quadro = PerguntaModel(
    id: 'quadro',
    texto: 'Esse professor costuma escrever bastante no quadro?',
    categoria: 'recurso',
  );

  static const mercado = PerguntaModel(
    id: 'mercado',
    texto:
        'Esse professor costuma relacionar o conteúdo com o mercado de trabalho?',
    categoria: 'metodologia',
  );

  static const projetos = PerguntaModel(
    id: 'projetos',
    texto:
        'Esse professor costuma trabalhar com projetos ou entregas práticas?',
    categoria: 'metodologia',
  );

  static const organizacao = PerguntaModel(
    id: 'organizacao',
    texto:
        'Esse professor costuma cobrar organização nos trabalhos e atividades?',
    categoria: 'metodologia',
  );

  static const diagramas = PerguntaModel(
    id: 'diagramas',
    texto:
        'Esse professor costuma usar diagramas ou modelagens para explicar o conteúdo?',
    categoria: 'recurso',
  );

  static const passoAPasso = PerguntaModel(
    id: 'passo_a_passo',
    texto: 'Esse professor costuma explicar o conteúdo passo a passo?',
    categoria: 'metodologia',
  );

  static const exercicios = PerguntaModel(
    id: 'exercicios',
    texto: 'Esse professor costuma resolver exercícios junto com a turma?',
    categoria: 'metodologia',
  );

  static const gestao = PerguntaModel(
    id: 'gestao',
    texto:
        'Esse professor costuma abordar temas de gestão, análise ou planejamento de sistemas?',
    categoria: 'area',
  );

  static const ferramentas = PerguntaModel(
    id: 'ferramentas',
    texto:
        'Esse professor costuma usar ferramentas como IDE, terminal ou Git durante a aula?',
    categoria: 'recurso',
  );

  static const trabalhoGrupo = PerguntaModel(
    id: 'trabalho_grupo',
    texto: 'Esse professor costuma propor atividades em grupo?',
    categoria: 'metodologia',
  );

  /// Lista completa, usada para sortear perguntas neutras de fallback
  /// e para validar que não há repetição.
  static const List<PerguntaModel> todas = [
    areaPratica,
    programacao,
    codigoPratico,
    bancoDados,
    laboratorio,
    slides,
    quadro,
    mercado,
    projetos,
    organizacao,
    diagramas,
    passoAPasso,
    exercicios,
    gestao,
    ferramentas,
    trabalhoGrupo,
  ];
}
