import 'dart:math';

import '../data/perguntas_data.dart';
import '../data/professores_data.dart';
import '../models/pergunta_model.dart';
import '../models/professor_model.dart';
import '../models/resposta_enum.dart';

/// Controla todo o estado e a regra de uma partida.
///
/// O jogo termina quando um professor atinge [limiarProbabilidade]
/// (mínimo de [_minimoPerguntas]) ou quando todas as perguntas
/// são esgotadas.
///
/// Pontuação:
///   Sim +2 / Provavelmente sim +1 / Não sei 0 /
///   Provavelmente não −1 / Não −2
///   (contrapesos de ±1 para grupos opostos onde aplicável)
class GameController {
  static const int _minimoPerguntas = 5;
  static const double limiarProbabilidade = 0.55;
  static const double temperatura = 0.40;

  // ------------------------------------------------------------
  // Grupos de calibração — baseados nos dados oficiais dos profs
  // ------------------------------------------------------------

  /// Professores que trabalham com programação / desenvolvimento.
  static const idsProgramacao = [
    'prof_fabiane', // C/C++, lógica
    'prof_willian', // Python, Django
    'prof_guilherme', // JS, UX/UI
    'prof_jhoni', // Java, POO
    'prof_speck', // Dart, Flutter
    'prof_marcos', // C/C++, redes
    'prof_fabiano',
  ];

  /// Professores sem foco direto em programação.
  static const idsNaoProgramacao = [
    'prof_hiago', // gestão/ágil
    'prof_andre', // testes/PI
    'prof_marcel', // empreendedorismo
    'prof_renato', // PI
    'prof_alan', // requisitos
  ];

  /// Professores que usam óculos.
  static const idsUsamOculos = [
    'prof_alan',
    'prof_fabiane',
    'prof_wander',
    'prof_leticia',
  ];

  /// Professores confirmados sem óculos.
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

  /// Professores com cabeça raspada / carecas.
  static const idsCareca = ['prof_willian', 'prof_marcos'];

  /// Professores com cabelo normal (confirmado não careca).
  static const idsNaoCareca = [
    'prof_hiago',
    'prof_alan',
    'prof_fabiane',
    'prof_wander',
    'prof_guilherme',
    'prof_jhoni',
    'prof_andre',
    'prof_leticia',
    'prof_speck',
    'prof_marcel',
    'prof_renato',
    'prof_verspegel',
  ];

  /// Professores visivelmente altos.
  static const idsAltos = [
    'prof_hiago',
    'prof_alan',
    'prof_wander',
    'prof_andre',
    'prof_renato',
  ];

  /// Professores visivelmente baixos.
  static const idsBaixos = ['prof_jhoni', 'prof_verspegel'];

  /// Professores com cabelo loiro.
  static const idsCabeloLoiro = ['prof_fabiane', 'prof_leticia'];

  /// Estilo de roupa mais formal (camisa social).
  static const idsEstiloFormal = ['prof_fabiane', 'prof_renato'];

  /// Estilo de roupa casual / não-formal.
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

  /// Professores reconhecidamente animados e enérgicos em aula.
  static const idsAnimadoAula = ['prof_hiago'];

  /// Professores que não têm perfil de coordenador do curso.
  static const idsNaoAnimadoAula = ['prof_renato', 'prof_marcel'];

  /// Professores que exercem ou exerceram a coordenação do curso.
  static const idsCoordenador = ['prof_fabiane'];

  final List<ProfessorModel> professores = criarProfessores();
  final List<String> perguntasRespondidas = [];
  final List<PerguntaModel> _perguntasEmbaralhadas = [];

  late PerguntaModel perguntaAtual;
  int quantidadePerguntasRespondidas = 0;
  bool jogoFinalizado = false;

  GameController() {
    iniciarJogo();
  }

  void iniciarJogo() {
    for (final professor in professores) {
      professor.resetarPontos();
    }
    perguntasRespondidas.clear();
    quantidadePerguntasRespondidas = 0;
    jogoFinalizado = false;
    _perguntasEmbaralhadas
      ..clear()
      ..addAll(PerguntasData.todas)
      ..shuffle();
    perguntaAtual = _perguntasEmbaralhadas.first;
  }

