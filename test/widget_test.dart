import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profkinator_ads/app/profkinator_app.dart';

void main() {
  // Obs.: a HomePage tem uma animação contínua de flutuação,
  // então os testes usam pump com duração em vez de pumpAndSettle.
  Future<void> avancarFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
  }

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

    expect(find.text('Sim'), findsOneWidget);
    expect(find.text('Não'), findsOneWidget);
    expect(find.text('Não sei'), findsOneWidget);
    expect(find.text('Provavelmente sim'), findsOneWidget);
    expect(find.text('Provavelmente não'), findsOneWidget);
    expect(find.textContaining('Certeza:'), findsOneWidget);
  });

  testWidgets('responder troca a pergunta exibida', (tester) async {
    await tester.pumpWidget(const ProfkinatorApp());

    await tocar(tester, 'Começar');
    await avancarFrames(tester);

    // Captura o texto da primeira pergunta.
    final textoAntes = (tester
            .widget<Text>(
              find
                  .descendant(
                    of: find.byType(AnimatedSwitcher),
                    matching: find.byType(Text),
                  )
                  .first,
            )
            .data) ??
        '';

    await tocar(tester, 'Não sei');
    await avancarFrames(tester);

    // Após responder, a pergunta na tela deve ter mudado.
    final textoDepois = (tester
            .widget<Text>(
              find
                  .descendant(
                    of: find.byType(AnimatedSwitcher),
                    matching: find.byType(Text),
                  )
                  .first,
            )
            .data) ??
        '';

    expect(textoDepois, isNot(equals(textoAntes)));
  });

  testWidgets('fluxo completo chega ao resultado e permite jogar novamente', (
    tester,
  ) async {
    await tester.pumpWidget(const ProfkinatorApp());

    await tocar(tester, 'Começar');
    await avancarFrames(tester);

    // Responde "Não sei" até o jogo terminar (esgota perguntas sem atingir 70%).
    for (var i = 0; i < 25; i++) {
      if (find.text('Não sei').evaluate().isEmpty) break;
      await tocar(tester, 'Não sei');
      await avancarFrames(tester);
    }

    expect(find.text('Meu palpite é:'), findsOneWidget);
    expect(find.textContaining('Confiança:'), findsOneWidget);
    expect(find.text('Outras possibilidades'), findsOneWidget);
    expect(find.text('Acertou'), findsOneWidget);
    expect(find.text('Errou'), findsOneWidget);
    expect(find.text('Jogar novamente'), findsOneWidget);

    await tocar(tester, 'Jogar novamente');
    await avancarFrames(tester);

    expect(find.text('Sim'), findsOneWidget);
    expect(find.textContaining('Certeza:'), findsOneWidget);
  });
}
