# Orbace Sudoku V2 — Infrastructure & Resource Setup Guide  
  
**Version**: 1.0  
**Date**: 2026-06-29  
**Context**: While V1 is in final build/test/deploy, begin provisioning all V2 resources. This guide assumes blinkingchorus and orbacetech.com are already on Cloudflare and the team is familiar with that platform.  
  
---  
  
## 1. Resource Inventory  
  
### 1.1 Everything We Need to Register/Configure  
  
| # | Resource | Provider | Purpose | Monthly Cost | Setup Time |  
|---|----------|----------|---------|-------------|------------|  
| 1 | **orbacesudoku.com** | Cloudflare Registrar | Primary domain | ~$12/year | 10 min |  
| 2 | **orbacesudoku.cn** | Cloudflare Registrar | China market (defensive) | ~$12/year | 10 min |  
| 3 | **Supabase Project** | Supabase | Database + Auth + Storage | $25/mo (Pro) | 15 min |  
| 4 | **Vercel Project** | Vercel | Web hosting + Edge Functions | $20/mo (Pro) | 10 min |  
| 5 | **Upstash Redis** | Upstash | Cache + Live Leaderboard | $0 (free tier) | 5 min |  
| 6 | **Fly.io Account** | Fly.io | ORG Submission Endpoint | ~$5/mo | 15 min |  
| 7 | **Sentry Project** | Sentry | Error monitoring | $26/mo (Team) | 10 min |  
| 8 | **Resend Account** | Resend | Transactional email | $0 (free tier) | 10 min |  
| 9 | **GitHub Repository** | GitHub | Source control + CI/CD | $0 (private repo) | 5 min |  
| 10 | **Google Cloud OAuth** | Google Cloud | Sign in with Google | $0 | 30 min |  
| 11 | **Apple Developer OAuth** | Apple Developer | Sign in with Apple | $0 (included in $99/yr) | 30 min |  
| 12 | **Firebase Project** | Firebase | Android push notifications | $0 | 15 min |  
| 13 | **Apple APNs Key** | Apple Developer | iOS push notifications | $0 (included in $99/yr) | 15 min |  
| 14 | **Cloudflare R2 Bucket** | Cloudflare | Object storage (backup) | $0 (free tier) | 10 min |  
| 15 | **China Monitoring** | TBD | GFW accessibility testing | ~$10/mo | 30 min |  
  
**Total Monthly (after free tiers)**: ~$86/month  
**One-time setup costs**: ~$24 (domains)  
  
---  
  
## 2. Step-by-Step Registration Instructions  
  
### 2.1 orbacesudoku.com (Cloudflare Registrar)  
  
Since orbacetech.com is already on Cloudflare, follow the same pattern.  
  
```  
1. Log into Cloudflare Dashboard  
   → https://dash.cloudflare.com  
   → Select the account that holds orbacetech.com  
  
2. Register Domain  
   → Click "Domain Registration" in left sidebar  
   → Click "Register Domains"  
   → Search: orbacesudoku.com  
   → Add to cart  
   → Search: orbacesudoku.cn  
   → Add to cart  
   → Complete purchase (~$24 total for both)  
  
3. Configure DNS (after registration)  
   → Go to DNS → Records  
   → We'll add these later when services are created:  
     - orbacesudoku.com → Vercel (for web app)  
     - api.orbacesudoku.com → Fly.io (for ORG endpoint)  
     - replay.orbacesudoku.com → Vercel or R2 (for replay viewer)  
     
   → For now, add a temporary CNAME:  
     Type: CNAME  
     Name: @  
     Target: placeholder.orbacetech.com (or any existing page)  
     TTL: Auto  
     Proxy: ✅ (Orange cloud ON — this enables Cloudflare protection)  
  
4. Configure SSL/TLS  
   → SSL/TLS → Overview  
   → Set to "Full (strict)"  
   → Edge Certificates: Enable "Always Use HTTPS"  
  
5. Configure Security  
   → Security → Settings  
   → Security Level: Medium  
   → Challenge Passage: 30 minutes  
   → Browser Integrity Check: On  
  
6. Add to existing Cloudflare project context  
   → Note: orbacesudoku.com should be in the SAME Cloudflare account as orbacetech.com  
   → This allows sharing of WAF rules, firewall policies, and team access  
```  
  
