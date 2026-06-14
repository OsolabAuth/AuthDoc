# Local Docker Setup

Run the HonKit documentation site locally.

```powershell
docker compose -f docker-compose.local.yml up -d
```

Open:

```text
http://localhost:4000
```

Build without serving:

```powershell
npm.cmd run build
```

The current PlantUML rendering uses the external PlantUML server configured in `book.json`.
