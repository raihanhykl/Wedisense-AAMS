import { CorsOptions } from 'cors';
import { env, isDev } from './env.js';

export const corsOptions: CorsOptions = {
  origin: isDev
    ? [env.FRONTEND_URL, 'http://localhost:3000', 'http://localhost:3001']
    : [env.FRONTEND_URL],
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With', 'X-Tenant-ID'],
  exposedHeaders: ['X-Total-Count', 'X-Total-Pages'],
  maxAge: 86400, // 24 hours
};
