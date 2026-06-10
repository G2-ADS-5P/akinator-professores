import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../theme/app_colors.dart';

/// Widget reutilizável que exibe o personagem do jogo.
///
/// Todas as telas devem usar este widget. O caminho da imagem fica
/// centralizado em [AppAssets.character], então trocar o personagem
/// não exige nenhuma alteração nas telas.
class CharacterAvatar extends StatelessWidget {
  final double height;

  /// Quando true, desenha um brilho suave atrás do personagem.
  final bool comBrilho;

  const CharacterAvatar({super.key, this.height = 180, this.comBrilho = true});

  @override
  Widget build(BuildContext context) {
    final imagem = Image.asset(
      AppAssets.character,
      height: height,
      fit: BoxFit.contain,
      // Fallback amigável caso o asset seja removido por engano.
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.psychology_alt_rounded,
          size: height * 0.8,
          color: AppColors.gold,
        );
      },
    );

    if (!comBrilho) {
      return imagem;
    }

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.25),
            blurRadius: height * 0.35,
            spreadRadius: height * 0.05,
          ),
        ],
      ),
      child: imagem,
    );
  }
}
