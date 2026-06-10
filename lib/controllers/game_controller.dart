import '../data/perguntas_data.dart';
import '../data/professores_data.dart';
import '../models/pergunta_model.dart';
import '../models/professor_model.dart';
import '../models/resposta_enum.dart';

/// Controla todo o estado e a regra de uma partida.
///
/// Fluxo geral:
/// 1. [iniciarJogo] zera pontuações e define a pergunta inicial.
/// 2. [responder] usa `if / else` para identificar a pergunta atual,
///    tratar a resposta, atualizar pontuações e escolher a próxima
///    pergunta sem repetição.
/// 3. Quando retorna `null`, a partida terminou e a tela deve exibir
///    o resultado ([calcularResultado], [calcularConfianca],
///    [calcularTopTres]).
///
/// ============================================================
/// CALIBRAÇÃO
/// As associações abaixo foram montadas com base nas informações
/// oficiais enviadas pelo responsável do projeto (10/06/2026).
/// Pesos: Sim +2 | Provavelmente sim +1 | Não sei 0 |
///        Provavelmente não -1 | Não -2 (com contrapesos de ±1
///        em perguntas que separam grupos grandes).
/// ============================================================
class GameController {
  static const int limitePerguntas = 12;

  // ------------------------------------------------------------
  // Grupos de calibração (listas auxiliares permitidas pelos docs)
  // ------------------------------------------------------------

  /// Professores que trabalham diretamente com programação.
  static const idsProgramacao = [
    'prof_fabiane',
    'prof_willian',
    'prof_guilherme',
    'prof_jhoni',
    'prof_speck',
    'prof_marcos',
  ];

  /// Professores de áreas não focadas em programação.
  static const idsNaoProgramacao = [
    'prof_hiago',
    'prof_andre',
    'prof_marcel',
    'prof_renato',
    'prof_alan',
  ];

  /// Professores que usam óculos.
  static const idsUsamOculos = [
    'prof_alan',
    'prof_fabiane',
    'prof_vander',
    'prof_leticia',
  ];

  /// Professores que não usam óculos (informação confirmada).
  static const idsSemOculos = [
    'prof_hiago',
    'prof_willian',
    'prof_guilherme',
    'prof_jhoni',
    'prof_marcos',
    'prof_andre',
    'prof_renato',
    'prof_verspegel',
  ];

  /// Professores de estilo mais formal.
  static const idsEstiloFormal = ['prof_fabiane', 'prof_renato'];

  /// Professores de estilo casual (informação confirmada).
  static const idsEstiloCasual = [
    'prof_hiago',
    'prof_alan',
    'prof_willian',
    'prof_guilherme',
    'prof_jhoni',
    'prof_marcos',
    'prof_leticia',
    'prof_speck',
  ];

  final List<ProfessorModel> professores = criarProfessores();
  final List<String> perguntasRespondidas = [];

  late PerguntaModel perguntaAtual;
  int quantidadePerguntasRespondidas = 0;
  bool jogoFinalizado = false;

  GameController() {
    iniciarJogo();
  }

  /// Inicia (ou reinicia) a partida, zerando todo o estado.
  void iniciarJogo() {
    for (final professor in professores) {
      professor.resetarPontos();
    }
    perguntasRespondidas.clear();
    quantidadePerguntasRespondidas = 0;
    jogoFinalizado = false;
    perguntaAtual = PerguntasData.programacao;
  }

  /// Recebe a resposta do usuário.
  ///
  /// Retorna a próxima pergunta ou `null` quando a partida termina.
  PerguntaModel? responder(RespostaEnum resposta) {
    if (jogoFinalizado) {
      return null;
    }

    perguntasRespondidas.add(perguntaAtual.id);
    quantidadePerguntasRespondidas++;

    // Identifica a pergunta atual e trata a resposta com if / else.
    final PerguntaModel? proxima = _tratarPerguntaAtual(resposta);

    // Condições de fim de jogo: limite atingido ou sem perguntas úteis.
    if (quantidadePerguntasRespondidas >= limitePerguntas || proxima == null) {
      jogoFinalizado = true;
      return null;
    }

    perguntaAtual = proxima;
    return perguntaAtual;
  }

