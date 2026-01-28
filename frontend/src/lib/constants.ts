// Application Constants
export const APP_NAME = 'WediSense AMS';
export const APP_DESCRIPTION = 'AI-powered Asset Management System';
export const APP_VERSION = '1.0.0';

// API Configuration
export const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:4000/api';
export const APP_URL = process.env.NEXT_PUBLIC_APP_URL || 'http://localhost:3000';

// Tenant Configuration
export const TENANT_SLUG = process.env.NEXT_PUBLIC_TENANT_SLUG || 'wedison';

// Feature Flags
export const FEATURES = {
  AI_ENABLED: process.env.NEXT_PUBLIC_ENABLE_AI === 'true',
  OFFLINE_ENABLED: process.env.NEXT_PUBLIC_ENABLE_OFFLINE === 'true',
  QR_ENABLED: process.env.NEXT_PUBLIC_ENABLE_QR === 'true',
} as const;

// Pagination
export const DEFAULT_PAGE_SIZE = 10;
export const PAGE_SIZE_OPTIONS = [10, 25, 50, 100] as const;

// Asset Status
export const ASSET_STATUS = {
  AVAILABLE: 'AVAILABLE',
  IN_USE: 'IN_USE',
  MAINTENANCE: 'MAINTENANCE',
  RESERVED: 'RESERVED',
  DISPOSED: 'DISPOSED',
  LOST: 'LOST',
} as const;

export const ASSET_STATUS_LABELS: Record<string, string> = {
  AVAILABLE: 'Tersedia',
  IN_USE: 'Digunakan',
  MAINTENANCE: 'Maintenance',
  RESERVED: 'Dipesan',
  DISPOSED: 'Dibuang',
  LOST: 'Hilang',
};

export const ASSET_STATUS_COLORS: Record<string, string> = {
  AVAILABLE: 'bg-green-100 text-green-800',
  IN_USE: 'bg-blue-100 text-blue-800',
  MAINTENANCE: 'bg-amber-100 text-amber-800',
  RESERVED: 'bg-purple-100 text-purple-800',
  DISPOSED: 'bg-gray-100 text-gray-800',
  LOST: 'bg-red-100 text-red-800',
};

// Asset Condition
export const ASSET_CONDITION = {
  EXCELLENT: 'EXCELLENT',
  GOOD: 'GOOD',
  FAIR: 'FAIR',
  POOR: 'POOR',
  DAMAGED: 'DAMAGED',
} as const;

export const ASSET_CONDITION_LABELS: Record<string, string> = {
  EXCELLENT: 'Sangat Baik',
  GOOD: 'Baik',
  FAIR: 'Cukup',
  POOR: 'Buruk',
  DAMAGED: 'Rusak',
};

export const ASSET_CONDITION_COLORS: Record<string, string> = {
  EXCELLENT: 'bg-green-100 text-green-800',
  GOOD: 'bg-blue-100 text-blue-800',
  FAIR: 'bg-amber-100 text-amber-800',
  POOR: 'bg-orange-100 text-orange-800',
  DAMAGED: 'bg-red-100 text-red-800',
};

// User Roles
export const USER_ROLES = {
  SUPER_ADMIN: 'SUPER_ADMIN',
  ADMIN: 'ADMIN',
  MANAGER: 'MANAGER',
  STAFF: 'STAFF',
  VIEWER: 'VIEWER',
} as const;

export const USER_ROLE_LABELS: Record<string, string> = {
  SUPER_ADMIN: 'Super Admin',
  ADMIN: 'Admin',
  MANAGER: 'Manager',
  STAFF: 'Staff',
  VIEWER: 'Viewer',
};

// Maintenance Status
export const MAINTENANCE_STATUS = {
  SCHEDULED: 'SCHEDULED',
  IN_PROGRESS: 'IN_PROGRESS',
  COMPLETED: 'COMPLETED',
  CANCELLED: 'CANCELLED',
  OVERDUE: 'OVERDUE',
} as const;

export const MAINTENANCE_STATUS_LABELS: Record<string, string> = {
  SCHEDULED: 'Terjadwal',
  IN_PROGRESS: 'Sedang Berjalan',
  COMPLETED: 'Selesai',
  CANCELLED: 'Dibatalkan',
  OVERDUE: 'Terlambat',
};

// Maintenance Types
export const MAINTENANCE_TYPES = {
  PREVENTIVE: 'PREVENTIVE',
  CORRECTIVE: 'CORRECTIVE',
  INSPECTION: 'INSPECTION',
  CALIBRATION: 'CALIBRATION',
  UPGRADE: 'UPGRADE',
} as const;

export const MAINTENANCE_TYPE_LABELS: Record<string, string> = {
  PREVENTIVE: 'Preventif',
  CORRECTIVE: 'Korektif',
  INSPECTION: 'Inspeksi',
  CALIBRATION: 'Kalibrasi',
  UPGRADE: 'Upgrade',
};

// Date Formats
export const DATE_FORMAT = {
  DISPLAY: 'dd MMMM yyyy',
  INPUT: 'yyyy-MM-dd',
  DATETIME: 'dd MMMM yyyy HH:mm',
  SHORT: 'dd MMM yyyy',
} as const;

// File Upload
export const ALLOWED_FILE_TYPES = {
  IMAGE: ['image/jpeg', 'image/png', 'image/webp'],
  DOCUMENT: ['application/pdf', 'image/jpeg', 'image/png'],
  ALL: ['image/jpeg', 'image/png', 'image/webp', 'application/pdf'],
} as const;

export const MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB
