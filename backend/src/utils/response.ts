import { Response } from 'express';

export interface ApiResponse<T = unknown> {
  success: boolean;
  data?: T;
  error?: {
    code: string;
    message: string;
    details?: Record<string, string[]>;
  };
  meta?: {
    page: number;
    pageSize: number;
    total: number;
    totalPages: number;
  };
}

export function sendSuccess<T>(
  res: Response,
  data: T,
  statusCode = 200,
  meta?: ApiResponse['meta']
): Response {
  const response: ApiResponse<T> = {
    success: true,
    data,
  };

  if (meta) {
    response.meta = meta;
  }

  return res.status(statusCode).json(response);
}

export function sendError(
  res: Response,
  code: string,
  message: string,
  statusCode = 400,
  details?: Record<string, string[]>
): Response {
  const response: ApiResponse = {
    success: false,
    error: {
      code,
      message,
      details,
    },
  };

  return res.status(statusCode).json(response);
}

export function sendCreated<T>(res: Response, data: T): Response {
  return sendSuccess(res, data, 201);
}

export function sendNoContent(res: Response): Response {
  return res.status(204).send();
}

export function sendNotFound(res: Response, message = 'Resource not found'): Response {
  return sendError(res, 'NOT_FOUND', message, 404);
}

export function sendUnauthorized(res: Response, message = 'Unauthorized'): Response {
  return sendError(res, 'UNAUTHORIZED', message, 401);
}

export function sendForbidden(res: Response, message = 'Forbidden'): Response {
  return sendError(res, 'FORBIDDEN', message, 403);
}

export function sendValidationError(res: Response, details: Record<string, string[]>): Response {
  return sendError(res, 'VALIDATION_ERROR', 'Validation failed', 400, details);
}

export function sendInternalError(res: Response, message = 'Internal server error'): Response {
  return sendError(res, 'INTERNAL_ERROR', message, 500);
}
