# Orbace Sudoku 2.0 — Product Requirements Document  
  
**Version**: 2.0  
**Date**: 2026-06-29  
**Supersedes**: V1.1 (MVP), V1.2 (Ranking System Draft)  
**Platform**: Flutter for iOS, Android + Flutter Web  
**Backend**: Vercel + Supabase + Upstash Redis + Fly.io  
**Status**: Pre-implementation  
  
---  
  
## Document Structure  
  
This PRD is organized into three parts:  
  
| Part | Scope | Primary Audience |  
|------|-------|-----------------|  
| **Part 1: App** | V1.1 → V2.0 improvements, UX/CX redesign, Su-Pu system, account & privacy, ranking integration | Mobile developers, UX designers |  
| **Part 2: Web** | orbacesudoku.com platform, web player, public replay viewer, landing page, leaderboard browser | Web developers, UX designers |  
| **Part 3: Backend & Cloud** | Tech stack, database schema, API design, authentication, anti-cheat, deployment, scaling | Backend developers, DevOps |  
  
---  
  
## Brand Design System  
  
### Iconography  
  
All feature icons follow a consistent pattern: **vermilion seal (印章) with Chinese character + English name beneath**. This ensures both English and Chinese users understand functionality at a glance without relying solely on language.  
  
```  
┌─────────────────────────────────────────────────────────────────┐  
│                    ICON DESIGN SYSTEM                             │  
│                                                                  │  
│  Pattern: [Vermilion Seal with Chinese Character]                │  
│           [English Name Beneath]                                  │  
│                                                                  │  
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐        │  
│  │   茶     │  │   榜     │  │   谱     │  │   弈     │        │  
│  │  Tea     │  │ Ranking  │  │  Su-Pu   │  │  Play    │        │  
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘        │  
│                                                                  │  
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐        │  
│  │   学     │  │   极     │  │   对     │  │   传     │        │  
│  │ Scholar  │  │ Extreme  │  │ Compare  │  │  Share   │        │  
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘        │  
│                                                                  │  
│  Tab Bar Icons follow the same seal pattern at smaller scale     │  
│  Active: Full vermilion seal with character                      │  
│  Inactive: Ink outline seal with character                      │  
└─────────────────────────────────────────────────────────────────┘  
```  
  
### Complete Icon Set  
  
| Feature | Chinese Character | English Label | Usage |  
|---------|------------------|---------------|-------|  
| Tea Moment | 茶 | Tea | Daily calm puzzle, primary brand anchor |  
| Daily Ranking | 榜 | Ranking | Official ranking game entry |  
| Play / Level Packs | 弈 | Play | Structured puzzle play |  
| Record Hall | 谱 | Su-Pu | Personal collection of recorded solves |  
| Scholar's Path | 学 | Scholar | Learning progression |  
| Extreme Challenge | 极 | Extreme | Gated mastery challenges |  
| Compare Su-Pu | 对 | Compare | Side-by-side replay comparison |  
| Share Su-Pu | 传 | Share | Share replayable solve record |  
| Replay | 复 | Replay | Watch recorded solve playback |  
| Settings | 设 | Settings | App configuration |  
| Import Puzzle | 入 | Import | Import external puzzle |  
| Leaderboard | 名 | Top | View rankings and 名谱 |  
| Account / Profile | 弈者 | Player | Player identity and profile |  
  
### Color Palette  
  
| Role | Hex | Usage |  
|------|-----|-------|  
| Rice Paper | #F5F0E8 | Backgrounds, negative space |  
| Warm Ivory | #EDE4D3 | Alternate background, card surfaces |  
| Dark Ink | #2C2C2C | Primary text, board numbers, UI elements |  
| Mid Ink | #5C5C5C | Secondary text, given numbers |  
| Light Ink | #A0A0A0 | Notes, pencil marks, disabled states |  
| Vermilion | #C41E3A | Seals, accents, highlights, CTAs |  
| Deep Vermilion | #8B1A2B | Pressed states, seal edges |  
| Celadon | #B5C9BC | Celadon theme background |  
| Celadon Dark | #8AA894 | Celadon theme accents |  
| Success Green | #5B8C5A | Clean solve indicators |  
| Warning Amber | #C49A3A | Error indicators (gentle, never red alert) |  
| Error Red | #C4533A | Error highlights only (never flashing) |  
  
### Typography  
  
| Use | Font | Weight |  
|-----|------|--------|  
| Chinese headings, seals | Noto Serif CJK SC | Bold / Regular |  
| English headings | Source Serif Pro | Semibold |  
| Board numbers | SF Mono / JetBrains Mono (tabular figures) | Regular |  
| UI labels, buttons | SF Pro Text / Roboto | Medium / Regular |  
| Body text | SF Pro Text / Roboto | Regular |  
| Score numbers | Source Serif Pro (oldstyle figures) | Semibold |  
  
---  
  
# PART 1: APP (iOS + Android)  
  
## 1.1 App Overview: V1.1 → V2.0  
  
### What V1.1 Delivers (Local-First Foundation)  
  
| Feature | Status |  
|---------|--------|  
| Classic 9x9 Sudoku gameplay | ✅ |  
| Three-tier teaching hints (nudge → explain → reveal) | ✅ |  
| Human-ranked solver with 5 techniques | ✅ |  
| 1,850 solver-validated puzzles with pre-computed solve paths | ✅ |  
| Difficulty tiers: 入門, 小成, 貫通, 精深, 入神 | ✅ |  
| Notes, undo/redo, highlighting, auto-remove notes | ✅ |  
| Ink Wash + Celadon themes | ✅ |  
| Su-Pu system: 藏谱阁, 复盘, 对谱, 成绩单 | ✅ |  
| Scholar's Path Stages 1-3 | ✅ |  
| Extreme Challenge (gated) | ✅ |  
| Tea Moment daily puzzle | ✅ |  
| Import Puzzle | ✅ |  
| Timer (off by default), mistake checking (optional) | ✅ |  
| Offline play, local persistence (Drift SQLite) | ✅ |  
| Accessibility: screen reader, large text, high contrast | ✅ |  
  
### What V2.0 Adds  
  
| Feature | Category |  
|---------|----------|  
| Account system (Auto-UUID + Social Auth + Email/Password) | Account |  
| Daily Ranking Game (ORG) with full lifecycle | Ranking |  
| Saturday Mini Tournament (3 puzzles) | Ranking |  
| Third-Saturday Major Tournament (5 puzzles) | Ranking |  
| Live leaderboard + finalized daily/weekly/monthly/annual 名谱榜 | Ranking |  
| 传谱 (Share replayable Su-Pu) | Sharing |  
| Push notifications for ORG events and results | Engagement |  
| Bottom navigation redesign with section-based Home | UX |  
| State-aware Daily Ranking card (9 states) | UX |  
| Calm design constraints enforced throughout | UX |  
| Empty states for new players | UX |  
| Loading, error, and success states for all async operations | UX |  
| Transition animations (seal stamps, ink brush effects) | UX |  
| Privacy control center | Privacy |  
| Data export and account deletion | Privacy |  
| Underage restricted accounts | Privacy |  
  
---  
  
## 1.2 Navigation Architecture  
  
### Bottom Tab Bar (V2.0)  
  
```  
┌─────────────────────────────────────────────────────────────┐  
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  
│  │   今     │  │   弈     │  │   谱     │  │   榜     │  │   学     │  
│  │  Today   │  │  Play    │  │  Su-Pu   │  │ Ranking  │  │  Growth  │  
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘  └──────────┘  
└─────────────────────────────────────────────────────────────┘  
  
Today (今日): Tea Moment + Daily Ranking + Continue Playing  
Play (弈): Level Packs + Import Puzzle + Practice Mode  
Su-Pu (谱): 藏谱阁 — full personal collection  
Ranking (榜): 名谱榜 — leaderboards + player profile  
Growth (学): Scholar's Path + Extreme Challenge + Technique Practice  
```  
  
### Tab States by Account Type  
  
