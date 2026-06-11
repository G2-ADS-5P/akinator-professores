import 'package:flutter_test/flutter_test.dart';
import 'package:profkinator_ads/controllers/game_controller.dart';
import 'package:profkinator_ads/data/perguntas_data.dart';
import 'package:profkinator_ads/models/resposta_enum.dart';

void main() {
  group('GameController - início de jogo', () {
    test('inicia com pontuações zeradas e uma pergunta definida', () {
      final controller = GameController();

      expect(controller.perguntaAtual, isNotNull);
      expect(controller.quantidadePerguntasRespondidas, 0);
      expect(controller.jogoFinalizado, isFalse);
      for (final professor in controller.professores) {
        expect(professor.pontos, 0);
      }
    });

    test('possui pelo menos 15 professores cadastrados, com ids únicos', () {
      final controller = GameController();
      final ids = controller.professores.map((p) => p.id).toList();

      expect(ids.length, greaterThanOrEqualTo(15));
      expect(ids.toSet().length, ids.length);
    });

    test('a pergunta inicial pertence ao banco de perguntas cadastrado', () {
      final controller = GameController();
      final idsValidos = PerguntasData.todas.map((p) => p.id).toSet();
      expect(idsValidos.contains(controller.perguntaAtual.id), isTrue);
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

    test('pontuação positiva sobe probabilidade; negativa desce', () {
      final controller = GameController();

      final probsIniciais = controller.calcularProbabilidades();
      final probInicial = probsIniciais['prof_hiago']!;

      controller.alterarPontuacao(['prof_hiago'], 5);
      final probsAltas = controller.calcularProbabilidades();
      expect(probsAltas['prof_hiago'], greaterThan(probInicial));

      controller.alterarPontuacao(['prof_hiago'], -10);
      final probsBaixas = controller.calcularProbabilidades();
      expect(probsBaixas['prof_hiago'], lessThan(probInicial));
    });
  });

  group('GameController - fluxo da partida', () {
    test('não repete perguntas durante a partida', () {
      final controller = GameController();
      final vistas = <String>{controller.perguntaAtual.id};

      var proxima = controller.responder(RespostaEnum.naoSei);
      while (proxima != null) {
        expect(
          vistas.contains(proxima.id),
          isFalse,
          reason: 'Pergunta ${proxima.id} repetida',
        );
        vistas.add(proxima.id);
        proxima = controller.responder(RespostaEnum.naoSei);
      }
    });

    test('finaliza quando todas as perguntas são esgotadas', () {
      final controller = GameController();

      // "Não sei" não altera pontuação, então nenhum professor chega a 70%.
      // O jogo deve terminar quando não houver mais perguntas disponíveis.
      var proxima = controller.responder(RespostaEnum.naoSei);
      while (proxima != null) {
        proxima = controller.responder(RespostaEnum.naoSei);
      }

      expect(controller.jogoFinalizado, isTrue);
      expect(
        controller.quantidadePerguntasRespondidas,
        equals(PerguntasData.todas.length),
      );
    });

    test('finaliza cedo quando professor atinge 70% de probabilidade', () {
      final controller = GameController();

      // Força pontuação altíssima para um único professor.
      controller.alterarPontuacao(['prof_leticia'], 20);
      final probs = controller.calcularProbabilidades();

      expect(probs['prof_leticia'], greaterThanOrEqualTo(0.70));
    });

    test('existem pelo menos 15 perguntas neutras cadastradas', () {
      expect(PerguntasData.todas.length, greaterThanOrEqualTo(15));
    });

    test('nenhuma pergunta cita nomes de professores', () {
      final controller = GameController();
      for (final pergunta in PerguntasData.todas) {
        for (final professor in controller.professores) {
          for (final parte in professor.nome.split(' ')) {
            if (parte.length < 3) continue; // ignora partículas curtas
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
      expect(controller.calcularConfianca(), inInclusiveRange(0, 100));
    });

    test('confiança cresce com a vantagem do primeiro colocado', () {
      final controller = GameController();
      final empatado = controller.calcularConfianca();

      controller.alterarPontuacao(['prof_hiago'], 5);
      final comVantagem = controller.calcularConfianca();

      expect(comVantagem, greaterThan(empatado));
    });

    test('cenário: pontos de mobile identificam prof_speck', () {
      final controller = GameController();
      // Simula as pontuações acumuladas por quem respondeu:
      // programação:sim, web:não, mobile:sim, visual_alternativo:sim
      controller.alterarPontuacao(GameController.idsProgramacao, 2);
      controller.alterarPontuacao(['prof_willian', 'prof_guilherme'], -2);
      controller.alterarPontuacao(['prof_fabiane', 'prof_speck'], 1);
      controller.alterarPontuacao(['prof_speck'], 2);
      controller.alterarPontuacao(['prof_speck'], 2);

      expect(controller.calcularResultado().id, 'prof_speck');
    });

    test('cenário: pontos de ágil+testes identificam prof_andre', () {
      final controller = GameController();
      controller.alterarPontuacao(GameController.idsProgramacao, -2);
      controller.alterarPontuacao(GameController.idsNaoProgramacao, 1);
      controller.alterarPontuacao(['prof_hiago', 'prof_andre'], 2);
      controller.alterarPontuacao(['prof_alan', 'prof_marcel'], -1);
      controller.alterarPontuacao(['prof_andre'], 2);
      controller.alterarPontuacao(['prof_hiago'], -1);

      expect(controller.calcularResultado().id, 'prof_andre');
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
      expect(controller.perguntaAtual, isNotNull);
      for (final professor in controller.professores) {
        expect(professor.pontos, 0);
      }
    });
  });
}
