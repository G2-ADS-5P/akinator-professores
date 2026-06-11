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
List<ProfessorModel> criarProfessores() {
  return [
    // Gestão de Projetos / Métodos Ágeis & PI
    ProfessorModel(id: 'prof_hiago', nome: 'Hiago'),
    // Engenharia de Requisitos
    ProfessorModel(id: 'prof_alan', nome: 'Alan'),
    // Desenvolvimento Desktop (C/C++, lógica) — coordenadora
    ProfessorModel(id: 'prof_fabiane', nome: 'Fabiane'),
    // Sites básicos & Banco de Dados (Python, Django)
    ProfessorModel(id: 'prof_willian', nome: 'Willian'),
    // Manutenção de Computadores (hardware, Arduino)
    ProfessorModel(id: 'prof_wander', nome: 'Wander'),
    // UX/UI & Sites Dinâmicos (JavaScript)
    ProfessorModel(id: 'prof_guilherme', nome: 'Guilherme Alves'),
    // POO & UML (Java)
    ProfessorModel(id: 'prof_jhoni', nome: 'Jhoni'),
    // Redes e infraestrutura (C/C++ com ponteiros)
    ProfessorModel(id: 'prof_marcos', nome: 'Marcos Guido'),
    // Teste de Software & PI
    ProfessorModel(id: 'prof_andre', nome: 'André Dorr'),
    // Versionamento, Virtualização & Segurança
    ProfessorModel(id: 'prof_leticia', nome: 'Letícia'),
    // Mobile (Dart e Flutter)
    ProfessorModel(id: 'prof_speck', nome: 'Jefferson Speck'),
    // Empreendedorismo (eletiva, aulas em inglês)
    ProfessorModel(id: 'prof_marcel', nome: 'Marcel'),
    // Projeto Integrador
    ProfessorModel(id: 'prof_renato', nome: 'Renato'),
    // Tecnologias Emergentes & IA
    ProfessorModel(id: 'prof_verspegel', nome: 'Jeferson Vorpagel'),
    // Programação / Algoritmos e Banco de Dados
    ProfessorModel(id: 'prof_fabiano', nome: 'Fabiano'),
  ];
}
