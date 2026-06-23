# Agent Mesh Hub

Centralized MQTT broker for AI agent coordination. Deployed on R750 via Coolify.

## Architecture

```
Warlock (cyberdeck) ──┐
                      ├──→ MQTT Hub (R750) ←──┤
Evy (Pi) ─────────────┘                       └──→ Future agents
```

Star topology — each agent connects to the hub instead of N² direct connections.

## Topic Structure

| Pattern | Purpose |
|---------|---------|
| `agents/<name>/inbox` | Messages TO a specific agent |
| `agents/broadcast` | Fan-out to all agents |
| `tasks/queue/<name>` | Task assignment to specific agent |
| `presence/<name>` | Online status / heartbeat |
| `system/` | Broker announcements |

## Credentials

Per-agent auth via Mosquitto password file. Rotate via Coolify environment rebuild.

| User | Role |
|------|------|
| warlock | Red team / security / infra |
| evy | Documentation / research / coordination |
| jason | Operator — full access |

## Deployment

1. Repo pushed to GitHub
2. Coolify pulls Dockerfile, builds, deploys
3. Exposed on MQTT port 1883 (Tailscale network only)
4. WebSocket listener on 9001 for dashboards

## Build

```bash
docker build -t agent-mesh-hub .
```

## Run locally

```bash
docker run -p 1883:1883 -p 9001:9001 agent-mesh-hub
```

## Test

```bash
# Subscribe
mosquitto_sub -h <host> -p 1883 -u warlock -p mesh-lock-red -t "agents/broadcast"

# Publish
mosquitto_pub -h <host> -p 1883 -u evy -P mesh-trace-doc -t "agents/warlock/inbox" -m "Hello from Evy"
```
