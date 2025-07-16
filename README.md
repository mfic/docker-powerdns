# 🚀 PowerDNS Multi-Node Docker Setup (Authoritative + Recursor + Admin UI)

This repository provides a modular, production-ready Docker Compose setup for running a multi-node **PowerDNS authoritative DNS** infrastructure with:

* **Primary and Secondary PowerDNS servers**
* **Recursor for DNS resolution**
* **PowerDNS-Admin UI**
* **MySQL backend**
* **Traefik reverse proxy support**

> ⚙️ This setup is still in development but intended for **production deployment**.

---

## 📦 Project Structure

```
docker-powerdns-main/
├── pdns/            # Authoritative DNS server
├── pdns-db/         # MySQL backend for PowerDNS and PowerDNS-Admin
├── pdns-admin/      # PowerDNS-Admin UI
└── pdns-recursor/   # PowerDNS Recursor setup
```

---

## 🔧 Services Overview

### 🔸 pdns/

* Authoritative PowerDNS server using MySQL backend
* Schema initialization included

### 🔸 pdns-db/

* MySQL container with support for multiple databases:

  * `pdns`, `pdnsadmin`, `pdns_master`, `pdns_slave`
* Contains `init.sql.template` and `generate-init.sh` for setup

### 🔸 pdns-admin/

* UI for managing zones, records, users
* Secured via Traefik and `.env` for credentials

### 🔸 pdns-recursor/

* DNS resolver with forwarding and custom rules
* Configurable via `.env` variables

> Make sure to disable systemd-resolved on the host prior to starting the container

>  ```
>  systemctl disable systemd-resovled
>  ```

---

## 🚀 Getting Started

### 1. Clone and Prepare Environment

```bash
git clone https://your-repo-url/docker-powerdns-main.git
cd docker-powerdns-main
```

### 2. Configure Environment Variables

Each service has a `.env.sample`. Copy and edit each:

```bash
cp pdns/.env.sample pdns/.env
cp pdns-db/.env.sample pdns-db/.env
cp pdns-db/env-admin.sample pdns-db/env-admin.env
cp pdns-db/env-master.sample pdns-db/env-master.env
cp pdns-admin/.env.sample pdns-admin/.env
cp pdns-recursor/.env.sample pdns-recursor/.env
```

Edit the `.env` files to match your database credentials, domain names, and Traefik labels.

---

### 3. Generate Initial SQL for MySQL

Inside `pdns-db/`:

```bash
cd pdns-db
bash generate-init.sh
```

This will generate a `init.sql` file from the `init.sql.template` using the values in your `.env` file.

---

### 4. Start Containers

You can start each service independently on different nodes depending on your topology. Example for the primary node:

```bash
cd pdns-db
docker compose up -d

cd ../pdns
docker compose up -d

cd ../pdns-recursor
docker compose up -d

cd ../pdns-admin
docker compose up -d
```

---

## 🌐 Traefik Integration

This project is designed to work with [Traefik](https://traefik.io/) as a reverse proxy. Each `docker-compose.yml` includes labels for Traefik routing.

To enable:

* Ensure your Traefik instance is running on the Docker network used by the services
* Match the `traefik.enable=true` labels and hostname routes
* Use a shared Docker network (e.g., `traefik-public`) and attach containers to it

---

## ✅ Recommended Deployment Topology

| Node       | Services                                         |
| ---------- | ------------------------------------------------ |
| DNS Master | `pdns-db`, `pdns`, `pdns-admin`                  |
| DNS Slave  | `pdns-db`, `pdns` (slave), optional `pdns-admin` |
| Recursor   | `pdns-recursor`                                  |
| Proxy      | `traefik` reverse proxy                          |

---

## ☑️ To Do / Improvements

* Harden authentication and SSL
* Enable mTLS or Cloudflare Access
* Add backup automation
* Health monitoring (Prometheus/Grafana)

---

## 📜 License

MIT License – Feel free to use and contribute.

---

## 🤝 Contributing

Contributions are welcome! Please open issues or submit PRs for improvements.
