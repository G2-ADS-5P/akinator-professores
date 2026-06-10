import 'package:flutter_test/flutter_test.dart';
import 'package:profkinator_ads/controllers/game_controller.dart';
import 'package:profkinator_ads/data/perguntas_data.dart';
import 'package:profkinator_ads/models/resposta_enum.dart';

void main() {
  group('GameController - início de jogo', () {
    test('inicia com pontuações zeradas e pergunta inicial definida', () {
      final controller = GameController();

      expect(controller.perguntaAtual.id, 'area_pratica');
      expect(controller.quantidadePerguntasRespondidas, 0);
      expect(controller.jogoFinalizado, isFalse);
      for (final professor in controller.professores) {
        expect(professor.pontos, 0);
      }
    });

    test('usa apenas candidatos fictícios no MVP', () {
      final controller = GameController();
      final ids = controller.professores.map((p) => p.id).toList();

      expect(ids, ['candidato_1', 'candidato_2', 'candidato_3']);
    });
  });

  group('GameController - respostas e pontuação', () {
    test('responder Sim altera pontuação dos candidatos', () {
      final controller = GameController();
      controller.responder(RespostaEnum.sim);

      final pontos = controller.professores.map((p) => p.pontos).toList();
      expect(pontos.any((p) => p != 0), isTrue);
    });

    test('responder Não sei não altera pontuação', () {
      final controller = GameController();
      controller.responder(RespostaEnum.naoSei);

      for (final professor in controller.professores) {
        expect(professor.pontos, 0);
      }
    });

    test('respostas diferentes levam a perguntas diferentes', () {
      final controllerSim = GameController();
      final controllerNao = GameController();

      final proximaSim = controllerSim.responder(RespostaEnum.sim);
      final proximaNao = controllerNao.responder(RespostaEnum.nao);

      expect(proximaSim, isNotNull);
      expect(proximaNao, isNotNull);
      expect(proximaSim!.id, isNot(proximaNao!.id));
    });

    test('alterarPontuacao soma pontos apenas nos ids informados', () {
      final controller = GameController();
      controller.alterarPontuacao(['candidato_2'], 3);

      expect(controller.professores[0].pontos, 0);
      expect(controller.professores[1].pontos, 3);
      expect(controller.professores[2].pontos, 0);
    });
  });

  group('GameController - fluxo da partida', () {
    test('não repete perguntas durante a partida', () {
      final controller = GameController();
      final vistas = <String>{controller.perguntaAtual.id};

      var proxima = controller.responder(RespostaEnum.sim);
      while (proxima != null) {
        expect(
          vistas.contains(proxima.id),
          isFalse,
          reason: 'Pergunta ${proxima.id} repetida',
        );
        vistas.add(proxima.id);
        proxima = controller.responder(RespostaEnum.sim);
      }
    });

    test('finaliza após o limite de perguntas', () {
      final controller = GameController();

      for (var i = 0; i < GameController.limitePerguntas - 1; i++) {
        expect(controller.responder(RespostaEnum.provavelmenteSim), isNotNull);
      }
      // A última resposta encerra o jogo.
      expect(controller.responder(RespostaEnum.provavelmenteSim), isNull);
      expect(controller.jogoFinalizado, isTrue);
      expect(
        controller.quantidadePerguntasRespondidas,
        GameController.limitePerguntas,
      );
    });

    test('existem pelo menos 15 perguntas neutras cadastradas', () {
      expect(PerguntasData.todas.length, greaterThanOrEqualTo(15));
    });

    test('nenhuma pergunta cita nomes de professores', () {
      for (final pergunta in PerguntasData.todas) {
        expect(pergunta.texto.contains('Professor 1'), isFalse);
        expect(pergunta.texto.contains('Professor 2'), isFalse);
        expect(pergunta.texto.contains('Professor 3'), isFalse);
      }
    });
  });

  group('GameController - resultado', () {
    test('calcularResultado retorna o candidato com mais pontos', () {
      final controller = GameController();
      controller.alterarPontuacao(['candidato_3'], 10);

      expect(controller.calcularResultado().id, 'candidato_3');
    });

    test('calcularTopTres retorna três candidatos ordenados', () {
      final controller = GameController();
      controller.alterarPontuacao(['candidato_2'], 5);
      controller.alterarPontuacao(['candidato_3'], 2);

      final top = controller.calcularTopTres();
      expect(top.length, 3);
      expect(top[0].id, 'candidato_2');
      expect(top[1].id, 'candidato_3');
      expect(top[2].id, 'candidato_1');
    });

    test('confiança fica sempre entre 0 e 100', () {
      final controller = GameController();
      expect(controller.calcularConfianca(), inInclusiveRange(0, 100));

      controller.alterarPontuacao(['candidato_1'], 100);
      expect(controller.calcularConfianca(), 100);
    });

    test('confiança cresce com a vantagem do primeiro colocado', () {
      final controller = GameController();
      final empatado = controller.calcularConfianca();

      controller.alterarPontuacao(['candidato_1'], 2);
      final comVantagem = controller.calcularConfianca();

      expect(comVantagem, greaterThan(empatado));
    });
  });

  group('GameController - reiniciar', () {
    test('iniciarJogo zera todo o estado da partida', () {
      final controller = GameController();
      controller.responder(RespostaEnum.sim);
      controller.responder(RespostaEnum.nao);

      controller.iniciarJogo();

      expect(controller.quantidadePerguntasRespondidas, 0);
      expect(controller.perguntasRespondidas, isEmpty);
      expect(controller.jogoFinalizado, isFalse);
      expect(controller.perguntaAtual.id, 'area_pratica');
      for (final professor in controller.professores) {
        expect(professor.pontos, 0);
      }
    });
  });
}
