#!/usr/bin/env bash
# ============================================================================
# probar.sh — comprueba que todo el bucle funciona, de entrar a tirar el dado.
#
#   ./probar.sh
#
# Necesita: curl y jq. El backend tiene que estar corriendo en el 8080 con el
# perfil dev (los endpoints /api/dev/** solo existen ahí).
# ============================================================================

set -euo pipefail

API="${API:-http://localhost:8080}"
EMAIL="${EMAIL:-mix@trycatchmix.com}"
PASS="${PASS:-archivos}"

azul()  { printf '\033[36m%s\033[0m\n' "$*"; }
verde() { printf '\033[32m  ✓ %s\033[0m\n' "$*"; }
rojo()  { printf '\033[31m  ✗ %s\033[0m\n' "$*"; }

morir() { rojo "$*"; exit 1; }

for cmd in curl jq; do
  command -v "$cmd" >/dev/null || morir "Falta '$cmd'. Instálalo con: sudo pacman -S $cmd"
done

# ---------------------------------------------------------------- 0. vivo ---
azul "0 · ¿Responde el backend?"
if ! curl -sf -o /dev/null "$API/api/auth/login" -X POST \
      -H 'Content-Type: application/json' -d '{"email":"x@x.x","password":"x"}' \
      --max-time 5 2>/dev/null; then
  # Un 401 también significa "está vivo". Solo nos preocupa que no conteste.
  codigo=$(curl -s -o /dev/null -w '%{http_code}' --max-time 5 \
           -X POST "$API/api/auth/login" -H 'Content-Type: application/json' \
           -d '{"email":"x@x.x","password":"x"}' || echo 000)
  [ "$codigo" = "000" ] && morir "No contesta nadie en $API. ¿Arrancaste el backend?"
fi
verde "el backend responde en $API"

# --------------------------------------------------------------- 1. entrar --
azul "1 · Entrar"
LOGIN=$(curl -s -X POST "$API/api/auth/login" \
        -H 'Content-Type: application/json' \
        -d "{\"email\":\"$EMAIL\",\"password\":\"$PASS\"}")

TOKEN=$(echo "$LOGIN" | jq -r '.accessToken // empty')
[ -z "$TOKEN" ] && morir "No se pudo entrar: $(echo "$LOGIN" | jq -r '.message // .')"

verde "dentro como $(echo "$LOGIN" | jq -r '.displayName') ($(echo "$LOGIN" | jq -r '.role'))"
verde "el access token caduca en $(echo "$LOGIN" | jq -r '.expiresIn') s"

AUTH=(-H "Authorization: Bearer $TOKEN")

# ------------------------------------------------------------ 2. quien soy --
azul "2 · Quién soy"
curl -s "${AUTH[@]}" "$API/api/auth/me" | jq -c .

# ---------------------------------------------------------- 3. personajes ---
azul "3 · Los cuatro del libro"
PERSONAJES=$(curl -s "${AUTH[@]}" "$API/api/dev/personajes")
echo "$PERSONAJES" | jq -r '.[] | "  \(.nombre) — \(.clase) · Vigor \(.vigor) · \(.ciudad)"'

CHAR=$(echo "$PERSONAJES" | jq -r '.[] | select(.nombre=="Gorash") | .id')
[ -z "$CHAR" ] && morir "No aparece Gorash. ¿Se aplicó el seed (V2)?"

# ------------------------------------------------------------- 4. la ficha --
azul "4 · La ficha de Gorash (debe cuadrar con los mockups)"
FICHA=$(curl -s "${AUTH[@]}" "$API/api/dev/personajes/$CHAR")
echo "$FICHA" | jq -r '"  PG \(.pg) · CA \(.ca) · Vigor \(.vigor)"'
echo "$FICHA" | jq -r '"  Bolsa: \(.bolsa)"'
echo "$FICHA" | jq -r '"  Carga: \(.carga)"'
echo "$FICHA" | jq -r '.habilidades | to_entries[] | "  \(.key): +\(.value)"'

TREPAR=$(echo "$FICHA" | jq -r '.habilidades.Trepar // 0')
if [ "$TREPAR" = "7" ]; then
  verde "Trepar +7, igual que el mockup"
else
  rojo "Trepar sale +$TREPAR y el mockup dice +7"
fi

# --------------------------------------------------------------- 5. tablón --
azul "5 · El tablón"
TABLON=$(curl -s "${AUTH[@]}" "$API/api/personajes/$CHAR/tablon")
echo "$TABLON" | jq -r '.[] | "  [\(.availability)] \(.title)\(if .reason then " — \(.reason)" else "" end)"'

BLOQUEADO=$(echo "$TABLON" | jq -r '[.[] | select(.availability=="BLOCKED_BY_WORLD")] | length')
if [ "$BLOQUEADO" -gt 0 ]; then
  verde "hay $BLOQUEADO encargo(s) bloqueado(s) por el estado del mundo"
else
  rojo "ninguno bloqueado: ¿se aplicó la flag puente_norte_en_pie?"
fi

# --------------------------------------------------------------- 6. firmar --
azul "6 · Firmar un encargo"
QUEST=$(echo "$TABLON" | jq -r 'first(.[] | select(.availability=="AVAILABLE") | .id) // empty')
[ -z "$QUEST" ] && { rojo "no hay ninguno disponible (¿Gorash ya está ocupado?)"; exit 0; }

ESCENA=$(curl -s -X POST "${AUTH[@]}" "$API/api/personajes/$CHAR/encargos/$QUEST")
echo "$ESCENA" | jq -r '"  \(.questTitle) — escena \(.sceneOrdinal)/\(.sceneCount)"'
echo "$ESCENA" | jq -r '"  \(.title)"'
echo "$ESCENA" | jq -r '.options[] | "  · \(.label)  [\(.skill // "sin tirada") \(if .dc then "CD \(.dc)" else "" end) \(if .successChance then "\(.successChance)%" else "" end)]"'

# --------------------------------------------------------------- 7. tirar ---
azul "7 · Elegir una opción (el servidor tira el d20)"
OPT=$(echo "$ESCENA" | jq -r '.options[0].id')
RES=$(curl -s -X POST "${AUTH[@]}" "$API/api/personajes/$CHAR/escena/opciones/$OPT")

if [ "$(echo "$RES" | jq -r '.roll // "null"')" != "null" ]; then
  echo "$RES" | jq -r '"  d20 \(.roll.d20)"'
  echo "$RES" | jq -r '.roll.breakdown[] | "  \(.label): \(if .value > 0 then "+" else "" end)\(.value)"'
  echo "$RES" | jq -r '"  Total \(.roll.total) contra CD \(.roll.dc)  →  \(.roll.gradeLabel) (grado \(.roll.grade) de 5)"'
fi
echo "$RES" | jq -r '"  \(.narrative)"'
echo "$RES" | jq -r '.changes[]? | "  → \(.)"'
echo "$RES" | jq -r 'if .finished then "  El encargo queda cerrado." else "  En camino: \(.waitingFor)" end'

# ------------------------------------------------------------ 8. el mundo ---
azul "8 · ¿Cambió el mundo para los demás?"
TABLON2=$(curl -s "${AUTH[@]}" "$API/api/personajes/$CHAR/tablon")
echo "$TABLON2" | jq -r '.[] | "  [\(.availability)] \(.title)"'

echo
verde "El bucle entero funciona."
