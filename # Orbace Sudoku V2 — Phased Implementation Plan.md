Orbace Sudoku V2.0 — Phased Implementation Plan  
  
**Version**: 1.0  
**Date**: 2026-06-29  
**Duration**: 24 weeks (6 months)  
**Team Size**: 4-6 developers + 1 designer + 1 PM  
**Prerequisite**: V1.1 successfully launched and stabilized  
  
---  
  
## Implementation Philosophy  
  
1. **Vertical slices over horizontal layers.** Each phase delivers a demonstrable, testable feature, not just a technical layer.  
2. **Backend before frontend within each phase.** Data models and APIs are built first; UI consumes them second.  
3. **Local-first, cloud-enhanced.** The app must work offline for all V1.1 features. Cloud features enhance but never block.  
4. **Ship to test, not to finish.** Each phase ends with a build that can be tested by the team or beta users.  
  
---  
  
## Team Composition by Phase  
  
| Phase | Mobile Dev | Web Dev | Backend Dev | Designer | PM |  
|-------|-----------|---------|-------------|----------|-----|  
| Phase 0 | 1 | 0 | 1 | 1 | 1 |  
| Phase 1 | 1 | 0 | 2 | 1 | 1 |  
| Phase 2 | 2 | 1 | 2 | 1 | 1 |  
| Phase 3 | 2 | 1 | 1 | 1 | 1 |  
| Phase 4 | 1 | 1 | 1 | 0.5 | 1 |  
| Phase 5 | 1 | 1 | 1 | 0.5 | 1 |  
| Phase 6 | 1 | 1 | 1 | 0.5 | 1 |  
  
---  
  
## Technology Stack Summary  
  
| Component | Technology | Account/Service Needed | Setup Cost | Monthly Cost (Launch) |  
|-----------|-----------|----------------------|------------|----------------------|  
| **Mobile App** | Flutter 3.x | Apple Developer ($99/yr) + Google Play ($25 one-time) | $124 | $8/mo |  
| **Web Platform** | Flutter Web | Vercel Pro ($20/mo) | $0 | $20/mo |  
| **Local Database** | Drift (SQLite) | None (open source) | $0 | $0 |  
| **Cloud Database** | Supabase (PostgreSQL) | Supabase Pro ($25/mo) | $0 | $25/mo |  
| **Authentication** | Supabase Auth | Included in Supabase Pro | $0 | $0 |  
| **Cache** | Upstash Redis | Upstash (free tier → pay-as-you-go) | $0 | $0-20/mo |  
| **ORG Endpoint** | Fly.io (Fastify) | Fly.io account (free → $5/mo) | $0 | $5/mo |  
| **Object Storage** | Supabase Storage + Cloudflare R2 | R2 free tier | $0 | $0 |  
| **Background Jobs** | Vercel Cron | Included in Vercel Pro | $0 | $0 |  
| **Email Service** | Resend | Resend free tier (100/day) | $0 | $0 |  
| **Push Notifications** | Firebase Cloud Messaging + APNs | Firebase (free) + Apple Developer | $0 | $0 |  
| **Error Monitoring** | Sentry | Sentry Team ($26/mo) | $0 | $26/mo |  
| **Analytics** | Vercel Analytics + Custom Events | Included in Vercel Pro | $0 | $0 |  
| **CI/CD** | GitHub Actions + Fastlane | GitHub (free for public, $4/mo private) | $0 | $4/mo |  
| **Domain** | orbacesudoku.com + orbacesudoku.cn | Cloudflare Registrar (~$15/yr) | $15 | $1/mo |  
| **China Monitoring** | External probe service | TBD (~$10/mo) | $0 | $10/mo |  
| **TOTAL** | | | **$139** | **~$119/mo** |  
  
---  
  
## Phase 0: Foundation & Setup (Weeks 1-2)  
  
### Objective  
Set up all cloud infrastructure, development environments, and CI/CD pipelines. No user-facing features.  
  
### Technology Accounts to Create  
  
