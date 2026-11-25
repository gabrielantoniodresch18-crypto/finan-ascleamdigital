-- Deixa só o administrador usando o app.
-- Não apaga ninguém: só tira a aprovação dos outros, que deixam de conseguir entrar.
-- Para desfazer: update public.profiles set approved = true where role <> 'admin';
update public.profiles set approved = false where role <> 'admin';