**Value to project**:  
- Primary domain for web platform and API  
- Cloudflare provides DDoS protection, CDN, and SSL  
- Consistent with existing orbacetech.com infrastructure  
- Team already knows Cloudflare management  
  
---  
  
### 2.2 Supabase Project  
  
```  
1. Sign up / Log in  
   → https://supabase.com  
   → Sign in with GitHub (recommended for team access)  
  
2. Create Organization  
   → Click "New organization"  
   → Name: Orbace  
   → Choose plan: Free (upgrade to Pro before launch)  
   → This organization will hold all Orbace projects  
  
3. Create Project  
   → Click "New project"  
   → Name: orbace-sudoku  
   → Database Password: [Generate and save in password manager]  
     Format: 32+ characters, mix of upper/lower/numbers/symbols  
     Save as: SUPABASE_DB_PASSWORD  
   → Region: US East (Northern Virginia) — closest to Fly.io and Vercel defaults  
   → Pricing: Free tier for now → Upgrade to Pro ($25/mo) before production  
  
4. Configure Database  
   → Settings → Database  
   → Connection Pooling: Enable PgBouncer  
   → Pool Mode: Transaction  
   → Connection string: Save for later (Prisma setup)  
  
5. Configure Authentication  
   → Authentication → Providers  
   → Email: Enable  
     - Confirm email: Enable  
     - Secure email change: Enable  
   → Google: Will configure in Step 2.9  
   → Apple: Will configure in Step 2.10  
  
6. Get API Keys  
   → Settings → API  
   → Save these values (we'll need them for Flutter + Backend):  
     - SUPABASE_URL: https://xxxxxxxxxxxx.supabase.co  
     - SUPABASE_ANON_KEY: eyJ... (public, safe for client)  
     - SUPABASE_SERVICE_ROLE_KEY: eyJ... (SECRET — server only)  
  
7. Configure Storage  
   → Storage → New bucket  
   → Name: replays  
   → Public: No (access via signed URLs or RLS)  
   → Name: certificates  
   → Public: No  
   → Name: packs  
   → Public: Yes (puzzle packs are downloadable)  
  
8. Invite Team  
   → Settings → Team  
   → Invite developers by email  
   → Role: Developer for devs, Administrator for tech lead  
```  
  
**Value to project**:  
- PostgreSQL database with built-in Auth  
- Row-Level Security for player data isolation  
- Storage for replays, certificates, and puzzle packs  
- Real-time subscriptions (for future live features)  
- Managed backups and point-in-time recovery  
  
**Credentials to save in password manager**:  
```  
SUPABASE_URL=https://xxxxxxxxxxxx.supabase.co  
SUPABASE_ANON_KEY=eyJ...  
SUPABASE_SERVICE_ROLE_KEY=eyJ...  
SUPABASE_DB_PASSWORD=xxxxxxxx  
DATABASE_URL=postgresql://postgres.xxxxxxxxxxxx:password@aws-0-us-east-1.pooler.supabase.com:6543/postgres  
DIRECT_URL=postgresql://postgres.xxxxxxxxxxxx:password@aws-0-us-east-1.pooler.supabase.com:5432/postgres  
```  
  
---  
  
### 2.3 Vercel Project  
  
```  
1. Sign up / Log in  
   → https://vercel.com  
   → Sign in with GitHub (required — Vercel deploys from Git)  
  
2. Create Project  
   → Click "New Project"  
   → Import from GitHub: [will connect to orbace-sudoku repo later]  
   → For now, create a placeholder:  
     - Framework: Other  
     - Root Directory: apps/web  
     - Build Command: flutter build web --release  
     - Output Directory: build/web  
  
3. Configure Domain  
   → Settings → Domains  
   → Add: orbacesudoku.com  
   → Add: www.orbacesudoku.com (redirect to orbacesudoku.com)  
   → Vercel will provide DNS records to add in Cloudflare:  
     - Type: CNAME  
     - Name: @  
     - Value: cname.vercel-dns.com  
     - Go back to Cloudflare → DNS → Add this record  
  
4. Configure Environment Variables  
   → Settings → Environment Variables  
   → Add these (values from Supabase step):  
     - SUPABASE_URL  
     - SUPABASE_ANON_KEY  
   → Environment: Production, Preview, Development  
  
5. Configure Cron Jobs (after backend is deployed)  
   → Settings → Cron Jobs  
   → We'll add these in Phase 2 (per V2 Implementation Plan)  
  
6. Upgrade to Pro  
   → Settings → Billing  
   → Upgrade to Pro ($20/mo)  
   → Why: Cron jobs, analytics, team access, increased bandwidth  
  
7. Invite Team  
   → Settings → Team  
   → Invite developers by GitHub username  
```  
  
