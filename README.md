# WediSense AMS

AI-powered Asset Management System untuk PT Wedison New Energy Technology.

## Tech Stack

### Frontend

- Next.js 14 (App Router)
- React 18
- TypeScript
- TailwindCSS 3
- shadcn/ui
- Zustand (State Management)
- TanStack Query (Server State)

### Backend

- Node.js 20 LTS
- Express.js 4
- TypeScript
- Prisma 5 (ORM)
- PostgreSQL 15

### AI Services

- Claude API (claude-sonnet-4-20250514)
- Tesseract.js (OCR)

## Getting Started

### Prerequisites

- Node.js 20+
- PostgreSQL 15+
- npm 10+

### Installation

1. Clone repository

```bash
git clone https://github.com/raihanhykl/WediSense-AAMS.git
cd WediSense-AAMS
```

2. Install dependencies

```bash
npm install
```

3. Setup environment variables

```bash
cp frontend/.env.example frontend/.env.local
cp backend/.env.example backend/.env
```

4. Setup database

```bash
npm run db:migrate
npm run db:seed
```

5. Run development server

```bash
npm run dev
```

## Project Structure

```
WediSense-AAMS/
├── frontend/          # Next.js frontend application
├── backend/           # Express.js backend API
├── docs/              # Documentation
├── .github/           # GitHub Actions workflows
├── docker-compose.yml # Docker configuration
└── package.json       # Root package.json (workspaces)
```

## Development

- Frontend runs on: http://localhost:3000
- Backend runs on: http://localhost:4000
- API Documentation: http://localhost:4000/api-docs

## License

Private - PT Wedison New Energy Technology
