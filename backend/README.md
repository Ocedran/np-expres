# NP Expres — Back-End inicial

API REST inicial da agenda para salão e barbearia, criada para a etapa de banco físico e início do Back-End.

## Tecnologias

- Node.js
- Express
- SQLite com `better-sqlite3`
- CORS

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

| Recurso | Rotas |
|---|---|
| Clientes | `GET/POST /api/clientes`, `GET/PUT/DELETE /api/clientes/:id` |
| Profissionais | `GET/POST /api/profissionais`, `GET/PUT/DELETE /api/profissionais/:id` |
| Serviços | `GET/POST /api/servicos`, `GET/PUT/DELETE /api/servicos/:id` |
| Disponibilidades | `GET/POST /api/disponibilidades`, `GET/PUT/DELETE /api/disponibilidades/:id` |
| Agendamentos | `GET/POST /api/agendamentos`, `GET/PUT/DELETE /api/agendamentos/:id` |
| Saúde da API | `GET /api/health` |

## Exemplo de criação de cliente

```bash
curl -X POST http://localhost:3000/api/clientes \
  -H 'Content-Type: application/json' \
  -d '{"nome":"Pietro Jaider","telefone":"(44) 98888-0000","email":"pietro@teste.com"}'
```

## Observação

Este é o CRUD inicial para a entrega escolar. A autenticação, as permissões de usuário, a validação mais completa de conflitos de horário e a integração com a interface ficam para as próximas etapas.
