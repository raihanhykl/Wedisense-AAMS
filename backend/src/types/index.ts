import { Request } from 'express';

// User roles enum (akan di-generate oleh Prisma nanti, tapi kita define dulu)
export type UserRole = 'SUPER_ADMIN' | 'ADMIN' | 'MANAGER' | 'STAFF' | 'VIEWER';

// Extend Express Request to include user info
export interface AuthenticatedRequest extends Request {
  user?: {
    id: string;
    email: string;
    tenantId: string;
    role: UserRole;
  };
}

// Pagination
export interface PaginationParams {
  page: number;
  pageSize: number;
  skip: number;
  take: number;
}

export interface PaginatedResult<T> {
  data: T[];
  meta: {
    page: number;
    pageSize: number;
    total: number;
    totalPages: number;
  };
}

// Sort
export interface SortParams {
  sortBy: string;
  sortOrder: 'asc' | 'desc';
}

// Common filters
export interface DateRangeFilter {
  startDate?: Date;
  endDate?: Date;
}

// JWT Payload
export interface JwtPayload {
  userId: string;
  email: string;
  tenantId: string;
  role: UserRole;
}

export interface JwtRefreshPayload {
  userId: string;
  tokenId: string;
}
