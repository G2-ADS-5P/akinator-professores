import 'package:flutter/material.dart';

import '../controllers/game_controller.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/character_avatar.dart';
import 'question_page.dart';

/// Tela inicial: apresenta o jogo e inicia a partida.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flutuacao;

  @override
  void initState() {
    super.initState();
    // Animação suave de flutuação do personagem.
    _flutuacao = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _flutuacao.dispose();
    super.dispose();
  }

  void _comecarJogo() {
    final controller = GameController();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => QuestionPage(controller: controller)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _flutuacao,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, -8 * _flutuacao.value),
                          child: child,
                        );
                      },
                      child: const CharacterAvatar(height: 250),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Profkinator ADS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'O gênio que adivinha professores',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.gold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                        ),
                      ),
                      child: const Text(
                        'Pense em um professor do curso de ADS. '
                        'Responda às perguntas e o app tentará adivinhar '
                        'em quem você está pensando.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _comecarJogo,
                        icon: const Icon(Icons.auto_awesome_rounded),
                        label: const Text(
                          'Começar',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          foregroundColor: const Color(0xFF3C096C),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Projeto acadêmico — sem coleta de dados',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
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
