Welcome to the OpenChampPS installation and configuration guide. Please look at the included overviews for details on endpoints and technical specifications for particular endpoints.

## Installation and Requirements

### Prerequisites

- Go 1.20+ installed and available on PATH
- Podman (Windows/Linux) or Docker Desktop (macOS)
- PostgreSQL container

### Installation

1. Clone the repository:

```bash
git clone https://github.com/OpenChamp/openchampPS.git
```

2. Run a PostgreSQL container

3. Extract a server image using the dev client (Required for server creation functionality)

4. Build or run the application:
   - For production use:

   ```bash
   go build ./...
   ```

   - For development use:

   ```bash
   go run .
   ```

## Configuration

### Environment Variables

| Variable | Type | Description | Default |
|----------|------|-------------|---------|
| OC_EMAIL_VALIDATION | Boolean | Must be true for registration | false |
| DB_CONN | String | Sets registration credentials for Postgres connection* | none |
| DB_HOST | String | Sets Database server hostname for Postgres connection | localhost |
| DB_PORT | Integer | Sets Database server port for Postgres connection | 5432 |
| DB_USER | String | Sets Database username for Postgres connection | postgres |
| DB_PASSWORD | String | Sets registration credentials for Postgres connection | mypasswd1234 |
| DB_NAME | String | Sets Database name for Postgres connection | myappdb |

`*Overrides all other DB varibles`