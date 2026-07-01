Document 1: Orbace Sudoku V1.2 PRD (Updated)  
  
  
# Orbace Sudoku — Product Requirements Document V1.2  
  
**Version**: 1.2    
**Date**: 2026-06-28    
**Supersedes**: V1.1 (MVP)    
**Platform**: Flutter for iOS, Android + Flutter Web (orbacesudoku.com)    
**Backend**: Vercel + Supabase + Upstash Redis + Fly.io    
**Status**: Pre-implementation    
**Prerequisite**: V1.1 launch (local Su-Pu, 藏谱阁, 复盘, 对谱, Scholar's Path Stages 1-3, Extreme)  
  
---  
  
## 1. Executive Summary  
  
Orbace Sudoku V1.2 adds a server-backed **Global Ranking System** as an opt-in competitive layer on top of the V1.1 local experience. It also introduces the **Web Platform** for browser-based play, **Additional Game Packs** for expanded content, and **Share Replay (传谱)** for viral Su-Pu sharing.  
  
**V1.1 remains unchanged.** Local play, Su-Pu records, 藏谱阁 (Record Hall), 复盘 (Replay), 对谱 (Compare), Scholar's Path progression, and local 名谱榜 continue to function exactly as before.  
  
**V1.2 introduces Official Ranking Games (ORGs)** — specific puzzles published by Orbace that can earn global ranking status. Only ORGs are eligible. Only registered players can participate. Only 正谱 (Official class) Su-Pu submitted under standardized conditions count toward global leaderboards.  
  
**The V1.2 promise:**  
  
> Keep everyday Sudoku calm and personal. Make global competition opt-in, account-based, time-boxed, fair, and auditable. Every submitted ORG becomes a verifiable 正谱 Su-Pu in the player's 藏谱阁, replayable and shareable like any other Su-Pu.  
  
---  
  
## 2. Product Principles  
  
| Principle | Implementation |  
|-----------|---------------|  
| **V1.1 untouched** | Local ranking, Su-Pu classes, 藏谱阁, 复盘, 对谱, Scholar's Path all unchanged |  
| **Opt-in competition** | Players must register an account and explicitly submit ORG attempts |  
| **ORGs are special events** | Only Orbace-designated puzzles earn global ranking points. Level Pack puzzles, Tea Moment, imported puzzles, and retries do not. |  
| **One attempt only** | Each ORG can be started once. No pause. No retry for ranking. |  
| **Fair time window** | All ORGs available 01:00–22:00 Eastern Time. Same window for all players worldwide. |  
| **Transparent scoring** | Normal Solve Quality Score remains. Global Ranking Points use a separate, visible formula. |  
| **Su-Pu based** | Every ORG submission is a 正谱 Su-Pu, stored in the player's 藏谱阁, replayable via 复盘, comparable via 对谱, shareable via 传谱. |  
| **Integrity verified** | Server validates every submission: time window, single attempt, no pause, no hints, replay hash, puzzle checksum. |  
| **Global-first, China-possible** | Primary infrastructure serves global players. Chinese players can access but experience may be inconsistent. No China-specific infrastructure in V1.2. Monitor demand for V2.0+ China strategy. |  
  
---  
  
## 3. Relationship to V1.1  
  
| Area | V1.1 Behavior | V1.2 Global Ranking |  
|------|--------------|---------------------|  
| Local 名谱榜 | Device-local ranking for built-in puzzles | Unchanged |  
| 对谱 (Compare) | Compare any two Su-Pu for the same puzzle | Unchanged; can also compare ORG submissions |  
| Imported Puzzles | Personal, local-only | Unchanged |  
| 重解 (Retry) | Creates 重修谱 Su-Pu, personal improvement | Unchanged; retries never ranked |  
| 藏谱阁 (Record Hall) | Personal Su-Pu collection | Unchanged; ORG submissions appear as 正谱 Su-Pu |  
| 复盘 (Replay) | Local replay of any Su-Pu | Unchanged; ORG replays also shareable via 传谱 |  
| 传谱 (Share) | Share Su-Pu as replayable link | Extended: ORG Su-Pu can be shared with event metadata |  
| 成绩单 (Certificate) | Local score card | Extended: ORG certificates include placement and RP |  
| Global 名谱榜 | Not available | Account-based, server-backed, per-event and cumulative |  
  
---  
  
## 4. Su-Pu Terminology Integration  
  
| Term | Chinese | V1.2 Usage |  
|------|---------|------------|  
| 正谱 | Zhèng Pǔ | ORG submissions are 正谱 class Su-Pu |  
| 名谱 | Míng Pǔ | Top-ranked ORG Su-Pu on leaderboards |  
| 名谱榜 | Míng Pǔ Bǎng | Global leaderboards (daily, weekly, monthly, annual) |  
| 传谱 | Chuán Pǔ | Share ORG replay as link |  
| 复盘 | Fù Pán | Replay any Su-Pu, including ORG submissions |  
| 对谱 | Duì Pǔ | Compare ORG Su-Pu against others |  
| 藏谱阁 | Cáng Pǔ Gé | ORG Su-Pu appear alongside all other Su-Pu |  
| 弈者 | Yì Zhě | Player on leaderboards |  
| 弈者名 | Yì Zhě Míng | Display name for global ranking |  
  
---  
  
## 5. Target Users  
  
### 5.1 Competitive Players  
- Want fair comparison against others under standardized rules  
- Willing to follow stricter rules (one attempt, no pause, no hints)  
- Value transparent scoring, placement bonuses, and replay verification  
- Want public or semi-public leaderboards with shareable proof  
  
### 5.2 Existing Orbace Learners (V1.1 Players)  
- Use Orbace for calm daily practice  
- May occasionally join official events  
- Need clear separation between practice and competition  
- Need gentle onboarding into ORG rules  
  
### 5.3 Web Visitors  
- Discover Orbace through shared replays or orbacesudoku.com  
- Want playable web experience without installing  
- May convert to mobile app for offline play and richer features  
- Can browse leaderboards and shared 名谱 without account  
  
### 5.4 International Players (Including China)  
- Players from regions with higher latency (Asia, South America, Africa)  
- ORG system designed to accommodate: completion time measured client-side, validated server-side  
- Submission deadline based on completion timestamp, not arrival time  
- Experience may be slower but not unfair for competitive play  
- No region-specific infrastructure in V1.2; monitor demand for future optimization  
  
---  
  
## 6. Account System  
  
### 6.1 Registration  
  
| Field | Required | Purpose |  
|-------|----------|---------|  
| Display Name (弈者名) | Yes | Public identity on leaderboards |  
| Email | Yes | Account recovery, notifications |  
| Password | Yes | Authentication |  
| Country/Region | Optional | Regional filtering on leaderboards |  
  
### 6.2 Authentication  
  
- Email/password with JWT tokens (Supabase Auth)  
- Optional: Sign in with Apple, Sign in with Google (Supabase Auth built-in)  
- Guest browsing allowed for leaderboards and shared replays  
- Guest play allowed for non-ranked web puzzles  
- Account required only before starting an ORG  
  
### 6.3 Account Management  
  
- Change display name (once per 30 days)  
- Change email with verification  
- Password reset flow (Supabase Auth built-in)  
- Account deletion (GDPR compliant)  
- Data export (all Su-Pu, ranking history)  
- Terms acceptance and privacy consent at registration  
  
### 6.4 Scholar's Path Requirement  
  
Players must complete **Scholar's Path Stage 2 (Discipline / 自律)** before participating in Global Ranking. This ensures baseline competency and familiarity with Su-Pu concepts.  
  
---  
  
## 7. Official Ranking Games (ORGs)  
  
### 7.1 Definition  
  
Official Ranking Games are event puzzles published exclusively by Orbace. Only ORGs can earn global ranking points.  
  
### 7.2 Rules  
  
| Rule | Specification |  
|------|---------------|  
| **Availability Window** | Daily: 01:00–22:00 Eastern Time. Same for all players worldwide. |  
| **Account Required** | Must be signed in before starting. Scholar's Path Stage 2 required. |  
| **One Attempt Only** | Once started, the attempt is consumed. No retry for ranking. |  
| **No Pause** | App backgrounding or disconnection during ORG marks the attempt as abandoned. 10 RP earned. No resume. |  
| **No Hints** | Using any hint reclassifies the Su-Pu as 习谱 (Practice). Completion bonus still earned; speed bonus forfeited. |  
| **No Auto-Check** | Auto-check disabled during ORG. |  
| **No Mistake Reveal** | Mistake reveal disabled during ORG. |  
| **Timer Always On** | Completion time recorded for speed bonus calculation. |  
| **Notes Allowed** | Pencil marks permitted. |  
| **Explicit Submission** | After completion, player chooses "Submit for Global Ranking" or "Keep Local Only." Unsubmitted completions earn completion bonus only. |  
| **Client-Side Timing** | Completion time measured on device. Server validates plausibility. Deadline based on completion timestamp, not submission arrival time. |  
| **Server Validated** | All submissions validated server-side before acceptance. |  
  
### 7.3 Disconnect/Abandonment Policy  
  
If the app backgrounds, crashes, or loses connection during an ORG:  
- The attempt is marked as **abandoned** on the server  
- Player earns **10 RP** (Started but unfinished)  
- No resume is possible  
- The puzzle becomes available locally as a practice puzzle (习谱) for personal completion, but cannot be submitted for ranking  
- This policy is clearly communicated before the player starts the ORG  
  
### 7.4 High-Latency Player Accommodation  
  
For players in regions with higher latency (Asia, South America, Africa):  
  
| Concern | Design Response |  
|---------|-----------------|  
| **Submission arrives after 22:00 ET** | Server accepts based on `completed_at` client timestamp (validated for plausibility), not arrival time |  
| **Slow API responses** | ORG puzzle loaded at start. No API calls needed during solve. Only submission at end. |  
| **Unstable connections** | Submission payload is small (<5KB). Retry logic built into client. |  
| **Live leaderboard unavailable** | Polling-based leaderboard (5-10s interval) instead of WebSocket. More reliable over unstable connections. |  
| **Competitive disadvantage** | Solve time is measured locally. Network speed doesn't affect recorded time. |  
  
### 7.5 Pre-Game Confirmation  
  
Before starting an ORG, the player must explicitly confirm:  
  
> **Official Ranking Game Rules:**  
> - ⏰ One attempt only. No retry.  
> - ⏸️ No pause. If the app closes, the attempt is lost.  
> - 💡 No hints. No auto-check.  
> - 📤 You must submit to earn speed bonus points.  
> - 🕐 Available until 22:00 Eastern Time.  
>  
> **[I Understand — Start Game]**  
  
---  
  
## 8. Scoring System  
  
### 8.1 Dual Score Model  
  
| Score Type | Purpose | Display |  
|------------|---------|---------|  
| **Solve Quality Score** | Standard Orbace score based on difficulty, accuracy, efficiency | Shown on Su-Pu and certificate |  
| **Global Ranking Points (RP)** | Event points for leaderboard competition | Shown on leaderboards and ORG results |  
  
### 8.2 Global Ranking Points Formula  
  
```  
Total RP = Completion Bonus + Speed Bonus  
  
Completion Bonus:  
  Started but unfinished:         10 RP  
  Finished, 3+ errors/hints:      20 RP  
  Finished, 2 errors/hints:       30 RP  
  Finished, 1 error/hint:         50 RP  
  Finished, 0 errors/hints:      100 RP  (Clean Play / 净谱)  
  
Speed Bonus (awarded after 22:00 ET):  
  All submitted finishes ranked by completion time (shortest first)  
  1st place:     400 RP  
  2nd place:     200 RP  
  3rd place:     100 RP  
  4th–10th:       50 RP each  
  11th+:           0 RP  
  
Maximum Daily RP: 100 (Clean) + 400 (1st) = 500 RP  
```  
  
### 8.3 Submission Choice  
  
| Action | Completion Bonus | Speed Bonus Eligible |  
|--------|-----------------|---------------------|  
| Submit for Global Ranking | Yes | Yes |  
| Keep Local Only | Yes | No |  
  
---  
  
## 9. Event Schedule  
  
### 9.1 Weekly Schedule  
  
| Day | Event | Puzzles | Notes |  
|-----|-------|---------|-------|  
| Monday–Friday | Daily ORG | 1 per day | Standard daily competition |  
| Saturday (except 3rd) | Mini Tournament | 3 puzzles | Cumulative RP across all 3 |  
| 3rd Saturday | Major Tournament | 5 puzzles | Cumulative RP across all 5 |  
| Sunday | Rest / Practice | 0 ORG | No ranked play. Practice puzzles available. |  
  
### 9.2 Tournament Scoring  
  
For each tournament puzzle:  
1. Completion Bonus awarded per standard ORG rules  
2. Speed Bonus awarded per standard ORG rules (ranked within that puzzle's submissions)  
3. Player's tournament total = sum of RP from all tournament puzzles  
  
Tournament ranking tiebreakers:  
1. Total RP (higher = better)  
2. Number of puzzles completed (more = better)  
3. Total completion time across completed puzzles (shorter = better)  
4. Clean-game count (more = better)  
5. Earliest final submission time (earlier = better)  
  
### 9.3 Tournament Window  
  
Tournaments use extended 48-hour window: Saturday 01:00 ET – Sunday 22:00 ET. This ensures all regions get at least one full calendar day for tournament play.  
  
---  
  
## 10. Leaderboard System  
  
### 10.1 Leaderboard Types  
  
| Leaderboard | Chinese | Scope | Reset |  
|-------------|---------|-------|-------|  
| Daily 名谱榜 | 日名谱榜 | Single day's ORG | Daily 22:00 ET |  
| Weekly 名谱榜 | 周名谱榜 | Mon-Fri + Saturday tournament | Sunday 00:00 ET |  
| Monthly 名谱榜 | 月名谱榜 | All ORGs in calendar month | 1st of month |  
| Annual 名谱榜 | 年名谱榜 | All ORGs in calendar year | Jan 1 |  
| All-Time 名谱榜 | 总名谱榜 | Cumulative, never resets | Never |  
| Tournament 名谱榜 | 赛名谱榜 | Per-tournament | After tournament close |  
  
### 10.2 Single Worldwide Window Policy  
  
All ORGs use a single worldwide window (01:00–22:00 ET). There is no separate Asia-Pacific window. Rationale:  
  
- **One world, one puzzle, one 名谱榜** — central to Orbace's competitive identity  
- **Regional windows would fragment the community** — separate leaderboards, no world champion  
- **The current window provides 21 hours of access to all time zones**  
- **Tournament extended windows (48 hours) ensure all regions get full calendar day coverage**  
- **Asia-Pacific experience gaps addressed through UI mitigations** (local time display, configurable notifications, live polling-based leaderboard)  
  
Regional leaderboard filters (e.g., "Top in Asia-Pacific") may be added in V1.3+ without fragmenting the primary worldwide leaderboard.  
  
---  
  
## 11. Web Platform  
  
### 11.1 Scope  
  
| Feature | Web MVP |  
|---------|---------|  
| Sign in / sign up (Supabase Auth) | ✅ |  
| View ORG schedule | ✅ |  
| Start and play ORG | ✅ |  
| Full Sudoku gameplay (board, notes, undo/redo) | ✅ |  
| Three-tier hints (disabled during ORG) | ✅ |  
| Submit ORG result | ✅ |  
| View leaderboards | ✅ |  
| View own ORG history | ✅ |  
| View shared replays (no account required) | ✅ |  
| Non-ranked practice puzzles | ✅ |  
| App download prompts (iOS/Android) | ✅ |  
| 藏谱阁 access | ✅ |  
| 复盘 (Replay) | ✅ |  
| Keyboard input (desktop) | ✅ |  
| Offline play | ❌ |  
| Push notifications | ❌ (post-MVP) |  
| Haptic feedback | ❌ |  
  
### 11.2 Technical Approach  
  
- **Framework**: Flutter Web (same codebase as mobile)  
- **Hosting**: Vercel (optimized for Flutter Web + edge network)  
- **Responsive**: Desktop (1024px+), Tablet (768px-1023px), Mobile web  
- **Keyboard support**: Number keys for input, arrow keys for navigation, Space for notes toggle  
  
---  
  
## 12. Share Replay (传谱) for ORG  
  
### 12.1 Share Flow  
  
```  
Player views submitted ORG Su-Pu → Taps "传谱" →  
  Options: Copy link, Share via platform sheet  
  Link format: orbacesudoku.com/supu/SP-2026-0615-000247  
  ↓  
Recipient opens link → Web replay viewer  
  - Full 复盘 playback (no account required)  
  - Score and RP displayed  
  - Player attribution (if public)  
  - "Get Orbace Sudoku" CTA with store links  
```  
  
### 12.2 Privacy Controls  
  
| Setting | Description | ORG Default |  
|---------|-------------|-------------|  
| Public | Visible on leaderboards. Replay accessible via link. | ✅ Default for submitted ORGs |  
| Link Only | Accessible only with link. Not listed publicly. | Optional change |  
| Private | Not shareable. | Available on request |  
  
---  
  
## 13. Additional Game Packs  
  
| Pack | Puzzles | Availability |  
|------|---------|--------------|  
| Solar Terms · 夏 (二十四節氣 · 夏) | 48 | Free, included |  
| Technique Practice: Naked Single | 25 | Free, included |  
| Technique Practice: Hidden Single | 25 | Free, included |  
| Technique Practice: Naked Pair | 25 | Free, included |  
| Technique Practice: Hidden Pair | 25 | Free, included |  
| Technique Practice: Pointing Pair | 25 | Free, included |  
| Tournament Archives | Past ORG puzzles | After tournament concludes |  
| Tournament Practice | ORG-similar puzzles | Always available |  
  
---  
  
## 14. Technology Stack  
  
### 14.1 Stack Summary  
  
| Layer | Technology | Purpose |  
|-------|-----------|---------|  
| Mobile + Web | Flutter 3.x | Cross-platform client |  
| Local DB | Drift (SQLite) | Puzzles, Su-Pu, game state, settings |  
| Web Hosting | Vercel | Flutter Web deployment, edge network |  
| Cloud Database | Supabase (PostgreSQL 15) | Accounts, ORG submissions, leaderboards |  
| Authentication | Supabase Auth | Email/password, OAuth, JWT |  
| Cache | Upstash Redis | Live leaderboards, rate limiting, sessions |  
| ORG Submission Endpoint | Fly.io (Fastify) | Always-warm container for latency-sensitive submissions |  
| Object Storage | Supabase Storage / Cloudflare R2 | Replays, certificates, packs |  
| Background Jobs | Vercel Cron + Supabase Edge Functions | Leaderboard finalization at 22:00 ET |  
| Monitoring | Sentry + Vercel Analytics | Error tracking, performance |  
  
### 14.2 China Accessibility  
  
| Aspect | V1.2 Approach |  
|--------|---------------|  
| **Infrastructure** | US-hosted (Vercel + Supabase). No China-specific infrastructure. |  
| **Accessibility** | Chinese players can access orbacesudoku.com. Sudoku content is low-risk for GFW blocking. |  
| **Performance** | 2-8s initial load. 300-800ms API latency. Inconsistent. Acceptable for V1.2. |  
| **ORG fairness** | Completion time measured client-side (validated server-side). Deadline based on completion timestamp, not submission arrival. Chinese players not disadvantaged. |  
| **Future** | Monitor Chinese demand. If >15% of ORG participants from China, evaluate V2.0+ China strategy (orbacesudoku.cn, Alibaba Cloud, ICP filing). |  
  
---  
  
## 15. Anti-Cheat & Integrity  
  
### 15.1 Minimum Controls  
  
- Server creates official attempt record before play starts  
- Server records start time via trusted timestamp  
- Puzzle payload only available during event window  
- Attempt can only be submitted once (UNIQUE constraint on event_id + player_id)  
- Replay hash must match server-validated solution  
- Completion time validated against server-trusted timestamps and plausibility bounds  
- Submission accepted based on client `completed_at` timestamp (validated), not arrival time  
- Client version must be current and supported  
  
### 15.2 Recommended Controls (Post-MVP)  
  
- Device/app attestation where platform provides it  
- Rate limiting per account (Upstash Redis)  
- Server-side final board reconstruction validation  
- Hash chain for replay moves  
- Admin disqualification workflow with audit trail  
- Suspicious pattern detection (impossible times, statistical anomalies)  
- Manual review of top 10 daily submissions  
  
---  
  
## 16. Implementation Plan  
  
### Phase V1.2-0: Architecture & Policy (Week 1)  
- Confirm tech stack (Vercel + Supabase + Upstash Redis + Fly.io)  
- Define account, privacy, and terms requirements  
- Define official attempt and replay schemas  
- Set up Supabase project, Vercel project, Upstash Redis  
  
### Phase V1.2-1: Backend Foundation (Weeks 2-5)  
- Supabase Auth integration (email/password, Apple, Google)  
- Player profile service  
- Event/puzzle database and admin publishing  
- Official attempt lifecycle  
- Replay storage (Supabase Storage)  
- Fly.io deployment for ORG submission endpoint  
  
### Phase V1.2-2: Daily ORG MVP (Weeks 6-9)  
- Mobile Official Ranking screen  
- Web official game page  
- ORG game flow (confirmation, timer, no pause, no hints, submission)  
- Submission validation with client-timestamp acceptance  
- Daily leaderboard finalization (Vercel Cron)  
- Upstash Redis live leaderboard  
- Daily 名谱榜 UI (mobile + web)  
  
### Phase V1.2-3: Replay Sharing & Web Platform (Weeks 10-13)  
- Web replay viewer (orbacesudoku.com/supu/{id})  
- Share replay link generation  
- Share card with ORG metadata  
- Privacy controls per Su-Pu  
- Full web gameplay for non-ORG puzzles  
  
### Phase V1.2-4: Tournaments (Weeks 14-17)  
- Saturday Mini Tournament (3-puzzle)  
- Third-Saturday Major Tournament (5-puzzle)  
- Tournament cumulative RP scoring  
- Tournament leaderboards and badges  
- Extended 48-hour tournament windows  
  
### Phase V1.2-5: Packs, Profiles & Polish (Weeks 18-21)  
- Additional game packs  
- Player profile pages (public)  
- Weekly/monthly/annual leaderboards  
- Scholar's Path Stage 4 integration  
  
### Phase V1.2-6: Hardening & Scale (Weeks 22-24)  
- Anti-cheat review tools  
- Load testing (k6)  
- China accessibility monitoring  
- Beta testing with 200+ players  
  
---  
  
## 17. Success Metrics  
  
| Metric | Target (6 months post-launch) |  
|--------|-------------------------------|  
| % of V1.1 active players who create V1.2 account | ≥20% |  
| % of registered players who start ≥1 ORG per week | ≥10% |  
| ORG completion rate (among started) | ≥70% |  
| Submit rate (among completed ORGs) | ≥50% |  
| Clean play rate (among submitted) | ≥30% |  
| Replay share rate (among submitted) | ≥5% |  
| Daily leaderboard return rate (week-over-week) | Increasing |  
| Tournament participation (% of weekly active ORG players) | ≥40% |  
| Web-to-app conversion | ≥15% |  
| China-origin traffic (% of total) | Measured as baseline for V2.0 decision |  
| No unresolved high-severity ranking integrity defects | 0 |  
  
---  
  
## 18. Key Decisions  
  
| Decision | Resolution |  
|----------|-----------|  
| Submit vs. auto-submit? | **Explicit opt-in submission.** Player chooses after completion. |  
| Disconnect/resume policy? | **Abandoned.** 10 RP earned. No resume. Clear pre-game warning. |  
| ORG playable on web at launch? | **Yes.** Flutter Web, hosted on Vercel. |  
| Separate Asia-Pacific ORG window? | **No.** Single worldwide window. Client-timestamp submission accommodates high-latency players. |  
| Replay privacy default for ORG? | **Public.** Player can change to Link Only or Private. |  
| Tournament scoring model? | **Cumulative RP across all tournament puzzles.** Tiebreakers as specified. |  
| Tournament window? | **Extended 48 hours** (Saturday 01:00 ET – Sunday 22:00 ET) for full calendar day coverage worldwide. |  
| Scholar's Path requirement? | **Stage 2 (Discipline) completion required** for ORG participation. |  
| Tech stack? | **Vercel + Supabase + Upstash Redis + Fly.io (ORG endpoint).** |  
| China infrastructure? | **Deferred to V2.0+.** Monitor demand. orbacesudoku.cn registered defensively. |  
  
---  
  
## 19. Recommendation  
  
Proceed with V1.2 implementation in the phased order specified, contingent on successful V1.1 launch and stabilization.  
  
**Critical path**: V1.1 must ship with full Su-Pu infrastructure (move history capture, 藏谱阁, 复盘, 对谱, Su-Pu classes) before V1.2 development begins. The ORG system depends on Su-Pu data architecture.  
  
**The Global Ranking System extends Orbace's differentiation.** Where competitors offer either no competition (Good Sudoku) or speed-dominant opaque competition (Brainium), Orbace offers fair, transparent, Su-Pu-verified competition that respects both calm play and competitive drive — accessible to players worldwide, with design accommodations for regions with less reliable connectivity.  
  
   
*End of Orbace Sudoku V1.2 PRD*  
  
    
  
