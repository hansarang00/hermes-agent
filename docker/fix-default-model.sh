#!/bin/sh
# Railway workaround: 01-hermes-setup regenerates config.yaml on every boot
# with a stale default model. Rewrite it before the gateway starts.
[ -f /opt/data/config.yaml ] || exit 0
sed -i 's|anthropic/claude-opus-4.6|google/gemini-2.5-flash|g' /opt/data/config.yaml
exit 0
