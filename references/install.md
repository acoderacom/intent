# Turso Prerequisites

Run once per machine. If `npx intent-turso --version` works, skip this.

## 1. Get Turso Credentials

**Option A: Turso Dashboard**
1. Create database at https://turso.tech (free tier)
2. Copy URL and create auth token from dashboard

**Option B: Turso CLI**
```bash
curl -sSfL https://get.tur.so/install.sh | bash
turso auth login
turso db create intent-db
turso db show intent-db --url        # Copy this
turso db tokens create intent-db     # Copy this
```

## 2. Verify CLI

```bash
npx intent-turso --version
```

If this works, return to `/intent:setup` for project configuration.
