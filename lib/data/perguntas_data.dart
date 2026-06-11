import '../models/pergunta_model.dart';

/// Banco de perguntas neutras do jogo, criadas a partir das
/// informações oficiais dos professores.
///
/// Regras éticas seguidas por todas as perguntas:
/// - nunca citam nomes de professores;
/// - são respeitosas, neutras e observáveis;
/// - tratam apenas de áreas de conhecimento, metodologia,
///   recursos didáticos ou características neutras (óculos,
///   estilo de roupa);
/// - nada sobre peso, altura, corpo, idade ou personalidade.
class PerguntasData {
  // ----------------------- Áreas técnicas -----------------------

  static const programacao = PerguntaModel(
    id: 'programacao',
    texto:
        'Esse professor costuma trabalhar com programação ou desenvolvimento de software?',
    categoria: 'area',
  );

  static const web = PerguntaModel(
    id: 'web',
    texto:
        'Esse professor costuma trabalhar com desenvolvimento de sites ou aplicações web?',
    categoria: 'area',
  );

  static const javascript = PerguntaModel(
    id: 'javascript',
    texto:
        'Esse professor costuma trabalhar com JavaScript, UX/UI ou interfaces dinâmicas?',
    categoria: 'area',
  );

  static const bancoDados = PerguntaModel(
    id: 'banco_dados',
    texto: 'Esse professor costuma trabalhar com banco de dados?',
    categoria: 'area',
  );

  static const mobile = PerguntaModel(
    id: 'mobile',
    texto:
        'Esse professor costuma trabalhar com desenvolvimento de aplicativos mobile?',
    categoria: 'area',
  );

  static const cCpp = PerguntaModel(
    id: 'c_cpp',
    texto: 'Esse professor costuma ensinar linguagens como C ou C++?',
    categoria: 'area',
  );

  static const pooUml = PerguntaModel(
    id: 'poo_uml',
    texto:
        'Esse professor costuma trabalhar com orientação a objetos (POO) ou diagramas UML?',
    categoria: 'area',
  );

  static const ia = PerguntaModel(
    id: 'ia',
    texto:
        'Esse professor costuma falar sobre inteligência artificial nas aulas?',
    categoria: 'area',
  );

  static const redesInfra = PerguntaModel(
    id: 'redes_infra',
    texto: 'Esse professor costuma trabalhar com redes ou infraestrutura?',
    categoria: 'area',
  );

  static const hardware = PerguntaModel(
    id: 'hardware',
    texto:
        'Esse professor costuma trabalhar com hardware, manutenção de computadores ou Arduino?',
    categoria: 'area',
  );

  static const versionamentoSeg = PerguntaModel(
    id: 'versionamento_seg',
    texto:
        'Esse professor costuma ensinar versionamento (Git), virtualização ou segurança?',
    categoria: 'area',
  );

  // ------------------- Metodologia e disciplina -------------------

  static const agil = PerguntaModel(
    id: 'agil',
    texto:
        'Esse professor costuma ensinar metodologias ágeis, como Scrum e Kanban?',
    categoria: 'metodologia',
  );

  static const testes = PerguntaModel(
    id: 'testes',
    texto: 'Esse professor costuma trabalhar com testes de software?',
    categoria: 'area',
  );

  static const requisitos = PerguntaModel(
    id: 'requisitos',
    texto:
        'Esse professor costuma trabalhar com levantamento e documentação de requisitos?',
    categoria: 'area',
  );

  static const empreendedorismo = PerguntaModel(
    id: 'empreendedorismo',
    texto:
        'Esse professor costuma abordar temas de empreendedorismo e negócios?',
    categoria: 'area',
  );

  static const ingles = PerguntaModel(
    id: 'ingles',
    texto: 'Esse professor costuma ministrar as aulas em inglês?',
    categoria: 'metodologia',
  );

  static const projetoIntegrador = PerguntaModel(
    id: 'projeto_integrador',
    texto: 'Esse professor costuma orientar o Projeto Integrador (PI)?',
    categoria: 'metodologia',
  );

  // ----------- Características neutras e observáveis -----------

  static const oculos = PerguntaModel(
    id: 'oculos',
    texto: 'Esse professor usa óculos?',
    categoria: 'aparencia',
  );

  static const estiloFormal = PerguntaModel(
    id: 'estilo_formal',
    texto:
        'Esse professor costuma usar roupas mais formais, como camisa social?',
    categoria: 'aparencia',
  );

  static const visualAlternativo = PerguntaModel(
    id: 'visual_alternativo',
    texto:
        'Esse professor tem um visual marcante, como cabelo colorido ou tatuagens?',
    categoria: 'aparencia',
  );

  static const careca = PerguntaModel(
    id: 'careca',
    texto: 'Esse professor tem o cabelo raspado ou é careca?',
    categoria: 'aparencia',
  );

  static const animadoAula = PerguntaModel(
    id: 'animado_aula',
    texto:
        'Esse professor costuma ser bastante animado e enérgico durante as aulas?',
    categoria: 'metodologia',
  );

  static const coordenador = PerguntaModel(
    id: 'coordenador',
    texto: 'Esse professor é coordenador do curso?',
    categoria: 'metodologia',
  );

  static const lecionaIa = PerguntaModel(
    id: 'leciona_ia',
    texto:
        'Esse professor é o responsável pela disciplina de Inteligência Artificial ou Tecnologias Emergentes?',
    categoria: 'area',
  );

  static const alto = PerguntaModel(
    id: 'alto',
    texto: 'Esse professor é visivelmente mais alto do que a maioria dos alunos?',
    categoria: 'aparencia',
  );

  static const loiro = PerguntaModel(
    id: 'loiro',
    texto: 'Esse professor tem o cabelo loiro?',
    categoria: 'aparencia',
  );

  /// Lista completa, em ordem de prioridade para o fallback
  /// (perguntas mais abrangentes primeiro).
  static const List<PerguntaModel> todas = [
    programacao,
    agil,
    oculos,
    careca,
    loiro,
    alto,
    estiloFormal,
    web,
    cCpp,
    pooUml,
    redesInfra,
    versionamentoSeg,
    projetoIntegrador,
    ia,
    bancoDados,
    javascript,
    mobile,
    hardware,
    testes,
    requisitos,
    empreendedorismo,
    ingles,
    visualAlternativo,
    animadoAula,
    coordenador,
    lecionaIa,
  ];
}
