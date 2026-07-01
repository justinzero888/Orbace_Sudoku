Document 2: Orbace Sudoku — Technology Stack & Infrastructure Document  
  
---  
  
# Orbace Sudoku — Technology Stack & Infrastructure  
  
**Version**: 2.0    
**Date**: 2026-06-28    
**Supersedes**: V1.0 Tech Stack Recommendation    
**Purpose**: Define the complete technology stack for Orbace Sudoku across mobile, web, and cloud infrastructure, incorporating Vercel + Supabase analysis and China market considerations.  
  
---  
  
## 1. Architecture Overview  
  
```  
┌─────────────────────────────────────────────────────────────────┐  
│                    ORBACE SUDOKU ARCHITECTURE                     │  
│                                                                  │  
│  ┌──────────────────┐  ┌──────────────────┐  ┌───────────────┐ │  
│  │   Mobile Apps    │  │   Web Platform   │  │  Admin Panel  │ │  
│  │  (iOS + Android) │  │  (Flutter Web)   │  │  (Web)        │ │  
│  │                  │  │                  │  │               │ │  
│  │  Local DB: Drift │  │  Hosted: Vercel  │  │  Vercel       │ │  
│  │  (SQLite)        │  │                  │  │               │ │  
│  └────────┬─────────┘  └────────┬─────────┘  └───────┬───────┘ │  
│           │                     │                     │          │  
│           └─────────────────────┼─────────────────────┘          │  
│                                 │                                 │  
│                                 ▼                                 │  
│              ┌─────────────────────────────────────┐             │  
│              │           Vercel Edge Network        │             │  
│              │     (CDN, Edge Functions, Routing)   │             │  
│              └─────────────────┬───────────────────┘             │  
│                                 │                                 │  
│                    ┌────────────┼────────────┐                   │  
│                    ▼            ▼            ▼                   │  
│              ┌──────────┐ ┌──────────┐ ┌──────────┐            │  
│              │ Supabase │ │ Upstash  │ │  Fly.io  │            │  
│              │PostgreSQL│ │  Redis   │ │ Fastify  │            │  
│              │  + Auth  │ │ (Cache)  │ │(ORG API) │            │  
│              │+ Storage │ │          │ │          │            │  
│              └──────────┘ └──────────┘ └──────────┘            │  
│                                                                  │  
│  China Access: orbacesudoku.com accessible (low-risk content).   │  
│  Performance varies. orbacesudoku.cn registered defensively.     │  
│  China infrastructure deferred to V2.0+ contingent on demand.    │  
└─────────────────────────────────────────────────────────────────┘  
```  
  
---  
  
## 2. Stack Decision: Vercel + Supabase (with Additions)  
  
### 2.1 Why Not AWS (for V1.2)  
  
| Factor | AWS | Vercel + Supabase | Winner |  
|--------|-----|-------------------|--------|  
| Time to V1.2 launch | 12-16 weeks | 8-10 weeks | Vercel/Supabase |  
| Monthly cost (launch) | ~$141/month | ~$45-75/month | Vercel/Supabase |  
| Cold start risk | None (always-warm) | Mitigated (Fly.io for ORG) | AWS (but mitigated) |  
| Developer experience | Complex (VPC, IAM, ECS) | Excellent (Git push deploy) | Vercel/Supabase |  
| PostgreSQL portability | Standard | Standard (same Postgres) | Tie |  
| Scalability ceiling | Very high | High (with Team/Enterprise) | AWS |  
| China readiness | AWS China available | No China infra | AWS |  
  
**Decision**: Vercel + Supabase for V1.2, with Fly.io for the ORG submission endpoint to eliminate cold start risk for competitive play. Re-evaluate AWS migration at V2.0 based on scale requirements and China market demand.  
  
### 2.2 Migration Path to AWS (If Needed)  
  
```  
V1.2: Vercel + Supabase + Upstash + Fly.io  
  │  
  │  Trigger: 50K+ concurrent ORG players OR China market entry  
  │  
  ▼  
V2.0: Hybrid or Full AWS  
  - Supabase PostgreSQL → AWS RDS PostgreSQL (pg_dump, same schema)  
  - Supabase Auth → Keep or migrate to custom/Clerk  
  - Vercel → Keep for frontend hosting  
  - Fly.io → AWS ECS for ORG endpoint at scale  
  - Upstash Redis → AWS ElastiCache or keep Upstash (multi-cloud)  
```  
  