| Account | Who Creates | How | Verification Required |  
|---------|-------------|-----|----------------------|  
| **Supabase** | Backend lead | supabase.com → Create Organization "Orbace" → New Project | Email |  
| **Vercel** | Web lead | vercel.com → Sign up with GitHub → Import repo | GitHub |  
| **Upstash** | Backend lead | upstash.com → Create Redis database | Email |  
| **Fly.io** | Backend lead | fly.io → Sign up → `fly launch` from CLI | Credit card (not charged) |  
| **Sentry** | All devs | sentry.io → Create Org → Add projects (flutter, node) | Email |  
| **Resend** | Backend lead | resend.com → Create account → Verify domain | Domain DNS |  
| **Cloudflare** | PM/Backend | cloudflare.com → Register orbacesudoku.com + orbacesudoku.cn | Domain purchase |  
| **Apple Developer** | Mobile lead | developer.apple.com → Enroll in program | $99 + identity verification |  
| **Google Play** | Mobile lead | play.google.com/console → Create developer account | $25 |  
| **GitHub** | All | github.com → Private repo (orbace-sudoku) | None |  
  
### Tasks  
  
#### Backend Setup (Backend Lead, Week 1)  
  
```  
Day 1-2: Supabase Project  
  - Create Supabase project (us-east-1)  
  - Configure database connection string  
  - Set up Prisma with Supabase PostgreSQL  
  - Create initial migration (V2.0 schema)  
  - Enable Row-Level Security  
  - Configure Supabase Auth providers (Google, Apple, Email)  
  - Set up Supabase Storage buckets (replays, certificates, packs)  
    
Day 3-4: Upstash + Fly.io  
  - Create Upstash Redis database  
  - Test Redis connection from local  
  - Create Fly.io app for ORG endpoint  
  - Deploy placeholder Fastify server  
  - Configure health check endpoint  
    
Day 5: CI/CD Pipeline  
  - Set up GitHub Actions workflow  
  - Configure environment secrets (GitHub Secrets)  
  - Test deploy to Fly.io from CI  
  - Set up database migration in CI  
  - Configure Sentry DSN  
```  
  
#### Mobile Setup (Mobile Lead, Week 1-2)  
  
```  
Week 1:  
  - Update Flutter to latest stable  
  - Add dependencies: supabase_flutter, drift, upstash_redis, sentry_flutter  
  - Configure Supabase client with project URL + anon key  
  - Set up Drift schema migration V1→V2  
  - Add ORG-related tables to local Drift schema  
  - Configure Sentry in Flutter app  
    
Week 2:  
  - Set up Fastlane for iOS + Android  
  - Configure code signing (iOS certificates, Android keystore)  
  - Create App Store Connect listing (V2.0 placeholder)  
  - Create Google Play Console listing (V2.0 placeholder)  
  - Test build pipeline: GitHub Actions → TestFlight + Internal Testing  
```  
  
#### Web Setup (Web Lead, Week 2)  
  
```  
  - Configure Flutter Web build for Vercel  
  - Create vercel.json with rewrite rules  
  - Deploy placeholder landing page  
  - Configure custom domain (orbacesudoku.com → Vercel)  
  - Set up Cloudflare DNS  
  - Test web build pipeline  
```  
  
### Deliverables  
- [ ] All cloud services provisioned and communicating  
- [ ] CI/CD pipeline deploying to TestFlight, Internal Testing, and Vercel preview  
- [ ] Database schema V2.0 deployed to Supabase  
- [ ] Sentry capturing errors from all platforms  
- [ ] orbacesudoku.com serving placeholder page  
  
### Exit Criteria  
- Developer can `git push` and see a build on TestFlight and Vercel preview within 15 minutes  
- Database migrations run automatically in CI  
- Sentry dashboard shows test events from iOS, Android, and Web  
  
---  
  
## Phase 1: Account System (Weeks 3-6)  
  
### Objective  
Build the hybrid identity system (Auto-UUID Tier 1 + Social Auth/Email Tier 2). Players can create accounts, sign in, manage profiles, and upgrade from Tier 1 to Tier 2.  
  