  /// Recebe a resposta e retorna a próxima pergunta, ou `null` ao
  /// fim do jogo (70 % de probabilidade atingida ou perguntas esgotadas).
  PerguntaModel? responder(RespostaEnum resposta) {
    if (jogoFinalizado) return null;

    perguntasRespondidas.add(perguntaAtual.id);
    quantidadePerguntasRespondidas++;

    final PerguntaModel? proxima = _tratarPerguntaAtual(resposta);

    if (quantidadePerguntasRespondidas >= _minimoPerguntas) {
      final probs = calcularProbabilidades();
      if (probs.values.reduce(max) >= limiarProbabilidade) {
        jogoFinalizado = true;
        return null;
      }
    }

    if (proxima == null) {
      jogoFinalizado = true;
      return null;
    }

    perguntaAtual = proxima;
    return perguntaAtual;
  }

  // ------------------------------------------------------------
  // Roteamento de respostas
  // ------------------------------------------------------------

  PerguntaModel? _tratarPerguntaAtual(RespostaEnum resposta) {
    switch (perguntaAtual.id) {
      case 'programacao':
        return _responderProgramacao(resposta);
      case 'web':
        return _responderWeb(resposta);
      case 'javascript':
        return _responderJavascript(resposta);
      case 'banco_dados':
        return _responderBancoDados(resposta);
      case 'mobile':
        return _responderMobile(resposta);
      case 'c_cpp':
        return _responderCCpp(resposta);
      case 'poo_uml':
        return _responderPooUml(resposta);
      case 'ia':
        return _responderIa(resposta);
      case 'redes_infra':
        return _responderRedesInfra(resposta);
      case 'hardware':
        return _responderHardware(resposta);
      case 'versionamento_seg':
        return _responderVersionamentoSeg(resposta);
      case 'agil':
        return _responderAgil(resposta);
      case 'testes':
        return _responderTestes(resposta);
      case 'requisitos':
        return _responderRequisitos(resposta);
      case 'empreendedorismo':
        return _responderEmpreendedorismo(resposta);
      case 'ingles':
        return _responderIngles(resposta);
      case 'projeto_integrador':
        return _responderProjetoIntegrador(resposta);
      case 'oculos':
        return _responderOculos(resposta);
      case 'estilo_formal':
        return _responderEstiloFormal(resposta);
      case 'visual_alternativo':
        return _responderVisualAlternativo(resposta);
      case 'careca':
        return _responderCareca(resposta);
      case 'alto':
        return _responderAlto(resposta);
      case 'loiro':
        return _responderLoiro(resposta);
      case 'animado_aula':
        return _responderAnimadoAula(resposta);
      case 'coordenador':
        return _responderCoordenador(resposta);
      case 'leciona_ia':
        return _responderLecionaIa(resposta);
      default:
        return _proximaPerguntaFallback();
    }
  }

  // ------------------------------------------------------------
  // Métodos de resposta por pergunta
  // ------------------------------------------------------------

  /// Programam: Fabiane, Willian, Guilherme, Jhoni, Speck, Marcos, Fabiano.
  PerguntaModel? _responderProgramacao(RespostaEnum resposta) {
    switch (resposta) {
      case RespostaEnum.sim:
        alterarPontuacao(idsProgramacao, 2);
        alterarPontuacao(idsNaoProgramacao, -1);
        return _definirProxima(PerguntasData.web);
      case RespostaEnum.provavelmenteSim:
        alterarPontuacao(idsProgramacao, 1);
        return _definirProxima(PerguntasData.cCpp);
      case RespostaEnum.nao:
        alterarPontuacao(idsProgramacao, -2);
        alterarPontuacao(idsNaoProgramacao, 1);
        return _definirProxima(PerguntasData.agil);
      case RespostaEnum.provavelmenteNao:
        alterarPontuacao(idsProgramacao, -1);
        return _definirProxima(PerguntasData.requisitos);
      case RespostaEnum.naoSei:
        return _definirProxima(PerguntasData.oculos);
    }
  }

  /// Web: Willian (Django/Python) e Guilherme (JS/UX/UI).
  PerguntaModel? _responderWeb(RespostaEnum resposta) {
    switch (resposta) {
      case RespostaEnum.sim:
        alterarPontuacao(['prof_willian', 'prof_guilherme'], 2);
        alterarPontuacao(['prof_fabiane', 'prof_speck', 'prof_fabiano'], -1);
        return _definirProxima(PerguntasData.javascript);
      case RespostaEnum.provavelmenteSim:
        alterarPontuacao(['prof_willian', 'prof_guilherme'], 1);
        return _definirProxima(PerguntasData.bancoDados);
      case RespostaEnum.nao:
        alterarPontuacao(['prof_willian', 'prof_guilherme'], -2);
        alterarPontuacao(['prof_fabiane', 'prof_speck'], 1);
        return _definirProxima(PerguntasData.mobile);
      case RespostaEnum.provavelmenteNao:
        alterarPontuacao(['prof_willian', 'prof_guilherme'], -1);
        return _definirProxima(PerguntasData.cCpp);
      case RespostaEnum.naoSei:
        return _definirProxima(PerguntasData.oculos);
    }
  }