| Tab | Anonymous (No Account) | Auto-UUID (Tier 1) | Registered (Tier 2) |  
|-----|----------------------|--------------------|--------------------|  
| Today | Tea Moment + Continue + Ranking preview ("Sign in") | Tea Moment + Continue + Live Ranking Card | Tea Moment + Continue + Live Ranking Card |  
| Play | Full access | Full access | Full access |  
| Su-Pu | Full access (local) | Full access (local) | Full access (local + cloud sync future) |  
| Ranking | Locked: "Sign in to unlock ranking" | Live leaderboards + player position | Full leaderboards + player profile + history |  
| Growth | Full access | Full access | Full access |  
  
### Top App Bar  
  
```  
┌─────────────────────────────────────────────────────────────┐  
│  [Vermilion Seal: 数]  Orbace Sudoku           [设 Settings] │  
│                        一局一茶                               │  
└─────────────────────────────────────────────────────────────┘  
  
Settings (设) icon: always visible  
  - Themes  
  - Gameplay defaults (timer, mistake check, notes)  
  - Notifications (V2.0+)  
  - Privacy (V2.0+)  
  - Account (V2.0+)  
  - About / Legal  
  - Remove Ads (future)  
```  
  
---  
  
## 1.3 Home Screen (Today Tab)  
  
### 1.3.1 Empty State (New Player, No Account)  
  
```  
┌─────────────────────────────────────────────────────────────┐  
│  [数] Orbace Sudoku                                [设]      │  
│                                                              │  
│  ── 今日 Today ──────────────────────────────────────────   │  
│                                                              │  
│  ┌──────────────────────────────────────────────────────┐   │  
│  │                                                       │   │  
│  │    ┌──────┐                                           │   │  
│  │    │  茶  │  今日茶局 · Tea Moment                    │   │  
│  │    │ Tea  │                                           │   │  
│  │    └──────┘  "One puzzle, one tea."                   │   │  
│  │              Your daily moment of calm.                │   │  
│  │              No timer. No pressure.                    │   │  
│  │                                                       │   │  
│  │              ┌──────────────────────────┐            │   │  
│  │              │   Begin Today's Puzzle   │            │   │  
│  │              └──────────────────────────┘            │   │  
│  └──────────────────────────────────────────────────────┘   │  
│                                                              │  
│  ┌──────────────────────────────────────────────────────┐   │  
│  │  ┌──────┐  今日榜局 · Daily Ranking                   │   │  
│  │  │  榜  │                                            │   │  
│  │  │Ranking│  Official competition. Fair rules.         │   │  
│  │  └──────┘  Worldwide leaderboard.                     │   │  
│  │                                                       │   │  
│  │  ┌──────────────────────────────────────────────┐    │   │  
│  │  │  🔐 Sign in to participate in ranking        │    │   │  
│  │  └──────────────────────────────────────────────┘    │   │  
│  │  [View Today's Leaderboard]                           │   │  
│  └──────────────────────────────────────────────────────┘   │  
│                                                              │  
│  ── 续 Continue ────────────────────────────────────────   │  
│  (No puzzle in progress)                                    │  
│                                                              │  
│  ┌──────────────────────────────────────────────────────┐   │  
│  │  ┌──────┐  开始游戏 · Start Playing                   │   │  
│  │  │  弈  │                                            │   │  
│  │  │ Play  │  Level Packs → 1,850 puzzles              │   │  
│  │  └──────┘  Import Puzzle → Play shared puzzles        │   │  
│  └──────────────────────────────────────────────────────┘   │  
│                                                              │  
│  ── 谱 Su-Pu ────────────────────────────────────────────   │  
│  ┌──────────────────────────────────────────────────────┐   │  
│  │  ┌──────┐  藏谱阁 · Record Hall                       │   │  
│  │  │  谱  │                                            │   │  
│  │  │Su-Pu │  Your Su-Pu collection will appear here.    │   │  
│  │  └──────┘  Complete a puzzle to create your first     │   │  
│  │            recorded solve.                            │   │  
│  └──────────────────────────────────────────────────────┘   │  
│                                                              │  
│  ── 学 Growth ───────────────────────────────────────────   │  
│  ┌──────────────────────┐  ┌──────────────────────────┐    │  
│  │  ┌──────┐            │  │  ┌──────┐                │    │  
│  │  │  学  │ 学者之路   │  │  │  极  │ 极境挑战       │    │  
│  │  │Schlr │ Scholar's  │  │  │Extrm │ Extreme        │    │  
│  │  └──────┘ Path       │  │  └──────┘ Challenge      │    │  
│  │  Not yet started      │  │  Locked                  │    │  
│  └──────────────────────┘  └──────────────────────────┘    │  
│                                                              │  
│  [今 Today] [弈 Play] [谱 Su-Pu] [榜 Ranking] [学 Growth]   │  
└─────────────────────────────────────────────────────────────┘  
```  
  
### 1.3.2 Returning Player with Account (ORG Window Open)  
  
```  
┌─────────────────────────────────────────────────────────────┐  
│  [数] Orbace Sudoku                                [设]      │  
│                                                              │  
│  ── 今日 Today ──────────────────────────────────────────   │  
│                                                              │  
│  ┌──────────────────────────────────────────────────────┐   │  
│  │  ┌──────┐  今日茶局 · Tea Moment                      │   │  
│  │  │  茶  │  June 29, 2026 · 精深 #892                  │   │  
│  │  │ Tea  │                                            │   │  
│  │  └──────┘  ┌──────────────────────────┐              │   │  
│  │            │    Begin Tea Moment      │              │   │  
│  │            └──────────────────────────┘              │   │  
│  └──────────────────────────────────────────────────────┘   │  
│                                                              │  
│  ┌──────────────────────────────────────────────────────┐   │  
│  │  ┌──────┐  今日榜局 · Daily Ranking           🔴 LIVE │   │  
│  │  │  榜  │                                            │   │  
│  │  │Ranking│  Signed in as: ZenSolver 🇨🇳 ⭐            │   │  
│  │  └──────┘                                            │   │  
│  │                                                       │   │  
│  │  Today's puzzle is ready.                             │   │  
│  │  ⏰ Window closes in 08:42:15                         │   │  
│  │  📊 847 players have submitted                        │   │  
│  │                                                       │   │  
│  │  ┌──────────────────────────────────────────────┐    │   │  
│  │  │         Start Ranking Game                    │    │   │  
│  │  └──────────────────────────────────────────────┘    │   │  
│  │                                                       │   │  
│  │  Your replay will be public on the leaderboard.       │   │  
│  │  [Change privacy setting]                             │   │  
│  │  [View Live Leaderboard]                              │   │  
│  └──────────────────────────────────────────────────────┘   │  
│                                                              │  
│  ── 续 Continue ────────────────────────────────────────   │  
│  ┌──────────────────────────────────────────────────────┐   │  
│  │  📖 精深 #128 · 34% complete · Last played 2h ago    │   │  
│  │  [Resume]                                            │   │  
│  └──────────────────────────────────────────────────────┘   │  
│                                                              │  
│  ── 谱 Su-Pu ────────────────────────────────────────────   │  
│  ┌──────────────────────────────────────────────────────┐   │  
│  │  ┌──────┐  藏谱阁 · Record Hall                       │   │  
│  │  │  谱  │  247 Su-Pu · 42 净谱 · 12 this week        │   │  
│  │  │Su-Pu │  [Browse ▸]                                 │   │  
│  │  └──────┘                                            │   │  
│  └──────────────────────────────────────────────────────┘   │  
│                                                              │  
│  ── 学 Growth ───────────────────────────────────────────   │  
│  ┌──────────────────────┐  ┌──────────────────────────┐    │  
│  │  ┌──────┐ 学者之路   │  │  ┌──────┐ 极境挑战       │    │  
│  │  │  学  │ Stage 2    │  │  │  极  │ Stage 3 needed │    │  
│  │  │Schlr │ 67% ▸      │  │  │Extrm │ ▸              │    │  
│  │  └──────┘            │  │  └──────┘                │    │  
│  └──────────────────────┘  └──────────────────────────┘    │  
│                                                              │  
│  [今 Today] [弈 Play] [谱 Su-Pu] [榜 Ranking] [学 Growth]   │  
└─────────────────────────────────────────────────────────────┘  
```  
  
