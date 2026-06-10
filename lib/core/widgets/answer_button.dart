import 'package:flutter/material.dart';

import '../../models/resposta_enum.dart';
import '../theme/app_colors.dart';

/// Botão reutilizável para as cinco respostas obrigatórias do jogo.
class AnswerButton extends StatelessWidget {
  final RespostaEnum resposta;
  final VoidCallback onPressed;

  const AnswerButton({
    super.key,
    required this.resposta,
    required this.onPressed,
  });

  /// Cor de destaque de cada resposta, mantendo boa legibilidade.
  Color get _cor {
    if (resposta == RespostaEnum.sim) {
      return AppColors.success;
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      return const Color(0xFF40916C);
    } else if (resposta == RespostaEnum.naoSei) {
      return const Color(0xFF6C757D);
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      return const Color(0xFFB5544D);
    } else {
      return AppColors.danger;
    }
  }

  IconData get _icone {
    if (resposta == RespostaEnum.sim) {
      return Icons.check_circle_rounded;
    } else if (resposta == RespostaEnum.provavelmenteSim) {
      return Icons.thumb_up_alt_rounded;
    } else if (resposta == RespostaEnum.naoSei) {
      return Icons.help_rounded;
    } else if (resposta == RespostaEnum.provavelmenteNao) {
      return Icons.thumb_down_alt_rounded;
    } else {
      return Icons.cancel_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(_icone, size: 20),
        label: Text(
          resposta.label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: _cor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