---  
  
## 3. Component Details  
  
### 3.1 Mobile & Web Client  
  
| Component | Technology | Version | Purpose |  
|-----------|-----------|---------|---------|  
| Framework | Flutter | 3.x stable | Cross-platform iOS, Android, Web |  
| State Management | Riverpod | 2.x | Reactive state, dependency injection |  
| Local Database | Drift (SQLite) | Latest | Puzzles, Su-Pu records, game state, settings |  
| HTTP Client | Dio | Latest | API communication with JWT interceptors |  
| Secure Storage | flutter_secure_storage | Latest | JWT tokens, sensitive credentials |  
| Share | share_plus | Latest | Platform share sheet for 传谱 |  
| Image Generation | RepaintBoundary + dart:ui | Built-in | Certificate PNG rendering |  
| URL Launcher | url_launcher | Latest | Deep links for replay sharing |  
| Web Hosting | Vercel | — | Flutter Web deployment with edge network |  
  
### 3.2 Cloud Database: Supabase (PostgreSQL 15)  
  
| Feature | Implementation |  
|---------|---------------|  
| **Database** | PostgreSQL 15, managed by Supabase |  
| **ORM** | Prisma 5.x (type-safe, migrations, supports Supabase PostgreSQL) |  
| **Row-Level Security** | Supabase RLS policies for player data isolation |  
| **Connection Pooling** | PgBouncer (included in Supabase Pro) |  
| **Backups** | Automated 7-day point-in-time recovery (Pro tier) |  
| **Migrations** | Prisma Migrate (development) + Supabase CLI (production) |  
| **Direct Access** | Connection string available for Prisma, Drizzle, or raw SQL |  
  
**Key Tables:**  
  
```sql  
-- Players (extends Supabase auth.users)  
CREATE TABLE player_profiles (  
  player_id UUID PRIMARY KEY REFERENCES auth.users(id),  
  display_name TEXT UNIQUE NOT NULL,  
  display_name_lower TEXT UNIQUE NOT NULL,  
  country_code TEXT,  
  scholar_path_stage INTEGER DEFAULT 1,  
  total_rp INTEGER DEFAULT 0,  
  privacy_replay_default TEXT DEFAULT 'public',  
  created_at TIMESTAMPTZ DEFAULT NOW()  
);  
  
-- ORG Events  
CREATE TABLE official_events (  
  event_id TEXT PRIMARY KEY,  
  event_type TEXT NOT NULL,  -- 'daily', 'mini_tournament', 'major_tournament'  
  puzzle_id TEXT NOT NULL,  
  event_date DATE NOT NULL,  
  window_start TIMESTAMPTZ NOT NULL,  
  window_end TIMESTAMPTZ NOT NULL,  
  puzzle_checksum TEXT NOT NULL,  
  scoring_version INTEGER NOT NULL,  
  is_active BOOLEAN DEFAULT TRUE  
);  
  
-- ORG Submissions (one per player per event)  
CREATE TABLE org_submissions (  
  submission_id TEXT PRIMARY KEY,  
  event_id TEXT NOT NULL REFERENCES official_events(event_id),  
  player_id UUID NOT NULL REFERENCES player_profiles(player_id),  
  supu_id TEXT NOT NULL,  
  completed BOOLEAN NOT NULL,  
  error_count INTEGER DEFAULT 0,  
  hint_count INTEGER DEFAULT 0,  
  elapsed_seconds INTEGER,  
  completion_bonus INTEGER NOT NULL,  
  speed_bonus INTEGER DEFAULT 0,  
  speed_rank INTEGER,  
  total_rp INTEGER NOT NULL,  
  submitted_for_speed BOOLEAN DEFAULT FALSE,  
  completed_at_timestamp TIMESTAMPTZ,  -- Client-reported completion time  
  replay_data_json JSONB,  
  replay_hash TEXT,  
  validation_status TEXT DEFAULT 'pending',  
  client_version TEXT,  
  platform TEXT,  
  UNIQUE(event_id, player_id)  
);  
  
-- Leaderboards (materialized after event close)  
CREATE TABLE leaderboard_daily (  
  event_date DATE PRIMARY KEY,  
  event_id TEXT NOT NULL,  
  results_json JSONB NOT NULL,  
  total_participants INTEGER NOT NULL,  
  finalized_at TIMESTAMPTZ NOT NULL  
);  
  
-- RP Ledger (immutable audit trail)  
CREATE TABLE rp_ledger (  
  transaction_id TEXT PRIMARY KEY,  
  player_id UUID NOT NULL,  
  event_id TEXT NOT NULL,  
  completion_bonus INTEGER NOT NULL,  
  speed_bonus INTEGER NOT NULL,  
  total_rp INTEGER NOT NULL,  
  transaction_type TEXT NOT NULL,  
  created_at TIMESTAMPTZ DEFAULT NOW()  
);  
```  
  