### 1.3.3 Daily Ranking Card — All 9 States  
  
```  
┌─────────────────────────────────────────────────────────────────┐  
│              DAILY RANKING CARD STATE MACHINE                     │  
├─────────────────────────────────────────────────────────────────┤  
│                                                                  │  
│  STATE 1: NO ACCOUNT                                             │  
│  ┌──────────────────────────────────────────────────────────┐   │  
│  │  ┌──────┐  今日榜局 · Daily Ranking                       │   │  
│  │  │  榜  │  🔐 Sign in to participate in ranking           │   │  
│  │  │Ranking│  [Sign In] [Create Account]                    │   │  
│  │  └──────┘  [View Leaderboard]                             │   │  
│  └──────────────────────────────────────────────────────────┘   │  
│                                                                  │  
│  STATE 2: ACCOUNT, NOT ELIGIBLE (Scholar's Path Stage < 2)       │  
│  ┌──────────────────────────────────────────────────────────┐   │  
│  │  ┌──────┐  今日榜局 · Daily Ranking                       │   │  
│  │  │  榜  │  ⚠️ Complete Scholar's Path Stage 2 first       │   │  
│  │  │Ranking│  Progress: 67% · 8/20 Hard puzzles             │   │  
│  │  └──────┘  [Continue Scholar's Path] [View Leaderboard]   │   │  
│  └──────────────────────────────────────────────────────────┘   │  
│                                                                  │  
│  STATE 3: BEFORE WINDOW (countdown)                              │  
│  ┌──────────────────────────────────────────────────────────┐   │  
│  │  ┌──────┐  今日榜局 · Daily Ranking                       │   │  
│  │  │  榜  │  Opens in 02:34:12                              │   │  
│  │  │Ranking│  Available 01:00-22:00 Eastern Time            │   │  
│  │  └──────┘  [Set Reminder] [View Past Leaderboards]        │   │  
│  └──────────────────────────────────────────────────────────┘   │  
│                                                                  │  
│  STATE 4: WINDOW OPEN, NOT STARTED                               │  
│  ┌──────────────────────────────────────────────────────────┐   │  
│  │  ┌──────┐  今日榜局 · Daily Ranking               🔴 LIVE │   │  
│  │  │  榜  │  ⏰ Closes in 08:42:15                          │   │  
│  │  │Ranking│  📊 847 players submitted                      │   │  
│  │  └──────┘  [Start Ranking Game] [View Live Leaderboard]   │   │  
│  └──────────────────────────────────────────────────────────┘   │  
│                                                                  │  
│  STATE 5: IN PROGRESS                                            │  
│  ┌──────────────────────────────────────────────────────────┐   │  
│  │  ┌──────┐  今日榜局 · Daily Ranking               🔴 LIVE │   │  
│  │  │  榜  │  ⚠️ Attempt in progress — no pause               │   │  
│  │  │Ranking│  ⏰ Closes in 06:15:30                          │   │  
│  │  └──────┘  [Resume Ranking Game]                           │   │  
│  └──────────────────────────────────────────────────────────┘   │  
│                                                                  │  
│  STATE 6: COMPLETED, NOT SUBMITTED                               │  
│  ┌──────────────────────────────────────────────────────────┐   │  
│  │  ┌──────┐  今日榜局 · Daily Ranking               🔴 LIVE │   │  
│  │  │  榜  │  ⭐ Solve: 14,400 · 4:32 · 1 error              │   │  
│  │  │Ranking│  🏆 Completion Bonus: 50 RP                    │   │  
│  │  └──────┘  [Submit for Global Ranking] [Keep Local Only]  │   │  
│  └──────────────────────────────────────────────────────────┘   │  
│                                                                  │  
│  STATE 7: SUBMITTED, WAITING (before 22:00 ET)                   │  
│  ┌──────────────────────────────────────────────────────────┐   │  
│  │  ┌──────┐  今日榜局 · Daily Ranking                       │   │  
│  │  │  榜  │  ✅ Submitted · #847 provisional                │   │  
│  │  │Ranking│  ⚡ Speed Bonus: Pending                       │   │  
│  │  └──────┘  ⏰ Final results in 04:22:08                   │   │  
│  │            [View Live Leaderboard] [View My Su-Pu]        │   │  
│  └──────────────────────────────────────────────────────────┘   │  
│                                                                  │  
│  STATE 8: CALCULATING (22:00-23:00 ET)                           │  
│  ┌──────────────────────────────────────────────────────────┐   │  
│  │  ┌──────┐  今日榜局 · Daily Ranking                       │   │  
│  │  │  榜  │  ⏰ Window closed. Calculating results...        │   │  
│  │  │Ranking│  🏆 50 RP (Completion) + ⚡ Pending            │   │  
│  │  └──────┘  Final ranking available shortly.               │   │  
│  │            [View My Submission]                            │   │  
│  └──────────────────────────────────────────────────────────┘   │  
│                                                                  │  
│  STATE 9: RESULTS PUBLISHED (after 23:00 ET)                     │  
│  ┌──────────────────────────────────────────────────────────┐   │  
│  │  ┌──────┐  今日榜局 · Results Ready! 🎉                   │   │  
│  │  │  榜  │  #42 of 3,847 · Top 1.1%                       │   │  
│  │  │Ranking│  🏆 50 RP + ⚡ 50 RP = 💰 100 RP Today        │   │  
│  │  └──────┘  [View Leaderboard] [传谱 Share] [View Su-Pu]  │   │  
│  └──────────────────────────────────────────────────────────┘   │  
│                                                                  │  
└─────────────────────────────────────────────────────────────────┘  
```  
  
---  
  
## 1.4 Account & Identity System  
  
### 1.4.1 Hybrid Identity Architecture  
  
```  
┌─────────────────────────────────────────────────────────────────┐  
│                    HYBRID IDENTITY SYSTEM                         │  
│                                                                  │  
│  TIER 0: ANONYMOUS (No identity, No server data)                  │  
│  ┌──────────────────────────────────────────────────────────┐   │  
│  │  • Tea Moment, Level Packs, 藏谱阁, 复盘, 对谱           │   │  
│  │  • Scholar's Path, Extreme Challenge                     │   │  
│  │  • All local features — no server interaction            │   │  
│  │  • Can VIEW leaderboards (read-only)                     │   │  
│  │  • Cannot PARTICIPATE in Daily Ranking                   │   │  
│  │  • Cannot appear on leaderboards                         │   │  
│  │  • No personal data collected                            │   │  
│  └──────────────────────────────────────────────────────────┘   │  
│                         │                                        │  
│                         ▼ (tap "Sign in" on Ranking tab)         │  
│                                                                  │  
│  TIER 1: AUTO-UUID (Instant ranking, device-bound)                │  
│  ┌──────────────────────────────────────────────────────────┐   │  
│  │  • Auto-generated on first Ranking interaction            │   │  
│  │  • Friendly name: "CalmPuzzle_847" (wordlist-based)      │   │  
│  │  • CAN participate in Daily Ranking immediately          │   │  
│  │  • CAN appear on leaderboards (as CalmPuzzle_847)        │   │  
│  │  • CAN earn RP and build ranking history                 │   │  
│  │  • LIMITED: Device-bound. No cross-device. No recovery.  │   │  
│  │  • Trust tier affects leaderboard eligibility            │   │  
│  │  • UPGRADE PATH: Claim history → Tier 2                  │   │  
│  │  • 🎭 icon next to name on leaderboards                  │   │  
│  └──────────────────────────────────────────────────────────┘   │  
│                         │                                        │  
│                         ▼ (upgrade prompt at milestones)         │  
│                                                                  │  
│  TIER 2: REGISTERED (Full identity, cross-device)                 │  
│  ┌──────────────────────────────────────────────────────────┐   │  
│  │  • Social Auth (Google, Apple) OR Email/Password         │   │  
│  │  • Custom display name (弈者名)                          │   │  
│  │  • Full ranking participation                            │   │  
│  │  • Cross-device sync (future)                             │   │  
│  │  • Account recovery via email or provider                │   │  
│  │  • Data export (GDPR/CCPA compliant)                     │   │  
│  │  • Privacy controls (public/private Su-Pu, anonymous share│   │  
│  │  • Email notifications (opt-in)                           │   │  
│  │  • ⭐ icon next to name on leaderboards                  │   │  
│  │  • Higher trust tier = fewer restrictions                │   │  
│  └──────────────────────────────────────────────────────────┘   │  
│                                                                  │  
└─────────────────────────────────────────────────────────────────┘  
```  
  