### Technology Accounts Needed  
All accounts from Phase 0. Additionally:  
- **Apple Developer**: Configure Sign in with Apple service ID  
- **Google Cloud Console**: Configure OAuth 2.0 credentials for Sign in with Google  
  
### Tasks  
  
#### Backend (Backend Lead, Weeks 3-4)  
  
```  
Week 3: Supabase Auth Configuration  
  - Configure Google OAuth provider in Supabase dashboard  
  - Configure Apple OAuth provider in Supabase dashboard  
  - Configure Email/Password provider  
  - Set up email templates (confirmation, reset, magic link)  
  - Test all three auth flows manually  
    
Week 3: UUID Account System  
  - Implement POST /auth/uuid/register endpoint on Fly.io  
    - Generate UUID  
    - Generate friendly name from wordlist  
    - Store in player_accounts table (tier1_uuid)  
    - Return JWT  
  - Implement device fingerprinting logic  
    - Hash device identifiers (IDFV on iOS, SSAID on Android)  
    - Store in device_fingerprints table  
  - Implement POST /auth/uuid/upgrade endpoint  
    - Accept Supabase auth token  
    - Transfer RP, ORG history, Su-Pu references to new account  
    - Retire old UUID account  
    - Log in account_upgrades table  
  
Week 4: Profile & Privacy API  
  - Implement GET /player/{id}/profile  
  - Implement PUT /player/me (update display name, country, privacy)  
  - Implement GET /auth/check-name/{name}  
  - Implement DELETE /player/me (account deletion with anonymization)  
  - Implement GET /player/me/export (GDPR data export)  
  - Age verification endpoint  
  - Underage account restriction logic  
```  
  
#### Mobile (Mobile Lead, Weeks 3-6)  
  
```  
Week 3-4: Auth UI  
  - Build Sign In / Sign Up screen  
    - Social auth buttons (Google, Apple)  
    - Email/Password form  
    - "Continue as Guest" (Auto-UUID) option  
  - Build display name selection screen (post-auth)  
  - Build country selector (optional)  
  - Build age verification screen  
  - Integrate Supabase Auth SDK  
  - Handle auth state changes (signed in/out)  
  - Store JWT in secure storage  
    
Week 5: Profile & Privacy UI  
  - Build Privacy Settings screen  
    - Replay visibility (public/link-only/private)  
    - Share as (display name/anonymous)  
    - Country visibility toggle  
  - Build "Download My Data" button with progress  
  - Build "Delete Account" flow with confirmation  
  - Display account tier on profile (🎭 or ⭐)  
    
Week 6: UUID → Registered Upgrade Flow  
  - Build upgrade prompt (triggered on milestone)  
  - Build "Claim Your History" confirmation screen  
  - Show RP + ORGs being transferred  
  - Handle upgrade success/error states  
  - Update UI to reflect new tier (🎭 → ⭐)  
```  
  
#### Web (Web Lead, Weeks 5-6)  
  
```  
Week 5:  
  - Build Sign In page at /account  
  - Integrate Supabase Auth on web  
  - Build Profile page  
    
Week 6:  
  - Build Privacy Settings page  
  - Test cross-platform auth (sign in on web, same account on mobile)  
```  
  
### Deliverables  
- [ ] Auto-UUID account creation working (Tier 1)  
- [ ] Google, Apple, Email auth working (Tier 2)  
- [ ] Tier 1 → Tier 2 upgrade working with history transfer  
- [ ] Privacy settings screen functional  
- [ ] Account deletion working  
- [ ] Data export working  
- [ ] Age verification and underage restrictions working  
  
### Exit Criteria  
- New player can open app, enter Ranking tab, get auto-assigned "CalmPuzzle_847" and start ranking within 10 seconds  
- Player can upgrade to registered account and keep all history  
- Player can delete account and verify data is removed  
- All auth flows work on iOS, Android, and Web  
  
---  
  
## Phase 2: Daily ORG System (Weeks 7-12)  
  
