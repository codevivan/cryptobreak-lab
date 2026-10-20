# Stage 1: Base image with dependencies
FROM node:22-alpine AS base

WORKDIR /app

# Copy dependency manifests first to leverage Docker layer caching
COPY package.json package-lock.json ./

# Install exact dependencies using package-lock.json
RUN npm ci

# Stage 2: Development stage for live containerized development with hot reload
FROM base AS development

COPY . .

EXPOSE 5173

CMD ["npm", "run", "dev"]

# Stage 3: Build the React + Vite application for production
FROM base AS build

# Copy all source files
COPY . .

# Build the production bundle into /app/dist
RUN npm run build

# Stage 4: Serve the production build using lightweight Nginx
FROM nginx:alpine AS production

# Copy custom Nginx configuration for single-page application routing and caching
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy production assets from the builder stage
COPY --from=build /app/dist /usr/share/nginx/html

# Built-in healthcheck to verify Nginx serves the root SPA
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q --spider http://127.0.0.1:80/ || exit 1

# Expose standard HTTP port
EXPOSE 80

# Start Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
