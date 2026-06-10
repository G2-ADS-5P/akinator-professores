import 'package:flutter_test/flutter_test.dart';
import 'package:profkinator_ads/controllers/game_controller.dart';
import 'package:profkinator_ads/data/perguntas_data.dart';
import 'package:profkinator_ads/models/resposta_enum.dart';

void main() {
  group('GameController - início de jogo', () {
    test('inicia com pontuações zeradas e pergunta inicial definida', () {
      final controller = GameController();

      expect(controller.perguntaAtual.id, 'programacao');
      expect(controller.quantidadePerguntasRespondidas, 0);
      expect(controller.jogoFinalizado, isFalse);
      for (final professor in controller.professores) {
        expect(professor.pontos, 0);
      }
    });

    test('possui pelo menos 8 professores cadastrados, com ids únicos', () {
      final controller = GameController();
      final ids = controller.professores.map((p) => p.id).toList();

      expect(ids.length, greaterThanOrEqualTo(8));
      expect(ids.toSet().length, ids.length);
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
      controller.alterarPontuacao(['prof_alan'], 3);

      for (final professor in controller.professores) {
        if (professor.id == 'prof_alan') {
          expect(professor.pontos, 3);
        } else {
          expect(professor.pontos, 0);
        }
      }
    });

    test('quem programa sobe e quem não programa desce ao responder Sim', () {
      final controller = GameController();
      // Pergunta inicial: programação.
      controller.responder(RespostaEnum.sim);

      final guilherme = controller.professores.firstWhere(
        (p) => p.id == 'prof_guilherme',
      );
      final marcel = controller.professores.firstWhere(
        (p) => p.id == 'prof_marcel',
      );

      expect(guilherme.pontos, greaterThan(0));
      expect(marcel.pontos, lessThan(0));
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
      final controller = GameController();
      for (final pergunta in PerguntasData.todas) {
        for (final professor in controller.professores) {
          // Verifica nome completo e cada parte do nome.
          for (final parte in professor.nome.split(' ')) {
            expect(
              pergunta.texto.toLowerCase().contains(parte.toLowerCase()),
              isFalse,
              reason:
                  'Pergunta "${pergunta.id}" cita o professor ${professor.nome}',
            );
          }
        }
      }
    });
  });

  group('GameController - resultado', () {
    test('calcularResultado retorna o candidato com mais pontos', () {
      final controller = GameController();
      controller.alterarPontuacao(['prof_leticia'], 10);

      expect(controller.calcularResultado().id, 'prof_leticia');
    });

    test('calcularTopTres retorna três candidatos ordenados', () {
      final controller = GameController();
      controller.alterarPontuacao(['prof_jhoni'], 5);
      controller.alterarPontuacao(['prof_marcos'], 2);

      final top = controller.calcularTopTres();
      expect(top.length, 3);
      expect(top[0].id, 'prof_jhoni');
      expect(top[1].id, 'prof_marcos');
      expect(top[0].pontos, greaterThanOrEqualTo(top[1].pontos));
      expect(top[1].pontos, greaterThanOrEqualTo(top[2].pontos));
    });

    test('confiança fica sempre entre 0 e 100', () {
      final controller = GameController();
      expect(controller.calcularConfianca(), inInclusiveRange(0, 100));

      controller.alterarPontuacao(['prof_hiago'], 100);
      expect(controller.calcularConfianca(), 100);
    });

    test('confiança cresce com a vantagem do primeiro colocado', () {
      final controller = GameController();
      final empatado = controller.calcularConfianca();

      controller.alterarPontuacao(['prof_hiago'], 2);
      final comVantagem = controller.calcularConfianca();

      expect(comVantagem, greaterThan(empatado));
    });

    test('cenário guiado: respostas sobre mobile levam ao professor certo', () {
      final controller = GameController();
      // Programação? Sim → web
      controller.responder(RespostaEnum.sim);
      // Web? Não → mobile
      controller.responder(RespostaEnum.nao);
      // Mobile? Sim → visual alternativo
      controller.responder(RespostaEnum.sim);
      // Visual marcante (cabelo colorido/tatuagens)? Sim
      controller.responder(RespostaEnum.sim);

      expect(controller.calcularResultado().id, 'prof_speck');
    });

    test(
      'cenário guiado: respostas sobre ágil/testes levam ao professor certo',
      () {
        final controller = GameController();
        // Programação? Não → ágil
        controller.responder(RespostaEnum.nao);
        // Ágil (Scrum/Kanban)? Sim → testes
        controller.responder(RespostaEnum.sim);
        // Testes de software? Sim
        controller.responder(RespostaEnum.sim);

        expect(controller.calcularResultado().id, 'prof_andre');
      },
    );
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
      expect(controller.perguntaAtual.id, 'programacao');
      for (final professor in controller.professores) {
        expect(professor.pontos, 0);
      }
    });
  });
}