### 1.4.2 Registration Flow  
  
**Auto-UUID (Tier 1) — Instant**  
  
```  
Player opens Ranking tab for first time  
        │  
        ▼  
System generates UUID + friendly name: "CalmPuzzle_847"  
        │  
        ▼  
┌──────────────────────────────────────────────────────┐  
│  ┌──────┐  Welcome to Ranking!                        │  
│  │  榜  │                                            │  
│  │Ranking│  You can participate as:                   │  
│  └──────┘                                            │  
│                                                       │  
│  🎭 CalmPuzzle_847                                    │  
│                                                       │  
│  This name is tied to this device.                    │  
│  Create a free account to choose your                 │  
│  own name and protect your ranking history.           │  
│                                                       │  
│  ┌──────────────────────────────────────────────┐    │  
│  │      Start Ranking as CalmPuzzle_847          │    │  
│  └──────────────────────────────────────────────┘    │  
│  [Create Account Instead]                             │  
└──────────────────────────────────────────────────────┘  
```  
  
**Social Auth (Tier 2) — One Tap**  
  
```  
┌──────────────────────────────────────────────────────┐  
│  ┌──────┐  Join the Global Ranking                    │  
│  │  榜  │                                            │  
│  │Ranking│                                           │  
│  └──────┘                                            │  
│                                                       │  
│  ┌──────────────────────────────────────────────┐    │  
│  │  G  Continue with Google                      │    │  
│  └──────────────────────────────────────────────┘    │  
│  ┌──────────────────────────────────────────────┐    │  
│  │     Continue with Apple                       │    │  
│  └──────────────────────────────────────────────┘    │  
│  ── or ──────────────────────────────────────────    │  
│  ┌──────────────────────────────────────────────┐    │  
│  │  ✉  Sign up with Email                        │    │  
│  └──────────────────────────────────────────────┘    │  
│                                                       │  
│  Already have an account? [Sign In]                   │  
└──────────────────────────────────────────────────────┘  
```  
  
**Post-Auth: Choose Display Name**  
  
```  
┌──────────────────────────────────────────────────────┐  
│  Almost done!                                         │  
│                                                       │  
│  Choose your leaderboard name (弈者名):                │  
│                                                       │  
│  ┌──────────────────────────────────────────────┐    │  
│  │  ZenSolver                                    │    │  
│  └──────────────────────────────────────────────┘    │  
│  ✓ Available!                                         │  
│                                                       │  
│  This appears on all leaderboards.                    │  
│  Changes allowed once per 30 days.                    │  
│                                                       │  
│  ┌──────────────────────────────────────────────┐    │  
│  │  Country (Optional)     [▼ Prefer not to say] │    │  
│  └──────────────────────────────────────────────┘    │  
│                                                       │  
│  ┌──────────────────────────────────────────────┐    │  
│  │         Enter Global Ranking                   │    │  
│  └──────────────────────────────────────────────┘    │  
└──────────────────────────────────────────────────────┘  
```  
  
### 1.4.3 Upgrade Flow: Tier 1 → Tier 2  
  
```  
Prompt triggers:  
  • Player reaches top 100 for first time  
  • 5th ORG completion  
  • 1,000 RP accumulated  
  
┌──────────────────────────────────────────────────────┐  
│  🎉 Great solve, CalmPuzzle_847!                      │  
│                                                       │  
│  You placed #42 today — your best rank yet!           │  
│                                                       │  
│  💡 Claim your ranking history before it's lost.      │  
│                                                       │  
│  Right now, your 14 ORGs and 1,250 RP are             │  
│  tied to this device. If you lose your phone           │  
│  or uninstall, they're gone forever.                  │  
│                                                       │  
│  Create a free account in 30 seconds to:              │  
│  ✅ Keep your ranking history forever                 │  
│  ✅ Choose your own name                              │  
│  ✅ Play on all your devices                          │  
│                                                       │  
│  ┌──────────────────────────────────────────────┐    │  
│  │  G  Continue with Google                      │    │  
│  └──────────────────────────────────────────────┘    │  
│  ┌──────────────────────────────────────────────┐    │  
│  │     Continue with Apple                       │    │  
│  └──────────────────────────────────────────────┘    │  
│  ┌──────────────────────────────────────────────┐    │  
│  │  ✉  Sign up with Email                        │    │  
│  └──────────────────────────────────────────────┘    │  
│                                                       │  
│  [Maybe Later]                                        │  
└──────────────────────────────────────────────────────┘  
```  
  
### 1.4.4 Privacy Control Center  
  
```  
┌─────────────────────────────────────────────────────────────┐  
│  ← Settings    隐私 Privacy                                   │  
│                                                              │  
│  ── Profile ──────────────────────────────────────────────   │  
│                                                              │  
│  ┌──────┐  Display Name     ZenSolver            [Change ▸]  │  
│  │ 弈者 │  (30 days until next change)                       │  
│  │Player│                                                    │  
│  └──────┘  Country on        ○ Show  ● Hide                 │  
│            Leaderboard                                        │  
│                                                              │  
│  ── Su-Pu Privacy ────────────────────────────────────────   │  
│                                                              │  
│  Default for ORG     ● Public  ○ Link Only  ○ Private        │  
│  Submissions         (Public replays appear on leaderboards) │  
│                                                              │  
│  Default for         ○ Public  ○ Link Only  ● Private        │  
│  Practice Su-Pu                                               │  
│                                                              │  
│  ── Sharing ──────────────────────────────────────────────   │  
│                                                              │  
│  Share as            ● Display Name  ○ Anonymous             │  
│                      (Can change per share)                   │  
│                                                              │  
│  ── Your Data ────────────────────────────────────────────   │  
│                                                              │  
│  [Download My Data ▸]                                        │  
│  Export all Su-Pu, ranking history, and account data         │  
│                                                              │  
│  [Delete My Account ▸]                                       │  
│  Permanently delete account. Ranking history anonymized.     │  
│                                                              │  
│  ── Legal ────────────────────────────────────────────────   │  
│  [Privacy Policy ▸]  [Terms of Service ▸]                    │  
└─────────────────────────────────────────────────────────────┘  
```  
  
---  
  
## 1.5 Ranking Tab (榜)  
  
### 1.5.1 Ranking Tab — Leaderboard Browser  
  
```  
┌─────────────────────────────────────────────────────────────┐  
│  [数] Orbace Sudoku                                [设]      │  
│                                                              │  
│  ── 名谱榜 Leaderboards ──────────────────────────────────   │  
│                                                              │  
│  [Daily 日] [Weekly 周] [Monthly 月] [Annual 年] [All-Time] │  
│                                                              │  
│  ┌──────────────────────────────────────────────────────┐   │  
│  │  🏆 Daily 名谱榜 · June 29, 2026                      │   │  
│  │  精深 #247 · 3,847 弈者                               │   │  
│  │                                                       │   │  
│  │  🥇 ZenSolver       500 RP  ·  3:58  ·  净谱  🇨🇳 ⭐ │   │  
│  │     📜 名谱 · 复盘 ▸                                   │   │  
│  │  🥈 SharpLogic_502  300 RP  ·  4:15  ·  净谱  🎭     │   │  
│  │  🥉 SudokuMaster    200 RP  ·  4:22  ·  净谱  🇯🇵 ⭐ │   │  
│  │  4  CalmPuzzle_847  150 RP  ·  4:28  ·  净谱  🎭     │   │  
│  │  ...                                                   │   │  
│  │  42 You             100 RP  ·  4:32  ·  1错   🇨🇳 ⭐ │   │  ← Highlighted  
│  │     📜 Your Su-Pu · 对谱 with #1 ▸                     │   │  
│  │  ...                                                   │   │  
│  └──────────────────────────────────────────────────────┘   │  
│                                                              │  
│  ⭐ = Registered    🎭 = Auto-generated                      │  
│                                                              │  
│  ── My Profile ──────────────────────────────────────────   │  
│  ┌──────────────────────────────────────────────────────┐   │  
│  │  ┌──────┐  ZenSolver 🇨🇳 ⭐                           │   │  
│  │  │ 弈者 │  💰 1,250 RP · 📜 14 ORGs                  │   │  
│  │  │Player│  🥇 Best: #5 · 🏅 3 名谱                    │   │  
│  │  └──────┘  [View Full Profile ▸]                      │   │  
│  └──────────────────────────────────────────────────────┘   │  
│                                                              │  
│  [今 Today] [弈 Play] [谱 Su-Pu] [榜 Ranking] [学 Growth]   │  
└─────────────────────────────────────────────────────────────┘  
```  
  
