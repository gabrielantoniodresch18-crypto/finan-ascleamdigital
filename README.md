# Cleam Digital · Prospecção

App de controle da equipe (vendas, agenda, metas, painel, finanças, clientes, comissões e postagens).

O app é o `index.html`. Os arquivos `.sql` criam as tabelas no Supabase (rodar uma vez cada no SQL Editor):

- `planos.sql`: aba Comissões.
- `agenda.sql`: aba Agenda (cada pessoa só vê a própria).
- `postagens.sql`: aba Postagens (cada pessoa só vê os próprios perfis).
- `cobranca.sql`: cobranças mensais na aba Clientes (dia do vencimento e meses pagos; o botão "Cobrar no WhatsApp" abre a conversa com a mensagem pronta).
