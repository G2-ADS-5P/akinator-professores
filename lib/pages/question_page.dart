import 'package:flutter/material.dart';

import '../controllers/game_controller.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/answer_button.dart';
import '../core/widgets/character_avatar.dart';
import '../models/resposta_enum.dart';
import 'result_page.dart';

/// Tela de perguntas: exibe a pergunta atual e as cinco respostas.
class QuestionPage extends StatefulWidget {
  final GameController controller;

  const QuestionPage({super.key, required this.controller});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  GameController get controller => widget.controller;

  void _responder(RespostaEnum resposta) {
    final proximaPergunta = controller.responder(resposta);

    if (proximaPergunta == null) {
      // Fim de jogo: navega para o resultado.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ResultPage(controller: controller)),
      );
    } else {
      // Continua o jogo com a nova pergunta.
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final numeroPergunta = controller.quantidadePerguntasRespondidas + 1;
    const total = GameController.limitePerguntas;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradient),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    // Contador + barra de progresso
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Pergunta $numeroPergunta de $total',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value:
                                  controller.quantidadePerguntasRespondidas /
                                  total,
                              minHeight: 8,
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.2,
                              ),
                              valueColor: const AlwaysStoppedAnimation(
                                AppColors.gold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const CharacterAvatar(height: 210),
                    const SizedBox(height: 12),
                    // Balão da pergunta com animação de troca
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.15, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        key: ValueKey(controller.perguntaAtual.id),
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Text(
                          controller.perguntaAtual.texto,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // As cinco respostas obrigatórias
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (final resposta in [
                              RespostaEnum.sim,
                              RespostaEnum.provavelmenteSim,
                              RespostaEnum.naoSei,
                              RespostaEnum.provavelmenteNao,
                              RespostaEnum.nao,
                            ]) ...[
                              AnswerButton(
                                resposta: resposta,
                                onPressed: () => _responder(resposta),
                              ),
                              const SizedBox(height: 10),
                            ],
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
