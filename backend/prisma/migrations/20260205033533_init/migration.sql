-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('SUPER_ADMIN', 'ADMIN', 'MANAGER', 'STAFF', 'VIEWER');

-- CreateEnum
CREATE TYPE "AssetStatus" AS ENUM ('AVAILABLE', 'IN_USE', 'MAINTENANCE', 'RESERVED', 'DISPOSED', 'LOST');

-- CreateEnum
CREATE TYPE "AssetCondition" AS ENUM ('EXCELLENT', 'GOOD', 'FAIR', 'POOR', 'DAMAGED');

-- CreateEnum
CREATE TYPE "MaintenanceType" AS ENUM ('PREVENTIVE', 'CORRECTIVE', 'INSPECTION', 'CALIBRATION', 'UPGRADE');

-- CreateEnum
CREATE TYPE "MaintenanceStatus" AS ENUM ('SCHEDULED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'OVERDUE');

-- CreateEnum
CREATE TYPE "DocumentType" AS ENUM ('INVOICE', 'WARRANTY_CERT', 'MANUAL', 'PHOTO', 'CONTRACT', 'MAINTENANCE_REPORT', 'OTHER');

-- CreateEnum
CREATE TYPE "DisposalMethod" AS ENUM ('SOLD', 'DONATED', 'RECYCLED', 'SCRAPPED', 'RETURNED_TO_VENDOR', 'OTHER');

-- CreateEnum
CREATE TYPE "DisposalStatus" AS ENUM ('PENDING', 'APPROVED', 'REJECTED', 'COMPLETED');

-- CreateEnum
CREATE TYPE "AlertType" AS ENUM ('WARRANTY_EXPIRING', 'MAINTENANCE_DUE', 'MAINTENANCE_OVERDUE', 'ASSET_IDLE', 'ANOMALY_DETECTED', 'SYSTEM');

-- CreateEnum
CREATE TYPE "AlertPriority" AS ENUM ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL');

-- CreateTable
CREATE TABLE "tenants" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "logo" TEXT,
    "config" JSONB NOT NULL DEFAULT '{}',
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tenants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "role" "UserRole" NOT NULL DEFAULT 'STAFF',
    "department" TEXT,
    "phone" TEXT,
    "avatar" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "lastLoginAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "refresh_tokens" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "refresh_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "categories" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "icon" TEXT,
    "color" TEXT,
    "parentId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "locations" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "address" TEXT,
    "city" TEXT,
    "province" TEXT,
    "postalCode" TEXT,
    "latitude" DOUBLE PRECISION,
    "longitude" DOUBLE PRECISION,
    "parentId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "locations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "vendors" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "contactName" TEXT,
    "email" TEXT,
    "phone" TEXT,
    "address" TEXT,
    "website" TEXT,
    "notes" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "vendors_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "assets" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "categoryId" TEXT NOT NULL,
    "locationId" TEXT,
    "vendorId" TEXT,
    "purchaseDate" TIMESTAMP(3),
    "purchasePrice" DECIMAL(15,2),
    "purchaseOrderNumber" TEXT,
    "brand" TEXT,
    "model" TEXT,
    "serialNumber" TEXT,
    "specifications" JSONB,
    "status" "AssetStatus" NOT NULL DEFAULT 'AVAILABLE',
    "condition" "AssetCondition" NOT NULL DEFAULT 'GOOD',
    "usefulLifeMonths" INTEGER,
    "residualValue" DECIMAL(15,2),
    "depreciationMethod" TEXT,
    "qrCode" TEXT,
    "createdById" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "assets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "assignments" (
    "id" TEXT NOT NULL,
    "assetId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "assignedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expectedReturnDate" TIMESTAMP(3),
    "returnedAt" TIMESTAMP(3),
    "assignmentNotes" TEXT,
    "returnNotes" TEXT,
    "returnCondition" "AssetCondition",
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "maintenances" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "assetId" TEXT NOT NULL,
    "type" "MaintenanceType" NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "scheduledDate" TIMESTAMP(3) NOT NULL,
    "completedDate" TIMESTAMP(3),
    "status" "MaintenanceStatus" NOT NULL DEFAULT 'SCHEDULED',
    "performedById" TEXT,
    "vendorId" TEXT,
    "estimatedCost" DECIMAL(15,2),
    "actualCost" DECIMAL(15,2),
    "findings" TEXT,
    "actions" TEXT,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "maintenances_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "warranties" (
    "id" TEXT NOT NULL,
    "assetId" TEXT NOT NULL,
    "vendorId" TEXT,
    "type" TEXT,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3) NOT NULL,
    "terms" TEXT,
    "contactInfo" TEXT,
    "claimProcess" TEXT,
    "documentUrl" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "warranties_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "documents" (
    "id" TEXT NOT NULL,
    "assetId" TEXT NOT NULL,
    "type" "DocumentType" NOT NULL,
    "name" TEXT NOT NULL,
    "fileName" TEXT NOT NULL,
    "filePath" TEXT NOT NULL,
    "fileSize" INTEGER NOT NULL,
    "mimeType" TEXT NOT NULL,
    "extractedData" JSONB,
    "uploadedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "documents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "disposals" (
    "id" TEXT NOT NULL,
    "assetId" TEXT NOT NULL,
    "reason" TEXT NOT NULL,
    "requestedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status" "DisposalStatus" NOT NULL DEFAULT 'PENDING',
    "approvedById" TEXT,
    "approvedAt" TIMESTAMP(3),
    "rejectionReason" TEXT,
    "method" "DisposalMethod",
    "disposedAt" TIMESTAMP(3),
    "disposalValue" DECIMAL(15,2),
    "disposalNotes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "disposals_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ai_logs" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "query" TEXT NOT NULL,
    "intent" TEXT,
    "response" TEXT NOT NULL,
    "functionsUsed" JSONB,
    "inputTokens" INTEGER,
    "outputTokens" INTEGER,
    "latencyMs" INTEGER,
    "model" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ai_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "alerts" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "type" "AlertType" NOT NULL,
    "priority" "AlertPriority" NOT NULL DEFAULT 'MEDIUM',
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "assetId" TEXT,
    "metadata" JSONB,
    "isRead" BOOLEAN NOT NULL DEFAULT false,
    "isDismissed" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" TIMESTAMP(3),

    CONSTRAINT "alerts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "activity_logs" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "userId" TEXT,
    "action" TEXT NOT NULL,
    "entity" TEXT NOT NULL,
    "entityId" TEXT,
    "description" TEXT NOT NULL,
    "previousData" JSONB,
    "newData" JSONB,
    "ipAddress" TEXT,
    "userAgent" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "activity_logs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "tenants_slug_key" ON "tenants"("slug");

-- CreateIndex
CREATE INDEX "users_tenantId_idx" ON "users"("tenantId");

-- CreateIndex
CREATE INDEX "users_email_idx" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_tenantId_email_key" ON "users"("tenantId", "email");

-- CreateIndex
CREATE UNIQUE INDEX "refresh_tokens_token_key" ON "refresh_tokens"("token");

-- CreateIndex
CREATE INDEX "refresh_tokens_userId_idx" ON "refresh_tokens"("userId");

-- CreateIndex
CREATE INDEX "refresh_tokens_token_idx" ON "refresh_tokens"("token");

-- CreateIndex
CREATE INDEX "categories_tenantId_idx" ON "categories"("tenantId");

-- CreateIndex
CREATE UNIQUE INDEX "categories_tenantId_name_parentId_key" ON "categories"("tenantId", "name", "parentId");

-- CreateIndex
CREATE INDEX "locations_tenantId_idx" ON "locations"("tenantId");

-- CreateIndex
CREATE UNIQUE INDEX "locations_tenantId_name_parentId_key" ON "locations"("tenantId", "name", "parentId");

-- CreateIndex
CREATE INDEX "vendors_tenantId_idx" ON "vendors"("tenantId");

-- CreateIndex
CREATE UNIQUE INDEX "vendors_tenantId_name_key" ON "vendors"("tenantId", "name");

-- CreateIndex
CREATE INDEX "assets_tenantId_status_idx" ON "assets"("tenantId", "status");

-- CreateIndex
CREATE INDEX "assets_tenantId_categoryId_idx" ON "assets"("tenantId", "categoryId");

-- CreateIndex
CREATE INDEX "assets_tenantId_locationId_idx" ON "assets"("tenantId", "locationId");

-- CreateIndex
CREATE INDEX "assets_tenantId_code_idx" ON "assets"("tenantId", "code");

-- CreateIndex
CREATE UNIQUE INDEX "assets_tenantId_code_key" ON "assets"("tenantId", "code");

-- CreateIndex
CREATE INDEX "assignments_assetId_idx" ON "assignments"("assetId");

-- CreateIndex
CREATE INDEX "assignments_userId_idx" ON "assignments"("userId");

-- CreateIndex
CREATE INDEX "maintenances_tenantId_idx" ON "maintenances"("tenantId");

-- CreateIndex
CREATE INDEX "maintenances_assetId_idx" ON "maintenances"("assetId");

-- CreateIndex
CREATE INDEX "maintenances_status_idx" ON "maintenances"("status");

-- CreateIndex
CREATE INDEX "maintenances_scheduledDate_idx" ON "maintenances"("scheduledDate");

-- CreateIndex
CREATE INDEX "warranties_assetId_idx" ON "warranties"("assetId");

-- CreateIndex
CREATE INDEX "warranties_endDate_idx" ON "warranties"("endDate");

-- CreateIndex
CREATE INDEX "documents_assetId_idx" ON "documents"("assetId");

-- CreateIndex
CREATE UNIQUE INDEX "disposals_assetId_key" ON "disposals"("assetId");

-- CreateIndex
CREATE INDEX "disposals_status_idx" ON "disposals"("status");

-- CreateIndex
CREATE INDEX "ai_logs_userId_idx" ON "ai_logs"("userId");

-- CreateIndex
CREATE INDEX "ai_logs_createdAt_idx" ON "ai_logs"("createdAt");

-- CreateIndex
CREATE INDEX "alerts_tenantId_idx" ON "alerts"("tenantId");

-- CreateIndex
CREATE INDEX "alerts_type_idx" ON "alerts"("type");

-- CreateIndex
CREATE INDEX "alerts_isRead_idx" ON "alerts"("isRead");

-- CreateIndex
CREATE INDEX "activity_logs_tenantId_idx" ON "activity_logs"("tenantId");

-- CreateIndex
CREATE INDEX "activity_logs_userId_idx" ON "activity_logs"("userId");

-- CreateIndex
CREATE INDEX "activity_logs_entity_idx" ON "activity_logs"("entity");

-- CreateIndex
CREATE INDEX "activity_logs_createdAt_idx" ON "activity_logs"("createdAt");

-- AddForeignKey
ALTER TABLE "users" ADD CONSTRAINT "users_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refresh_tokens" ADD CONSTRAINT "refresh_tokens_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "categories" ADD CONSTRAINT "categories_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "categories"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "categories" ADD CONSTRAINT "categories_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "locations" ADD CONSTRAINT "locations_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "locations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "locations" ADD CONSTRAINT "locations_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vendors" ADD CONSTRAINT "vendors_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assets" ADD CONSTRAINT "assets_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assets" ADD CONSTRAINT "assets_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assets" ADD CONSTRAINT "assets_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "locations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assets" ADD CONSTRAINT "assets_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES "vendors"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assets" ADD CONSTRAINT "assets_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assignments" ADD CONSTRAINT "assignments_assetId_fkey" FOREIGN KEY ("assetId") REFERENCES "assets"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assignments" ADD CONSTRAINT "assignments_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "maintenances" ADD CONSTRAINT "maintenances_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "maintenances" ADD CONSTRAINT "maintenances_assetId_fkey" FOREIGN KEY ("assetId") REFERENCES "assets"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "maintenances" ADD CONSTRAINT "maintenances_performedById_fkey" FOREIGN KEY ("performedById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "maintenances" ADD CONSTRAINT "maintenances_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES "vendors"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "warranties" ADD CONSTRAINT "warranties_assetId_fkey" FOREIGN KEY ("assetId") REFERENCES "assets"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "warranties" ADD CONSTRAINT "warranties_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES "vendors"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "documents" ADD CONSTRAINT "documents_assetId_fkey" FOREIGN KEY ("assetId") REFERENCES "assets"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "disposals" ADD CONSTRAINT "disposals_assetId_fkey" FOREIGN KEY ("assetId") REFERENCES "assets"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "disposals" ADD CONSTRAINT "disposals_approvedById_fkey" FOREIGN KEY ("approvedById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ai_logs" ADD CONSTRAINT "ai_logs_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "alerts" ADD CONSTRAINT "alerts_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "activity_logs" ADD CONSTRAINT "activity_logs_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;
