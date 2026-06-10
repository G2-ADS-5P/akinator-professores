import 'package:flutter_test/flutter_test.dart';
import 'package:profkinator_ads/app/profkinator_app.dart';
import 'package:profkinator_ads/controllers/game_controller.dart';

void main() {
  // Obs.: a HomePage tem uma animação contínua de flutuação,
  // então os testes usam pump com duração em vez de pumpAndSettle.
  Future<void> avancarFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
  }

  // Garante que o widget esteja visível na tela antes de tocar
  // (a superfície de teste tem 800x600 e as telas são roláveis).
  Future<void> tocar(WidgetTester tester, String texto) async {
    await tester.ensureVisible(find.text(texto));
    await tester.pump();
    await tester.tap(find.text(texto));
  }

  testWidgets('tela inicial exibe título, explicação e botão Começar', (
    tester,
  ) async {
    await tester.pumpWidget(const ProfkinatorApp());

    expect(find.text('Profkinator ADS'), findsOneWidget);
    expect(find.textContaining('Pense em um professor'), findsOneWidget);
    expect(find.text('Começar'), findsOneWidget);
  });

  testWidgets('começar abre a tela de perguntas com as cinco respostas', (
    tester,
  ) async {
    await tester.pumpWidget(const ProfkinatorApp());

    await tocar(tester, 'Começar');
    await avancarFrames(tester);

    expect(find.text('Pergunta 1 de 10'), findsOneWidget);
    expect(find.text('Sim'), findsOneWidget);
    expect(find.text('Não'), findsOneWidget);
    expect(find.text('Não sei'), findsOneWidget);
    expect(find.text('Provavelmente sim'), findsOneWidget);
    expect(find.text('Provavelmente não'), findsOneWidget);
  });

  testWidgets('responder avança o contador e troca a pergunta', (tester) async {
    await tester.pumpWidget(const ProfkinatorApp());

    await tocar(tester, 'Começar');
    await avancarFrames(tester);

    await tocar(tester, 'Sim');
    await avancarFrames(tester);

    expect(find.text('Pergunta 2 de 10'), findsOneWidget);
  });

  testWidgets('fluxo completo chega ao resultado e permite jogar novamente', (
    tester,
  ) async {
    await tester.pumpWidget(const ProfkinatorApp());

    await tocar(tester, 'Começar');
    await avancarFrames(tester);

    // Responde todas as perguntas até o fim do jogo.
    for (var i = 0; i < GameController.limitePerguntas; i++) {
      await tocar(tester, 'Sim');
      await avancarFrames(tester);
    }

    // Tela de resultado com palpite, confiança e top 3.
    expect(find.text('Meu palpite é:'), findsOneWidget);
    expect(find.textContaining('Confiança:'), findsOneWidget);
    expect(find.text('Outras possibilidades'), findsOneWidget);
    expect(find.text('Acertou'), findsOneWidget);
    expect(find.text('Errou'), findsOneWidget);
    expect(find.text('Jogar novamente'), findsOneWidget);

    // Jogar novamente reinicia a partida do zero.
    await tocar(tester, 'Jogar novamente');
    await avancarFrames(tester);

    expect(find.text('Pergunta 1 de 10'), findsOneWidget);
  });
}