  /// Direciona a resposta para o método específico da pergunta atual.
  PerguntaModel? _tratarPerguntaAtual(RespostaEnum resposta) {
    if (perguntaAtual.id == 'programacao') {
      return _responderProgramacao(resposta);
    } else if (perguntaAtual.id == 'web') {
      return _responderWeb(resposta);
    } else if (perguntaAtual.id == 'javascript') {
      return _responderJavascript(resposta);
    } else if (perguntaAtual.id == 'banco_dados') {
      return _responderBancoDados(resposta);
    } else if (perguntaAtual.id == 'mobile') {
      return _responderMobile(resposta);
    } else if (perguntaAtual.id == 'c_cpp') {
      return _responderCCpp(resposta);
    } else if (perguntaAtual.id == 'poo_uml') {
      return _responderPooUml(resposta);
    } else if (perguntaAtual.id == 'ia') {
      return _responderIa(resposta);
    } else if (perguntaAtual.id == 'redes_infra') {
      return _responderRedesInfra(resposta);
    } else if (perguntaAtual.id == 'hardware') {
      return _responderHardware(resposta);
    } else if (perguntaAtual.id == 'versionamento_seg') {
      return _responderVersionamentoSeg(resposta);
    } else if (perguntaAtual.id == 'agil') {
      return _responderAgil(resposta);
    } else if (perguntaAtual.id == 'testes') {
      return _responderTestes(resposta);
    } else if (perguntaAtual.id == 'requisitos') {
      return _responderRequisitos(resposta);
    } else if (perguntaAtual.id == 'empreendedorismo') {
      return _responderEmpreendedorismo(resposta);
    } else if (perguntaAtual.id == 'ingles') {
      return _responderIngles(resposta);
    } else if (perguntaAtual.id == 'projeto_integrador') {
      return _responderProjetoIntegrador(resposta);
    } else if (perguntaAtual.id == 'oculos') {
      return _responderOculos(resposta);
    } else if (perguntaAtual.id == 'estilo_formal') {
      return _responderEstiloFormal(resposta);
    } else if (perguntaAtual.id == 'visual_alternativo') {
      return _responderVisualAlternativo(resposta);
    } else {
      return _proximaPerguntaFallback();
    }
  }

  // ------------------------------------------------------------
  // Métodos de resposta por pergunta (CALIBRAÇÃO oficial)
  // ------------------------------------------------------------