  /// JavaScript: Guilherme (ama JS/microsserviços); Willian usa Python.
  PerguntaModel? _responderJavascript(RespostaEnum resposta) {
    switch (resposta) {
      case RespostaEnum.sim:
        alterarPontuacao(['prof_guilherme'], 2);
        alterarPontuacao(['prof_willian', 'prof_fabiano'], -1);
        return _definirProxima(PerguntasData.bancoDados);
      case RespostaEnum.provavelmenteSim:
        alterarPontuacao(['prof_guilherme'], 1);
        return _definirProxima(PerguntasData.bancoDados);
      case RespostaEnum.nao:
        alterarPontuacao(['prof_guilherme'], -2);
        alterarPontuacao(['prof_willian'], 1);
        return _definirProxima(PerguntasData.mobile);
      case RespostaEnum.provavelmenteNao:
        alterarPontuacao(['prof_guilherme'], -1);
        return _definirProxima(PerguntasData.mobile);
      case RespostaEnum.naoSei:
        return _definirProxima(PerguntasData.oculos);
    }
  }

  /// Banco de dados: Willian (Python/Django/BD) e Fabiano.
  PerguntaModel? _responderBancoDados(RespostaEnum resposta) {
    switch (resposta) {
      case RespostaEnum.sim:
        alterarPontuacao(['prof_willian', 'prof_fabiano'], 2);
        alterarPontuacao(['prof_guilherme'], -1);
        return _definirProxima(PerguntasData.careca);
      case RespostaEnum.provavelmenteSim:
        alterarPontuacao(['prof_willian', 'prof_fabiano'], 1);
        return _definirProxima(PerguntasData.web);
      case RespostaEnum.nao:
        alterarPontuacao(['prof_willian', 'prof_fabiano'], -2);
        return _definirProxima(PerguntasData.mobile);
      case RespostaEnum.provavelmenteNao:
        alterarPontuacao(['prof_willian', 'prof_fabiano'], -1);
        return _definirProxima(PerguntasData.pooUml);
      case RespostaEnum.naoSei:
        return _definirProxima(PerguntasData.cCpp);
    }
  }

  /// Mobile: Jefferson Speck (Dart e Flutter).
  PerguntaModel? _responderMobile(RespostaEnum resposta) {
    switch (resposta) {
      case RespostaEnum.sim:
        alterarPontuacao(['prof_speck'], 2);
        alterarPontuacao(['prof_willian', 'prof_guilherme'], -1);
        return _definirProxima(PerguntasData.visualAlternativo);
      case RespostaEnum.provavelmenteSim:
        alterarPontuacao(['prof_speck'], 1);
        return _definirProxima(PerguntasData.visualAlternativo);
      case RespostaEnum.nao:
        alterarPontuacao(['prof_speck'], -2);
        return _definirProxima(PerguntasData.pooUml);
      case RespostaEnum.provavelmenteNao:
        alterarPontuacao(['prof_speck'], -1);
        return _definirProxima(PerguntasData.cCpp);
      case RespostaEnum.naoSei:
        return _definirProxima(PerguntasData.oculos);
    }
  }

  /// C/C++: Fabiane (lógica/desktop) e Marcos (ponteiros/redes).
  PerguntaModel? _responderCCpp(RespostaEnum resposta) {
    switch (resposta) {
      case RespostaEnum.sim:
        alterarPontuacao(['prof_fabiane', 'prof_marcos'], 2);
        alterarPontuacao(
            ['prof_willian', 'prof_guilherme', 'prof_speck', 'prof_fabiano'],
            -1);
        return _definirProxima(PerguntasData.careca);
      case RespostaEnum.provavelmenteSim:
        alterarPontuacao(['prof_fabiane', 'prof_marcos'], 1);
        return _definirProxima(PerguntasData.estiloFormal);
      case RespostaEnum.nao:
        alterarPontuacao(['prof_fabiane', 'prof_marcos'], -2);
        return _definirProxima(PerguntasData.pooUml);
      case RespostaEnum.provavelmenteNao:
        alterarPontuacao(['prof_fabiane', 'prof_marcos'], -1);
        return _definirProxima(PerguntasData.ia);
      case RespostaEnum.naoSei:
        return _definirProxima(PerguntasData.redesInfra);
    }
  }