### Objective  
Build the complete Daily Official Ranking Game lifecycle: event publishing, puzzle delivery, ORG gameplay with rules enforcement, submission, validation, leaderboard calculation, and result publication.  
  
### Technology Accounts Needed  
All previous accounts. Additionally:  
- **Apple Developer**: Configure APNs key for push notifications  
- **Firebase Console**: Create project for FCM (Android push)  
  
### Tasks  
  
#### Backend (2 Backend Devs, Weeks 7-10)  
  
```  
Week 7: Event Management  
  Backend Dev A:  
  - Build admin endpoint: POST /admin/events (create ORG event)  
  - Build puzzle publishing pipeline  
    - Upload puzzle to Supabase  
    - Generate checksum  
    - Set window times  
  - Implement GET /org/status endpoint  
    - Return today's event + player status  
    - Return tomorrow's event  
    - Return upcoming tournament info  
    
  Backend Dev B:  
  - Implement GET /org/{eventId}/puzzle  
    - Validate window is open  
    - Validate player is eligible (Scholar's Path Stage 2+)  
    - Validate player hasn't already started  
    - Return puzzle payload with givens  
  - Implement POST /org/{eventId}/start  
    - Create org_attempts record  
    - Create org_submissions record (status: started)  
    - Return attempt_id  
    - Enforce UNIQUE(event_id, player_id)  
  
Week 8: Submission & Validation  
  Backend Dev A:  
  - Implement POST /org/{eventId}/submit (on Fly.io)  
    - Validate window open  
    - Validate single submission  
    - Validate replay hash  
    - Validate puzzle checksum  
    - Validate time plausibility  
    - Calculate completion bonus  
    - Store submission  
    - Return provisional rank  
    
  Backend Dev B:  
  - Implement submission validation logic  
    - Move sequence validation (does it solve the puzzle?)  
    - Score recalculation  
    - Time plausibility bounds  
    - Assist detection (hints, auto-check)  
  - Implement validation status updates  
    - pending → accepted / rejected  
  
Week 9: Leaderboard Calculation  
  Backend Dev A:  
  - Implement Vercel Cron job: calculate-results (22:05 ET)  
    - Query all accepted submissions for event  
    - Order by elapsed_seconds  
    - Assign speed_bonus based on rank  
    - Update org_submissions with speed_bonus, speed_rank, total_rp  
    - Record in rp_ledger  
    - Update player_accounts.total_rp  
    
  Backend Dev B:  
  - Implement Vercel Cron job: publish-results (23:00 ET)  
    - Materialize leaderboard_daily record  
    - Generate full results_json  
    - Implement GET /leaderboard/daily/{date}  
    - Implement pagination (50 per page)  
  
Week 10: Live Leaderboard  
  Backend Dev A:  
  - Implement Upstash Redis sorted set for live rankings  
    - ZADD on each submission  
    - ZRANK for player position  
  - Implement GET /leaderboard/live/{eventId}  
    - Return top 10 from Redis  
    - Return player position if authenticated  
  - Implement Redis → PostgreSQL sync on window close  
    
  Backend Dev B:  
  - Implement push notification service  
    - FCM for Android  
    - APNs for iOS  
  - Implement notification triggers:  
    - Window open (01:00 ET, opt-in)  
    - Window closing (20:00 ET, opt-in)  
    - Results published (23:00 ET, opt-in)  
  - Store push tokens in push_tokens table  
```  
  
#### Mobile (2 Mobile Devs, Weeks 7-12)  
  
