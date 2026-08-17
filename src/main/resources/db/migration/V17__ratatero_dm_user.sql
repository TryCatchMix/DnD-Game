-- =====================================================================
-- Cuenta de máster "ratatero" (rol DM).
--
-- El registro público (/api/auth/register) SIEMPRE crea jugadores (PLAYER),
-- nunca DM, así que un máster solo puede nacer sembrado aquí (igual que Admin
-- en V10).
--
-- El login es por EMAIL (el campo "Nombre en el libro" del formulario es de
-- tipo email), de modo que se inicia sesión con 'ratatero@ratatero.com'.
-- El nombre visible en el libro es 'ratatero'.
--
-- Hash bcrypt de la contraseña 'ratatero.master'. CÁMBIALA en producción.
-- =====================================================================
insert into users (id, email, password_hash, display_name, role) values
('22222222-2222-2222-2222-2222222222aa',
 'ratatero@ratatero.com',
 '$2b$10$0gvsJxoCdaEupSdTxsuTYejBbhkniTSe04yT.6a5pKnUze/rWhFlS',
 'ratatero', 'DM')
on conflict (email) do nothing;