---  
  
## 1.6 Su-Pu Tab (谱) — Record Hall  
  
```  
┌─────────────────────────────────────────────────────────────┐  
│  [数] Orbace Sudoku                                [设]      │  
│                                                              │  
│  ── 藏谱阁 Record Hall ──────────────────────────────────   │  
│                                                              │  
│  📜 248 Su-Pu  ·  ✨ 12 this week  ·  ⭐ 42 净谱             │  
│                                                              │  
│  [全部 All] [正谱 Official] [净谱 Clean] [珍藏 Favorites]    │  
│                                                              │  
│  ┌──────────────────────────────────────────────────────┐   │  
│  │  🏆 精深 #247                                         │   │  
│  │  ⭐ Best: 14,400 · 净谱 · 34 steps                    │   │  
│  │  3 Su-Pu versions: v1(习谱) v2(正谱) v3(重修谱)      │   │  
│  │  [View Collection] [复盘 Best] [对谱 Compare]         │   │  
│  ├──────────────────────────────────────────────────────┤   │  
│  │  📜 精深 #128                                         │   │  
│  │  ⭐ 15,200 · 净谱 · 47 steps                          │   │  
│  │  1 Su-Pu · 正谱 Official                              │   │  
│  │  [复盘 Replay] [成绩单 Certificate] [传谱 Share]      │   │  
│  ├──────────────────────────────────────────────────────┤   │  
│  │  📜 精深 #312                                         │   │  
│  │  ⭐ 11,800 · 2 errors · 1 nudge                       │   │  
│  │  1 Su-Pu · 习谱 Practice                              │   │  
│  │  [复盘 Replay] [重解 Retry] [谱评 Notes]              │   │  
│  └──────────────────────────────────────────────────────┘   │  
│                                                              │  
│  [今 Today] [弈 Play] [谱 Su-Pu] [榜 Ranking] [学 Growth]   │  
└─────────────────────────────────────────────────────────────┘  
```  
  
---  
  
## 1.7 Growth Tab (学)  
  
```  
┌─────────────────────────────────────────────────────────────┐  
│  [数] Orbace Sudoku                                [设]      │  
│                                                              │  
│  ── 学者之路 Scholar's Path ──────────────────────────────   │  
│                                                              │  
│  ┌──────────────────────────────────────────────────────┐   │  
│  │  Stage 1: 基础 Foundation                             │   │  
│  │  ✅ Complete 10 Medium puzzles                        │   │  
│  │  ✅ Complete 3 Medium puzzles with 0 hints            │   │  
│  │  🏅 "Steady Hand" seal earned                        │   │  
│  └──────────────────────────────────────────────────────┘   │  
│                                                              │  
│  ┌──────────────────────────────────────────────────────┐   │  
│  │  Stage 2: 自律 Discipline — IN PROGRESS               │   │  
│  │  ✅ Complete 20 Hard puzzles                          │   │  
│  │  ⬜ Complete 5 Hard with ≥80% accuracy (3/5)          │   │  
│  │  ⬜ Complete 3 Hard with 0 errors (1/3)               │   │  
│  │  ████████████░░░░░░░░ 67%                             │   │  
│  └──────────────────────────────────────────────────────┘   │  
│                                                              │  
│  ┌──────────────────────────────────────────────────────┐   │  
│  │  Stage 3: 悟性 Insight — LOCKED                       │   │  
│  │  🔒 Complete Stage 2 to unlock                        │   │  
│  │  Unlocks: Extreme Challenges                          │   │  
│  └──────────────────────────────────────────────────────┘   │  
│                                                              │  
│  ── 极境挑战 Extreme Challenge ──────────────────────────   │  
│  ┌──────────────────────────────────────────────────────┐   │  
│  │  ┌──────┐  🔒 Locked                                  │   │  
│  │  │  极  │  Complete Scholar's Path Stage 3            │   │  
│  │  │Extrm │  to unlock Extreme Challenges               │   │  
│  │  └──────┘                                            │   │  
│  └──────────────────────────────────────────────────────┘   │  
│                                                              │  
│  ── 技法练习 Technique Practice ─────────────────────────   │  
│  ┌──────────┐ ┌──────────┐ ┌──────────┐                    │  
│  │ Naked    │ │ Hidden   │ │ Naked    │                    │  
│  │ Single   │ │ Single   │ │ Pair     │ ...                │  
│  │ 25 puz   │ │ 25 puz   │ │ 25 puz   │                    │  
│  └──────────┘ └──────────┘ └──────────┘                    │  
│                                                              │  
│  [今 Today] [弈 Play] [谱 Su-Pu] [榜 Ranking] [学 Growth]   │  
└─────────────────────────────────────────────────────────────┘  
```  
  
---  
  
## 1.8 Motion & Animation Spec  
  
| Transition | Animation | Duration | Easing |  
|------------|-----------|----------|--------|  
| Tab switch | Crossfade | 150ms | ease-out |  
| Screen push/pop | Slide left/right | 200ms | ease-in-out |  
| Seal stamp (completion) | Scale 0→1.15→1.0 | 400ms | custom spring (damping 0.6) |  
| ORG card state change | Morph (height + content fade) | 300ms | ease-out |  
| Leaderboard row (own position) | Gentle amber pulse | 500ms | ease-in-out |  
| Su-Pu saving | Card shrinks toward 谱 tab icon | 350ms | ease-in |  
| Pull to refresh | Ink drip from top | variable | spring |  
| Loading skeleton | Shimmer on rice paper cards | continuous | linear |  
| Error toast | Slide down + auto-dismiss | 300ms in, 3s hold, 200ms out | ease-out |  
| Countdown timer | Smooth digit transition | 200ms per tick | ease-out |  
  
**Reduced Motion**: When system "Reduce Motion" is enabled, all animations become instant crossfades (150ms). Seal stamp becomes static image. No scaling, no sliding, no spring effects.  
  
---  
  
## 1.9 Accessibility  
  
| Element | Requirement |  
|---------|-------------|  
| Touch targets | ≥44×44pt (iOS), ≥48×48dp (Android) |  
| Text contrast | WCAG AA (4.5:1 body, 3:1 large) |  
| Screen reader (board) | "Row 5, Column 3. Value: 7. Player-entered." |  
| Screen reader (ORG card) | "Daily Ranking. Window open. 847 players submitted. Button: Start Ranking Game." |  
| Dynamic type | Scale to 135% without layout breakage |  
| Color independence | Color never sole indicator. Shape (seal icon), position, and text label reinforce all states. |  
| Haptic alternatives | Visual pulse replaces haptic when accessibility settings request. |  
  
---  
  
# PART 2: WEB PLATFORM  
  
## 2.1 Web Overview  
  
orbacesudoku.com serves three audiences:  
  
| Audience | Primary Need | Pages |  
|----------|-------------|-------|  
| **Potential players** | Discover Orbace, understand value | Landing page |  
| **Active players** | Play on desktop, access Su-Pu, check rankings | /play, /record-hall, /ranking |  
| **Shared replay viewers** | Watch a Su-Pu replay someone shared | /supu/{id} |  
  
### 2.2 Site Map  
  