  /// POO/UML: Jhoni (Java). Fanboy de IA, especialmente Claude.
  PerguntaModel? _responderPooUml(RespostaEnum resposta) {
    switch (resposta) {
      case RespostaEnum.sim:
        alterarPontuacao(['prof_jhoni'], 2);
        alterarPontuacao(['prof_fabiano'], -1);
        return _definirProxima(PerguntasData.alto);
      case RespostaEnum.provavelmenteSim:
        alterarPontuacao(['prof_jhoni'], 1);
        return _definirProxima(PerguntasData.oculos);
      case RespostaEnum.nao:
        alterarPontuacao(['prof_jhoni'], -2);
        return _definirProxima(PerguntasData.ia);
      case RespostaEnum.provavelmenteNao:
        alterarPontuacao(['prof_jhoni'], -1);
        return _definirProxima(PerguntasData.versionamentoSeg);
      case RespostaEnum.naoSei:
        return _definirProxima(PerguntasData.oculos);
    }
  }

  /// IA: Verspegel (primário); Jhoni é fanboy declarado.
  PerguntaModel? _responderIa(RespostaEnum resposta) {
    switch (resposta) {
      case RespostaEnum.sim:
        alterarPontuacao(['prof_verspegel'], 2);
        alterarPontuacao(['prof_jhoni'], 1);
        return _definirProxima(PerguntasData.lecionaIa);
      case RespostaEnum.provavelmenteSim:
        alterarPontuacao(['prof_verspegel'], 1);
        return _definirProxima(PerguntasData.pooUml);
      case RespostaEnum.nao:
        alterarPontuacao(['prof_verspegel'], -2);
        return _definirProxima(PerguntasData.versionamentoSeg);
      case RespostaEnum.provavelmenteNao:
        alterarPontuacao(['prof_verspegel'], -1);
        return _definirProxima(PerguntasData.redesInfra);
      case RespostaEnum.naoSei:
        return _definirProxima(PerguntasData.estiloFormal);
    }
  }

  /// Redes/infraestrutura: Marcos Guido (redes, C/C++ com ponteiros).
  PerguntaModel? _responderRedesInfra(RespostaEnum resposta) {
    switch (resposta) {
      case RespostaEnum.sim:
        alterarPontuacao(['prof_marcos'], 2);
        alterarPontuacao(['prof_fabiane', 'prof_willian', 'prof_guilherme'],
            -1);
        return _definirProxima(PerguntasData.careca);
      case RespostaEnum.provavelmenteSim:
        alterarPontuacao(['prof_marcos'], 1);
        return _definirProxima(PerguntasData.hardware);
      case RespostaEnum.nao:
        alterarPontuacao(['prof_marcos'], -2);
        return _definirProxima(PerguntasData.versionamentoSeg);
      case RespostaEnum.provavelmenteNao:
        alterarPontuacao(['prof_marcos'], -1);
        return _definirProxima(PerguntasData.oculos);
      case RespostaEnum.naoSei:
        return _definirProxima(PerguntasData.cCpp);
    }
  }

  /// Hardware/Arduino: Wander (manutenção de computadores).
  PerguntaModel? _responderHardware(RespostaEnum resposta) {
    switch (resposta) {
      case RespostaEnum.sim:
        alterarPontuacao(['prof_wander'], 2);
        return _definirProxima(PerguntasData.alto);
      case RespostaEnum.provavelmenteSim:
        alterarPontuacao(['prof_wander'], 1);
        return _definirProxima(PerguntasData.oculos);
      case RespostaEnum.nao:
        alterarPontuacao(['prof_wander'], -2);
        return _definirProxima(PerguntasData.cCpp);
      case RespostaEnum.provavelmenteNao:
        alterarPontuacao(['prof_wander'], -1);
        return _definirProxima(PerguntasData.versionamentoSeg);
      case RespostaEnum.naoSei:
        return _definirProxima(PerguntasData.estiloFormal);
    }
  }

  /// Git, VMs e segurança: Letícia (estilosa, ama cachorros).
  PerguntaModel? _responderVersionamentoSeg(RespostaEnum resposta) {
    switch (resposta) {
      case RespostaEnum.sim:
        alterarPontuacao(['prof_leticia'], 2);
        return _definirProxima(PerguntasData.loiro);
      case RespostaEnum.provavelmenteSim:
        alterarPontuacao(['prof_leticia'], 1);
        return _definirProxima(PerguntasData.oculos);
      case RespostaEnum.nao:
        alterarPontuacao(['prof_leticia'], -2);
        return _definirProxima(PerguntasData.redesInfra);
      case RespostaEnum.provavelmenteNao:
        alterarPontuacao(['prof_leticia'], -1);
        return _definirProxima(PerguntasData.ia);
      case RespostaEnum.naoSei:
        return _definirProxima(PerguntasData.estiloFormal);
    }
  }

