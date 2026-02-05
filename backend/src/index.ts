import cors from 'cors';
import express, { Express, NextFunction, Request, Response } from 'express';
import helmet from 'helmet';
import morgan from 'morgan';
import path from 'path';
import { fileURLToPath } from 'url';

import { corsOptions } from './config/cors.js';
import { env, isDev } from './config/env.js';
import { logger, morganStream } from './utils/logger.js';
import { sendError, sendNotFound } from './utils/response.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Create Express app
const app: Express = express();

// Trust proxy (for rate limiting behind reverse proxy)
app.set('trust proxy', 1);

// Security middleware
app.use(helmet());

// CORS
app.use(cors(corsOptions));

// Body parsing
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Request logging
app.use(morgan(isDev ? 'dev' : 'combined', { stream: morganStream }));

// Static files (uploads)
app.use('/uploads', express.static(path.join(__dirname, '../uploads')));

// Health check endpoint
app.get('/health', (_req: Request, res: Response) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    environment: env.NODE_ENV,
  });
});

// API Routes placeholder
app.get('/api', (_req: Request, res: Response) => {
  res.json({
    message: 'Welcome to WediSense AMS API',
    version: '1.0.0',
    documentation: '/api-docs',
  });
});

// TODO: Add routes here
// app.use('/api/auth', authRoutes);
// app.use('/api/assets', assetRoutes);
// ... etc

// 404 handler
app.use((_req: Request, res: Response) => {
  sendNotFound(res, 'Endpoint not found');
});

// Global error handler
app.use((err: Error, _req: Request, res: Response, _next: NextFunction) => {
  logger.error('Unhandled error:', err);

  if (isDev) {
    sendError(res, 'INTERNAL_ERROR', err.message, 500);
  } else {
    sendError(res, 'INTERNAL_ERROR', 'An unexpected error occurred', 500);
  }
});

// Start server
const PORT = env.PORT;

app.listen(PORT, () => {
  logger.info(`🚀 Server running on http://localhost:${PORT}`);
  logger.info(`📝 Environment: ${env.NODE_ENV}`);
  logger.info(`🔗 Frontend URL: ${env.FRONTEND_URL}`);
});

export default app;