**Value to project**:  
- Hosting for Flutter Web app  
- Edge functions for API routes  
- Cron jobs for leaderboard finalization  
- Automatic preview deployments for PRs  
- Analytics for web traffic  
  
**Credentials to save**:  
```  
VERCEL_TOKEN=[from Vercel → Settings → Tokens]  
VERCEL_ORG_ID=[from Vercel → Settings → General]  
VERCEL_PROJECT_ID=[from Vercel → Settings → General]  
```  
  
---  
  
### 2.4 Upstash Redis  
  
```  
1. Sign up / Log in  
   → https://upstash.com  
   → Sign in with GitHub  
  
2. Create Redis Database  
   → Click "Create Database"  
   → Name: orbace-sudoku  
   → Region: US East (same as Supabase)  
   → Type: Redis  
   → Plan: Free (1GB storage, 10K commands/day)  
   → Click Create  
  
3. Get Connection Details  
   → Database Details  
   → Save:  
     - UPSTASH_REDIS_URL: redis://...  
     - UPSTASH_REDIS_TOKEN: ...  
  
4. Configure (Console)  
   → Data → You can test commands here:  
     - SET test "hello"  
     - GET test  
  
5. Note  
   → Upgrade to Pay-as-you-go before production launch  
   → Free tier is sufficient for development and beta  
   → Pay-as-you-go starts at ~$0.20/10K commands  
```  
  
**Value to project**:  
- Live leaderboard (sorted sets for ranking)  
- Rate limiting (counters with TTL)  
- Session caching (JWT validation)  
- ORG attempt tracking (temporary flags)  
  
**Credentials to save**:  
```  
UPSTASH_REDIS_URL=redis://...  
UPSTASH_REDIS_TOKEN=...  
```  
  
---  
  
### 2.5 Fly.io  
  
```  
1. Sign up / Log in  
   → https://fly.io  
   → Sign up with GitHub  
   → Add credit card (required, but free tier covers small usage)  
  
2. Install CLI  
   → brew install flyctl  (macOS)  
   → or: curl -L https://fly.io/install.sh | sh  (Linux)  
   → or: iwr https://fly.io/install.ps1 -useb | iex  (Windows)  
  
3. Authenticate  
   → fly auth login  
   → This opens browser → authorize  
  
4. Create App (will do later via CLI from monorepo)  
   → We'll run this from backend/org-api/:  
     cd backend/org-api  
     fly launch  
     → Name: orbace-sudoku-api  
     → Region: iad (Ashburn, Virginia — same as Supabase)  
     → Deploy now? No (we'll deploy after code is ready)  
  
5. Configure Secrets (after app creation)  
   → fly secrets set \  
       SUPABASE_URL=https://... \  
       SUPABASE_SERVICE_ROLE_KEY=eyJ... \  
       UPSTASH_REDIS_URL=redis://... \  
       UPSTASH_REDIS_TOKEN=... \  
       DATABASE_URL=postgresql://... \  
       SENTRY_DSN=https://...  
  
6. Configure Scaling  
   → fly scale count 1        # Start with 1 instance  
   → fly scale memory 256     # 256MB RAM (sufficient for ORG endpoint)  
   → fly scale vm shared-cpu-1x  
  
7. Note  
   → Free tier includes 3 shared-cpu VMs  
   → ORG endpoint only needs 1 instance to start  
   → Auto-scale later when needed  
```  
  
**Value to project**:  
- Always-warm container for ORG submissions (no cold starts)  
- Close to Supabase (both in us-east-1) for low latency  
- Simple deployment from Git  
- Free tier covers development + early production  
  
**Credentials to save**:  
```  
FLY_API_TOKEN=[from fly auth token]  
FLY_APP_NAME=orbace-sudoku-api  
```  
  
---  
  
