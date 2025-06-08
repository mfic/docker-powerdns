# PowerDNS MySQL Initialization

## 🗂️ Overview

This folder contains the setup for the MySQL service used by PowerDNS and PowerDNS-Admin. It defines multiple databases and users for a split configuration: `pdns`, `pdnsadmin`, `pdns_master`, and `pdns_slave`.

## 📁 Files

* `init.sql.template`: Template SQL script with placeholders for environment variables.
* `.env`: Define sensitive values like passwords and database names.
* `generate-init.sh`: Script to render `init.sql` from the template.
* `docker-compose.yml`: Launches the MySQL container with volume bindings.

## 🚀 Usage

### 1. Prepare the environment

Copy the `.env.sample` to `.env` and customize your credentials:

```bash
cp .env.sample .env
```

### 2. Generate `init.sql`

Run the provided script to render your SQL file:

```bash
chmod +x generate-init.sh
./generate-init.sh
```

This will substitute all variables from `.env` into `init.sql.template`, outputting `init.sql`.

### 3. Start the MySQL container

```bash
docker compose up -d
```

This will initialize the MySQL container and apply the `init.sql` during first-time setup.

---

✅ Make sure to **gitignore `.env`** to avoid committing secrets.
