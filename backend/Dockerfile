# ============================================
# Stage 1: Dependencies
# ============================================
FROM node:20-alpine AS deps

WORKDIR /app

# Copy package files
COPY package.json package-lock.json* ./
COPY prisma ./prisma/

# Install dependencies (use npm install as fallback if no lock file)
RUN if [ -f package-lock.json ]; then npm ci; else npm install; fi

# Generate Prisma Client
RUN npx prisma generate

# ============================================
# Stage 2: Development
# ============================================
FROM node:20-alpine AS development

WORKDIR /app

# Copy dependencies from deps stage
COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/prisma ./prisma

# Copy source code
COPY . .

# Expose port
EXPOSE 4000

# Start development server
CMD ["npm", "run", "dev"]

# ============================================
# Stage 3: Builder
# ============================================
FROM node:20-alpine AS builder

WORKDIR /app

# Copy dependencies
COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/prisma ./prisma

# Copy source code
COPY . .

# Build application
RUN npm run build

# ============================================
# Stage 4: Production
# ============================================
FROM node:20-alpine AS production

WORKDIR /app

ENV NODE_ENV=production

# Create non-root user
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 expressjs

# Copy necessary files
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/package.json ./

# Create uploads directory
RUN mkdir -p uploads && chown -R expressjs:nodejs uploads

# Switch to non-root user
USER expressjs

# Expose port
EXPOSE 4000

# Start production server
CMD ["npm", "start"]