  /// Ágil: Hiago (carismático, Prati) e André (testes/PI).
  PerguntaModel? _responderAgil(RespostaEnum resposta) {
    switch (resposta) {
      case RespostaEnum.sim:
        alterarPontuacao(['prof_hiago', 'prof_andre'], 2);
        alterarPontuacao(['prof_alan', 'prof_marcel'], -1);
        return _definirProxima(PerguntasData.testes);
      case RespostaEnum.provavelmenteSim:
        alterarPontuacao(['prof_hiago', 'prof_andre'], 1);
        return _definirProxima(PerguntasData.projetoIntegrador);
      case RespostaEnum.nao:
        alterarPontuacao(['prof_hiago', 'prof_andre'], -2);
        alterarPontuacao(['prof_alan', 'prof_marcel'], 1);
        return _definirProxima(PerguntasData.requisitos);
      case RespostaEnum.provavelmenteNao:
        alterarPontuacao(['prof_hiago', 'prof_andre'], -1);
        return _definirProxima(PerguntasData.empreendedorismo);
      case RespostaEnum.naoSei:
        return _definirProxima(PerguntasData.oculos);
    }
  }

  /// Testes: André (Jira, Trello, churrasco, cerveja artesanal).
  PerguntaModel? _responderTestes(RespostaEnum resposta) {
    switch (resposta) {
      case RespostaEnum.sim:
        alterarPontuacao(['prof_andre'], 2);
        alterarPontuacao(['prof_hiago'], -1);
        return _definirProxima(PerguntasData.projetoIntegrador);
      case RespostaEnum.provavelmenteSim:
        alterarPontuacao(['prof_andre'], 1);
        return _definirProxima(PerguntasData.projetoIntegrador);
      case RespostaEnum.nao:
        alterarPontuacao(['prof_andre'], -2);
        alterarPontuacao(['prof_hiago'], 1);
        return _definirProxima(PerguntasData.animadoAula);
      case RespostaEnum.provavelmenteNao:
        alterarPontuacao(['prof_andre'], -1);
        return _definirProxima(PerguntasData.oculos);
      case RespostaEnum.naoSei:
        return _definirProxima(PerguntasData.requisitos);
    }
  }

  /// Requisitos: Alan (sério, alto, usa óculos).
  PerguntaModel? _responderRequisitos(RespostaEnum resposta) {
    switch (resposta) {
      case RespostaEnum.sim:
        alterarPontuacao(['prof_alan'], 2);
        alterarPontuacao(['prof_hiago', 'prof_andre'], -1);
        return _definirProxima(PerguntasData.oculos);
      case RespostaEnum.provavelmenteSim:
        alterarPontuacao(['prof_alan'], 1);
        return _definirProxima(PerguntasData.oculos);
      case RespostaEnum.nao:
        alterarPontuacao(['prof_alan'], -2);
        return _definirProxima(PerguntasData.empreendedorismo);
      case RespostaEnum.provavelmenteNao:
        alterarPontuacao(['prof_alan'], -1);
        return _definirProxima(PerguntasData.agil);
      case RespostaEnum.naoSei:
        return _definirProxima(PerguntasData.estiloFormal);
    }
  }

  /// Empreendedorismo: Marcel (Shark Tank, músico, motos custom).
  PerguntaModel? _responderEmpreendedorismo(RespostaEnum resposta) {
    switch (resposta) {
      case RespostaEnum.sim:
        alterarPontuacao(['prof_marcel'], 2);
        return _definirProxima(PerguntasData.ingles);
      case RespostaEnum.provavelmenteSim:
        alterarPontuacao(['prof_marcel'], 1);
        return _definirProxima(PerguntasData.ingles);
      case RespostaEnum.nao:
        alterarPontuacao(['prof_marcel'], -2);
        return _definirProxima(PerguntasData.projetoIntegrador);
      case RespostaEnum.provavelmenteNao:
        alterarPontuacao(['prof_marcel'], -1);
        return _definirProxima(PerguntasData.agil);
      case RespostaEnum.naoSei:
        return _definirProxima(PerguntasData.oculos);
    }
  }