### 3.3 Authentication: Supabase Auth  
  
| Feature | Implementation |  
|---------|---------------|  
| **Email/Password** | Supabase Auth built-in |  
| **Social OAuth** | Apple, Google (configured in Supabase dashboard) |  
| **JWT** | Automatic. Row-Level Security integrates with `auth.uid()` |  
| **Email Verification** | Built-in templates |  
| **Password Reset** | Built-in flow |  
| **Session Management** | Refresh token rotation |  
| **Rate Limiting** | Supabase provides basic rate limiting on auth endpoints |  
  
### 3.4 Cache: Upstash Redis  
  
| Use Case | Implementation |  
|----------|---------------|  
| **Live leaderboard** | Sorted Set: `ZADD org:live:{event_id} {elapsed_seconds} {player_id}` |  
| **Player rank lookup** | `ZRANK org:live:{event_id} {player_id}` |  
| **Rate limiting** | Per-player counters with TTL |  
| **ORG attempt tracking** | `SET org:attempt:{event_id}:{player_id} "started" EX 86400` |  
| **Session cache** | JWT validation cache for hot paths |  
  
**Why Upstash over Supabase Realtime:**  
- Supabase Realtime is WebSocket-based; unreliable from China and high-latency regions  
- Upstash Redis provides server-authoritative sorted sets for accurate ranking  
- Polling-based leaderboard (5-10s interval) more reliable than WebSocket for global audience  
- Upstash has free tier sufficient for V1.2 launch scale  
  
### 3.5 ORG Submission Endpoint: Fly.io  
  
| Factor | Detail |  
|--------|--------|  
| **Why separate?** | Eliminates cold start risk for latency-sensitive competitive submissions |  
| **Runtime** | Node.js 22 + Fastify |  
| **Scaling** | Single instance for V1.2 (auto-scales if needed) |  
| **Cost** | ~$5/month (1 shared CPU, 256MB RAM) |  
| **Deployment** | `fly deploy` from Git repository |  
| **Regions** | us-east-1 (closest to Supabase) |  
  
**What runs on Fly.io:**  
- `POST /org/submit` — ORG submission validation and acceptance  
- This is the only endpoint that requires guaranteed warm performance  
  
**What runs on Vercel:**  
- All other API routes (Edge Functions or Serverless)  
- Static page serving  
- Replay viewer  
  
### 3.6 Object Storage: Supabase Storage + Cloudflare R2  
  
| Use Case | Storage | Rationale |  
|----------|---------|-----------|  
| Replay JSON data | Supabase Storage | Integrated auth, simple access control |  
| Certificate PNGs | Supabase Storage | Generated on-demand, cached after first generation |  
| Remote puzzle packs | Supabase Storage | Versioned, downloadable |  
| Public replay viewer assets | Vercel (static) | CDN-cached, no storage cost |  
| Shared replay exports (viral) | Cloudflare R2 | Zero egress fees if replays go viral |  
  
### 3.7 Background Jobs: Vercel Cron + Supabase Edge Functions  
  
| Job | Schedule | Implementation |  
|-----|----------|---------------|  
| Leaderboard finalization | 22:00 ET daily | Vercel Cron → Edge Function |  
| Weekly leaderboard | Sunday 00:00 ET | Vercel Cron |  
| Monthly leaderboard | 1st of month 00:00 ET | Vercel Cron |  
| Session cleanup | Hourly | Supabase Edge Function |  
| Replay storage cleanup | Weekly | Supabase Edge Function |  
  
### 3.8 Monitoring & Observability  
  