```  
orbacesudoku.com  
  │  
  ├── / (Landing)  
  │     ├── Hero: "Calm Puzzles. Real Progress."  
  │     ├── Today's leaderboard preview  
  │     ├── Feature showcase  
  │     ├── App download CTAs  
  │     └── "Play in Browser" entry  
  │  
  ├── /play (Web player)  
  │     ├── Tea Moment (no account needed)  
  │     ├── Level Packs (no account needed)  
  │     ├── Daily Ranking (account required)  
  │     └── Practice mode  
  │  
  ├── /ranking (Leaderboards)  
  │     ├── Daily, Weekly, Monthly, Annual (public)  
  │     ├── Player profiles (public)  
  │     └── My ranking (account required)  
  │  
  ├── /supu/{id} (Public replay viewer)  
  │     ├── Full 复盘 playback (no account)  
  │     ├── Score + RP display  
  │     ├── Player attribution (if public)  
  │     └── "Get Orbace Sudoku" CTA  
  │  
  ├── /record-hall (Account required)  
  │     └── Full 藏谱阁 access  
  │  
  └── /account  
        ├── Sign in / Sign up  
        ├── Profile  
        └── Settings / Privacy  
```  
  
### 2.3 Landing Page  
  
```  
┌─────────────────────────────────────────────────────────────────┐  
│                                                                  │  
│  ┌─────────────────────────────────────────────────────────┐   │  
│  │  [数] Orbace Sudoku  一局一茶                             │   │  
│  │       Play  │  Ranking  │  Sign In                         │   │  
│  └─────────────────────────────────────────────────────────┘   │  
│                                                                  │  
│  ┌─────────────────────────────────────────────────────────┐   │  
│  │                                                          │   │  
│  │                    ┌──────┐                               │   │  
│  │                    │  数  │                               │   │  
│  │                    │ Su-Pu│                               │   │  
│  │                    └──────┘                               │   │  
│  │                                                          │   │  
│  │           Calm Puzzles. Real Progress.                    │   │  
│  │                                                          │   │  
│  │     The Sudoku app that respects your focus,              │   │  
│  │     teaches you to improve, and preserves every           │   │  
│  │     solve as a Su-Pu you can replay, compare,             │   │  
│  │     and share.                                            │   │  
│  │                                                          │   │  
│  │     ┌────────────────────┐  ┌────────────────────┐      │   │  
│  │     │  Download on App   │  │  Get on Google Play │      │   │  
│  │     │  Store             │  │                     │      │   │  
│  │     └────────────────────┘  └────────────────────┘      │   │  
│  │                                                          │   │  
│  │              or ┌──────────────────────────┐            │   │  
│  │                 │   Play in Browser Now    │            │   │  
│  │                 └──────────────────────────┘            │   │  
│  └─────────────────────────────────────────────────────────┘   │  
│                                                                  │  
│  ┌─────────────────────────────────────────────────────────┐   │  
│  │  Why Orbace?                                             │   │  
│  │                                                          │   │  
│  │  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐        │   │  
│  │  │  茶    │  │  谱    │  │  榜    │  │  学    │        │   │  
│  │  │  Tea   │  │ Su-Pu  │  │ Rank   │  │ Scholar│        │   │  
│  │  │        │  │        │  │        │  │        │        │   │  
│  │  │No Ads  │  │Replay  │  │Fair    │  │Learn & │        │   │  
│  │  │During  │  │Every   │  │Global  │  │Improve │        │   │  
│  │  │Play    │  │Solve   │  │Ranking │  │        │        │   │  
│  │  └────────┘  └────────┘  └────────┘  └────────┘        │   │  
│  └─────────────────────────────────────────────────────────┘   │  
│                                                                  │  
│  ┌─────────────────────────────────────────────────────────┐   │  
│  │  Today's Leaderboard                                     │   │  
│  │  🥇 ZenSolver · 500 RP  🥈 SharpLogic_502 · 300 RP     │   │  
│  │  🥉 SudokuMaster · 200 RP                                │   │  
│  │  [View Full Leaderboard ▸]                               │   │  
│  └─────────────────────────────────────────────────────────┘   │  
│                                                                  │  
│  ┌─────────────────────────────────────────────────────────┐   │  
│  │  Download on App Store  │  Google Play  │  About  │ Privacy│   │  
│  └─────────────────────────────────────────────────────────┘   │  
│                                                                  │  
└─────────────────────────────────────────────────────────────────┘  
```  
  
### 2.4 Web Player  
  
```  
┌─────────────────────────────────────────────────────────────────┐  
│  [数] Orbace Sudoku    Play │ Ranking │ 藏谱阁 │ ZenSolver ▾   │  
├─────────────────────────────────────────────────────────────────┤  
│                                                                  │  
│  ┌──────────────────────────────────────────┐  ┌────────────┐  │  
│  │                                          │  │ Puzzle Info │  │  
│  │          Sudoku Board                    │  │             │  │  
│  │          (responsive, larger             │  │ 精深 #892   │  │  
│  │           on desktop)                    │  │ Tea Moment  │  │  
│  │                                          │  │ ⏱ 04:32    │  │  
│  │  Keyboard shortcuts:                     │  │             │  │  
│  │  1-9: Input number                       │  │ [✏️ Notes]  │  │  
│  │  Arrow keys: Navigate cells              │  │ [↩️ Undo]   │  │  
│  │  Space: Toggle notes                     │  │ [↪️ Redo]   │  │  
│  │  Backspace/Delete: Erase                 │  │ [🗑️ Erase]  │  │  
│  │  H: Hint (if available)                  │  │ [💡 Hint]   │  │  
│  │                                          │  └────────────┘  │  
│  └──────────────────────────────────────────┘                    │  
│                                                                  │  
│  ┌──────────────────────────────────────────────────────────┐   │  
│  │  1    2    3    4    5    6    7    8    9               │   │  
│  └──────────────────────────────────────────────────────────┘   │  
│                                                                  │  
└─────────────────────────────────────────────────────────────────┘  
```  
  
### 2.5 Public Replay Viewer (/supu/{id})  
  
```  
┌─────────────────────────────────────────────────────────────────┐  
│  [数] Orbace Sudoku    Play │ Ranking │ 藏谱阁                   │  
├─────────────────────────────────────────────────────────────────┤  
│                                                                  │  
│  ┌─────────────────────────────────────────────────────────┐   │  
│  │  ┌──────┐  Su-Pu · 精深 #247                             │   │  
│  │  │  谱  │  ⭐ 14,400 · 正谱 Official · 净谱               │   │  
│  │  │Su-Pu │  34 steps · 4:32 · June 15, 2026               │   │  
│  │  └──────┘  Recorded by: ZenSolver 🇨🇳 ⭐                  │   │  
│  │            (Player chose to share this publicly)          │   │  
│  └─────────────────────────────────────────────────────────┘   │  
│                                                                  │  
│  ┌──────────────────────────────────┐  ┌────────────────────┐  │  
│  │      Board Replay                │  │  Move List         │  │  
│  │      (animated)                  │  │  1. NS R5C3=7      │  │  
│  │                                  │  │  2. HS C7R2=3      │  │  
│  │  ⏮ ⏪ ▶/⏸ ⏩ ⏭  Speed: 1x ▼    │  │  3. NP B1          │  │  
│  │                                  │  │  ...               │  │  
│  └──────────────────────────────────┘  └────────────────────┘  │  
│                                                                  │  
│  ┌─────────────────────────────────────────────────────────┐   │  
│  │  Want to create your own Su-Pu?                          │   │  
│  │  ┌────────────────────┐  ┌────────────────────┐         │   │  
│  │  │  Download on App   │  │  Get on Google Play │         │   │  
│  │  │  Store             │  │                     │         │   │  
│  │  └────────────────────┘  └────────────────────┘         │   │  
│  │              or [Play in Browser]                        │   │  
│  └─────────────────────────────────────────────────────────┘   │  
│                                                                  │  
│  🔒 This replay was shared publicly by the player.               │  
│  [Privacy Policy]                                                │  
└─────────────────────────────────────────────────────────────────┘  
```  
  
### 2.6 Web-Specific Features  
  
