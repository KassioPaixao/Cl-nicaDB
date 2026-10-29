-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS ClinicaDB;
USE ClinicaDB;

-- =========================================================================
-- 1. TABELA CATEGORIA (Entidade Forte / Tabela Independente)
-- CONCEITO:
-- * Armazena as categorias nas quais os medicamentos se enquadram.
-- * Possui chave primária própria e atributo simples 'descrição'.
-- =========================================================================
CREATE TABLE Categoria (
-- idCategoria: Chave Primária (PK). Identificador único da categoria.
idCategoria INT UNSIGNED NOT NULL PRIMARY KEY,

-- descricao: Atributo simples que descreve o nome/tipo da categoria.
descricao VARCHAR(100) NOT NULL
);

-- =========================================================================
-- 2. TABELA PACIENTE (Entidade Forte)
-- CONCEITO:
-- * Representa os pacientes cadastrados no sistema.
-- * O CPF é um atributo candidato a chave, mantido aqui como único (UNIQUE).
-- * NOTA: O atributo multivalorado 'EMAILS' do DER é transformado em uma
--   tabela separada (Paciente_Email) para respeitar a 1ª Forma Normal (1FN).
-- =========================================================================
CREATE TABLE Paciente (
-- idPaciente: Chave Primária (PK) gerada para identificação interna do paciente.
idPaciente INT UNSIGNED NOT NULL PRIMARY KEY,

-- nome: Atributo simples/atômico obrigatório.
nome VARCHAR(125) NOT NULL,

-- cpf: Atributo identificador natural do paciente.
cpf VARCHAR(11) UNIQUE NOT NULL
);

-- =========================================================================
-- 2.1. TABELA PACIENTE_EMAIL (Mapeamento de Atributo Multivalorado)
-- CONCEITO:
-- * Como um paciente pode ter múltiplos e-mails, cria-se uma tabela associativa
--   para armazenar esses e-mails garantindo a integridade dos dados.
-- =========================================================================
CREATE TABLE Paciente_Email (
-- idPaciente (FK): Liga o e-mail ao seu respetivo paciente.
idPaciente INT UNSIGNED NOT NULL,

-- email: Endereço de e-mail do paciente.
email VARCHAR(100) NOT NULL,

-- Chave primária composta para impedir que o mesmo e-mail seja repetido para o mesmo paciente.
PRIMARY KEY (idPaciente, email),

-- Restrição de integridade referencial:
CONSTRAINT fk_paciente_email
FOREIGN KEY (idPaciente)
REFERENCES Paciente(idPaciente)
ON DELETE CASCADE
);

-- =========================================================================
-- 3. TABELA MEDICAMENTO (O Lado "N" do Relacionamento 1:N com Categoria)
-- CONCEITO DE MAPEAMENTO:
-- * No relacionamento 1:N com Categoria ("Uma Categoria possui N Medicamentos"),
--   a PK de Categoria viaja para Medicamento como Chave Estrangeira (FK).
-- =========================================================================
CREATE TABLE Medicamento (
-- idMedicamento: Identificador único do medicamento (PK).
idMedicamento INT UNSIGNED NOT NULL PRIMARY KEY,

-- dosagem: Informação sobre a dosagem do medicamento (ex: '500mg').
dosagem VARCHAR(50) NOT NULL,

-- valor: Preço unitário do medicamento.
valor DECIMAL(10, 2) NOT NULL,

-- idCategoria (FK): Liga o medicamento à sua categoria correspondente.
idCategoria INT UNSIGNED NOT NULL,

-- Restrição de integridade referencial:
CONSTRAINT fk_medicamento_categoria
FOREIGN KEY (idCategoria)
REFERENCES Categoria(idCategoria)
);

-- =========================================================================
-- 4. TABELA CONSULTA (O Lado "N" do Relacionamento 1:N com Paciente)
-- CONCEITO DE MAPEAMENTO:
-- * No relacionamento 1:N com Paciente ("Um Paciente realiza N Consultas"),
--   a PK de Paciente viaja para Consulta como Chave Estrangeira (FK).
-- * NOTA SOBRE 'VALOR_TOTAL': O atributo tracejado no DER representa um
--   atributo DERIVADO (calculado a partir da soma dos valores dos medicamentos).
--   Em um banco relacional, geralmente não se armazena atributos derivados,
--   mas ele pode ser adicionado/calculado via VIEW ou mantido para histórico.
-- =========================================================================
CREATE TABLE Consulta (
-- idConsulta: Identificador único da consulta (PK).
idConsulta INT UNSIGNED NOT NULL PRIMARY KEY,

-- dataHora: Armazena o momento (data e hora) em que a consulta é realizada.
dataHora DATETIME NOT NULL,

-- valorTotal: Atributo derivado armazenado para fins de histórico/desempenho.
valorTotal DECIMAL(10, 2) DEFAULT 0.00,

-- idPaciente (FK): Ponte que associa a consulta ao paciente atendido.
idPaciente INT UNSIGNED NOT NULL,

-- Restrição de integridade referencial:
CONSTRAINT fk_consulta_paciente
FOREIGN KEY (idPaciente)
REFERENCES Paciente(idPaciente)
);

-- =========================================================================
-- 5. TABELA CONS_MED / CONSULTA_MEDICAMENTO (Relacionamento N:M Associativo)
-- CONCEITO DE MAPEAMENTO:
-- * O relacionamento "CONS_MED" possui cardinalidade N:M entre Consulta e Medicamento.
-- * Para resolver esse relacionamento N:M, cria-se uma tabela associativa/intermediária
--   que herda as Chaves Primárias de ambas as tabelas como Chaves Estrangeiras (FKs),
--   formando juntas uma Chave Primária Composta.
-- =========================================================================
CREATE TABLE Cons_Med (
-- idConsulta (FK): Referência à consulta realizada.
idConsulta INT UNSIGNED NOT NULL,

-- idMedicamento (FK): Referência ao medicamento prescrito/usado na consulta.
idMedicamento INT UNSIGNED NOT NULL,

-- Chave primária composta garantindo a unicidade do par (Consulta, Medicamento).
PRIMARY KEY (idConsulta, idMedicamento),

-- Restrições de integridade referencial:
CONSTRAINT fk_consmed_consulta
FOREIGN KEY (idConsulta)
REFERENCES Consulta(idConsulta),

CONSTRAINT fk_consmed_medicamento
FOREIGN KEY (idMedicamento)
REFERENCES Medicamento(idMedicamento)
);