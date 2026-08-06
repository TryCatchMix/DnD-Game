-- =====================================================================
-- Cuenta de administrador (rol DM = máster de la mesa).
--
-- El registro público (/api/auth/register) SIEMPRE crea jugadores (PLAYER),
-- nunca DM, así que esta es la vía por la que existe un admin: sembrado aquí.
--
-- Reutiliza el mismo hash bcrypt que Mix, así que la contraseña inicial es
-- 'archivos'. CÁMBIALA en cuanto entres en producción (ver README).
-- =====================================================================
insert into users (id, email, password_hash, display_name, role) values
('11111111-1111-1111-1111-1111111111ad',
 'admin@trycatchmix.com',
 '$2b$10$UbCIqdSjeXcPjed/mHmoPe4Sd1z9cjSQF0HP9I8KwYWlYJj8JAaPO',
 'Admin', 'DM')
on conflict (email) do nothing;
