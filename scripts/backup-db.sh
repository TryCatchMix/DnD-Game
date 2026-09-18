#!/usr/bin/env bash
# =====================================================================
# COPIA DE SEGURIDAD DE LA BASE DE DATOS (en el VPS).
#
# Vuelca la base de PostgreSQL del contenedor `archivos-db` a un fichero
# con fecha, comprueba que el volcado se puede leer y borra los antiguos.
#
#   ./scripts/backup-db.sh                  # solo la base de datos
#   ./scripts/backup-db.sh --con-archivos   # y además el material de La Mesa
#
# Variables opcionales:
#   BACKUP_DIR      dónde se guardan   (por defecto /var/backups/archivos)
#   RETENCION_DIAS  cuántos días se guardan las copias (por defecto 14)
#
# Para que se haga solo cada noche a las 4:00, con `crontab -e`:
#   0 4 * * * /ruta/al/repo/scripts/backup-db.sh --con-archivos >> /var/log/archivos-backup.log 2>&1
#
# RESTAURAR (¡sobrescribe la base actual!):
#   docker compose -f docker-compose.prod.yml stop api
#   docker exec -i archivos-db pg_restore -U archivos -d archivos --clean --if-exists \
#       < /var/backups/archivos/archivos-AAAAMMDD-HHMMSS.dump
#   docker compose -f docker-compose.prod.yml start api
#
# Por qué existe --con-archivos: los retratos, mapas y PDF de La Mesa no
# viven en la base, sino en disco (volumen `mesa`). Una copia de la base sin
# ellos restaura las fichas con los retratos rotos.
# =====================================================================
set -euo pipefail

CONTENEDOR_DB="archivos-db"
CONTENEDOR_API="archivos-api"
DB_NAME="archivos"
DB_USER="archivos"
BACKUP_DIR="${BACKUP_DIR:-/var/backups/archivos}"
RETENCION_DIAS="${RETENCION_DIAS:-14}"

CON_ARCHIVOS=false
for arg in "$@"; do
    case "$arg" in
        --con-archivos) CON_ARCHIVOS=true ;;
        -h|--help) sed -n '2,30p' "$0"; exit 0 ;;
        *) echo "Opción desconocida: $arg (usa --help)" >&2; exit 1 ;;
    esac
done

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }

if ! docker ps --format '{{.Names}}' | grep -qx "$CONTENEDOR_DB"; then
    log "ERROR: el contenedor $CONTENEDOR_DB no está en marcha." >&2
    exit 1
fi

mkdir -p "$BACKUP_DIR"
chmod 700 "$BACKUP_DIR"          # el volcado lleva emails y hashes de contraseñas
FECHA="$(date '+%Y%m%d-%H%M%S')"
DESTINO="$BACKUP_DIR/$DB_NAME-$FECHA.dump"
TEMPORAL="$DESTINO.parcial"

# Si algo falla a medias, no se deja un fichero cortado que parezca bueno.
trap 'rm -f "$TEMPORAL"' EXIT

# --- 1. El volcado -----------------------------------------------------------
# Formato "custom" (-Fc): va comprimido y permite restaurar tablas sueltas.
# Dentro del contenedor la conexión local no pide contraseña.
log "Volcando la base $DB_NAME..."
docker exec "$CONTENEDOR_DB" pg_dump -U "$DB_USER" -d "$DB_NAME" -Fc --no-owner > "$TEMPORAL"

# --- 2. Comprobar que se puede leer -----------------------------------------
# Un pg_dump que termina bien casi siempre deja un fichero válido, pero una
# copia que no se ha comprobado no es una copia.
if ! docker exec -i "$CONTENEDOR_DB" pg_restore --list < "$TEMPORAL" > /dev/null; then
    log "ERROR: el volcado no se puede leer. No se guarda." >&2
    exit 1
fi

mv "$TEMPORAL" "$DESTINO"
chmod 600 "$DESTINO"
log "Base guardada: $DESTINO ($(du -h "$DESTINO" | cut -f1))"

# --- 3. El material de La Mesa (opcional) -----------------------------------
if $CON_ARCHIVOS; then
    if docker ps --format '{{.Names}}' | grep -qx "$CONTENEDOR_API"; then
        ARCHIVOS="$DB_NAME-mesa-$FECHA.tar.gz"
        log "Copiando el material de La Mesa..."
        docker run --rm --volumes-from "$CONTENEDOR_API" -v "$BACKUP_DIR":/copia alpine \
            tar czf "/copia/$ARCHIVOS" -C /var/archivos mesa
        chmod 600 "$BACKUP_DIR/$ARCHIVOS"
        log "Material guardado: $BACKUP_DIR/$ARCHIVOS ($(du -h "$BACKUP_DIR/$ARCHIVOS" | cut -f1))"
    else
        log "AVISO: $CONTENEDOR_API no está en marcha; no se copia el material." >&2
    fi
fi

# --- 4. Retirar las copias viejas --------------------------------------------
BORRADAS=$(find "$BACKUP_DIR" -maxdepth 1 -type f \
    \( -name "$DB_NAME-*.dump" -o -name "$DB_NAME-mesa-*.tar.gz" \) \
    -mtime +"$RETENCION_DIAS" -print -delete | wc -l)
log "Copias de más de $RETENCION_DIAS días borradas: $BORRADAS"
log "Hecho."
