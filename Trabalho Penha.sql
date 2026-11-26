CREATE DATABASE IF NOT EXISTS ClinicaDB;
USE ClinicaDB;

-- 1. Categoria
CREATE TABLE Categoria (
    idCategoria INT UNSIGNED NOT NULL PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL UNIQUE,
    tarja VARCHAR(20) NOT NULL DEFAULT 'Sem Tarja',
    dataCadastro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_categoria_tarja CHECK (tarja IN ('Sem Tarja', 'Tarja Amarela', 'Tarja Vermelha', 'Tarja Preta'))
);

-- 2. Fabricante
CREATE TABLE Fabricante (
    idFabricante INT UNSIGNED NOT NULL PRIMARY KEY,
    nomeFantasia VARCHAR(120) NOT NULL,
    cnpj CHAR(14) NOT NULL UNIQUE,
    paisOrigem VARCHAR(60) NOT NULL DEFAULT 'Brasil'
);

-- 3. Medicamento
CREATE TABLE Medicamento (
    idMedicamento INT UNSIGNED NOT NULL PRIMARY KEY,
    nomeComercial VARCHAR(120) NOT NULL,
    dosagem VARCHAR(50) NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    idCategoria INT UNSIGNED NOT NULL,
    idFabricante INT UNSIGNED NOT NULL,
    CONSTRAINT chk_medicamento_valor CHECK (valor >= 0.00),
    CONSTRAINT fk_medicamento_categoria FOREIGN KEY (idCategoria) REFERENCES Categoria(idCategoria),
    CONSTRAINT fk_medicamento_fabricante FOREIGN KEY (idFabricante) REFERENCES Fabricante(idFabricante)
);

-- 4. Paciente
CREATE TABLE Paciente (
    idPaciente INT UNSIGNED NOT NULL PRIMARY KEY,
    nome VARCHAR(125) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    dataNascimento DATE NOT NULL,
    sexo CHAR(1) NOT NULL DEFAULT 'N',
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT chk_paciente_sexo CHECK (sexo IN ('M', 'F', 'O', 'N'))
);

-- 5. Paciente_Email (atributo multivalorado)
CREATE TABLE Paciente_Email (
    idEmail INT UNSIGNED NOT NULL PRIMARY KEY,
    idPaciente INT UNSIGNED NOT NULL,
    email VARCHAR(120) NOT NULL,
    principal BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT uq_paciente_email UNIQUE (idPaciente, email),
    CONSTRAINT fk_paciente_email FOREIGN KEY (idPaciente) REFERENCES Paciente(idPaciente) ON DELETE CASCADE
);

-- 6. Medico
CREATE TABLE Medico (
    idMedico INT UNSIGNED NOT NULL PRIMARY KEY,
    nome VARCHAR(125) NOT NULL,
    crm VARCHAR(20) NOT NULL UNIQUE,
    especialidade VARCHAR(80) NOT NULL,
    valorConsulta DECIMAL(10, 2) NOT NULL DEFAULT 150.00,
    CONSTRAINT chk_medico_valor_consulta CHECK (valorConsulta >= 0.00)
);

-- 7. Consulta
CREATE TABLE Consulta (
    idConsulta INT UNSIGNED NOT NULL PRIMARY KEY,
    idPaciente INT UNSIGNED NOT NULL,
    idMedico INT UNSIGNED NOT NULL,
    dataHora DATETIME NOT NULL,
    valorTotal DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    statusConsulta VARCHAR(20) NOT NULL DEFAULT 'Agendada',
    CONSTRAINT chk_consulta_valor_total CHECK (valorTotal >= 0.00),
    CONSTRAINT chk_consulta_status CHECK (statusConsulta IN ('Agendada', 'Em Andamento', 'Concluida', 'Cancelada')),
    CONSTRAINT fk_consulta_paciente FOREIGN KEY (idPaciente) REFERENCES Paciente(idPaciente),
    CONSTRAINT fk_consulta_medico FOREIGN KEY (idMedico) REFERENCES Medico(idMedico)
);

-- 8. Cons_Med (relação N:M)
CREATE TABLE Cons_Med (
    idConsulta INT UNSIGNED NOT NULL,
    idMedicamento INT UNSIGNED NOT NULL,
    quantidade INT UNSIGNED NOT NULL DEFAULT 1,
    posologia VARCHAR(150) NOT NULL DEFAULT 'Conforme orientacao medica',
    PRIMARY KEY (idConsulta, idMedicamento),
    CONSTRAINT chk_consmed_quantidade CHECK (quantidade > 0),
    CONSTRAINT fk_consmed_consulta FOREIGN KEY (idConsulta) REFERENCES Consulta(idConsulta) ON DELETE CASCADE,
    CONSTRAINT fk_consmed_medicamento FOREIGN KEY (idMedicamento) REFERENCES Medicamento(idMedicamento)
);