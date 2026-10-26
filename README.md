# NP Expres

Protótipo navegável e base técnica de uma agenda digital para salões de beleza e barbearias.

## Entregas do projeto

- Protótipo da interface em `index.html`;
- Tela de evolução técnica com CRUD e API;
- DER e modelo lógico em `database/`;
- Banco físico em SQLite com `database/schema.sql`;
- API REST com CRUD inicial em `backend/`;
- Imagens de apresentação em `docs/`.

## Etapa atual — 03–06/11: CRUD e API

Foram implementadas as operações `GET`, `POST`, `PUT` e `DELETE` para clientes, profissionais, serviços, disponibilidades e agendamentos. A API utiliza JSON, valida registros básicos e salva os dados no SQLite.

## Executar a API

```bash
cd backend
npm install
npm start
```

API: `http://localhost:3000`  
Documentação rápida: `GET /api`  
Verificação: `GET /api/health`

## Fluxo do produto

Início → Escolha do serviço → Horários disponíveis → Confirmação do agendamento.

Projeto Integrador — 2º ano TDS.  
Equipe: Nicolas Miguel Cedran e Pietro Jaider.
