import '../models/professor_model.dart';

/// ============================================================
/// PROFESSORES OFICIAIS DO CURSO DE ADS
/// ============================================================
/// Dados fornecidos pelo responsável do projeto em 10/06/2026.
/// As associações de pontuação ficam nos métodos _responderXxx
/// do GameController (blocos marcados como CALIBRAÇÃO).
///
/// Fotos: quando forem fornecidas, salvar em
/// assets/images/professores/, declarar a pasta no pubspec.yaml
/// e preencher o campo `foto` de cada professor abaixo.
/// Enquanto foto == null, o app mostra as iniciais do nome.
/// ============================================================
const _img = 'assets/images/';

List<ProfessorModel> criarProfessores() {
  return [
    ProfessorModel(id: 'prof_hiago',     nome: 'Hiago',           foto: '${_img}hiago.jpeg'),
    ProfessorModel(id: 'prof_alan',      nome: 'Alan'),
    ProfessorModel(id: 'prof_fabiane',   nome: 'Fabiane',         foto: '${_img}fabiane.jpeg'),
    ProfessorModel(id: 'prof_willian',   nome: 'Willian'),
    ProfessorModel(id: 'prof_wander',    nome: 'Wander'),
    ProfessorModel(id: 'prof_guilherme', nome: 'Guilherme Alves', foto: '${_img}guilherme.jpeg'),
    ProfessorModel(id: 'prof_jhoni',     nome: 'Jhoni'),
    ProfessorModel(id: 'prof_marcos',    nome: 'Marcos Guido',    foto: '${_img}marcos.jpeg'),
    ProfessorModel(id: 'prof_andre',     nome: 'André Dorr',      foto: '${_img}andre.jpeg'),
    ProfessorModel(id: 'prof_leticia',   nome: 'Letícia',         foto: '${_img}leticia.jpeg'),
    ProfessorModel(id: 'prof_speck',     nome: 'Jefferson Speck', foto: '${_img}jefferson_speck.jpeg'),
    ProfessorModel(id: 'prof_marcel',    nome: 'Marcel',          foto: '${_img}marcel.jpeg'),
    ProfessorModel(id: 'prof_renato',    nome: 'Renato'),
    ProfessorModel(id: 'prof_verspegel', nome: 'Jeferson Vorpagel', foto: '${_img}jeferson_vorpagel.jpeg'),
    ProfessorModel(id: 'prof_fabiano',   nome: 'Fabiano'),
  ];
}