  /// Fabiane, Willian, Guilherme, Jhoni, Speck e Marcos programam.
  PerguntaModel? _responderProgramacao(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(idsProgramacao, 2);
      alterarPontuacao(idsNaoProgramacao, -1);
      return _definirProxima(PerguntasData.web);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(idsProgramacao, 1);
      return _definirProxima(PerguntasData.cCpp);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(idsProgramacao, -2);
      alterarPontuacao(idsNaoProgramacao, 1);
      return _definirProxima(PerguntasData.agil);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(idsProgramacao, -1);
      return _definirProxima(PerguntasData.requisitos);
    } else {
      // Não sei: segue para característica observável.
      return _definirProxima(PerguntasData.oculos);
    }
  }

  /// Willian (sites básicos/Django) e Guilherme (sites dinâmicos).
  PerguntaModel? _responderWeb(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['prof_willian', 'prof_guilherme'], 2);
      alterarPontuacao(['prof_fabiane', 'prof_speck'], -1);
      return _definirProxima(PerguntasData.javascript);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['prof_willian', 'prof_guilherme'], 1);
      return _definirProxima(PerguntasData.bancoDados);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['prof_willian', 'prof_guilherme'], -2);
      alterarPontuacao(['prof_fabiane', 'prof_speck'], 1);
      return _definirProxima(PerguntasData.mobile);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['prof_willian', 'prof_guilherme'], -1);
      return _definirProxima(PerguntasData.cCpp);
    } else {
      return _definirProxima(PerguntasData.oculos);
    }
  }

  /// Guilherme ama JavaScript e UX/UI; Willian foca em Python.
  PerguntaModel? _responderJavascript(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['prof_guilherme'], 2);
      alterarPontuacao(['prof_willian'], -1);
      return _definirProxima(PerguntasData.bancoDados);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['prof_guilherme'], 1);
      return _definirProxima(PerguntasData.bancoDados);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['prof_guilherme'], -2);
      alterarPontuacao(['prof_willian'], 1);
      return _definirProxima(PerguntasData.mobile);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['prof_guilherme'], -1);
      return _definirProxima(PerguntasData.mobile);
    } else {
      return _definirProxima(PerguntasData.oculos);
    }
  }

  /// Willian leciona banco de dados.
  PerguntaModel? _responderBancoDados(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['prof_willian'], 2);
      alterarPontuacao(['prof_guilherme'], -1);
      return _definirProxima(PerguntasData.oculos);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['prof_willian'], 1);
      return _definirProxima(PerguntasData.web);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['prof_willian'], -2);
      return _definirProxima(PerguntasData.mobile);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['prof_willian'], -1);
      return _definirProxima(PerguntasData.pooUml);
    } else {
      return _definirProxima(PerguntasData.cCpp);
    }
  }

  /// Jefferson Speck ensina Dart e Flutter.
  PerguntaModel? _responderMobile(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['prof_speck'], 2);
      alterarPontuacao(['prof_willian', 'prof_guilherme'], -1);
      return _definirProxima(PerguntasData.visualAlternativo);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['prof_speck'], 1);
      return _definirProxima(PerguntasData.visualAlternativo);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['prof_speck'], -2);
      return _definirProxima(PerguntasData.pooUml);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['prof_speck'], -1);
      return _definirProxima(PerguntasData.cCpp);
    } else {
      return _definirProxima(PerguntasData.oculos);
    }
  }

  /// Fabiane (desktop) e Marcos (ponteiros) ensinam C/C++.
  PerguntaModel? _responderCCpp(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['prof_fabiane', 'prof_marcos'], 2);
      alterarPontuacao(['prof_willian', 'prof_guilherme', 'prof_speck'], -1);
      return _definirProxima(PerguntasData.oculos);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['prof_fabiane', 'prof_marcos'], 1);
      return _definirProxima(PerguntasData.estiloFormal);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['prof_fabiane', 'prof_marcos'], -2);
      return _definirProxima(PerguntasData.pooUml);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['prof_fabiane', 'prof_marcos'], -1);
      return _definirProxima(PerguntasData.ia);
    } else {
      return _definirProxima(PerguntasData.redesInfra);
    }
  }

  /// Jhoni ensina Java, POO e UML.
  PerguntaModel? _responderPooUml(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['prof_jhoni'], 2);
      return _definirProxima(PerguntasData.ia);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['prof_jhoni'], 1);
      return _definirProxima(PerguntasData.oculos);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['prof_jhoni'], -2);
      return _definirProxima(PerguntasData.ia);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['prof_jhoni'], -1);
      return _definirProxima(PerguntasData.versionamentoSeg);
    } else {
      return _definirProxima(PerguntasData.oculos);
    }
  }

  /// Verspegel é o professor de IA; Jhoni é entusiasta declarado.
  PerguntaModel? _responderIa(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['prof_verspegel'], 2);
      alterarPontuacao(['prof_jhoni'], 1);
      return _definirProxima(PerguntasData.oculos);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['prof_verspegel'], 1);
      return _definirProxima(PerguntasData.pooUml);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['prof_verspegel'], -2);
      return _definirProxima(PerguntasData.versionamentoSeg);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['prof_verspegel'], -1);
      return _definirProxima(PerguntasData.redesInfra);
    } else {
      return _definirProxima(PerguntasData.estiloFormal);
    }
  }

  /// Marcos (redes) e Vander (manutenção) atuam em infraestrutura.
  PerguntaModel? _responderRedesInfra(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['prof_marcos', 'prof_vander'], 2);
      alterarPontuacao(['prof_fabiane', 'prof_willian', 'prof_guilherme'], -1);
      return _definirProxima(PerguntasData.hardware);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['prof_marcos', 'prof_vander'], 1);
      return _definirProxima(PerguntasData.hardware);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['prof_marcos', 'prof_vander'], -2);
      return _definirProxima(PerguntasData.versionamentoSeg);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['prof_marcos', 'prof_vander'], -1);
      return _definirProxima(PerguntasData.oculos);
    } else {
      return _definirProxima(PerguntasData.cCpp);
    }
  }

  /// Vander trabalha com hardware, manutenção e Arduino.
  PerguntaModel? _responderHardware(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['prof_vander'], 2);
      return _definirProxima(PerguntasData.oculos);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['prof_vander'], 1);
      return _definirProxima(PerguntasData.oculos);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['prof_vander'], -2);
      return _definirProxima(PerguntasData.cCpp);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['prof_vander'], -1);
      return _definirProxima(PerguntasData.versionamentoSeg);
    } else {
      return _definirProxima(PerguntasData.estiloFormal);
    }
  }

  /// Letícia ensina Git, virtualização e segurança.
  PerguntaModel? _responderVersionamentoSeg(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['prof_leticia'], 2);
      return _definirProxima(PerguntasData.oculos);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['prof_leticia'], 1);
      return _definirProxima(PerguntasData.oculos);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['prof_leticia'], -2);
      return _definirProxima(PerguntasData.redesInfra);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['prof_leticia'], -1);
      return _definirProxima(PerguntasData.ia);
    } else {
      return _definirProxima(PerguntasData.estiloFormal);
    }
  }

  /// Hiago e Andre ensinam Scrum/Kanban; Alan e Marcel não.
  PerguntaModel? _responderAgil(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['prof_hiago', 'prof_andre'], 2);
      alterarPontuacao(['prof_alan', 'prof_marcel'], -1);
      return _definirProxima(PerguntasData.testes);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['prof_hiago', 'prof_andre'], 1);
      return _definirProxima(PerguntasData.projetoIntegrador);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['prof_hiago', 'prof_andre'], -2);
      alterarPontuacao(['prof_alan', 'prof_marcel'], 1);
      return _definirProxima(PerguntasData.requisitos);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['prof_hiago', 'prof_andre'], -1);
      return _definirProxima(PerguntasData.empreendedorismo);
    } else {
      return _definirProxima(PerguntasData.oculos);
    }
  }

  /// Andre ama testes (Jira, Trello); separa Andre de Hiago.
  PerguntaModel? _responderTestes(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['prof_andre'], 2);
      alterarPontuacao(['prof_hiago'], -1);
      return _definirProxima(PerguntasData.projetoIntegrador);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['prof_andre'], 1);
      return _definirProxima(PerguntasData.projetoIntegrador);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['prof_andre'], -2);
      alterarPontuacao(['prof_hiago'], 1);
      return _definirProxima(PerguntasData.estiloFormal);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['prof_andre'], -1);
      return _definirProxima(PerguntasData.oculos);
    } else {
      return _definirProxima(PerguntasData.requisitos);
    }
  }

  /// Alan é o professor de Engenharia de Requisitos.
  PerguntaModel? _responderRequisitos(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['prof_alan'], 2);
      alterarPontuacao(['prof_hiago', 'prof_andre'], -1);
      return _definirProxima(PerguntasData.oculos);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['prof_alan'], 1);
      return _definirProxima(PerguntasData.oculos);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['prof_alan'], -2);
      return _definirProxima(PerguntasData.empreendedorismo);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['prof_alan'], -1);
      return _definirProxima(PerguntasData.agil);
    } else {
      return _definirProxima(PerguntasData.estiloFormal);
    }
  }

  /// Marcel leciona empreendedorismo (formato Shark Tank).
  PerguntaModel? _responderEmpreendedorismo(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['prof_marcel'], 2);
      return _definirProxima(PerguntasData.ingles);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['prof_marcel'], 1);
      return _definirProxima(PerguntasData.ingles);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['prof_marcel'], -2);
      return _definirProxima(PerguntasData.projetoIntegrador);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['prof_marcel'], -1);
      return _definirProxima(PerguntasData.agil);
    } else {
      return _definirProxima(PerguntasData.oculos);
    }
  }

  /// Marcel ministra as aulas em inglês.
  PerguntaModel? _responderIngles(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['prof_marcel'], 2);
      return _definirProxima(PerguntasData.oculos);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['prof_marcel'], 1);
      return _definirProxima(PerguntasData.oculos);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['prof_marcel'], -2);
      return _definirProxima(PerguntasData.projetoIntegrador);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['prof_marcel'], -1);
      return _definirProxima(PerguntasData.agil);
    } else {
      return _definirProxima(PerguntasData.estiloFormal);
    }
  }

  /// Hiago, Andre e Renato orientam o Projeto Integrador.
  PerguntaModel? _responderProjetoIntegrador(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['prof_hiago', 'prof_andre', 'prof_renato'], 2);
      return _definirProxima(PerguntasData.estiloFormal);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['prof_hiago', 'prof_andre', 'prof_renato'], 1);
      return _definirProxima(PerguntasData.agil);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['prof_hiago', 'prof_andre', 'prof_renato'], -2);
      return _definirProxima(PerguntasData.oculos);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['prof_hiago', 'prof_andre', 'prof_renato'], -1);
      return _definirProxima(PerguntasData.requisitos);
    } else {
      return _definirProxima(PerguntasData.estiloFormal);
    }
  }

  /// Alan, Fabiane, Vander e Letícia usam óculos.
  PerguntaModel? _responderOculos(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(idsUsamOculos, 2);
      alterarPontuacao(idsSemOculos, -1);
      return _definirProxima(PerguntasData.estiloFormal);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(idsUsamOculos, 1);
      return _definirProxima(PerguntasData.estiloFormal);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(idsUsamOculos, -2);
      alterarPontuacao(idsSemOculos, 1);
      return _definirProxima(PerguntasData.visualAlternativo);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(idsUsamOculos, -1);
      return _definirProxima(PerguntasData.estiloFormal);
    } else {
      return _definirProxima(PerguntasData.estiloFormal);
    }
  }

  /// Fabiane e Renato têm estilo formal; a maioria é casual.
  PerguntaModel? _responderEstiloFormal(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(idsEstiloFormal, 2);
      alterarPontuacao(idsEstiloCasual, -1);
      return _definirProxima(PerguntasData.cCpp);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(idsEstiloFormal, 1);
      return _definirProxima(PerguntasData.projetoIntegrador);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(idsEstiloFormal, -2);
      alterarPontuacao(idsEstiloCasual, 1);
      return _definirProxima(PerguntasData.visualAlternativo);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(idsEstiloFormal, -1);
      return _definirProxima(PerguntasData.agil);
    } else {
      return _definirProxima(PerguntasData.oculos);
    }
  }

  /// Jefferson Speck tem cabelo colorido e tatuagens.
  PerguntaModel? _responderVisualAlternativo(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['prof_speck'], 2);
      alterarPontuacao(idsEstiloFormal, -1);
      return _definirProxima(PerguntasData.mobile);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['prof_speck'], 1);
      return _definirProxima(PerguntasData.mobile);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['prof_speck'], -2);
      return _definirProxima(PerguntasData.oculos);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['prof_speck'], -1);
      return _definirProxima(PerguntasData.oculos);
    } else {
      return _definirProxima(PerguntasData.estiloFormal);
    }
  }

  // ------------------------------------------------------------
  // Funções auxiliares
  // ------------------------------------------------------------

  /// Soma [pontos] (positivo ou negativo) aos professores com os [ids].
  void alterarPontuacao(List<String> ids, double pontos) {
    for (final professor in professores) {
      if (ids.contains(professor.id)) {
        professor.pontos += pontos;
      }
    }
  }

  /// Garante que a próxima pergunta não se repita.
  ///
  /// Se a pergunta desejada já foi respondida, usa o fallback.
  PerguntaModel? _definirProxima(PerguntaModel proxima) {
    if (perguntasRespondidas.contains(proxima.id)) {
      return _proximaPerguntaFallback();
    } else {
      return proxima;
    }
  }

  /// Retorna a primeira pergunta neutra ainda não respondida,
  /// ou `null` quando não há mais perguntas úteis (fim de jogo).
  PerguntaModel? _proximaPerguntaFallback() {
    for (final pergunta in PerguntasData.todas) {
      if (!perguntasRespondidas.contains(pergunta.id)) {
        return pergunta;
      }
    }
    return null;
  }

  // ------------------------------------------------------------
  // Resultado
  // ------------------------------------------------------------

  /// Professor com a maior pontuação.
  ProfessorModel calcularResultado() {
    final ordenados = [...professores];
    ordenados.sort((a, b) => b.pontos.compareTo(a.pontos));
    return ordenados.first;
  }

  /// Três professores com as maiores pontuações.
  List<ProfessorModel> calcularTopTres() {
    final ordenados = [...professores];
    ordenados.sort((a, b) => b.pontos.compareTo(a.pontos));
    return ordenados.take(3).toList();
  }

  /// Confiança baseada na vantagem do 1º colocado sobre o 2º.
  double calcularConfianca() {
    final ordenados = [...professores];
    ordenados.sort((a, b) => b.pontos.compareTo(a.pontos));

    if (ordenados.length < 2) {
      return 100;
    }

    final diferenca = ordenados[0].pontos - ordenados[1].pontos;
    final confianca = 50 + (diferenca * 8);

    if (confianca < 0) {
      return 0;
    } else if (confianca > 100) {
      return 100;
    } else {
      return confianca;
    }
  }
}