```  
Week 7-8: ORG Gameplay UI  
  Mobile Dev A:  
  - Build pre-game rules confirmation dialog  
    - One attempt, no pause, no hints, submit required  
    - "I Understand — Start Game" button  
  - Build ORG gameplay screen  
    - Timer always visible  
    - Hints disabled with "unavailable" label  
    - Auto-check disabled indicator  
    - Window countdown  
    - Backgrounding warning  
    - Abandonment detection (app lifecycle)  
    
  Mobile Dev B:  
  - Build ORG completion screen  
    - Show Solve Quality Score  
    - Show Completion Bonus earned  
    - "Submit for Global Ranking" vs "Keep Local Only"  
    - Privacy reminder ("Your replay will be public")  
  - Build ORG submission flow  
    - Loading state: seal stamping animation  
    - Success: provisional rank display  
    - Error: retry with saved data  
  - Build submitted state  
    - "Waiting for results" with countdown  
  
Week 9-10: Ranking Tab UI  
  Mobile Dev A:  
  - Build Ranking tab (榜)  
    - Empty state: "Sign in to unlock ranking" (Tier 0)  
    - Auto-UUID prompt (Tier 1, first visit)  
  - Build leaderboard browser  
    - Daily/Weekly/Monthly/Annual tabs  
    - Top 10 + paginated list  
    - Player row highlighted  
    - ⭐/🎭 indicators  
    - Tap row → mini-profile or replay  
    
  Mobile Dev B:  
  - Build player profile screen  
    - Stats: RP, ORGs, best rank, 名谱 count  
    - Recent results  
    - Su-Pu collection preview  
  - Build daily/weekly/monthly leaderboard screens  
    - Same pattern, different data sources  
  
Week 11-12: Home Screen Redesign  
  Mobile Dev A:  
  - Implement bottom navigation bar  
    - 5 tabs with seal icons  
    - Active: vermilion fill, Inactive: ink outline  
  - Redesign Home screen  
    - Section-based layout (Today / Continue / Su-Pu / Growth)  
    - Tea Moment card (always primary)  
    - Daily Ranking card with state machine (9 states)  
    
  Mobile Dev B:  
  - Implement Daily Ranking card states  
    - State 1-9 as specified in UX/CX document  
    - Smooth transitions between states  
    - Countdown timer for window open/close  
    - "Sign in" prompt for Tier 0  
    - "Complete Scholar's Path" for ineligible  
  - Implement Continue Playing section  
  - Implement Su-Pu preview section  
  - Implement Growth preview section  
```  
  
#### Web (Web Lead, Weeks 9-12)  
  
```  
Week 9-10: Leaderboard on Web  
  - Build /ranking page  
    - Daily/Weekly/Monthly tabs  
    - Full leaderboard display  
    - No account needed to view  
    
Week 11-12: ORG on Web  
  - Build /play page with ORG support  
    - Keyboard shortcuts for ORG mode  
    - Browser close warning  
    - Submission flow  
  - Build web-specific ORG card states  
```  
  
### Deliverables  
- [ ] Daily ORG puzzle creation (admin)  
- [ ] Full ORG lifecycle working (start → solve → submit → results)  
- [ ] 9-state Daily Ranking card on Home screen  
- [ ] Live leaderboard during window  
- [ ] Finalized leaderboard after 23:00 ET  
- [ ] Push notifications for ORG events  
- [ ] Bottom navigation with seal icons  
- [ ] Section-based Home screen  
  
### Exit Criteria  
- Admin can create a daily ORG puzzle  
- Player can see ORG card, start game, solve, submit, and see results  
- Leaderboard correctly ranks by completion time  
- Speed bonuses correctly assigned after 22:00 ET  
- Push notification received when results are published  
- All 9 ORG card states display correctly  
  
---  
  
## Phase 3: Tournaments & Advanced Ranking (Weeks 13-16)  
  
### Objective  
Build Saturday Mini Tournament (3 puzzles) and Third-Saturday Major Tournament (5 puzzles). Implement weekly/monthly/annual leaderboards.  
  
### Tasks  
  
#### Backend (Backend Lead, Weeks 13-14)  
  