### 2.6 Sentry  
  
```  
1. Sign up / Log in  
   → https://sentry.io  
   → Sign in with GitHub  
  
2. Create Organization  
   → Organization name: Orbace  
   → This can hold multiple projects  
  
3. Create Projects  
   → Create Project: orbace-flutter  
     - Platform: Flutter  
     - Team: Orbace  
     
   → Create Project: orbace-backend  
     - Platform: Node.js  
     - Team: Orbace  
  
4. Get DSNs  
   → orbace-flutter → Settings → Client Keys  
   → Save: SENTRY_DSN_FLUTTER  
     
   → orbace-backend → Settings → Client Keys  
   → Save: SENTRY_DSN_BACKEND  
  
5. Configure Alert Rules  
   → Alerts → Create Alert  
   → Condition: "New issue in orbace-flutter"  
   → Action: Send notification to Slack/Email  
  
6. Invite Team  
   → Settings → Members  
   → Invite developers  
  
7. Upgrade to Team Plan  
   → Settings → Subscription  
   → Team plan: $26/month  
   → Includes: 50K errors/month, 30-day history, team access  
```  
  
**Value to project**:  
- Crash reporting for Flutter app (iOS + Android + Web)  
- Error tracking for backend (Fly.io + Edge Functions)  
- Performance monitoring  
- Release tracking (which version introduced the bug?)  
  
**Credentials to save**:  
```  
SENTRY_DSN_FLUTTER=https://...@sentry.io/...  
SENTRY_DSN_BACKEND=https://...@sentry.io/...  
SENTRY_AUTH_TOKEN=[from Sentry → Settings → Auth Tokens]  
SENTRY_ORG=orbace  
```  
  
---  
  
### 2.7 Resend (Email)  
  
```  
1. Sign up / Log in  
   → https://resend.com  
   → Sign in with GitHub  
  
2. Add Domain  
   → Domains → Add Domain  
   → Domain: orbacesudoku.com  
   → Resend will provide DNS records:  
     - MX record  
     - TXT record (DKIM)  
     - TXT record (SPF)  
   → Add these in Cloudflare DNS  
  
3. Generate API Key  
   → API Keys → Create API Key  
   → Name: orbace-sudoku  
   → Permission: Sending access  
   → Save: RESEND_API_KEY  
  
4. Verify Domain  
   → Wait for DNS propagation (5-30 minutes)  
   → Resend shows green check when verified  
  
5. Configure (later in code)  
   → We'll use Resend for:  
     - Email verification (Supabase handles this natively too)  
     - Password reset (Supabase handles this natively too)  
     - "Your daily rank is ready!" notifications (custom)  
     - Tournament reminder emails (custom)  
```  
  
**Value to project**:  
- Transactional email for notifications  
- Modern API, good Flutter/Node.js SDKs  
- Free tier: 100 emails/day (sufficient for development)  
  
**Credentials to save**:  
```  
RESEND_API_KEY=re_...  
```  
  
---  
  
### 2.8 GitHub Repository  
  
```  
1. Create Repository  
   → https://github.com/new  
   → Owner: [orbace organization or personal account]  
   → Name: orbace-sudoku  
   → Description: Orbace Sudoku — Calm puzzles. Real progress.  
   → Private: ✅ Yes  
   → Initialize: No (we'll push from local)  
  
2. Configure Branch Protection  
   → Settings → Branches → Add rule  
   → Branch name pattern: main  
   → Require pull request reviews: ✅  
   → Require status checks: ✅  
   → Require branches to be up to date: ✅  
  
3. Add Secrets (for CI/CD)  
   → Settings → Secrets and variables → Actions  
   → Add all the credentials collected above:  
     - SUPABASE_URL  
     - SUPABASE_ANON_KEY  
     - SUPABASE_SERVICE_ROLE_KEY  
     - DATABASE_URL  
     - UPSTASH_REDIS_URL  
     - UPSTASH_REDIS_TOKEN  
     - FLY_API_TOKEN  
     - SENTRY_DSN_FLUTTER  
     - SENTRY_DSN_BACKEND  
     - VERCEL_TOKEN  
     - VERCEL_ORG_ID  
     - VERCEL_PROJECT_ID  
     - RESEND_API_KEY  
  
4. Invite Team  
   → Settings → Collaborators and teams  
   → Add developers  
```  
  
