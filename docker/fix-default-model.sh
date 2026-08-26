#!/bin/sh
# Railway workaround: the data volume gets reinitialized on boot, wiping
# config.yaml and auth.json. Rebuild both before the gateway starts.
[ -f /opt/data/config.yaml ] && \
  sed -i 's|anthropic/claude-opus-4.6|anthropic/claude-sonnet-5|g' /opt/data/config.yaml

# Restore the Anthropic OAuth credential from the environment.
if [ ! -f /opt/data/auth.json ] && [ -n "$HERMES_AUTH_JSON" ]; then
  printf '%s' "$HERMES_AUTH_JSON" > /opt/data/auth.json
  chown 10000:10000 /opt/data/auth.json 2>/dev/null
  chmod 600 /opt/data/auth.json 2>/dev/null
  echo "[fix] restored auth.json from HERMES_AUTH_JSON"
fi

exit 0
