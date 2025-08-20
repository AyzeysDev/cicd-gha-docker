# Multi-stage build for Next.js
# Use the exact Node.js version from your root package.json
FROM node:22.18.0-alpine AS base
# Enable pnpm via corepack
RUN corepack enable pnpm

#----------------------------------------------------------------
# 1. Dependencies Stage ('deps')
# Creates a minimal copy of the workspace to reliably install dependencies.
#----------------------------------------------------------------
FROM base AS deps
WORKDIR /app

# Copy the files that define the pnpm workspace structure.
COPY pnpm-workspace.yaml ./
COPY package.json ./
COPY pnpm-lock.yaml ./

# Create the subdirectory for our frontend app...
RUN mkdir -p apps/frontend
# ...and copy its specific package.json into place.
COPY apps/frontend/package.json ./apps/frontend/

# Install ALL dependencies for the entire workspace.
RUN pnpm install --frozen-lockfile

#----------------------------------------------------------------
# 2. Build Stage ('builder')
# This stage starts FROM the 'deps' stage, inheriting the
# fully installed node_modules directory.
#----------------------------------------------------------------
FROM deps AS builder
WORKDIR /app

# Copy the application source code. This includes the 'frontend'
# directory and all its config files (next.config.js, etc.).
# The .dockerignore file prevents local node_modules from being included.
COPY ./apps ./apps

# Run the build command, filtering to build ONLY the frontend app.
RUN pnpm --filter frontend build

#----------------------------------------------------------------
# 3. Production/Runner Stage ('runner')
# Copies only the final, standalone build artifacts for a small, secure image.
#----------------------------------------------------------------
FROM base AS runner
WORKDIR /app
ENV NODE_ENV=production

# Create a non-root user for security.
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copy the standalone output from the builder stage.
COPY --from=builder --chown=nextjs:nodejs /app/apps/frontend/.next/standalone ./

# Copy the public assets and static build outputs.
COPY --from=builder /app/apps/frontend/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/apps/frontend/.next/static ./.next/static

USER nextjs
EXPOSE 3000
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

# The standalone output's server file is at the root of this stage.
CMD ["node", "server.js"]