| Tool | Purpose |  
|------|---------|  
| Sentry | Error tracking (Flutter + Node.js) |  
| Vercel Analytics | Web traffic, performance metrics |  
| Supabase Logs | Database query performance, auth events |  
| Upstash Console | Redis metrics, memory usage |  
| Fly.io Metrics | ORG endpoint latency, request volume |  
| China Monitoring | External service with China-based probes to test orbacesudoku.com accessibility |  
  
---  
  
## 4. Local Database: Drift (SQLite)  
  
### 4.1 Schema (Key Tables)  
  
```sql  
-- Puzzles (pre-loaded, read-only)  
CREATE TABLE puzzles (  
  id TEXT PRIMARY KEY,  
  pack_id TEXT NOT NULL,  
  difficulty TEXT NOT NULL,  
  givens_json TEXT NOT NULL,  
  solution_json TEXT NOT NULL,  
  solve_path_json TEXT NOT NULL,  
  difficulty_score INTEGER NOT NULL,  
  target_time_seconds INTEGER,  
  required_techniques_json TEXT,  
  ranked_eligible INTEGER DEFAULT 0  
);  
  
-- Su-Pu Records  
CREATE TABLE supu_records (  
  id TEXT PRIMARY KEY,  
  puzzle_id TEXT NOT NULL REFERENCES puzzles(id),  
  su_pu_class TEXT NOT NULL,  -- official, practice, retry, legacy  
  attempt_number INTEGER NOT NULL,  
  parent_supu_id TEXT,  
  elapsed_seconds INTEGER,  
  error_count INTEGER NOT NULL DEFAULT 0,  
  hint_nudge_count INTEGER DEFAULT 0,  
  hint_explanation_count INTEGER DEFAULT 0,  
  hint_reveal_count INTEGER DEFAULT 0,  
  auto_check_enabled INTEGER DEFAULT 0,  
  clean_solve INTEGER DEFAULT 0,  
  ranked_eligible INTEGER DEFAULT 0,  
  score_total INTEGER,  
  score_breakdown_json TEXT,  
  scoring_version INTEGER,  
  move_history_json TEXT,  
  technique_counts_json TEXT,  
  total_steps INTEGER,  
  efficiency_ratio REAL,  
  player_difficulty_rating REAL,  
  player_notes TEXT,  
  is_favorite INTEGER DEFAULT 0,  
  replay_hash TEXT,  
  puzzle_checksum TEXT,  
  certificate_image_path TEXT,  
  started_at TEXT NOT NULL,  
  completed_at TEXT,  
  -- V1.2 ORG fields  
  is_org_submission INTEGER DEFAULT 0,  
  org_game_id TEXT,  
  org_completion_bonus INTEGER,  
  org_speed_bonus INTEGER,  
  org_total_rp INTEGER,  
  org_speed_rank INTEGER,  
  org_submitted_for_speed INTEGER DEFAULT 0  
);  
  
-- Current game state  
CREATE TABLE game_state (  
  puzzle_id TEXT PRIMARY KEY,  
  current_values_json TEXT,  
  notes_json TEXT,  
  move_history_json TEXT,  
  elapsed_seconds INTEGER,  
  is_org_game INTEGER DEFAULT 0,  
  org_game_id TEXT,  
  org_started_at TEXT,  
  updated_at TEXT NOT NULL  
);  
  
-- Scholar's Path  
CREATE TABLE scholar_path (  
  stage_id TEXT PRIMARY KEY,  
  is_complete INTEGER DEFAULT 0,  
  requirements_json TEXT,  
  completed_at TEXT  
);  
  
-- Settings  
CREATE TABLE settings (  
  key TEXT PRIMARY KEY,  
  value TEXT NOT NULL  
);  
```  
  
---  
  
## 5. Deployment Architecture  
  
