#!/command/with-contenv sh
# Railway workaround: the data volume is reinitialized on boot, wiping
# config.yaml and auth.json. Rebuild both before the gateway starts.

if [ -f /opt/data/config.yaml ]; then
  sed -i 's|anthropic/claude-opus-4.6|anthropic/claude-sonnet-5|g' /opt/data/config.yaml
  sed -i 's|^\( *provider: *\)auto *$|\1anthropic|' /opt/data/config.yaml
fi

# Restore the Anthropic OAuth credential from the environment.
if [ ! -s /opt/data/auth.json ] && [ -n "$HERMES_AUTH_JSON" ]; then
  printf '%s' "$HERMES_AUTH_JSON" > /opt/data/auth.json
  chown 10000:10000 /opt/data/auth.json 2>/dev/null
  chmod 600 /opt/data/auth.json 2>/dev/null
  echo "[fix] restored auth.json from HERMES_AUTH_JSON"
fi

exit 0