**Value to project**:  
- Source control  
- CI/CD via GitHub Actions  
- Issue tracking  
- Pull request reviews  
  
---  
  
### 2.9 Google Cloud OAuth (Sign in with Google)  
  
```  
1. Go to Google Cloud Console  
   → https://console.cloud.google.com  
   → Create new project or use existing  
   → Project name: Orbace Sudoku  
  
2. Configure OAuth Consent Screen  
   → APIs & Services → OAuth consent screen  
   → User Type: External  
   → App name: Orbace Sudoku  
   → User support email: support@orbacesudoku.com  
   → Developer contact: [team lead email]  
   → Scopes: email, profile (basic)  
   → Save  
  
3. Create OAuth Credentials  
   → APIs & Services → Credentials  
   → Create Credentials → OAuth client ID  
   → Application type: Web application  
   → Name: Orbace Sudoku Web  
   → Authorized redirect URIs:  
     - https://xxxxxxxxxxxx.supabase.co/auth/v1/callback  (from Supabase)  
   → Create  
  
4. Save Credentials  
   → Client ID: [save]  
   → Client Secret: [save]  
  
5. Add to Supabase  
   → Supabase Dashboard → Authentication → Providers → Google  
   → Client ID: [paste]  
   → Client Secret: [paste]  
   → Enable  
```  
  
**Credentials to save**:  
```  
GOOGLE_CLIENT_ID=...  
GOOGLE_CLIENT_SECRET=...  
```  
  
---  
  
### 2.10 Apple Developer OAuth (Sign in with Apple)  
  
```  
1. Go to Apple Developer  
   → https://developer.apple.com  
   → Certificates, Identifiers & Profiles  
  
2. Create Service ID  
   → Identifiers → Add (+)  
   → Service IDs  
   → Description: Orbace Sudoku Sign In  
   → Identifier: com.orbace.sudoku.signin  
   → Continue → Register  
  
3. Configure Sign in with Apple  
   → Click the new Service ID  
   → Enable "Sign in with Apple"  
   → Configure:  
     - Primary App ID: [your main app bundle ID]  
     - Web Domain: orbacesudoku.com  
     - Return URLs: https://xxxxxxxxxxxx.supabase.co/auth/v1/callback  
   → Save  
  
4. Create Private Key  
   → Keys → Add (+)  
   → Key Name: Orbace Sudoku Sign In Key  
   → Enable: Sign in with Apple  
   → Configure → Select your App ID  
   → Continue → Download  
   → Save the .p8 file securely  
  
5. Add to Supabase  
   → Supabase Dashboard → Authentication → Providers → Apple  
   → Service ID: com.orbace.sudoku.signin  
   → Key ID: [from the key you created]  
   → Team ID: [from Apple Developer membership]  
   → Private Key: [contents of .p8 file]  
   → Enable  
```  
  
**Credentials to save**:  
```  
APPLE_SERVICE_ID=com.orbace.sudoku.signin  
APPLE_KEY_ID=...  
APPLE_TEAM_ID=...  
APPLE_PRIVATE_KEY=-----BEGIN PRIVATE KEY-----...  
```  
  
---  
  
### 2.11 Firebase Project (Android Push Notifications)  
  
```  
1. Go to Firebase Console  
   → https://console.firebase.google.com  
   → Add project  
   → Name: Orbace Sudoku  
  
2. Add Android App  
   → Project Settings → Add app → Android  
   → Package name: com.orbace.sudoku  
   → Register  
   → Download google-services.json  
   → Place in apps/mobile/android/app/  
  
3. Get Cloud Messaging Credentials  
   → Project Settings → Cloud Messaging  
   → Save: Server key token (for backend)  
  
4. Note  
   → Firebase is FREE for push notifications  
   → We only use FCM, not other Firebase services  
   → This keeps the stack independent of Google ecosystem  
```  
  
**Credentials to save**:  
```  
FCM_SERVER_KEY=...  
```  
  
---  
  
### 2.12 Apple APNs Key (iOS Push Notifications)  
  