```  
┌─────────────────────────────────────────────────────────────────┐  
│                        CLOUDFLARE (DNS)                          │  
│                    orbacesudoku.com                              │  
└─────────────────────────────────────────────────────────────────┘  
                              │  
                              ▼  
┌─────────────────────────────────────────────────────────────────┐  
│                        VERCEL EDGE                                │  
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐  │  
│  │ Static Assets│  │ Flutter Web  │  │ Edge Functions       │  │  
│  │ (CDN)        │  │ (orbacesudoku│  │ (API routes, cron)   │  │  
│  │              │  │  .com)       │  │                      │  │  
│  └──────────────┘  └──────────────┘  └──────────────────────┘  │  
└─────────────────────────────────────────────────────────────────┘  
                              │  
                    ┌─────────┼─────────┐  
                    ▼         ▼         ▼  
              ┌──────────┐ ┌──────────┐ ┌──────────┐  
              │ Supabase │ │ Upstash  │ │  Fly.io  │  
              │ (US East)│ │  Redis   │ │ (US East)│  
              │          │ │ (Global) │ │          │  
              │ PostgreSQL│ │          │ │ ORG API  │  
              │ + Auth   │ │          │ │ Fastify  │  
              │ + Storage│ │          │ │          │  
              └──────────┘ └──────────┘ └──────────┘  
```  
  
---  
  
## 6. China Accessibility Strategy  
  
### 6.1 Current State (V1.2)  
  
| Aspect | Reality |  
|--------|---------|  
| **Can Chinese players access?** | Yes, most of the time. Sudoku is low-risk content. GFW unlikely to block. |  
| **Performance** | 2-8s initial load. 300-800ms API latency. Inconsistent. |  
| **ORG fairness** | Completion time measured client-side. Deadline based on completion timestamp, not submission arrival. No competitive disadvantage from latency. |  
| **Live leaderboard** | Polling-based (5-10s). More reliable than WebSocket for cross-Pacific connections. |  
| **Infrastructure** | No China-specific infrastructure. Vercel edge in Tokyo/Singapore serves nearby Asian traffic. |  
| **Domain** | orbacesudoku.cn registered defensively. Not deployed. |  
  
### 6.2 Monitoring  
  
- External monitoring service with China-based probes testing orbacesudoku.com accessibility  
- Track: % of ORG submissions from China IP ranges, submission success rate by region, average API latency by region  
- Alert if accessibility drops below 90% for 24+ hours  
  
### 6.3 Future (V2.0+)  
  
**Trigger**: >15% of active ORG participants from China IP ranges AND consistent demand.  
  
| Option | Description |  
|--------|-------------|  
| **CDN optimization** | Alibaba Cloud CDN or Cloudflare China for static assets |  
| **API edge in Asia** | Deploy API replica in Tokyo or Singapore |  
| **WeChat mini-program** | Lightweight play without full infrastructure |  
| **Full China mirror** | orbacesudoku.cn on Alibaba Cloud. Requires ICP filing, Chinese business entity. Separate leaderboard or unified with sync. |  
  
---  
  
## 7. Cost Estimates  
  
### 7.1 V1.2 Launch (Monthly)  
  
| Service | Plan | Monthly Cost |  
|---------|------|-------------|  
| Vercel | Pro ($20/mo) | $20 |  
| Supabase | Pro ($25/mo) | $25 |  
| Upstash Redis | Free tier (1GB) | $0 |  
| Fly.io | Single instance | ~$5 |  
| Cloudflare R2 | Free tier (10GB) | $0 |  
| Sentry | Team ($26/mo) | $26 |  
| Resend (email) | Free tier (5K) | $0 |  
| Domain (orbacesudoku.com) | Annual / 12 | ~$1 |  
| **Total** | | **~$77/month** |  
  
### 7.2 V1.2 Growth (Monthly)  
  
| Service | Plan | Monthly Cost |  
|---------|------|-------------|  
| Vercel | Pro | $20 |  
| Supabase | Pro ($25/mo, 8GB) | $25 |  
| Upstash Redis | Pay-as-you-go (~2GB) | ~$20 |  
| Fly.io | 2 instances | ~$10 |  
| Cloudflare R2 | 50GB + egress | ~$5 |  
| Sentry | Team | $26 |  
| Resend | 50K emails | ~$20 |  
| **Total** | | **~$126/month** |  
  
### 7.3 AWS Comparison (What We Save)  
  
| Stack | V1.2 Launch | V1.2 Growth |  
|-------|-------------|-------------|  
| Vercel + Supabase | ~$77/month | ~$126/month |  
| AWS (RDS + ECS + ElastiCache) | ~$141/month | ~$395/month |  
| **Savings** | **$64/month** | **$269/month** |  
  
---  
  
## 8. Key Decisions  
  