  /// Inglês: Marcel (único que ministra as aulas em inglês).
  PerguntaModel? _responderIngles(RespostaEnum resposta) {
    switch (resposta) {
      case RespostaEnum.sim:
        alterarPontuacao(['prof_marcel'], 2);
        return _definirProxima(PerguntasData.oculos);
      case RespostaEnum.provavelmenteSim:
        alterarPontuacao(['prof_marcel'], 1);
        return _definirProxima(PerguntasData.oculos);
      case RespostaEnum.nao:
        alterarPontuacao(['prof_marcel'], -2);
        return _definirProxima(PerguntasData.projetoIntegrador);
      case RespostaEnum.provavelmenteNao:
        alterarPontuacao(['prof_marcel'], -1);
        return _definirProxima(PerguntasData.agil);
      case RespostaEnum.naoSei:
        return _definirProxima(PerguntasData.estiloFormal);
    }
  }

  /// PI: Hiago, André e Renato. Renato: alto, formal, veio da Prati.
  PerguntaModel? _responderProjetoIntegrador(RespostaEnum resposta) {
    switch (resposta) {
      case RespostaEnum.sim:
        alterarPontuacao(['prof_hiago', 'prof_andre', 'prof_renato'], 2);
        return _definirProxima(PerguntasData.estiloFormal);
      case RespostaEnum.provavelmenteSim:
        alterarPontuacao(['prof_hiago', 'prof_andre', 'prof_renato'], 1);
        return _definirProxima(PerguntasData.agil);
      case RespostaEnum.nao:
        alterarPontuacao(['prof_hiago', 'prof_andre', 'prof_renato'], -2);
        return _definirProxima(PerguntasData.oculos);
      case RespostaEnum.provavelmenteNao:
        alterarPontuacao(['prof_hiago', 'prof_andre', 'prof_renato'], -1);
        return _definirProxima(PerguntasData.requisitos);
      case RespostaEnum.naoSei:
        return _definirProxima(PerguntasData.estiloFormal);
    }
  }

  /// Óculos: Alan, Fabiane, Wander, Letícia.
  /// Após sim → loiro (diferencia Fabiane/Letícia de Alan/Wander).
  /// Após não → careca (diferencia Willian/Marcos dos demais sem óculos).
  PerguntaModel? _responderOculos(RespostaEnum resposta) {
    switch (resposta) {
      case RespostaEnum.sim:
        alterarPontuacao(idsUsamOculos, 2);
        alterarPontuacao(idsSemOculos, -1);
        return _definirProxima(PerguntasData.loiro);
      case RespostaEnum.provavelmenteSim:
        alterarPontuacao(idsUsamOculos, 1);
        return _definirProxima(PerguntasData.loiro);
      case RespostaEnum.nao:
        alterarPontuacao(idsUsamOculos, -2);
        alterarPontuacao(idsSemOculos, 1);
        return _definirProxima(PerguntasData.careca);
      case RespostaEnum.provavelmenteNao:
        alterarPontuacao(idsUsamOculos, -1);
        return _definirProxima(PerguntasData.estiloFormal);
      case RespostaEnum.naoSei:
        return _definirProxima(PerguntasData.estiloFormal);
    }
  }

  /// Formal: Fabiane e Renato.
  PerguntaModel? _responderEstiloFormal(RespostaEnum resposta) {
    switch (resposta) {
      case RespostaEnum.sim:
        alterarPontuacao(idsEstiloFormal, 2);
        alterarPontuacao(idsEstiloCasual, -1);
        return _definirProxima(PerguntasData.coordenador);
      case RespostaEnum.provavelmenteSim:
        alterarPontuacao(idsEstiloFormal, 1);
        return _definirProxima(PerguntasData.projetoIntegrador);
      case RespostaEnum.nao:
        alterarPontuacao(idsEstiloFormal, -2);
        alterarPontuacao(idsEstiloCasual, 1);
        return _definirProxima(PerguntasData.visualAlternativo);
      case RespostaEnum.provavelmenteNao:
        alterarPontuacao(idsEstiloFormal, -1);
        return _definirProxima(PerguntasData.agil);
      case RespostaEnum.naoSei:
        return _definirProxima(PerguntasData.oculos);
    }
  }

  /// Visual alternativo: Speck (cabelo colorido + tatuagens).
  PerguntaModel? _responderVisualAlternativo(RespostaEnum resposta) {
    switch (resposta) {
      case RespostaEnum.sim:
        alterarPontuacao(['prof_speck'], 2);
        alterarPontuacao(idsEstiloFormal, -1);
        return _definirProxima(PerguntasData.mobile);
      case RespostaEnum.provavelmenteSim:
        alterarPontuacao(['prof_speck'], 1);
        return _definirProxima(PerguntasData.mobile);
      case RespostaEnum.nao:
        alterarPontuacao(['prof_speck'], -2);
        return _definirProxima(PerguntasData.alto);
      case RespostaEnum.provavelmenteNao:
        alterarPontuacao(['prof_speck'], -1);
        return _definirProxima(PerguntasData.oculos);
      case RespostaEnum.naoSei:
        return _definirProxima(PerguntasData.estiloFormal);
    }
  }

