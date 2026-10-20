# CryptoBreak Lab 🔐

**CryptoBreak Lab** is an interactive, browser-based cryptography and cryptanalysis laboratory designed to teach, simulate, and analyze classical cipher systems, breaking techniques, and security principles.

---

## 🚀 Quick Start with Docker

The project is fully containerized with multi-stage builds for both production serving (via Nginx Alpine) and live local development (via Node Alpine + Vite HMR).

### 1. Run Production Build (Recommended)

To build and run the optimized production container:

```bash
docker compose up -d --build
```

- Access the application at: **[http://localhost:8080](http://localhost:8080)**
- To stop the container:
  ```bash
  docker compose down
  ```

### 2. Run Containerized Development (Live Reload)

To run the development server inside Docker with Hot Module Replacement (HMR) and volume mounts:

```bash
docker compose -f docker-compose.dev.yml up --build
```

- Access the dev server at: **[http://localhost:5173](http://localhost:5173)**
- Changes made locally will trigger instant hot updates inside the container.

### 3. Alternative: Direct Docker CLI

```bash
# Build the production image
docker build -t cryptobreak-lab .

# Run the container (maps host port 8080 to container port 80)
docker run -d --name cryptobreak-lab -p 8080:80 cryptobreak-lab

# Check container health and status
docker ps

# View container logs
docker logs cryptobreak-lab

# Stop and clean up
docker stop cryptobreak-lab && docker rm cryptobreak-lab
```

---

## 🛠️ npm Docker Shortcuts

Convenient npm scripts are preconfigured in [package.json](file:///d:/projects/cryptobreak-lab/package.json):

| Command | Action |
| :--- | :--- |
| `npm run docker:compose` | Builds and launches production container detached (`docker compose up -d --build`) |
| `npm run docker:compose:dev` | Launches live development container with volume syncing (`docker compose -f docker-compose.dev.yml up --build`) |
| `npm run docker:compose:down` | Stops and removes compose containers and networks (`docker compose down`) |
| `npm run docker:clean` | Full cleanup of containers, volumes, and orphaned networks |
| `npm run docker:build` | Builds production image via Dockerfile |
| `npm run docker:run` | Runs containerized production instance on port `8080` |

---

## ⚙️ Configuration & Environment

Configuration options can be customized via `.env` file (see [.env.example](file:///d:/projects/cryptobreak-lab/.env.example)):

```env
# Host port mapping for production container (default: 8080)
PORT=8080

# Host port mapping for development container (default: 5173)
DEV_PORT=5173
```

---

## 🏗️ Docker Architecture

- **Multi-Stage Build** ([Dockerfile](file:///d:/projects/cryptobreak-lab/Dockerfile)):
  - **`base`**: `node:22-alpine` with deterministic dependency installation using `npm ci`.
  - **`development`**: Hot-reloading Vite dev server with volume mounts and inotify polling support.
  - **`build`**: Compiles and minifies React assets into `/app/dist`.
  - **`production`**: Super-lightweight `nginx:alpine` image serving the SPA assets with optimized caching, security headers, and single-page routing.
- **Built-in Healthcheck**: Automatically polls `http://127.0.0.1:80/` via busybox `wget --spider` to report container health state to Docker.
- **Security & Caching**: [nginx.conf](file:///d:/projects/cryptobreak-lab/nginx.conf) enables Gzip compression, immutable 1-year caching on hashed assets, `no-cache` on `index.html`, and security headers (`X-Content-Type-Options`, `X-Frame-Options`, `X-XSS-Protection`, `Referrer-Policy`).

---

## 💻 Local Development (Without Docker)

If you prefer running directly on your host machine:

```bash
# 1. Install dependencies
npm install

# 2. Start development server
npm run dev

# 3. Build for production
npm run build

# 4. Run linting
npm run lint

# 5. Run test suites
node test-certificate.js
node test-feedback.js
```