```  
Week 13: Tournament System  
  - Extend official_events for tournament support  
    - tournament_id groups puzzles  
    - tournament_type: mini_tournament, major_tournament  
  - Implement tournament puzzle sequencing  
    - Puzzles released every 2 hours on Saturday  
  - Implement tournament RP calculation  
    - Sum completion_bonus + speed_bonus across all puzzles  
  - Implement tournament leaderboard materialization  
  - Implement tournament badge assignment  
    - Champion (1st), Elite (2-3), Contender (4-10), Finisher  
  
Week 14: Multi-Period Leaderboards  
  - Implement weekly leaderboard (Mon-Fri + tournament)  
  - Implement monthly leaderboard  
  - Implement annual leaderboard aggregation  
  - Implement all-time RP leaderboard  
  - Implement GET endpoints for each  
  - Implement Vercel Cron jobs for weekly/monthly finalization  
```  
  
#### Mobile (Mobile Lead, Weeks 13-16)  
  
```  
Week 13-14: Tournament UI  
  - Build tournament schedule screen  
    - Upcoming tournaments with countdown  
    - Past tournament results  
  - Build tournament gameplay flow  
    - Multi-puzzle tracking (1/3, 2/3, 3/3)  
    - Cumulative RP display  
    - Tournament leaderboard (live + final)  
  - Build tournament badge display  
  - Build tournament notification prompts  
  
Week 15-16: Enhanced Leaderboards  
  - Build weekly/monthly/annual leaderboard tabs  
  - Build all-time 名谱榜  
  - Build player career stats screen  
  - Build 名谱 collection view  
  - Build friend comparison (future)  
```  
  
#### Web (Web Lead, Weeks 15-16)  
  
```  
  - Build tournament leaderboard pages  
  - Build player profile pages (public)  
  - Build 名谱 collection pages  
```  
  
### Deliverables  
- [ ] Mini Tournament (3 puzzles) working  
- [ ] Major Tournament (5 puzzles) working  
- [ ] Tournament badges awarded correctly  
- [ ] Weekly, Monthly, Annual leaderboards  
- [ ] All-time RP leaderboard  
- [ ] Player career profile with 名谱 collection  
  
### Exit Criteria  
- Saturday Mini Tournament runs end-to-end  
- Major Tournament runs on 3rd Saturday  
- Tournament winner correctly identified  
- All leaderboard periods display correctly  
- Player can view their full career stats  
  
---  
  
## Phase 4: Su-Pu Sharing & Web Replay (Weeks 17-18)  
  
### Objective  
Build 传谱 (Su-Pu sharing) with deep links, web replay viewer, and share cards. Public replay viewer accessible without account.  
  
### Tasks  
  
#### Backend (Backend Lead, Week 17)  
  
```  
Week 17:  
  - Implement Su-Pu public access endpoint  
    - GET /supu/{supuId} (public, no auth)  
    - Respect privacy settings  
  - Implement replay data delivery for web viewer  
  - Implement share link generation  
    - orbacesudoku.com/supu/SP-2026-0629-000247-V1  
  - Track share analytics (view count)  
```  
  
#### Mobile (Mobile Lead, Week 17)  
  
```  
Week 17:  
  - Build 传谱 button on Su-Pu detail screen  
  - Build share flow  
    - "Copy Link" action  
    - Platform share sheet  
    - Share card with QR code  
  - Build anonymous share toggle  
    - "Share as ZenSolver" vs "Share Anonymously"  
  - Build privacy change for shared Su-Pu  
```  
  
#### Web (Web Lead, Week 17-18)  
  
```  
Week 17-18:  
  - Build public replay viewer at /supu/{id}  
    - Full 复盘 playback (no account)  
    - Score + RP display  
    - Player attribution (if public)  
    - "Get Orbace Sudoku" CTA  
  - Build share card design (certificate + QR)  
  - Test sharing flow end-to-end  
```  
  
### Deliverables  
- [ ] Su-Pu sharing via deep link  
- [ ] Web replay viewer (public, no account)  
- [ ] Share card with QR code  
- [ ] Anonymous sharing option  
- [ ] Privacy controls for shared Su-Pu  
  
### Exit Criteria  
- Player taps 传谱, copies link, pastes in browser → sees full replay  
- Shared replay works without Orbace account  
- "Get Orbace" CTA appears on replay page  
- Anonymous share hides player name  
  
---  
  
