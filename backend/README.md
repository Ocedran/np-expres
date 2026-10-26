# NP Expres — CRUD e API

API REST inicial da agenda para salão e barbearia, atualizada para a etapa **03–06/11 — CRUD e API**.

## Tecnologias

- Node.js;
- Express;
- SQLite com `better-sqlite3`;
- CORS;
- JSON nas requisições e respostas.

## Executar localmente

```bash
cd backend
npm install
npm start
```

A API ficará disponível em `http://localhost:3000`.

O banco `np-expres.sqlite` é criado automaticamente na primeira execução usando `database/schema.sql`.

## Rotas disponíveis

Todas as rotas usam o prefixo `/api` e aceitam/retornam JSON.

| Recurso | Listar/criar | Consultar, atualizar e excluir |
|---|---|---|
| Clientes | `GET/POST /api/clientes` | `GET/PUT/DELETE /api/clientes/:id` |
| Profissionais | `GET/POST /api/profissionais` | `GET/PUT/DELETE /api/profissionais/:id` |
| Serviços | `GET/POST /api/servicos` | `GET/PUT/DELETE /api/servicos/:id` |
| Disponibilidades | `GET/POST /api/disponibilidades` | `GET/PUT/DELETE /api/disponibilidades/:id` |
| Agendamentos | `GET/POST /api/agendamentos` | `GET/PUT/DELETE /api/agendamentos/:id` |
| Saúde da API | `GET /api/health` | — |

## Fluxo de uma operação

```text
requisição JSON → rota REST → validação → banco SQLite → resposta JSON
```

## Exemplo de criação de cliente

```bash
curl -X POST http://localhost:3000/api/clientes \
  -H 'Content-Type: application/json' \
  -d '{"nome":"Pietro Jaider","telefone":"(44) 98888-0000","email":"pietro@teste.com"}'
```

## Exemplo de consulta

```bash
curl http://localhost:3000/api/clientes
curl http://localhost:3000/api/clientes/1
```

## Testes realizados

- `GET /api/health` retorna o status da API;
- `POST /api/clientes` cria um cliente no banco;
- `GET /api/clientes` lista os clientes cadastrados;
- O mesmo padrão CRUD está preparado para profissionais, serviços, disponibilidades e agendamentos.

A autenticação, permissões de usuário, validação avançada de conflitos e integração completa com a interface ficam para as próximas etapas.
