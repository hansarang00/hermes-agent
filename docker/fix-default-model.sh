#!/bin/sh
# Railway workaround: 01-hermes-setup regenerates config.yaml on every boot
# with a stale default model. Rewrite it before the gateway starts.
[ -f /opt/data/config.yaml ] && \
  sed -i 's|anthropic/claude-opus-4.6|anthropic/claude-sonnet-5|g' /opt/data/config.yaml

# Same story for auth.json: restore the OAuth credential if boot wiped it.
if [ ! -f /opt/data/auth.json ] && [ -f /opt/data/auth.json.backup ]; then
  cp /opt/data/auth.json.backup /opt/data/auth.json
  chown 10000:10000 /opt/data/auth.json 2>/dev/null
  echo "[fix] restored auth.json from backup"
fi

exit 0
