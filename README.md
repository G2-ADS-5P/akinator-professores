# Profkinator ADS (AKINATOR-G2-ADS)

Jogo mobile em Flutter inspirado no Akinator: o usuário pensa em um professor
do curso de ADS, responde perguntas neutras e o app tenta adivinhar em quem
ele está pensando.

> **Status: MVP estrutural.** Todo o fluxo funciona com candidatos fictícios
> (`Professor 1`, `Professor 2`, `Professor 3`). Os dados reais dos professores
> serão cadastrados e calibrados somente na etapa final, após o envio das
> informações oficiais pelo responsável do projeto.

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
│   ├── professores_data.dart       # candidatos FICTÍCIOS (ponto de integração)
│   └── perguntas_data.dart         # 16 perguntas neutras
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

## Como integrar os professores reais (etapa final)

1. Substituir a lista fictícia em `lib/data/professores_data.dart`.
2. Calibrar as associações de pontuação nos métodos `_responderXxx` do
   `lib/controllers/game_controller.dart` (os blocos estão marcados como
   "PONTO DE INTEGRAÇÃO FINAL").
3. Revisar perguntas e associações conforme as regras éticas do projeto.
4. Rodar novamente `flutter analyze` e `flutter test`.

## Regras do jogo

- 5 respostas obrigatórias: Sim, Não, Não sei, Provavelmente sim, Provavelmente não.
- Cada resposta altera a pontuação dos candidatos (+2 / +1 / 0 / -1 / -2) e
  define dinamicamente a próxima pergunta, sem repetição.
- A partida termina após 10 perguntas (ou quando acabam as perguntas úteis).
- O resultado mostra o palpite, a confiança e o top 3.

Documentação completa: `AGENTS.md`, `CONTEXT.md`, `DEVELOPMENT_GUIDE.md`,
`GAME_LOGIC.md`, `PROMPTS_CODEAGENTS.md` e `README_IDEACAO.md`.