## Phase 5: Web Platform Full Experience (Weeks 19-20)  
  
### Objective  
Complete the web platform: full gameplay, keyboard optimization, leaderboard browsing, and account management.  
  
### Tasks  
  
#### Web (Web Lead, Weeks 19-20)  
  
```  
Week 19: Web Player Enhancement  
  - Full puzzle gameplay on web  
    - Tea Moment  
    - Level Packs  
    - Import Puzzle  
  - Keyboard shortcuts overlay (press ? to show)  
  - Responsive board sizing  
  - Web-specific loading states  
  - Web-specific error states  
    
Week 20: Web Leaderboard & Account  
  - Full leaderboard browsing  
  - Player profile pages (public)  
  - Account management pages  
  - Privacy settings page (web)  
  - Landing page polish  
    - Feature animations  
    - Live leaderboard preview  
    - App store CTAs  
```  
  
### Deliverables  
- [ ] Full gameplay on web (all puzzle types)  
- [ ] Keyboard shortcuts documented and functional  
- [ ] Landing page complete with live leaderboard preview  
- [ ] All account features accessible on web  
  
### Exit Criteria  
- Player can complete a full puzzle on web with keyboard only  
- Landing page loads in <2 seconds on desktop  
- All features reachable from web navigation  
  
---  
  
## Phase 6: Polish, Hardening & Launch (Weeks 21-24)  
  
### Objective  
Accessibility audit, performance optimization, load testing, China accessibility monitoring, beta testing, and app store submission.  
  
### Tasks  
  
#### All Teams (Weeks 21-24)  
  
```  
Week 21: Accessibility & Performance  
  - Accessibility audit (Mobile + Web)  
    - Screen reader pass on all screens  
    - Touch target verification  
    - Color contrast verification  
    - Reduced motion testing  
  - Performance optimization  
    - Lighthouse audit (Web)  
    - Flutter performance profiling  
    - Database query optimization  
    - CDN cache tuning  
    
Week 22: Load Testing & Security  
  - Load test ORG submission endpoint (k6)  
    - 1,000 concurrent submissions  
    - Verify no data loss  
  - Load test leaderboard queries  
    - 10,000 concurrent viewers  
  - Security review  
    - JWT token handling  
    - SQL injection prevention  
    - Rate limiting effectiveness  
    - Anti-cheat bypass attempts  
    
Week 23: Beta Testing  
  - Recruit 200+ beta testers (TestFlight + Internal Testing)  
  - Run 5-day simulated ORG week  
    - Monitor submission success rate  
    - Monitor leaderboard accuracy  
    - Collect UX feedback  
  - Run 1 simulated tournament weekend  
  - Fix critical bugs  
  - Tune notification timing  
    
Week 24: Launch Preparation  
  - App Store Connect submission (iOS)  
  - Google Play Console submission (Android)  
  - Vercel production deployment (Web)  
  - Final Sentry alert configuration  
  - On-call rotation setup  
  - Launch day monitoring plan  
  - Press kit / launch assets  
  - Submit to Apple for featuring consideration  
  - Submit to Google Play for featuring consideration  
```  
  
### Deliverables  
- [ ] Accessibility audit passed (WCAG AA)  
- [ ] Load tests passed (1,000 concurrent ORG players)  
- [ ] Beta testing complete with ≥90% satisfaction  
- [ ] App Store and Google Play submissions approved  
- [ ] Web platform live on orbacesudoku.com  
- [ ] Launch monitoring dashboard active  
  
### Exit Criteria  
- App approved on both App Store and Google Play  
- Zero critical bugs remaining  
- Load tests show stable performance at 2x expected peak  
- Launch checklist complete  
  
---  
  
## Phase 7: Post-Launch (Week 25+)  
  
### Immediate Post-Launch (Week 25-26)  
- Monitor Sentry for crash spikes  
- Monitor ORG submission success rate  
- Monitor leaderboard accuracy  
- Respond to App Store reviews  
- Hotfix any critical issues within 24 hours  
  
