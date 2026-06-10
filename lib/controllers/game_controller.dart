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
/// PONTO DE INTEGRAÇÃO FINAL
/// As associações de pontuação abaixo usam apenas IDs FICTÍCIOS
/// (candidato_1, candidato_2, candidato_3) com pesos provisórios.
/// Quando o responsável enviar os dados oficiais dos professores,
/// os métodos _responderXxx devem ser calibrados com os IDs e
/// pesos reais. Nada aqui representa professores reais.
/// ============================================================
class GameController {
  static const int limitePerguntas = 10;

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
    perguntaAtual = PerguntasData.areaPratica;
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
    if (perguntaAtual.id == 'area_pratica') {
      return _responderAreaPratica(resposta);
    } else if (perguntaAtual.id == 'programacao') {
      return _responderProgramacao(resposta);
    } else if (perguntaAtual.id == 'codigo_pratico') {
      return _responderCodigoPratico(resposta);
    } else if (perguntaAtual.id == 'banco_dados') {
      return _responderBancoDados(resposta);
    } else if (perguntaAtual.id == 'laboratorio') {
      return _responderLaboratorio(resposta);
    } else if (perguntaAtual.id == 'slides') {
      return _responderSlides(resposta);
    } else if (perguntaAtual.id == 'quadro') {
      return _responderQuadro(resposta);
    } else if (perguntaAtual.id == 'mercado') {
      return _responderMercado(resposta);
    } else if (perguntaAtual.id == 'projetos') {
      return _responderProjetos(resposta);
    } else if (perguntaAtual.id == 'organizacao') {
      return _responderOrganizacao(resposta);
    } else if (perguntaAtual.id == 'diagramas') {
      return _responderDiagramas(resposta);
    } else if (perguntaAtual.id == 'passo_a_passo') {
      return _responderPassoAPasso(resposta);
    } else if (perguntaAtual.id == 'exercicios') {
      return _responderExercicios(resposta);
    } else if (perguntaAtual.id == 'gestao') {
      return _responderGestao(resposta);
    } else if (perguntaAtual.id == 'ferramentas') {
      return _responderFerramentas(resposta);
    } else if (perguntaAtual.id == 'trabalho_grupo') {
      return _responderTrabalhoGrupo(resposta);
    } else {
      return _proximaPerguntaFallback();
    }
  }

  // ----------------------------------------------------------
  // Métodos de resposta por pergunta (associações PROVISÓRIAS).
  // candidato_1 = perfil fictício "mão na massa / programação"
  // candidato_2 = perfil fictício "gestão / teoria / mercado"
  // candidato_3 = perfil fictício "dados / modelagem / quadro"
  // ----------------------------------------------------------

  PerguntaModel? _responderAreaPratica(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['candidato_1'], 2);
      alterarPontuacao(['candidato_2'], -1);
      return _definirProxima(PerguntasData.codigoPratico);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['candidato_1'], 1);
      return _definirProxima(PerguntasData.laboratorio);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['candidato_1'], -2);
      alterarPontuacao(['candidato_2'], 1);
      return _definirProxima(PerguntasData.slides);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['candidato_1'], -1);
      return _definirProxima(PerguntasData.quadro);
    } else {
      // Não sei: não altera pontuação e segue para pergunta neutra.
      return _definirProxima(PerguntasData.mercado);
    }
  }

  PerguntaModel? _responderProgramacao(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['candidato_1'], 2);
      alterarPontuacao(['candidato_2', 'candidato_3'], -1);
      return _definirProxima(PerguntasData.ferramentas);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['candidato_1'], 1);
      return _definirProxima(PerguntasData.codigoPratico);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['candidato_1'], -2);
      alterarPontuacao(['candidato_2', 'candidato_3'], 1);
      return _definirProxima(PerguntasData.gestao);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['candidato_1'], -1);
      return _definirProxima(PerguntasData.diagramas);
    } else {
      return _definirProxima(PerguntasData.slides);
    }
  }

  PerguntaModel? _responderCodigoPratico(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['candidato_1'], 2);
      alterarPontuacao(['candidato_2'], -1);
      return _definirProxima(PerguntasData.programacao);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['candidato_1'], 1);
      return _definirProxima(PerguntasData.ferramentas);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['candidato_1'], -2);
      alterarPontuacao(['candidato_2'], 1);
      return _definirProxima(PerguntasData.quadro);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['candidato_1'], -1);
      return _definirProxima(PerguntasData.passoAPasso);
    } else {
      return _definirProxima(PerguntasData.exercicios);
    }
  }

  PerguntaModel? _responderBancoDados(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['candidato_3'], 2);
      alterarPontuacao(['candidato_1'], -1);
      return _definirProxima(PerguntasData.diagramas);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['candidato_3'], 1);
      return _definirProxima(PerguntasData.quadro);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['candidato_3'], -2);
      alterarPontuacao(['candidato_1'], 1);
      return _definirProxima(PerguntasData.programacao);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['candidato_3'], -1);
      return _definirProxima(PerguntasData.mercado);
    } else {
      return _definirProxima(PerguntasData.organizacao);
    }
  }

  PerguntaModel? _responderLaboratorio(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['candidato_1'], 2);
      alterarPontuacao(['candidato_2'], -1);
      return _definirProxima(PerguntasData.ferramentas);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['candidato_1'], 1);
      return _definirProxima(PerguntasData.projetos);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['candidato_1'], -2);
      alterarPontuacao(['candidato_2'], 1);
      return _definirProxima(PerguntasData.slides);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['candidato_1'], -1);
      return _definirProxima(PerguntasData.exercicios);
    } else {
      return _definirProxima(PerguntasData.trabalhoGrupo);
    }
  }

  PerguntaModel? _responderSlides(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['candidato_2'], 2);
      alterarPontuacao(['candidato_1'], -1);
      return _definirProxima(PerguntasData.mercado);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['candidato_2'], 1);
      return _definirProxima(PerguntasData.gestao);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['candidato_2'], -2);
      alterarPontuacao(['candidato_1'], 1);
      return _definirProxima(PerguntasData.quadro);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['candidato_2'], -1);
      return _definirProxima(PerguntasData.codigoPratico);
    } else {
      return _definirProxima(PerguntasData.passoAPasso);
    }
  }

  PerguntaModel? _responderQuadro(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['candidato_3'], 2);
      alterarPontuacao(['candidato_2'], -1);
      return _definirProxima(PerguntasData.exercicios);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['candidato_3'], 1);
      return _definirProxima(PerguntasData.passoAPasso);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['candidato_3'], -2);
      alterarPontuacao(['candidato_2'], 1);
      return _definirProxima(PerguntasData.slides);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['candidato_3'], -1);
      return _definirProxima(PerguntasData.bancoDados);
    } else {
      return _definirProxima(PerguntasData.diagramas);
    }
  }

  PerguntaModel? _responderMercado(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['candidato_2'], 2);
      alterarPontuacao(['candidato_3'], -1);
      return _definirProxima(PerguntasData.gestao);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['candidato_2'], 1);
      return _definirProxima(PerguntasData.projetos);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['candidato_2'], -2);
      alterarPontuacao(['candidato_3'], 1);
      return _definirProxima(PerguntasData.exercicios);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['candidato_2'], -1);
      return _definirProxima(PerguntasData.bancoDados);
    } else {
      return _definirProxima(PerguntasData.trabalhoGrupo);
    }
  }

  PerguntaModel? _responderProjetos(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['candidato_1', 'candidato_2'], 2);
      alterarPontuacao(['candidato_3'], -1);
      return _definirProxima(PerguntasData.trabalhoGrupo);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['candidato_1', 'candidato_2'], 1);
      return _definirProxima(PerguntasData.organizacao);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['candidato_1', 'candidato_2'], -2);
      alterarPontuacao(['candidato_3'], 1);
      return _definirProxima(PerguntasData.exercicios);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['candidato_1', 'candidato_2'], -1);
      return _definirProxima(PerguntasData.passoAPasso);
    } else {
      return _definirProxima(PerguntasData.gestao);
    }
  }

  PerguntaModel? _responderOrganizacao(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['candidato_2', 'candidato_3'], 2);
      return _definirProxima(PerguntasData.gestao);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['candidato_2', 'candidato_3'], 1);
      return _definirProxima(PerguntasData.trabalhoGrupo);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['candidato_2', 'candidato_3'], -2);
      return _definirProxima(PerguntasData.laboratorio);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['candidato_2', 'candidato_3'], -1);
      return _definirProxima(PerguntasData.projetos);
    } else {
      return _definirProxima(PerguntasData.passoAPasso);
    }
  }

  PerguntaModel? _responderDiagramas(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['candidato_3'], 2);
      alterarPontuacao(['candidato_1'], -1);
      return _definirProxima(PerguntasData.bancoDados);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['candidato_3'], 1);
      return _definirProxima(PerguntasData.gestao);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['candidato_3'], -2);
      alterarPontuacao(['candidato_1'], 1);
      return _definirProxima(PerguntasData.codigoPratico);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['candidato_3'], -1);
      return _definirProxima(PerguntasData.exercicios);
    } else {
      return _definirProxima(PerguntasData.quadro);
    }
  }

  PerguntaModel? _responderPassoAPasso(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['candidato_3'], 2);
      return _definirProxima(PerguntasData.exercicios);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['candidato_3'], 1);
      return _definirProxima(PerguntasData.quadro);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['candidato_3'], -2);
      return _definirProxima(PerguntasData.projetos);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['candidato_3'], -1);
      return _definirProxima(PerguntasData.laboratorio);
    } else {
      return _definirProxima(PerguntasData.slides);
    }
  }

  PerguntaModel? _responderExercicios(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['candidato_1', 'candidato_3'], 2);
      return _definirProxima(PerguntasData.passoAPasso);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['candidato_1', 'candidato_3'], 1);
      return _definirProxima(PerguntasData.quadro);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['candidato_1', 'candidato_3'], -2);
      return _definirProxima(PerguntasData.projetos);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['candidato_1', 'candidato_3'], -1);
      return _definirProxima(PerguntasData.trabalhoGrupo);
    } else {
      return _definirProxima(PerguntasData.mercado);
    }
  }

  PerguntaModel? _responderGestao(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['candidato_2'], 2);
      alterarPontuacao(['candidato_1'], -1);
      return _definirProxima(PerguntasData.organizacao);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['candidato_2'], 1);
      return _definirProxima(PerguntasData.mercado);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['candidato_2'], -2);
      alterarPontuacao(['candidato_1'], 1);
      return _definirProxima(PerguntasData.programacao);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['candidato_2'], -1);
      return _definirProxima(PerguntasData.ferramentas);
    } else {
      return _definirProxima(PerguntasData.projetos);
    }
  }

  PerguntaModel? _responderFerramentas(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['candidato_1'], 2);
      alterarPontuacao(['candidato_2'], -1);
      return _definirProxima(PerguntasData.programacao);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['candidato_1'], 1);
      return _definirProxima(PerguntasData.codigoPratico);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['candidato_1'], -2);
      alterarPontuacao(['candidato_2'], 1);
      return _definirProxima(PerguntasData.slides);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['candidato_1'], -1);
      return _definirProxima(PerguntasData.quadro);
    } else {
      return _definirProxima(PerguntasData.laboratorio);
    }
  }

  PerguntaModel? _responderTrabalhoGrupo(RespostaEnum resposta) {
    if (resposta == RespostaEnum.sim) {
      alterarPontuacao(['candidato_2'], 2);
      alterarPontuacao(['candidato_3'], -1);
      return _definirProxima(PerguntasData.projetos);
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      alterarPontuacao(['candidato_2'], 1);
      return _definirProxima(PerguntasData.organizacao);
    } else if (resposta == RespostaEnum.nao) {
      alterarPontuacao(['candidato_2'], -2);
      alterarPontuacao(['candidato_3'], 1);
      return _definirProxima(PerguntasData.passoAPasso);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      alterarPontuacao(['candidato_2'], -1);
      return _definirProxima(PerguntasData.exercicios);
    } else {
      return _definirProxima(PerguntasData.mercado);
    }
  }

  // ----------------------------------------------------------
  // Funções auxiliares
  // ----------------------------------------------------------

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

  // ----------------------------------------------------------
  // Resultado
  // ----------------------------------------------------------

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
