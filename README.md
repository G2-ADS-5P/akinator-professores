# Profkinator ADS (AKINATOR-G2-ADS)

Jogo mobile em Flutter inspirado no Akinator: o usuário pensa em um professor
do curso de ADS, responde perguntas neutras e o app tenta adivinhar em quem
ele está pensando.

> **Status: dados oficiais integrados.** Os 14 professores reais do curso
> estão cadastrados, com 20 perguntas neutras e lógica calibrada a partir
> das informações fornecidas pelo grupo (10/06/2026). Pendências: fotos dos
> professores e refinamento da calibração conforme novas informações.

## Como rodar

```bash
flutter pub get
flutter run            # dispositivo padrão
flutter run -d chrome  # no navegador
flutter run -d windows # desktop Windows
```

## Validação

```bash
flutter analyze
flutter test
```

## Estrutura

```text
lib/
├── main.dart
├── app/profkinator_app.dart        # MaterialApp + tema
├── core/
│   ├── constants/app_assets.dart   # caminho ÚNICO da imagem do personagem
│   ├── theme/app_colors.dart       # paleta de cores
│   └── widgets/
│       ├── answer_button.dart      # botão das 5 respostas obrigatórias
│       └── character_avatar.dart   # widget reutilizável do personagem
├── data/
│   ├── professores_data.dart       # 14 professores oficiais do curso
│   └── perguntas_data.dart         # 20 perguntas neutras
├── controllers/game_controller.dart # lógica do jogo com if / else
└── pages/
    ├── home_page.dart
    ├── question_page.dart
    └── result_page.dart
assets/images/character_placeholder.png
```

## Como trocar o personagem

Basta **substituir o arquivo** `assets/images/character_placeholder.png`
(mantendo o nome) ou **alterar a constante** `AppAssets.character` em
`lib/core/constants/app_assets.dart`. Nenhuma tela precisa ser editada:
todas usam o widget `CharacterAvatar`.

## Como adicionar as fotos dos professores

1. Salvar as imagens em `assets/images/professores/` (ex.: `hiago.png`).
2. Declarar a pasta no `pubspec.yaml` (`- assets/images/professores/`).
3. Preencher o campo `foto` de cada professor em
   `lib/data/professores_data.dart`.
4. Enquanto `foto == null`, o resultado mostra as iniciais do nome.

## Como recalibrar a lógica

As associações de pontuação ficam nos métodos `_responderXxx` do
`lib/controllers/game_controller.dart` (blocos marcados como "CALIBRAÇÃO"),
e os grupos auxiliares (óculos, estilo, programação) no topo da classe.
Após qualquer ajuste, rodar `flutter analyze` e `flutter test`.

## Regras do jogo

- 5 respostas obrigatórias: Sim, Não, Não sei, Provavelmente sim, Provavelmente não.
- Cada resposta altera a pontuação dos candidatos (+2 / +1 / 0 / -1 / -2) e
  define dinamicamente a próxima pergunta, sem repetição.
- A partida termina após 12 perguntas (ou quando acabam as perguntas úteis).
- O resultado mostra o palpite, a confiança e o top 3.

Documentação completa: `AGENTS.md`, `CONTEXT.md`, `DEVELOPMENT_GUIDE.md`,
`GAME_LOGIC.md`, `PROMPTS_CODEAGENTS.md` e `README_IDEACAO.md`.