| Feature | Desktop | Tablet | Mobile Web |  
|---------|---------|--------|------------|  
| Keyboard input | ✅ Full | ✅ (external) | ❌ |  
| Multi-tab | ✅ 藏谱阁 in one tab, play in another | ⚠️ Limited | ❌ |  
| Right-click context | ✅ Cell actions | ❌ | ❌ |  
| Hover states | ✅ Tooltips, highlights | ❌ | ❌ |  
| Responsive board | ✅ Up to 600px | ✅ Adaptive | ✅ Compact |  
| Offline | ❌ | ❌ | ❌ |  
| PWA install | Future | Future | Future |  
  
---  
  
# PART 3: BACKEND & CLOUD  
  
## 3.1 Architecture Overview  
  
```  
┌─────────────────────────────────────────────────────────────────┐  
│                    ORBACE SUDOKU 2.0 ARCHITECTURE                 │  
│                                                                  │  
│  ┌──────────────────┐  ┌──────────────────┐  ┌───────────────┐ │  
│  │   iOS App        │  │   Android App    │  │  Web Platform │ │  
│  │   (Flutter)      │  │   (Flutter)      │  │  (Flutter Web)│ │  
│  │                  │  │                  │  │               │ │  
│  │  Local: Drift    │  │  Local: Drift    │  │  Host: Vercel │ │  
│  │  (SQLite)        │  │  (SQLite)        │  │               │ │  
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
└─────────────────────────────────────────────────────────────────┘  
```  
  
## 3.2 Technology Stack  
  
| Layer | Technology | Purpose |  
|-------|-----------|---------|  
| **Mobile + Web** | Flutter 3.x | Cross-platform client |  
| **Local DB** | Drift (SQLite) | Puzzles, Su-Pu, game state, settings |  
| **Web Hosting** | Vercel | Flutter Web deployment, edge network |  
| **Cloud Database** | Supabase (PostgreSQL 15) | Accounts, ORG submissions, leaderboards |  
| **Authentication** | Supabase Auth + Custom UUID | Email/password, OAuth (Google, Apple), Auto-UUID |  
| **Cache** | Upstash Redis | Live leaderboards, rate limiting, sessions |  
| **ORG Endpoint** | Fly.io (Fastify) | Always-warm for latency-sensitive submissions |  
| **Object Storage** | Supabase Storage + Cloudflare R2 | Replays, certificates, packs |  
| **Background Jobs** | Vercel Cron + Supabase Edge Functions | Leaderboard finalization, notifications |  
| **ORM** | Prisma 5.x | Type-safe database access |  
| **Monitoring** | Sentry + Vercel Analytics | Error tracking, performance |  
  
## 3.3 Database Schema  
  
### Core Tables  
  
```sql  
-- ============================================================  
-- PLAYER ACCOUNTS (Hybrid Identity)  
-- ============================================================  
CREATE TABLE player_accounts (  
  player_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),  
    
  -- Identity tier: 'tier1_uuid', 'tier2_registered', 'tier2_verified',   
  --                'tier3_established', 'tier4_veteran'  
  account_tier TEXT NOT NULL DEFAULT 'tier1_uuid',  
    
  -- Tier 1: Auto-UUID  
  device_uuid TEXT UNIQUE,  
  friendly_name TEXT UNIQUE,  -- "CalmPuzzle_847"  
    
  -- Tier 2: Registered  
  supabase_user_id UUID UNIQUE REFERENCES auth.users(id),  
  display_name TEXT UNIQUE,  
  display_name_lower TEXT UNIQUE,  
  email TEXT,  
  email_verified BOOLEAN DEFAULT FALSE,  
    
  -- Social auth  
  social_provider TEXT,  -- 'google', 'apple', null  
  social_uid TEXT,  
    
  -- Profile  
  country_code TEXT,  
  avatar_url TEXT,  
    
  -- Privacy  
  privacy_org_replay TEXT DEFAULT 'public',  
  privacy_practice_replay TEXT DEFAULT 'private',  
  privacy_share_as TEXT DEFAULT 'name',  -- 'name' or 'anonymous'  
  privacy_show_country BOOLEAN DEFAULT FALSE,  
    
  -- Notifications  
  notify_org_start BOOLEAN DEFAULT FALSE,  
  notify_window_closing BOOLEAN DEFAULT FALSE,  
  notify_results BOOLEAN DEFAULT TRUE,  
  notify_tournaments BOOLEAN DEFAULT TRUE,  
    
  -- Trust & anti-cheat  
  trust_score INTEGER DEFAULT 0,  
  device_fingerprint_hash TEXT,  
    
  -- Ranking stats  
  total_rp INTEGER DEFAULT 0,  
  total_orgs_started INTEGER DEFAULT 0,  
  total_orgs_completed INTEGER DEFAULT 0,  
  total_orgs_submitted INTEGER DEFAULT 0,  
  total_clean_solves INTEGER DEFAULT 0,  
  best_daily_rank INTEGER,  
  best_daily_rp INTEGER,  
  mingpu_count INTEGER DEFAULT 0,  
    
  -- Scholar's Path  
  scholar_path_stage INTEGER DEFAULT 1,  
    
  -- Status  
  account_status TEXT DEFAULT 'active',  
  age_verified BOOLEAN DEFAULT FALSE,  
  age_restricted BOOLEAN DEFAULT FALSE,  
  created_at TIMESTAMPTZ DEFAULT NOW(),  
  last_active_at TIMESTAMPTZ DEFAULT NOW()  
);  
  
-- ============================================================  
-- OFFICIAL EVENTS  
-- ============================================================  
CREATE TABLE official_events (  
  event_id TEXT PRIMARY KEY,              -- 'ORG-2026-0629-DAILY'  
  event_type TEXT NOT NULL,               -- 'daily', 'mini_tournament', 'major_tournament'  
  tournament_id TEXT,  
  puzzle_id TEXT NOT NULL REFERENCES puzzles(puzzle_id),  
  event_date DATE NOT NULL,  
  window_start TIMESTAMPTZ NOT NULL,  
  window_end TIMESTAMPTZ NOT NULL,  
  results_finalized_at TIMESTAMPTZ,  
  puzzle_checksum TEXT NOT NULL,  
  scoring_version INTEGER NOT NULL DEFAULT 1,  
  is_active BOOLEAN DEFAULT TRUE,  
  created_at TIMESTAMPTZ DEFAULT NOW()  
);  
  
-- ============================================================  
-- ORG SUBMISSIONS  
-- ============================================================  
CREATE TABLE org_submissions (  
  submission_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),  
  event_id TEXT NOT NULL REFERENCES official_events(event_id),  
  player_id UUID NOT NULL REFERENCES player_accounts(player_id),  
  supu_id TEXT NOT NULL,  
    
  completed BOOLEAN NOT NULL DEFAULT FALSE,  
  error_count INTEGER DEFAULT 0,  
  hint_count INTEGER DEFAULT 0,  
  elapsed_seconds INTEGER,  
  total_steps INTEGER,  
    
  completion_bonus INTEGER NOT NULL,  
  speed_bonus INTEGER DEFAULT 0,  
  speed_rank INTEGER,  
  total_rp INTEGER NOT NULL,  
  submitted_for_speed BOOLEAN DEFAULT FALSE,  
    
  completed_at_timestamp TIMESTAMPTZ,  
  started_at_timestamp TIMESTAMPTZ NOT NULL,  
  submitted_at_timestamp TIMESTAMPTZ,  
    
  replay_data_json JSONB,  
  replay_hash TEXT,  
  validation_status TEXT DEFAULT 'pending',  
    
  client_version TEXT,  
  platform TEXT,  
    
  UNIQUE(event_id, player_id)  
);  
  
-- ============================================================  
-- LEADERBOARDS (Materialized)  
-- ============================================================  
CREATE TABLE leaderboard_daily (  
  event_date DATE PRIMARY KEY,  
  event_id TEXT NOT NULL,  
  results_json JSONB NOT NULL,  
  total_participants INTEGER NOT NULL,  
  total_submissions INTEGER NOT NULL,  
  finalized_at TIMESTAMPTZ NOT NULL  
);  
  
CREATE TABLE leaderboard_weekly (  
  week_start DATE PRIMARY KEY,  
  results_json JSONB NOT NULL,  
  total_participants INTEGER NOT NULL,  
  finalized_at TIMESTAMPTZ NOT NULL  
);  
  
CREATE TABLE leaderboard_monthly (  
  month_start DATE PRIMARY KEY,  
  results_json JSONB NOT NULL,  
  total_participants INTEGER NOT NULL,  
  finalized_at TIMESTAMPTZ NOT NULL  
);  
  
-- ============================================================  
-- RP LEDGER (Immutable audit trail)  
-- ============================================================  
CREATE TABLE rp_ledger (  
  transaction_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),  
  player_id UUID NOT NULL REFERENCES player_accounts(player_id),  
  event_id TEXT NOT NULL,  
  supu_id TEXT NOT NULL,  
  completion_bonus INTEGER NOT NULL,  
  speed_bonus INTEGER NOT NULL,  
  total_rp INTEGER NOT NULL,  
  transaction_type TEXT NOT NULL,  
  created_at TIMESTAMPTZ DEFAULT NOW()  
);  
  
-- ============================================================  
-- DEVICE FINGERPRINTS (Anti-cheat)  
-- ============================================================  
CREATE TABLE device_fingerprints (  
  fingerprint_hash TEXT PRIMARY KEY,  
  player_id UUID REFERENCES player_accounts(player_id),  
  first_seen_at TIMESTAMPTZ DEFAULT NOW(),  
  last_seen_at TIMESTAMPTZ DEFAULT NOW(),  
  account_count INTEGER DEFAULT 1,  
  is_flagged BOOLEAN DEFAULT FALSE  
);  
  
-- ============================================================  
-- PUSH TOKENS  
-- ============================================================  
CREATE TABLE push_tokens (  
  token_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),  
  player_id UUID NOT NULL REFERENCES player_accounts(player_id) ON DELETE CASCADE,  
  platform TEXT NOT NULL,  
  token TEXT NOT NULL,  
  is_active BOOLEAN DEFAULT TRUE,  
  created_at TIMESTAMPTZ DEFAULT NOW()  
);  
```  
  