  /// Careca: Willian e Marcos Guido.
  /// Sim → redesInfra para separar Marcos (redes) de Willian (web/BD).
  /// Não → visualAlternativo (Speck pode estar no grupo sem óculos + não careca).
  PerguntaModel? _responderCareca(RespostaEnum resposta) {
    switch (resposta) {
      case RespostaEnum.sim:
        alterarPontuacao(idsCareca, 2);
        alterarPontuacao(idsNaoCareca, -1);
        return _definirProxima(PerguntasData.redesInfra);
      case RespostaEnum.provavelmenteSim:
        alterarPontuacao(idsCareca, 1);
        return _definirProxima(PerguntasData.redesInfra);
      case RespostaEnum.nao:
        alterarPontuacao(idsCareca, -2);
        alterarPontuacao(idsNaoCareca, 1);
        return _definirProxima(PerguntasData.visualAlternativo);
      case RespostaEnum.provavelmenteNao:
        alterarPontuacao(idsCareca, -1);
        return _definirProxima(PerguntasData.visualAlternativo);
      case RespostaEnum.naoSei:
        return _definirProxima(PerguntasData.estiloFormal);
    }
  }

  /// Alto: Hiago, Alan, Wander, André, Renato.
  /// Baixo: Jhoni e Verspegel.
  PerguntaModel? _responderAlto(RespostaEnum resposta) {
    switch (resposta) {
      case RespostaEnum.sim:
        alterarPontuacao(idsAltos, 2);
        alterarPontuacao(idsBaixos, -1);
        return _definirProxima(PerguntasData.agil);
      case RespostaEnum.provavelmenteSim:
        alterarPontuacao(idsAltos, 1);
        return _definirProxima(PerguntasData.projetoIntegrador);
      case RespostaEnum.nao:
        alterarPontuacao(idsAltos, -1);
        alterarPontuacao(idsBaixos, 2);
        return _definirProxima(PerguntasData.ia);
      case RespostaEnum.provavelmenteNao:
        alterarPontuacao(idsBaixos, 1);
        return _definirProxima(PerguntasData.pooUml);
      case RespostaEnum.naoSei:
        return _definirProxima(PerguntasData.oculos);
    }
  }

  /// Loiro: Fabiane (formal, óculos) e Letícia (informal, óculos).
  /// Sim → estiloFormal para separar as duas.
  /// Não → alto (para Alan/Wander que têm óculos mas não são loiros).
  PerguntaModel? _responderLoiro(RespostaEnum resposta) {
    switch (resposta) {
      case RespostaEnum.sim:
        alterarPontuacao(idsCabeloLoiro, 2);
        alterarPontuacao(['prof_alan', 'prof_wander'], -1);
        return _definirProxima(PerguntasData.estiloFormal);
      case RespostaEnum.provavelmenteSim:
        alterarPontuacao(idsCabeloLoiro, 1);
        return _definirProxima(PerguntasData.estiloFormal);
      case RespostaEnum.nao:
        alterarPontuacao(idsCabeloLoiro, -2);
        alterarPontuacao(['prof_alan', 'prof_wander'], 1);
        return _definirProxima(PerguntasData.alto);
      case RespostaEnum.provavelmenteNao:
        alterarPontuacao(idsCabeloLoiro, -1);
        return _definirProxima(PerguntasData.alto);
      case RespostaEnum.naoSei:
        return _definirProxima(PerguntasData.estiloFormal);
    }
  }

  /// Animado em aula: Hiago (charismatic/energetic). Renato e Marcel menos.
  PerguntaModel? _responderAnimadoAula(RespostaEnum resposta) {
    switch (resposta) {
      case RespostaEnum.sim:
        alterarPontuacao(idsAnimadoAula, 2);
        alterarPontuacao(idsNaoAnimadoAula, -1);
        return _definirProxima(PerguntasData.projetoIntegrador);
      case RespostaEnum.provavelmenteSim:
        alterarPontuacao(idsAnimadoAula, 1);
        return _definirProxima(PerguntasData.projetoIntegrador);
      case RespostaEnum.nao:
        alterarPontuacao(idsAnimadoAula, -2);
        alterarPontuacao(idsNaoAnimadoAula, 1);
        return _definirProxima(PerguntasData.estiloFormal);
      case RespostaEnum.provavelmenteNao:
        alterarPontuacao(idsAnimadoAula, -1);
        return _definirProxima(PerguntasData.estiloFormal);
      case RespostaEnum.naoSei:
        return _definirProxima(PerguntasData.oculos);
    }
  }

