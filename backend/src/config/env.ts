import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Load environment variables
dotenv.config({ path: path.resolve(__dirname, '../../.env') });

interface EnvConfig {
  // Server
  NODE_ENV: string;
  PORT: number;

  // Database
  DATABASE_URL: string;

  // JWT
  JWT_ACCESS_SECRET: string;
  JWT_REFRESH_SECRET: string;
  JWT_ACCESS_EXPIRY: string;
  JWT_REFRESH_EXPIRY: string;

  // AI
  ANTHROPIC_API_KEY: string;
  AI_MODEL_PRIMARY: string;
  AI_MODEL_SECONDARY: string;
  AI_MAX_TOKENS: number;

  // File Upload
  UPLOAD_DIR: string;
  MAX_FILE_SIZE: number;

  // Email
  SMTP_HOST: string;
  SMTP_PORT: number;
  SMTP_USER: string;
  SMTP_PASS: string;
  EMAIL_FROM: string;

  // Tenant
  DEFAULT_TENANT_NAME: string;
  DEFAULT_TENANT_SLUG: string;

  // Frontend
  FRONTEND_URL: string;
}

function getEnvVar(key: string, defaultValue?: string): string {
  const value = process.env[key] ?? defaultValue;
  if (value === undefined) {
    throw new Error(`Environment variable ${key} is not set`);
  }
  return value;
}

function getEnvVarAsInt(key: string, defaultValue?: number): number {
  const value = process.env[key];
  if (value === undefined) {
    if (defaultValue !== undefined) return defaultValue;
    throw new Error(`Environment variable ${key} is not set`);
  }
  const parsed = parseInt(value, 10);
  if (isNaN(parsed)) {
    throw new Error(`Environment variable ${key} is not a valid integer`);
  }
  return parsed;
}

export const env: EnvConfig = {
  // Server
  NODE_ENV: getEnvVar('NODE_ENV', 'development'),
  PORT: getEnvVarAsInt('PORT', 4000),

  // Database
  DATABASE_URL: getEnvVar('DATABASE_URL'),

  // JWT
  JWT_ACCESS_SECRET: getEnvVar('JWT_ACCESS_SECRET'),
  JWT_REFRESH_SECRET: getEnvVar('JWT_REFRESH_SECRET'),
  JWT_ACCESS_EXPIRY: getEnvVar('JWT_ACCESS_EXPIRY', '15m'),
  JWT_REFRESH_EXPIRY: getEnvVar('JWT_REFRESH_EXPIRY', '7d'),

  // AI
  ANTHROPIC_API_KEY: getEnvVar('ANTHROPIC_API_KEY', ''),
  AI_MODEL_PRIMARY: getEnvVar('AI_MODEL_PRIMARY', 'claude-sonnet-4-20250514'),
  AI_MODEL_SECONDARY: getEnvVar('AI_MODEL_SECONDARY', 'claude-haiku-4-20250514'),
  AI_MAX_TOKENS: getEnvVarAsInt('AI_MAX_TOKENS', 4096),

  // File Upload
  UPLOAD_DIR: getEnvVar('UPLOAD_DIR', './uploads'),
  MAX_FILE_SIZE: getEnvVarAsInt('MAX_FILE_SIZE', 10485760),

  // Email
  SMTP_HOST: getEnvVar('SMTP_HOST', 'smtp.gmail.com'),
  SMTP_PORT: getEnvVarAsInt('SMTP_PORT', 587),
  SMTP_USER: getEnvVar('SMTP_USER', ''),
  SMTP_PASS: getEnvVar('SMTP_PASS', ''),
  EMAIL_FROM: getEnvVar('EMAIL_FROM', 'noreply@wedison.id'),

  // Tenant
  DEFAULT_TENANT_NAME: getEnvVar('DEFAULT_TENANT_NAME', 'Wedison ID'),
  DEFAULT_TENANT_SLUG: getEnvVar('DEFAULT_TENANT_SLUG', 'wedison'),

  // Frontend
  FRONTEND_URL: getEnvVar('FRONTEND_URL', 'http://localhost:3000'),
};

export const isDev = env.NODE_ENV === 'development';
export const isProd = env.NODE_ENV === 'production';