| Decision | Resolution | Rationale |  
|----------|-----------|-----------|  
| Cloud provider | Vercel + Supabase | Faster time-to-market, lower cost, better DX. PostgreSQL portability ensures no lock-in. |  
| Cold start mitigation | Fly.io for ORG endpoint | Dedicated warm container eliminates cold start risk for competitive submissions. ~$5/month. |  
| Cache | Upstash Redis | Server-authoritative sorted sets for live leaderboard. More reliable than Supabase Realtime for global audience. |  
| Auth | Supabase Auth | Fastest implementation. Built-in OAuth, JWT, RLS. Migration path exists if needed. |  
| ORM | Prisma | Type-safe, excellent PostgreSQL support, works with Supabase connection string. |  
| Object storage | Supabase Storage + R2 | Supabase for integrated access control. R2 as backup for viral content (zero egress). |  
| Background jobs | Vercel Cron | Simpler than BullMQ. Sufficient for daily leaderboard finalization. |  
| China infrastructure | Deferred to V2.0+ | Monitor demand. orbacesudoku.cn registered defensively. |  
| WebSockets vs Polling | Polling (5-10s) for live leaderboard | More reliable across unstable connections. No dependency on Supabase Realtime limits. |  
  
---  
  
## 9. What We Avoid  
  
| Technology | Why Avoid |  
|------------|-----------|  
| **AWS (for V1.2)** | Higher cost, slower setup, operational complexity. Not needed at V1.2 scale. |  
| **Firebase/Firestore** | No complex queries. Leaderboard ranking impossible without reading all documents. |  
| **MongoDB** | Relational data model fits SQL better. No window functions. |  
| **Supabase Realtime (WebSockets)** | Unreliable from China and high-latency regions. Connection limits on Pro tier. |  
| **Serverless-only (no warm container)** | Cold starts risk competitive integrity for ORG submissions. |  
| **Microservices at launch** | Premature. Monolith with clear module boundaries. Extract only ORG endpoint for performance. |  
  
---  
  
## 10. Disaster Recovery & Backups  
  
| Component | Backup Strategy | RPO | RTO |  
|-----------|----------------|-----|-----|  
| Supabase PostgreSQL | Automated 7-day PITR (Pro tier) + weekly pg_dump to R2 | 1 hour | <1 hour |  
| Upstash Redis | Persistence enabled (snapshot to disk) | 1 minute | <5 minutes |  
| Supabase Storage | Automated by Supabase | 1 hour | <1 hour |  
| Vercel deployments | Git history + preview deployments | N/A | <5 minutes (git push) |  
| Fly.io | Git-based deployment | N/A | <5 minutes (fly deploy) |  
| Player local data | On-device (Drift SQLite) | N/A | N/A (local) |  
  
---  
  
## 11. Security  
  
| Layer | Measure |  
|-------|---------|  
| **Transport** | HTTPS only (enforced by Vercel and Supabase) |  
| **Authentication** | JWT with refresh token rotation (Supabase Auth) |  
| **Password Storage** | bcrypt (Supabase Auth default) |  
| **API Authorization** | Row-Level Security (Supabase RLS) + JWT claims validation |  
| **Rate Limiting** | Upstash Redis counters + Vercel Edge rate limiting |  
| **ORG Submission** | UNIQUE constraint on (event_id, player_id). One attempt enforced at database level. |  
| **Replay Access** | Supabase Storage RLS policies. Public replays: read-all. Private: owner-only. |  
| **Admin Access** | Supabase dashboard with 2FA. Separate admin panel with role-based access. |  
| **Secrets** | Vercel Environment Variables + Supabase Vault |  
| **Dependencies** | Dependabot / Renovate for automated updates |  
  
---  
  
## 12. Recommendation  
  
Proceed with **Vercel + Supabase + Upstash Redis + Fly.io** for V1.2.  
  
**This stack provides:**  
- **8-10 weeks to launch** (vs. 12-16 for AWS) — the decisive factor for V1.2  
- **~$77/month at launch** (vs. ~$141 for AWS)  
- **Excellent developer experience** — Git push deploys, Supabase dashboard, Prisma type-safety  
- **No cold start risk for competitive play** — Fly.io warm container for ORG submissions  
- **PostgreSQL portability** — migrate to AWS RDS with zero code changes if needed at V2.0+  
- **Global accessibility** — Chinese players can access (low-risk content); design accommodates latency  
  
**The stack is optimized for speed-to-market while preserving the option to scale up or migrate when demand warrants.**  