  /// Coordenador: Fabiane.
  PerguntaModel? _responderCoordenador(RespostaEnum resposta) {
    switch (resposta) {
      case RespostaEnum.sim:
        alterarPontuacao(idsCoordenador, 2);
        alterarPontuacao(['prof_renato'], -1);
        return _definirProxima(PerguntasData.cCpp);
      case RespostaEnum.provavelmenteSim:
        alterarPontuacao(idsCoordenador, 1);
        return _definirProxima(PerguntasData.cCpp);
      case RespostaEnum.nao:
        alterarPontuacao(idsCoordenador, -2);
        alterarPontuacao(['prof_renato'], 1);
        return _definirProxima(PerguntasData.projetoIntegrador);
      case RespostaEnum.provavelmenteNao:
        alterarPontuacao(idsCoordenador, -1);
        return _definirProxima(PerguntasData.projetoIntegrador);
      case RespostaEnum.naoSei:
        return _definirProxima(PerguntasData.cCpp);
    }
  }

  /// Leciona IA: Verspegel (primário). Jhoni é fanboy mas não é o responsável.
  PerguntaModel? _responderLecionaIa(RespostaEnum resposta) {
    switch (resposta) {
      case RespostaEnum.sim:
        alterarPontuacao(['prof_verspegel'], 2);
        alterarPontuacao(['prof_jhoni'], -1);
        return _definirProxima(PerguntasData.alto);
      case RespostaEnum.provavelmenteSim:
        alterarPontuacao(['prof_verspegel'], 1);
        return _definirProxima(PerguntasData.alto);
      case RespostaEnum.nao:
        alterarPontuacao(['prof_verspegel'], -2);
        alterarPontuacao(['prof_jhoni'], 1);
        return _definirProxima(PerguntasData.pooUml);
      case RespostaEnum.provavelmenteNao:
        alterarPontuacao(['prof_verspegel'], -1);
        return _definirProxima(PerguntasData.pooUml);
      case RespostaEnum.naoSei:
        return _definirProxima(PerguntasData.alto);
    }
  }

  // ------------------------------------------------------------
  // Funções auxiliares
  // ------------------------------------------------------------

  void alterarPontuacao(List<String> ids, double pontos) {
    for (final professor in professores) {
      if (ids.contains(professor.id)) {
        professor.pontos += pontos;
      }
    }
  }

  PerguntaModel? _definirProxima(PerguntaModel proxima) {
    if (perguntasRespondidas.contains(proxima.id)) {
      return _proximaPerguntaFallback();
    }
    return proxima;
  }

  PerguntaModel? _proximaPerguntaFallback() {
    for (final pergunta in _perguntasEmbaralhadas) {
      if (!perguntasRespondidas.contains(pergunta.id)) {
        return pergunta;
      }
    }
    return null;
  }

  // ------------------------------------------------------------
  // Resultado
  // ------------------------------------------------------------

  /// Probabilidade de cada professor via softmax.
  Map<String, double> calcularProbabilidades() {
    if (professores.isEmpty) return {};
    final maxPontos = professores.map((p) => p.pontos).reduce(max);
    final expScores = {
      for (final p in professores)
        p.id: exp((p.pontos - maxPontos) * temperatura),
    };
    final somaExp = expScores.values.reduce((a, b) => a + b);
    return {
      for (final entry in expScores.entries) entry.key: entry.value / somaExp,
    };
  }

  /// Probabilidade em % do líder atual (usado na barra da tela de perguntas).
  double get confiancaAtual {
    if (quantidadePerguntasRespondidas == 0) {
      return 1.0 / professores.length * 100;
    }
    final probs = calcularProbabilidades();
    return probs.values.reduce(max) * 100;
  }

  ProfessorModel calcularResultado() {
    final ordenados = [...professores]
      ..sort((a, b) => b.pontos.compareTo(a.pontos));
    return ordenados.first;
  }

  List<ProfessorModel> calcularTopTres() {
    final ordenados = [...professores]
      ..sort((a, b) => b.pontos.compareTo(a.pontos));
    return ordenados.take(3).toList();
  }

  double calcularConfianca() {
    final probs = calcularProbabilidades();
    return (probs[calcularResultado().id] ?? 0) * 100;
  }
}