### Month 1-3  
- Analyze ORG participation data  
- Analyze China-origin traffic (inform V2.1 China strategy)  
- Collect feature requests from community  
- Begin V2.1 planning (China mirror, friend system, advanced anti-cheat)  
  
---  
  
## Risk Register  
  
| Risk | Phase | Severity | Mitigation |  
|------|-------|----------|------------|  
| Supabase Auth outage during ORG window | Phase 2+ | High | Monitor Supabase status. Fallback: local-only ranking during outage. |  
| Fly.io cold start on ORG submission | Phase 2 | Medium | Keep-alive ping every 60s. Monitor latency. Scale to 2 instances if needed. |  
| Push notification delivery failure | Phase 2 | Medium | Email fallback for result notifications. In-app result card always available. |  
| Database migration failure in production | Phase 1 | High | Test migrations on staging. Backup before each migration. Rollback plan. |  
| Apple rejects Sign in with Apple implementation | Phase 1 | Medium | Test against Apple's guidelines early. Have email/password as primary alternative. |  
| Google OAuth quota exceeded | Phase 1 | Low | Supabase handles OAuth. Quota is per-project, well above V2.0 needs. |  
| Vercel cron job fails to trigger | Phase 2 | Medium | Monitor cron execution. Manual trigger fallback. Alert if job doesn't run. |  
| Tournament logic bug (wrong winner) | Phase 3 | High | Extensive automated tests. Manual verification of first 3 tournaments. |  
| Web replay viewer overload (viral Su-Pu) | Phase 4 | Medium | CDN cache replay data. Rate limit anonymous access. R2 for zero egress cost. |  
| China GFW blocks orbacesudoku.com | Phase 6 | Medium | Already monitoring. orbacesudoku.cn registered. Communication plan ready. |  
  
---  
  
## Cost Projection by Phase  
  
| Phase | Duration | New Monthly Costs | Cumulative Monthly |  
|-------|----------|-------------------|--------------------|  
| Phase 0 | Weeks 1-2 | $119/mo (all infra) | $119/mo |  
| Phase 1 | Weeks 3-6 | +$0 (no new services) | $119/mo |  
| Phase 2 | Weeks 7-12 | +$0 (no new services) | $119/mo |  
| Phase 3 | Weeks 13-16 | +$0 (no new services) | $119/mo |  
| Phase 4 | Weeks 17-18 | +$0 (no new services) | $119/mo |  
| Phase 5 | Weeks 19-20 | +$0 (no new services) | $119/mo |  
| Phase 6 | Weeks 21-24 | +$0 (no new services) | $119/mo |  
| **Launch** | Week 25+ | Upstash may upgrade (~$20) | ~$139/mo |  
  
### Annual Run Rate (Post-Launch)  
- Infrastructure: ~$1,668/year  
- Apple Developer: $99/year  
- Google Play: $25 (one-time)  
- Domain: ~$15/year  
- **Total Annual: ~$1,807**  
  
---  
  
## Summary: Critical Path  
  
```  
Phase 0 (Setup)  
  └─▶ Phase 1 (Account System) ── MUST COMPLETE BEFORE ──▶ Phase 2 (Daily ORG)  
                                                                  │  
                                                                  ▼  
                                                          Phase 3 (Tournaments)  
                                                                  │  
                                                                  ▼  
                                                          Phase 4 (Sharing)  
                                                                  │  
                                                    ┌─────────────┴─────────────┐  
                                                    ▼                           ▼  
                                            Phase 5 (Web)              Phase 6 (Polish)  
                                                    │                           │  
                                                    └───────────┬───────────────┘  
                                                                ▼  
                                                          LAUNCH (Week 25)  
```  
  
**The critical chain is Phase 1 → Phase 2.** Without accounts, ORG cannot function. Without ORG, the ranking system has no data. Phases 3-5 can be parallelized somewhat, but Phase 2 is the gate.  
  
**Total development time: 24 weeks (6 months) from Phase 0 start to launch.**  
  
---  
  
*End of Orbace Sudoku V2.0 Implementation Plan*  