```  
1. Go to Apple Developer  
   → https://developer.apple.com  
   → Certificates, Identifiers & Profiles  
  
2. Create APNs Key  
   → Keys → Add (+)  
   → Key Name: Orbace Sudoku Push  
   → Enable: Apple Push Notifications service (APNs)  
   → Continue → Download  
   → Save the .p8 file securely  
   → Note the Key ID  
  
3. Note  
   → Team ID is in your Apple Developer membership  
   → Bundle ID is your app's bundle identifier  
```  
  
**Credentials to save**:  
```  
APNS_KEY_ID=...  
APNS_TEAM_ID=...  
APNS_PRIVATE_KEY=-----BEGIN PRIVATE KEY-----...  
APNS_BUNDLE_ID=com.orbace.sudoku  
```  
  
---  
  
### 2.13 Cloudflare R2 Bucket (Object Storage Backup)  
  
```  
1. Go to Cloudflare Dashboard  
   → https://dash.cloudflare.com  
   → R2 → Overview  
  
2. Create Bucket  
   → Create bucket  
   → Name: orbace-sudoku-replays  
   → Location: Automatic  
   → Create  
  
3. Configure Public Access  
   → Bucket Settings → Public Access  
   → Enable: "Allow Public Access" for replay viewing  
  
4. Get Credentials  
   → R2 → Manage R2 API Tokens  
   → Create API Token  
   → Permission: Object Read & Write  
   → Specify bucket: orbace-sudoku-replays  
   → Save:  
     - R2_ACCESS_KEY_ID  
     - R2_SECRET_ACCESS_KEY  
     - R2_ENDPOINT: https://[account-id].r2.cloudflarestorage.com  
  
5. Note  
   → R2 has ZERO egress fees (critical if replays go viral)  
   → 10GB free storage  
   → Used as backup/cache for Supabase Storage  
```  
  
**Credentials to save**:  
```  
R2_ACCESS_KEY_ID=...  
R2_SECRET_ACCESS_KEY=...  
R2_ENDPOINT=https://....r2.cloudflarestorage.com  
R2_BUCKET=orbace-sudoku-replays  
```  
  
---  
  
### 2.14 China Accessibility Monitoring  
  
```  
1. Choose a Service  
   Options:  
   - Pingdom (has China probes on Enterprise plan, expensive)  
   - Dotcom-Monitor (has China monitoring points)  
   - Alibaba Cloud Site Monitoring (cheapest, but requires Alibaba account)  
   - UptimeRobot + custom script from China VPS (DIY)  
  
2. For V2 Development (lightweight):  
   → Use a simple script on a Hong Kong VPS (close to China)  
   → Test orbacesudoku.com accessibility weekly  
   → For now: no automated monitoring needed during V2 dev  
  
3. Before V2 Launch:  
   → Set up proper China monitoring  
   → Budget: ~$10-20/month  
```  
  
---  
  
## 3. Credentials Master List  
  
Create a secure document (1Password vault or similar) with these entries:  
  
```  
# Orbace Sudoku V2 — Service Credentials  
# Created: 2026-06-29  
# Access: Tech lead + Backend lead only  
  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  
DOMAINS (Cloudflare)  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  
ORBACESUDOKU_COM=registered  
ORBACESUDOKU_CN=registered  
  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  
SUPABASE  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  
SUPABASE_URL=https://xxxxxxxxxxxx.supabase.co  
SUPABASE_ANON_KEY=eyJ...  
SUPABASE_SERVICE_ROLE_KEY=eyJ...  
SUPABASE_DB_PASSWORD=[32+ char password]  
DATABASE_URL=postgresql://postgres.xxxx:password@aws-0-us-east-1.pooler.supabase.com:6543/postgres  
DIRECT_URL=postgresql://postgres.xxxx:password@aws-0-us-east-1.pooler.supabase.com:5432/postgres  
  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  
VERCEL  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  
VERCEL_TOKEN=  
VERCEL_ORG_ID=  
VERCEL_PROJECT_ID=  
  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  
UPSTASH REDIS  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  
UPSTASH_REDIS_URL=redis://...  
UPSTASH_REDIS_TOKEN=...  
  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  
FLY.IO  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  
FLY_API_TOKEN=  
FLY_APP_NAME=orbace-sudoku-api  
  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  
SENTRY  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  
SENTRY_DSN_FLUTTER=https://...@sentry.io/...  
SENTRY_DSN_BACKEND=https://...@sentry.io/...  
SENTRY_AUTH_TOKEN=  
SENTRY_ORG=orbace  
  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  
RESEND  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  
RESEND_API_KEY=re_...  
  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  
GOOGLE CLOUD (OAuth)  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  
GOOGLE_CLIENT_ID=...  
GOOGLE_CLIENT_SECRET=...  
  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  
APPLE DEVELOPER (OAuth + Push)  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  
APPLE_SERVICE_ID=com.orbace.sudoku.signin  
APPLE_KEY_ID=...  
APPLE_TEAM_ID=...  
APPLE_PRIVATE_KEY=-----BEGIN PRIVATE KEY-----...  
APNS_KEY_ID=...  
APNS_BUNDLE_ID=com.orbace.sudoku  
  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  
FIREBASE (Android Push)  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  
FCM_SERVER_KEY=...  
  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  
CLOUDFLARE R2  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  
R2_ACCESS_KEY_ID=...  
R2_SECRET_ACCESS_KEY=...  
R2_ENDPOINT=https://....r2.cloudflarestorage.com  
R2_BUCKET=orbace-sudoku-replays  
```  
  
