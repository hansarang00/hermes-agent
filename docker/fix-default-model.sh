#!/command/with-contenv sh
# Railway workaround: the data volume is reinitialized on boot, wiping
# config.yaml and auth.json. Rebuild both before the gateway starts.

if [ -f /opt/data/config.yaml ]; then
  # Primary model + provider
  sed -i 's|anthropic/claude-opus-4.6|anthropic/claude-sonnet-5|g' /opt/data/config.yaml
  sed -i 's|^\( *provider: *\)"\?auto"\? *$|\1"anthropic"|' /opt/data/config.yaml

  # Fallback chain: tried when the primary hits rate limits, 5xx or connection errors
  if ! grep -q '^fallback_providers:' /opt/data/config.yaml; then
    cat >> /opt/data/config.yaml <<'YAML'

fallback_providers:
  - provider: gemini
    model: gemini-2.5-flash
    base_url: https://generativelanguage.googleapis.com/v1beta
YAML
    echo "[fix] added fallback_providers (gemini-2.5-flash)"
  fi

  chown 10000:10000 /opt/data/config.yaml 2>/dev/null
fi

# Restore the Anthropic OAuth credential from the environment.
if [ ! -s /opt/data/auth.json ] && [ -n "$HERMES_AUTH_JSON" ]; then
  printf '%s' "$HERMES_AUTH_JSON" > /opt/data/auth.json
  chown 10000:10000 /opt/data/auth.json 2>/dev/null
  chmod 600 /opt/data/auth.json 2>/dev/null
  echo "[fix] restored auth.json from HERMES_AUTH_JSON"
fi

exit 0