## 3.4 API Design  
  
### Authentication Endpoints  
  
```  
POST /auth/uuid/register  
  Purpose: Create Tier 1 auto-UUID account  
  Request: { "device_uuid": "...", "device_fingerprint": "..." }  
  Response: { "player_id": "...", "friendly_name": "CalmPuzzle_847", "token": "jwt..." }  
  
POST /auth/uuid/upgrade  
  Purpose: Upgrade Tier 1 → Tier 2 (claim history)  
  Auth: Tier 1 JWT  
  Request: { "supabase_auth_token": "...", "display_name": "ZenSolver" }  
  Response: { "player_id": "...", "rp_transferred": 1250, "orgs_transferred": 14 }  
  
GET /auth/check-name/{displayName}  
  Purpose: Check display name availability  
  Response: { "available": true/false }  
```  
  
### ORG Endpoints  
  
```  
GET /org/status  
  Auth: Required (any tier)  
  Response: { today_event, player_status, tomorrow_event, upcoming_tournament }  
  
GET /org/{eventId}/puzzle  
  Auth: Required, eligible  
  Response: { puzzle_id, givens, checksum, issued_at }  
  
POST /org/{eventId}/start  
  Auth: Required, eligible  
  Response: { attempt_id, status, started_at }  
  
POST /org/{eventId}/submit  
  Auth: Required  
  Request: { supu_id, completed, error_count, elapsed_seconds,   
             total_steps, completed_at_timestamp, submitted_for_speed,  
             replay_data, score_breakdown, client_version, platform }  
  Response: { submission_id, status, completion_bonus, speed_bonus_pending,   
             total_rp, provisional_rank, total_submissions }  
```  
  
### Leaderboard Endpoints  
  
```  
GET /leaderboard/live/{eventId}  
  Auth: Optional  
  Response: { top_10, player_position (if authenticated) }  
  
GET /leaderboard/daily/{date}  
GET /leaderboard/weekly/{weekStart}  
GET /leaderboard/monthly/{monthStart}  
  Auth: Optional  
  Response: { rankings (paginated), player_result (if authenticated) }  
  
GET /player/{playerId}/profile  
  Auth: Optional  
  Response: { display_name, country_code, total_rp, mingpu_count, recent_results }  
```  
  
## 3.5 Cron Jobs (Vercel Cron)  
  
```json  
{  
  "crons": [  
    { "path": "/api/cron/org-window-open",    "schedule": "0 1 * * *" },  
    { "path": "/api/cron/org-window-closing", "schedule": "0 20 * * *" },  
    { "path": "/api/cron/org-window-closed",  "schedule": "0 22 * * *" },  
    { "path": "/api/cron/calculate-results",  "schedule": "5 22 * * *" },  
    { "path": "/api/cron/publish-results",    "schedule": "0 23 * * *" },  
    { "path": "/api/cron/weekly-finalize",    "schedule": "0 0 * * 0" },  
    { "path": "/api/cron/monthly-finalize",   "schedule": "0 0 1 * *" }  
  ]  
}  
```  
  
## 3.6 Cost Estimates  
  
| Service | V2.0 Launch | V2.0 Growth |  
|---------|-------------|-------------|  
| Vercel Pro | $20/mo | $20/mo |  
| Supabase Pro | $25/mo | $25/mo |  
| Upstash Redis | $0 (free tier) | ~$20/mo |  
| Fly.io | ~$5/mo | ~$10/mo |  
| Cloudflare R2 | $0 (free tier) | ~$5/mo |  
| Sentry Team | $26/mo | $26/mo |  
| Resend (email) | $0 (free tier) | ~$20/mo |  
| **Total** | **~$76/mo** | **~$126/mo** |  
  
## 3.7 Deployment Pipeline  
  
```  
GitHub (main branch)  
  │  
  ├── Flutter App  
  │     ├── CI: flutter test + flutter analyze  
  │     ├── CD: fastlane → App Store Connect + Google Play Console  
  │     └── Web: flutter build web → Vercel deploy  
  │  
  ├── Backend (Fly.io)  
  │     ├── CI: npm test + tsc  
  │     └── CD: fly deploy  
  │  
  └── Database (Supabase)  
        ├── Prisma Migrate (via GitHub Actions)  
        └── Supabase CLI for edge functions  
```  
  
---  
  
## 4. Summary: V2.0 Feature Map  
  
| Category | Feature | Priority |  
|----------|---------|----------|  
| **Account** | Auto-UUID (Tier 1) — instant ranking | P0 |  
| **Account** | Social Auth (Google, Apple) + Email/Password (Tier 2) | P0 |  
| **Account** | Tier 1 → Tier 2 upgrade with history transfer | P0 |  
| **Account** | Privacy control center | P0 |  
| **Account** | Underage restricted accounts | P1 |  
| **Ranking** | Daily ORG with full lifecycle (9 states) | P0 |  
| **Ranking** | Live + finalized leaderboards | P0 |  
| **Ranking** | Saturday tournaments (Mini + Major) | P1 |  
| **Ranking** | Weekly/Monthly/Annual 名谱榜 | P1 |  
| **UX** | Bottom navigation with seal icons | P0 |  
| **UX** | Section-based Home with state-aware cards | P0 |  
| **UX** | ORG card state machine (9 states) | P0 |  
| **UX** | Empty, loading, error states | P0 |  
| **UX** | Transition animations | P1 |  
| **Sharing** | 传谱 (share replayable Su-Pu link) | P1 |  
| **Sharing** | Web replay viewer (public) | P1 |  
| **Web** | Landing page with brand story | P0 |  
| **Web** | Web player (Tea Moment + Level Packs) | P0 |  
| **Web** | Web ORG participation | P1 |  
| **Web** | Keyboard-optimized desktop play | P1 |  
| **Backend** | Supabase PostgreSQL schema | P0 |  
| **Backend** | ORG submission API (Fly.io) | P0 |  
| **Backend** | Leaderboard calculation cron | P0 |  
| **Backend** | Push notification service | P1 |  
| **Anti-cheat** | Device fingerprinting | P0 |  
| **Anti-cheat** | Trust tier system | P0 |  
| **Anti-cheat** | Manual review for top ranks | P1 |  
  
---  
  
*End of Orbace Sudoku 2.0 PRD*  