---  
  
## 4. Setup Sequence (Optimized Order)  
  
Some services depend on others. Follow this order:  
  
```  
DAY 1 (30 minutes)  
├── 1. Register orbacesudoku.com + orbacesudoku.cn (Cloudflare)  
├── 2. Create GitHub repo (orbace-sudoku)  
└── 3. Create Supabase project (takes 2-3 min to provision)  
  
DAY 1 (while waiting for Supabase)  
├── 4. Create Vercel project  
├── 5. Create Upstash Redis  
├── 6. Create Fly.io account (install CLI)  
├── 7. Create Sentry projects  
├── 8. Create Resend account  
└── 9. Create Firebase project  
  
DAY 2 (after Supabase is ready)  
├── 10. Configure Google Cloud OAuth → Add to Supabase  
├── 11. Configure Apple OAuth → Add to Supabase  
├── 12. Create APNs Key (Apple Developer)  
└── 13. Create R2 Bucket (Cloudflare)  
  
DAY 2-3 (DNS propagation)  
├── 14. Point orbacesudoku.com to Vercel  
├── 15. Verify Resend domain (DNS records)  
└── 16. Test all connections  
  
END OF SETUP  
├── All credentials saved in password manager  
├── GitHub Secrets populated for CI/CD  
└── Ready to begin V2 development (Week 3 of the plan)  
```  
  
---  
  
## 5. Validation Checklist  
  
After all resources are provisioned, verify each one:  
  
```  
☐ Cloudflare: orbacesudoku.com resolves (may show placeholder)  
☐ Cloudflare: orbacesudoku.cn resolves  
☐ Cloudflare: SSL active on both domains  
☐ Supabase: Can connect via psql or Prisma Studio  
☐ Supabase: Can create a test table  
☐ Supabase: Auth email/password flow works (test from dashboard)  
☐ Vercel: Placeholder page deployed to orbacesudoku.com  
☐ Upstash: Can SET/GET from Redis CLI  
☐ Fly.io: flyctl auth works, can list apps  
☐ Sentry: Test event appears in dashboard  
☐ Resend: Domain verified, can send test email  
☐ GitHub: Repo accessible to all team members  
☐ Google OAuth: Test sign-in from Supabase dashboard  
☐ Apple OAuth: Test sign-in from Supabase dashboard  
☐ Firebase: google-services.json downloaded  
☐ APNs: .p8 key downloaded and saved  
☐ R2: Can upload/download test file  
☐ CI/CD: GitHub Actions secrets populated  
```  
  
---  
  
## 6. Summary  
  
| What | Who | How Long |  
|------|-----|----------|  
| Register domains | PM or Tech Lead | 10 min |  
| Create all cloud accounts | Backend Lead | 2-3 hours |  
| Configure OAuth providers | Backend Lead | 1-2 hours |  
| DNS + SSL configuration | Backend Lead | 30 min + propagation |  
| Populate GitHub Secrets | Backend Lead | 15 min |  
| Validate all connections | Backend Lead | 1 hour |  
| **Total setup time** | | **~5 hours over 2-3 days** |  
  
**All of this can be done in parallel with V1 final build/testing. Zero interference with V1 release timeline.**  
