USE ClinicaDB;

-- Cenário 1: Configuração inicial, catálogo e médicos
INSERT INTO Categoria (idCategoria, descricao, tarja) VALUES
    (1, 'Analgésicos e Antitérmicos', 'Sem Tarja'),
    (2, 'Antibióticos', 'Tarja Vermelha'),
    (3, 'Anti-hipertensivos', 'Tarja Vermelha'),
    (4, 'Anti-inflamatórios', 'Tarja Vermelha'),
    (5, 'Ansiolíticos e Sedativos', 'Tarja Preta');

INSERT INTO Fabricante (idFabricante, nomeFantasia, cnpj, paisOrigem) VALUES
    (1, 'MedSaúde Farmacêutica', '12345678000190', 'Brasil'),
    (2, 'VitaCorp Labs', '23456789000181', 'Brasil'),
    (3, 'EuroMed International', '34567890000172', 'Alemanha'),
    (4, 'BioFarma Sul', '45678901000163', 'Argentina'),
    (5, 'GlobalCare Pharma', '56789012000154', 'Estados Unidos');

INSERT INTO Medicamento (idMedicamento, nomeComercial, dosagem, valor, idCategoria, idFabricante) VALUES
    (1, 'Dipirona Sódica', '500mg', 14.50, 1, 1),
    (2, 'Amoxicilina', '500mg', 32.90, 2, 2),
    (3, 'Losartana Potássica', '50mg', 24.00, 3, 3),
    (4, 'Ibuprofeno', '600mg', 21.80, 4, 1),
    (5, 'Clonazepam', '2mg', 28.50, 5, 5),
    (6, 'Paracetamol', '750mg', 16.00, 1, 4);

INSERT INTO Medico (idMedico, nome, crm, especialidade, valorConsulta) VALUES
    (1, 'Dra. Helena Vasconcelos', 'CRM-SP 112233', 'Clínica Geral', 200.00),
    (2, 'Dr. Rafael Nogueira', 'CRM-SP 223344', 'Cardiologia', 280.00),
    (3, 'Dra. Camila Ribeiro', 'CRM-SP 334455', 'Infectologia', 250.00),
    (4, 'Dr. Lucas Azevedo', 'CRM-SP 445566', 'Ortopedia', 260.00),
    (5, 'Dra. Beatriz Monteiro', 'CRM-SP 556677', 'Psiquiatria', 300.00);

-- Cenário 2: Primeiros pacientes e e-mails
INSERT INTO Paciente (idPaciente, nome, cpf, dataNascimento, sexo, ativo) VALUES
    (1, 'Ana Carolina Souza', '11122233344', '1992-04-15', 'F', TRUE),
    (2, 'Bruno Henrique Lima', '22233344455', '1985-09-23', 'M', TRUE),
    (3, 'Carla Fernanda Rocha', '33344455566', '1978-01-10', 'F', TRUE),
    (4, 'Diego Martins Silva', '44455566677', '2000-12-05', 'M', TRUE),
    (5, 'Eduarda Costa Mendes', '55566677788', '1995-07-30', 'F', TRUE);

INSERT INTO Paciente_Email (idEmail, idPaciente, email, principal) VALUES
    (1, 1, 'ana.souza@email.com', TRUE),
    (2, 1, 'anacarol.trabalho@empresa.com', FALSE),
    (3, 2, 'bruno.lima@email.com', TRUE),
    (4, 3, 'carla.rocha@email.com', TRUE),
    (5, 4, 'diego.silva@email.com', TRUE),
    (6, 5, 'eduarda.mendes@email.com', TRUE);

-- Cenário 3: Consultas realizadas e prescrições
INSERT INTO Consulta (idConsulta, idPaciente, idMedico, dataHora, valorTotal, statusConsulta) VALUES
    (1, 1, 1, '2026-11-10 09:00:00', 236.30, 'Concluida'),
    (2, 2, 2, '2026-11-10 10:30:00', 328.00, 'Concluida'),
    (3, 3, 3, '2026-11-11 14:00:00', 282.90, 'Concluida'),
    (4, 4, 4, '2026-11-12 16:15:00', 296.30, 'Concluida'),
    (5, 5, 5, '2026-11-13 11:00:00', 328.50, 'Concluida');

INSERT INTO Cons_Med (idConsulta, idMedicamento, quantidade, posologia) VALUES
    (1, 1, 1, '1 comprimido a cada 6 horas em caso de dor ou febre'),
    (1, 4, 1, '1 comprimido a cada 8 horas por 3 dias'),
    (2, 3, 2, '1 comprimido pela manhã em jejum'),
    (3, 2, 1, '1 cápsula a cada 8 horas por 7 dias'),
    (4, 4, 1, '1 comprimido a cada 8 horas por 5 dias'),
    (4, 6, 1, '1 comprimido se houver dor intensa'),
    (5, 5, 1, 'Meio comprimido à noite antes de dormir');

-- Cenário 4: Atualização de status, novo agendamento e cancelamento
UPDATE Consulta
SET statusConsulta = 'Concluida'
WHERE idConsulta = 5;

INSERT INTO Consulta (idConsulta, idPaciente, idMedico, dataHora, valorTotal, statusConsulta) VALUES
    (6, 1, 2, '2026-11-28 08:30:00', 280.00, 'Agendada'),
    (7, 3, 1, '2026-11-15 15:00:00', 200.00, 'Cancelada');