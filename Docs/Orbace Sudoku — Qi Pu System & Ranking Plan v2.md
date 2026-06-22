# Orbace Sudoku — Qi Pu System & Ranking Plan  
  
**Version**: 2.1    
**Date**: 2026-06-22    
**Supersedes**: Score Ranking Plan V1.0, Qi Pu System V2.0    
**Purpose**: Define the Su-Pu (数谱) production plan — a unified framework for replay save/reload, score recording, achievement certification, collection management, comparison, sharing, and leaderboard readiness.  
  
---  
  
## Terminology  
  
| Chinese | Romanized | English UI | Meaning in Orbace |  
|---------|-----------|------------|-------------------|  
| 数谱 | Shù Pǔ | Su-Pu | A complete recorded solve of one puzzle |  
| 藏谱阁 | Cáng Pǔ Gé | Record Hall | The player's personal Su-Pu collection |  
| 复盘 | Fù Pán | Replay | Watch a recorded solve play back |  
| 对谱 | Duì Pǔ | Compare | Side-by-side comparison of two Su-Pu |  
| 传谱 | Chuán Pǔ | Share | Share a Su-Pu with another player |  
| 谱评 | Pǔ Píng | Notes | Personal annotations on a Su-Pu |  
| 名谱 | Míng Pǔ | Top Record | A top-ranked Su-Pu on a puzzle's leaderboard |  
| 净谱 | Jìng Pǔ | Clean Record | A Su-Pu with zero errors and zero hints |  
| 残谱 | Cán Pǔ | In Progress | An incomplete Su-Pu (puzzle in progress) |  
| 珍藏谱 | Zhēn Cáng Pǔ | Favorite | A bookmarked Su-Pu |  
| 正谱 | Zhèng Pǔ | Official | An official-class Su-Pu eligible for ranking |  
| 习谱 | Xí Pǔ | Practice | A practice-class Su-Pu (used hints or assists) |  
| 重修谱 | Chóng Xiū Pǔ | Retry | A retry-class Su-Pu |  
| 旧谱 | Jiù Pǔ | Legacy | A Su-Pu from an old scoring version |  
| 名谱榜 | Míng Pǔ Bǎng | Leaderboard | Per-puzzle ranking of top Su-Pu |  
| 重解 | Chóng Jiě | Retry | Create a new Su-Pu by re-solving a puzzle |  
  
---  
  
## 1. Product Intent  
  
Orbace Sudoku treats every completed puzzle as a **Su-Pu (数谱)** — a recorded solve that is simultaneously a learning record, a performance record, a collectible artifact, and a shareable achievement.  
  
In the tradition of Go and Chinese Chess, where 棋谱 (qípǔ) preserves every move of a strategy game for study and transmission, Su-Pu brings the same philosophy to Sudoku. A Su-Pu is not merely "a completed puzzle." It is:  
  
- **A record** — every move preserved in sequence  
- **A study object** — reviewed (复盘) and analyzed to improve  
- **A personal artifact** — collected, annotated, and revisited in the Record Hall (藏谱阁)  
- **A comparable document** — measured against other Su-Pu of the same puzzle (对谱)  
- **A shareable text** — transmitted to other players for discussion (传谱)  
  
This framework unifies what would otherwise be separate features (replay library, score certificate, player rating, ranking) into one coherent system organized around a single concept the player can understand and value.  
  
### 1.1 The Su-Pu Promise  
  
> Every solve is a Su-Pu. Every Su-Pu has a home in your Record Hall. Every Su-Pu can be replayed, compared, annotated, shared, and improved.  
  
---  
  
## 2. Core Architecture: The Su-Pu Data Object  
  
### 2.1 A Su-Pu Contains  
  
Every completed puzzle attempt is automatically saved as a Su-Pu with:  
  
**Identity & Classification:**  
- Su-Pu ID (unique identifier, format: `SP-YYYY-MMDD-PUZZLEID-V#`)  
- Puzzle ID (which puzzle was solved)  
- Su-Pu class: `official` (正谱) | `practice` (习谱) | `retry` (重修谱) | `legacy` (旧谱)  
- Attempt number (1st, 2nd, 3rd... for this puzzle)  
- Parent Su-Pu ID (if this is a retry, which Su-Pu it improves upon)  
- Completion timestamp  
  
**The Solve Record:**  
- Full move history (every cell entry, note toggle, erase, in sequence)  
- Total steps  
- Elapsed time (if timer enabled)  
- Step timestamps for pace analysis  
  
**Technique Profile:**  
- Technique counts (NS×18, HS×8, NP×5, etc.)  
- Technique sequence (order of technique usage)  
- Highest technique difficulty used  
  
**Quality Metrics:**  
- Solve Quality Score with full breakdown  
- Error count  
- Hints used by tier (nudge, explanation, reveal)  
- Auto-check enabled flag  
- Clean solve flag (净谱: zero errors, zero hints)  
- Efficiency ratio (optimal steps / player steps)  
  
**Ranked Eligibility:**  
- Su-Pu class (`official` only eligible)  
- Ranked eligible flag  
- Scoring version  
- Puzzle checksum (hash of givens + solution)  
- Replay hash (hash of move sequence for integrity verification)  
- Content version at time of solve  
  
**Player Input:**  
- Player difficulty rating (1.0-5.0, optional)  
- Player notes / 谱评 (optional text annotation)  
- Player tags (optional: "morning solve," "commute," "breakthrough")  
- Favorite flag (珍藏谱)  
  
**Artifact Data:**  
- Score certificate image path (generated on demand)  
- Share history (timestamps of shares)  
  
### 2.2 Su-Pu Classes  
  
| Class | Chinese | Label | Eligibility | Display Context |  
|-------|---------|-------|-------------|-----------------|  
| `official` | 正谱 | Official | First completion, no T3 hints, no retry, puzzle eligible, scoring version current | Local ranking, future worldwide leaderboard |  
| `practice` | 习谱 | Practice | Used hints or assist features | Personal progress only |  
| `retry` | 重修谱 | Retry | Retry attempt | Personal improvement tracking only |  
| `legacy` | 旧谱 | Legacy | Old scoring version | Display only, not ranked |  
  
### 2.3 Su-Pu Versioning  
  
Multiple Su-Pu for the same puzzle are versioned:  
  
```  
精深 #247 — Your Su-Pu Collection  
├─ 📜 v1 · June 12 · Score: 12,800 · 3 errors · 习谱 Practice  
├─ 🏆 v2 · June 15 · Score: 14,400 · 0 errors · 正谱 Official  ← Best Official  
└─ 📜 v3 · June 18 · Score: 14,600 · 0 errors · 重修谱 Retry      ← Best Overall  
```  
  
Each version is a complete, independent Su-Pu. They share a puzzle ID. The Record Hall groups them.  
  
---  
  
## 3. The Cáng Pǔ Gé (藏谱阁) — Record Hall  
  
### 3.1 Design Philosophy  
  
The Record Hall is not a "replay list." It is the player's personal archive — their Sudoku body of work. It should feel like entering a scholar's study, not opening a file browser.  
  
### 3.2 Screen Structure  
  
```  
┌─────────────────────────────────────────────────────────────────┐  
│                      藏 谱 阁                                    │  
│                 Cáng Pǔ Gé · Record Hall                         │  
│                                                                  │  
│  ┌─────────────────────────────────────────────────────────┐   │  
│  │  📜 248 Su-Pu  ·  ✨ 12 this week  ·  🏆 3 Top Records  │   │  
│  │  ⭐ 42 净谱 (clean)  ·  📈 15 personal bests            │   │  
│  └─────────────────────────────────────────────────────────┘   │  
│                                                                  │  
│  [全部 All] [正谱 Official] [净谱 Clean] [珍藏 Favorites]        │  
│  [残谱 In Progress]                                              │  
│                                                                  │  
│  Filter:  Difficulty ▼   Date ▼   Quality ▼                     │  
│                                                                  │  
│  ┌──────────────────────────────────────────────────────────┐  │  
│  │                                                           │  │  
│  │  📅 June 15, 2026                                         │  │  
│  │                                                           │  │  
│  │  ┌────────────────────────────────────────────────────┐  │  │  
│  │  │  🏆 精深 #247                                      │  │  │  
│  │  │  ⭐ Best Official: 14,400 · 净谱 · 34 steps        │  │  │  
│  │  │  3 Su-Pu: v1 (习谱)  v2 (正谱)  v3 (重修谱)       │  │  │  
│  │  │  Latest: June 18 · Personal Best: v3 (14,600)     │  │  │  
│  │  │  [View Collection]  [复盘 Best]  [对谱 Compare]    │  │  │  
│  │  └────────────────────────────────────────────────────┘  │  │  
│  │                                                           │  │  
│  │  ┌────────────────────────────────────────────────────┐  │  │  
│  │  │  📜 精深 #128                                      │  │  │  
│  │  │  ⭐ 15,200 · 净谱 · 47 steps · June 14            │  │  │  
│  │  │  1 Su-Pu · 正谱 Official  ·  💬 "X-Wing spotted!" │  │  │  
│  │  │  [复盘 Replay]  [成绩单 Certificate]  [传谱 Share] │  │  │  
│  │  └────────────────────────────────────────────────────┘  │  │  
│  │                                                           │  │  
│  │  ┌────────────────────────────────────────────────────┐  │  │  
│  │  │  📜 精深 #312                                      │  │  │  
│  │  │  ⭐ 11,800 · 2 errors · 1 nudge · June 13          │  │  │  
│  │  │  1 Su-Pu · 习谱 Practice  ·  ⚠️ Not ranked         │  │  │  
│  │  │  [复盘 Replay]  [重解 Retry]  [谱评 Notes]         │  │  │  
│  │  └────────────────────────────────────────────────────┘  │  │  
│  │                                                           │  │  
│  └──────────────────────────────────────────────────────────┘  │  
│                                                                  │  
│  Collection: 📜 248  ⭐ 42 clean  🏆 3 official  📈 12% PB rate │  
└─────────────────────────────────────────────────────────────────┘  
```  
  
### 3.3 Collection Views  
  
| View | Chinese | Content |  
|------|---------|---------|  
| All | 全部谱 | Every Su-Pu, grouped by puzzle, newest first |  
| Official | 正谱 | Only official-class Su-Pu (ranked eligible) |  
| Clean | 净谱 | Only Su-Pu with zero errors and zero hints |  
| Favorites | 珍藏谱 | Bookmarked Su-Pu |  
| In Progress | 残谱 | Unfinished puzzles |  
| By Difficulty | 按难 | Filtered by difficulty tier |  
| By Technique | 按法 | Filtered by technique used |  
  
### 3.4 Collection Statistics  
  
The Record Hall header displays:  
  
- Total Su-Pu in collection  
- Su-Pu added this week  
- Top Records count (名谱, post-MVP)  
- Clean records count and percentage (净谱)  
- Puzzles with multiple Su-Pu (retry engagement)  
- Personal best rate (% of retries that improved)  
- Most-used advanced technique  
- Collection span ("June 12, 2026 — Present")  
  
### 3.5 Entry Points  
  
Players reach the Record Hall from:  
- Home screen (primary navigation)  
- Completion screen ("View in Record Hall")  
- Scholar's Path (award context)  
- Level pack puzzle row (puzzle-specific Su-Pu)  
  
---  
  
## 4. Su-Pu Detail View  
  
### 4.1 Single Su-Pu View  
  
Tapping a specific Su-Pu opens its detail view:  
  
```  
┌─────────────────────────────────────────────────────────────┐  
│                    📜 精深 #247 · v2                          │  
│                    June 15, 2026 · 4:32 PM                    │  
│                                                              │  
│  ┌──────────────────────────────────────────────────────┐   │  
│  │                                                       │   │  
│  │              ⭐ 14,400                                │   │  
│  │          正谱 Official · 净谱 Clean Solve             │   │  
│  │                                                       │   │  
│  │   Score Breakdown:                                    │   │  
│  │   Base (Expert):     16,000                           │   │  
│  │   Accuracy:           ×0.90 (1 error)                 │   │  
│  │   Bonuses:            +0 (timer off)                  │   │  
│  │   ─────────────────────────                           │   │  
│  │   Final:              14,400                          │   │  
│  │                                                       │   │  
│  │   34 steps · 4:32 elapsed · Efficiency: 0.91          │   │  
│  │   Techniques: NS×18 HS×8 NP×5 PP×3                    │   │  
│  │                                                       │   │  
│  │   Player Rating: 4.2 / 5.0 "Challenging"              │   │  
│  │   💬 谱评: "Got stuck on the Hidden Pair in Box 3"    │   │  
│  │                                                       │   │  
│  └──────────────────────────────────────────────────────┘   │  
│                                                              │  
│  ┌──────────────────────────────────────────────────────┐   │  
│  │  This Puzzle: 精深 #247                                │   │  
│  │  Your Su-Pu:  3 versions                               │   │  
│  │  v1 · 12,800 · 习谱 · June 12                          │   │  
│  │  v2 · 14,400 · 正谱 · June 15  ← Current              │   │  
│  │  v3 · 14,600 · 重修谱 · June 18    ← Best Overall     │   │  
│  │  [View All Versions]                                   │   │  
│  └──────────────────────────────────────────────────────┘   │  
│                                                              │  
│  [复盘 Replay]  [对谱 Compare]  [成绩单 Certificate]         │  
│  [传谱 Share]   [谱评 Notes]    [⭐ 珍藏 Favorite]           │  
└─────────────────────────────────────────────────────────────┘  
```  
  
### 4.2 Puzzle Collection View (All Su-Pu for One Puzzle)  
  
When a puzzle has multiple Su-Pu:  
  
```  
┌─────────────────────────────────────────────────────────────┐  
│              精深 #247 · Your Su-Pu Collection               │  
│                                                              │  
│  🏆 Best Official: v2 · 14,400 · 净谱                        │  
│  📈 Best Overall:  v3 · 14,600 · 净谱 (重修谱)               │  
│  📜 3 Su-Pu  ·  First: June 12  ·  Latest: June 18          │  
│                                                              │  
│  ┌──────────────────────────────────────────────────────┐   │  
│  │  📜 v3 · June 18 · ⭐ 14,600                          │   │  
│  │  重修谱 Retry · 净谱 · 32 steps · 4:12               │   │  
│  │  📈 +200 vs. v2 · ⚡ 4 steps faster                  │   │  
│  │  [复盘 Replay]  [对谱 Compare with v2]  [成绩单]     │   │  
│  └──────────────────────────────────────────────────────┘   │  
│                                                              │  
│  ┌──────────────────────────────────────────────────────┐   │  
│  │  🏆 v2 · June 15 · ⭐ 14,400  ← Best Official        │   │  
│  │  正谱 Official · 净谱 · 34 steps · 4:32              │   │  
│  │  📈 +1,600 vs. v1                                    │   │  
│  │  [复盘 Replay]  [对谱 Compare]  [成绩单]  [传谱]     │   │  
│  └──────────────────────────────────────────────────────┘   │  
│                                                              │  
│  ┌──────────────────────────────────────────────────────┐   │  
│  │  📜 v1 · June 12 · ⭐ 12,800                          │   │  
│  │  习谱 Practice · 3 errors · 1 nudge · 52 steps       │   │  
│  │  [复盘 Replay]  [对谱 Compare with v2]                │   │  
│  └──────────────────────────────────────────────────────┘   │  
│                                                              │  
│  [重解 Retry This Puzzle]  [名谱榜 Leaderboard]              │  
└─────────────────────────────────────────────────────────────┘  
```  
  
---  
  
## 5. Duì Pǔ (对谱) — Su-Pu Comparison  
  
### 5.1 Feature Description  
  
对谱 is side-by-side replay comparison of two Su-Pu for the same puzzle. This is the learning engine — the feature that transforms replay from passive viewing into active study.  
  
### 5.2 Comparison View  
  
```  
┌─────────────────────────────────────────────────────────────────┐  
│                     对谱 · COMPARE RECORDS                        │  
│                                                                  │  
│  ┌─────────────────────────┐    ┌─────────────────────────┐    │  
│  │  Your Su-Pu (v2)        │    │  Your Su-Pu (v3)        │    │  
│  │  ⭐ 14,400              │    │  ⭐ 14,600              │    │  
│  │  正谱 Official · 净谱   │    │  重修谱 Retry · 净谱    │    │  
│  │  34 steps · 4:32        │    │  32 steps · 4:12        │    │  
│  │                         │    │                         │    │  
│  │  [Board A replaying]    │    │  [Board B replaying]    │    │  
│  │  Synchronized playback  │    │  Synchronized playback  │    │  
│  │                         │    │                         │    │  
│  │  Techniques:            │    │  Techniques:            │    │  
│  │  NS 18  HS 8            │    │  NS 16  HS 8            │    │  
│  │  NP 5   PP 3            │    │  NP 5   PP 3            │    │  
│  └─────────────────────────┘    └─────────────────────────┘    │  
│                                                                  │  
│  ── Step 18: Divergence Point ──────────────────────────────── │  
│                                                                  │  
│  v2: You found a Naked Pair in Box 3.                           │  
│  v3: You spotted a Hidden Single in Row 5 instead.              │  
│  Both valid! v3's path saved 2 steps.                           │  
│                                                                  │  
│  💡 Insight: The Hidden Single was available earlier.            │  
│     Want to practice spotting Hidden Singles? [Practice Pack]   │  
│                                                                  │  
│  [Sync Playback ⏸]  [Jump to Divergence]  [Show All Differences]│  
└─────────────────────────────────────────────────────────────────┘  
```  
  
### 5.3 Comparison Features  
  
- Synchronized playback: both boards animate simultaneously  
- Divergence detection: automatically identify where paths split  
- Technique comparison: side-by-side technique profiles  
- Score delta: clear improvement/difference metrics  
- Insight generation: "v3 saved 2 steps by spotting the Hidden Single earlier"  
  
---  
  
## 6. Fù Pán (复盘) — Replay  
  
### 6.1 Design Philosophy  
  
复盘 is the act of studying a Su-Pu — watching the recorded solve play back move by move. It is not passive video playback. It is active review, modeled on how Go and Chess players 复盘 their games to understand what happened and why.  
  
### 6.2 Replay Viewer  
  
```  
┌───────────────────────────────────────────────────────────┐  
│                     复盘 · REPLAY                          │  
│                    精深 #247 · v2                           │  
├───────────────────────────────────────────────────────────┤  
│                                                            │  
│  ┌───────────────────────────────────┐  ┌──────────────┐ │  
│  │                                   │  │  Step List   │ │  
│  │         BOARD REPLAY              │  │              │ │  
│  │         (animated)                │  │ 1. NS R5C3=7 │ │  
│  │                                   │  │ 2. HS C7R2=3 │ │  
│  │  Numbers appear in sequence       │  │ 3. NP B1     │ │  
│  │  Current step pulses              │  │ 4. NS R2C5=1 │ │  
│  │  Previous steps shown subtly      │  │ 5. HS C3R8=6 │ │  
│  │                                   │  │ ...          │ │  
│  └───────────────────────────────────┘  └──────────────┘ │  
│                                                            │  
│  ⏮   ⏪   ▶/⏸   ⏩   ⏭    Speed: 1x ▼                     │  
│                                                            │  
│  ┌───────────────────────────────────────────────────────┐ │  
│  │ Step 12/34: Naked Pair in Box 1                        │ │  
│  │ Eliminated candidates 3 and 7 from R1C1, R1C2          │ │  
│  │ ⏱ 0:42 into solve  │  🟢 Easy step                    │ │  
│  └───────────────────────────────────────────────────────┘ │  
└───────────────────────────────────────────────────────────┘  
```  
  
### 6.3 Replay Behavior  
  
| Action | Behavior |  
|--------|----------|  
| View replay | Opens 复盘 viewer. Does not create a new Su-Pu. Does not affect scores. |  
| Play/Pause/Skip | Standard media controls. Seek to any step. |  
| Speed control | 0.5x, 1x, 2x, 4x |  
| Step list | Scrollable list with technique labels and timestamps |  
| Exit replay | Returns to previous screen. Replay is consequence-free. |  
  
### 6.4 Replay vs. Retry  
  
| Action | Creates Su-Pu? | Affects Scores? | Ranked Eligible? |  
|--------|---------------|-----------------|------------------|  
| 复盘 (Replay) | No | No | N/A |  
| 重解 (Retry) | Yes (class: 重修谱) | Can update local best | Never |  
| First attempt | Yes (class: 正谱 or 习谱) | Yes | Yes (if conditions met) |  
  
---  
  
## 7. Score Certificate (成绩单)  
  
### 7.1 Design Philosophy  
  
The score certificate is one representation of a Su-Pu — the formal, shareable achievement document. It is generated from Su-Pu data, not stored as the primary record.  
  
### 7.2 Certificate Content  
  
**Header:**  
- Orbace Sudoku logo  
- "Solve Record · 一局成績" title  
- Vermilion seal with difficulty character (入門, 小成, 貫通, 精深, 入神, 極致)  
  
**Hero Section:**  
- Large score number  
- Su-Pu class badge (正谱 Official / 习谱 Practice / 重修谱 Retry)  
- Clean solve marker (净谱) if applicable  
  
**Detail Grid:**  
- Puzzle: 精深 #247  
- Pack: Solar Terms — 立夏  
- Date: June 15, 2026  
- Time: 4:32 (if timer enabled) or "Untimed"  
- Steps: 34  
- Errors: 0  
- Hints: 0  
- Techniques: Naked Single ×18, Hidden Single ×8, Naked Pair ×5, Pointing Pair ×3  
  
**Score Breakdown:**  
- Base (Expert): 16,000  
- Accuracy Multiplier: ×0.90  
- Bonuses: +0  
- Final: 14,400  
  
**Player Section (if provided):**  
- Player Difficulty Rating: 4.2 / 5.0 — "Challenging"  
- 谱评: "Got stuck on the Hidden Pair in Box 3"  
  
**Footer:**  
- "Su-Pu ID: SP-2026-0615-000247-V2"  
- "Recorded in 藏谱阁 · Orbace Sudoku"  
- Scoring Version: 1.0  
  
### 7.3 Certificate Visual Design  
  
```  
┌─────────────────────────────────────────────────────────┐  
│                                                          │  
│              Orbace Sudoku                               │  
│              一 局 成 績                                  │  
│                                                          │  
│                    [精深]                                │  
│              (Vermilion seal)                            │  
│                                                          │  
│              ═══════════════                              │  
│                                                          │  
│                 ⭐ 14,400                                │  
│              正谱 · Official                              │  
│              净谱 · Clean Solve                          │  
│                                                          │  
│              ═══════════════                              │  
│                                                          │  
│  Puzzle      精深 #247                                   │  
│  Pack        Solar Terms · 立夏                          │  
│  Date        June 15, 2026                               │  
│  Time        4:32                                        │  
│  Steps       34                                          │  
│  Errors      0                                           │  
│  Hints       0                                           │  
│                                                          │  
│  Techniques  NS×18  HS×8  NP×5  PP×3                    │  
│                                                          │  
│  ─────────────────────────────────────                   │  
│                                                          │  
│  Score Breakdown:                                        │  
│  Base (Expert)      16,000                               │  
│  Accuracy            ×0.90                               │  
│  Bonuses                +0                               │  
│  Final              14,400                               │  
│                                                          │  
│  ─────────────────────────────────────                   │  
│                                                          │  
│  Player Rating  4.2 / 5.0 — Challenging                  │  
│  谱评: "Got stuck on the Hidden Pair in Box 3"           │  
│                                                          │  
│  ═══════════════════════════════════                      │  
│  Su-Pu: SP-2026-0615-000247-V2                           │  
│  Recorded in 藏谱阁                                       │  
│  Orbace Sudoku · Scoring v1.0                             │  
│                                                          │  
└─────────────────────────────────────────────────────────┘  
```  
  
### 7.4 Certificate Generation & Sharing  
  
| Action | Behavior |  
|--------|----------|  
| View Certificate | Generated on-demand from Su-Pu data. Not persisted unless saved. |  
| Save Certificate | Renders PNG, stores in app-local documents. Path saved to Su-Pu record. |  
| Share Certificate | Renders PNG, opens platform share sheet. User chooses destination. |  
| Save to Photos | Explicit separate action requiring photo library permission. Deferred post-MVP unless UAT demands it. |  
  
Sharing uses `share_plus` for the platform share sheet. Image generation uses `RepaintBoundary` on a Flutter widget rendered off-screen.  
  
---  
  
## 8. Chuán Pǔ (传谱) — Su-Pu Sharing  
  
### 8.1 The Vision (Post-MVP)  
  
A shared Su-Pu is not a static image. It is a **replayable solve record** that the recipient can watch move-by-move. This is the difference between sharing a result and sharing a solve.  
  
### 8.2 MVP: Certificate Sharing  
  
V1 shares the certificate image via platform share sheet. This is functional and immediately useful.  
  
### 8.3 Post-MVP: Replayable Su-Pu Sharing  
  
- Su-Pu serialized to compact format (JSON with move sequence + metadata)  
- Shared via deep link: `orbace://supu/SP-2026-0615-000247-V2`  
- Recipient with Orbace installed: opens directly in app, can 复盘 full solve  
- Recipient without Orbace: opens web-based replay viewer  
- Shared Su-Pu includes: player name (if public), score, technique summary  
- Su-Pu can be marked public/private  
  
### 8.4 Share Card Preview  
  
```  
┌─────────────────────────────────────────────┐  
│                                              │  
│         📜 Su-Pu · 精深 #247                 │  
│                                              │  
│         ⭐ 14,400  ·  正谱 Official           │  
│         34 steps  ·  4:32                    │  
│                                              │  
│         [Mini board showing final state]     │  
│                                              │  
│         Techniques: NS×18 HS×8 NP×5 PP×3    │  
│                                              │  
│         Recorded by: PlayerName              │  
│         June 15, 2026                        │  
│                                              │  
│         [复盘 Replay in Orbace Sudoku]       │  
│                                              │  
└─────────────────────────────────────────────┘  
```  
  
---  
  
## 9. Míng Pǔ (名谱) — Leaderboard Integration  
  
### 9.1 Per-Puzzle Leaderboards  
  
Each official puzzle has its own 名谱榜 (Míng Pǔ Bǎng) — a leaderboard of the best Su-Pu:  
  
```  
┌─────────────────────────────────────────────────────────────┐  
│          精深 #247 · Míng Pǔ Bǎng · 名谱榜                    │  
│                                                              │  
│  🥇 Player_Wang     14,800  ·  38 steps  ·  3:58  ·  净谱  │  
│  🥈 Player_Chen     14,400  ·  34 steps  ·  4:32  ·  净谱  │  
│  🥉 Player_Liu      13,900  ·  41 steps  ·  5:10  ·  净谱  │  
│  4  Player_Zhang    13,200  ·  47 steps  ·  6:05  ·  1 err │  
│  5  You             12,800  ·  52 steps  ·  7:15  ·  3 err │  
│  ...                                                         │  
│  42 Your_v2         14,400  ·  34 steps  ·  4:32  ·  净谱  │  
│                                                              │  
│  [View Your Su-Pu]  [复盘 #1]  [对谱 Compare with #1]       │  
└─────────────────────────────────────────────────────────────┘  
```  
  
### 9.2 Ranking Rules  
  
- Compare only same `puzzleId` or `challengeId`  
- Compare only same `scoringVersion`  
- Accept only `official` (正谱) class Su-Pu  
- Exclude retries (重修谱)  
- Exclude Su-Pu with T3 hints (reveals)  
- Exclude Su-Pu with auto-check or mistake reveal enabled  
- Validate replay hash against move sequence  
- Validate puzzle checksum against official puzzle data  
  
### 9.3 Leaderboard Types  
  
| Type | Chinese | Scope | MVP Status |  
|------|---------|-------|------------|  
| Puzzle 名谱榜 | 题名谱榜 | Single puzzle, all time | Local MVP (on-device) |  
| Daily 名谱榜 | 日名谱榜 | Today's daily puzzle | Local MVP |  
| Weekly 名谱榜 | 周名谱榜 | Aggregate best 5 | Post-MVP |  
| Seasonal 名谱榜 | 季名谱榜 | Quarterly competition | Post-MVP |  
| Friend 名谱榜 | 友名谱榜 | Among connected players | Post-MVP |  
| Worldwide 名谱榜 | 世界名谱榜 | Cross-platform | Phase 3 backend |  
  
---  
  
## 10. Player Difficulty Rating  
  
### 10.1 Purpose  
  
Player difficulty rating captures subjective experience. It serves three purposes:  
  
1. **Personal record**: How did this puzzle feel to you?  
2. **Community signal**: Aggregated ratings reveal perceived vs. solver-rated difficulty  
3. **Curation**: Helps Orbace identify puzzles where solver rating and player experience diverge  
  
It does not affect official score.  
  
### 10.2 Scale  
  
| Range | Label |  
|-------|-------|  
| 1.0–1.9 | Gentle (轻松) |  
| 2.0–2.9 | Steady (平稳) |  
| 3.0–3.9 | Challenging (挑战) |  
| 4.0–4.6 | Hard (困难) |  
| 4.7–5.0 | Extreme (极限) |  
  
0.1 precision. Optional input on completion screen.  
  
### 10.3 Storage  
  
Per Su-Pu:  
- `playerDifficultyRating` (real, nullable)  
- `playerDifficultyRatedAt` (datetime, nullable)  
  
Post-MVP aggregation:  
- Community perceived difficulty per puzzle  
- Solver difficulty vs. player-perceived difficulty comparison  
- "This puzzle is rated Hard by the solver, but players find it Extreme"  
  
---  
  
## 11. Score Fairness Model  
  
### 11.1 Fairness Principles  
  
| Principle | Requirement |  
|-----------|-------------|  
| Deterministic | Same puzzle + same performance inputs = same score |  
| Versioned | Every Su-Pu stores `scoringVersion` |  
| Puzzle-specific | Rankings compare Su-Pu within the same puzzle/challenge |  
| Accuracy-dominant | Mistakes and hints matter more than raw speed |  
| Assist-aware | Hints, auto-check, mistake reveal, and retries affect eligibility |  
| Tamper-aware | Future leaderboard submission can validate score inputs against replay |  
| Explainable | Score card shows why the player earned the score |  
  
### 11.2 Score Classes  
  
| Class | Chinese | Eligibility |  
|-------|---------|-------------|  
| `official` | 正谱 | First completion, no T3 hints, no retry, puzzle eligible, scoring version current |  
| `practice` | 习谱 | Used hints or assist features |  
| `retry` | 重修谱 | Retry attempt |  
| `legacy` | 旧谱 | Old scoring version |  
  
### 11.3 Best Score Logic  
  
For each puzzle:  
  
- Personal best can include practice attempts if clearly labeled  
- Official best must include only 正谱 attempts  
- Future leaderboard should use 正谱 only  
  
Recommended UI labels:  
  
- Best Official (最佳正谱)  
- Best Practice (最佳习谱)  
- Latest Su-Pu (最新数谱)  
  
---  
  
## 12. Data Storage Plan  
  
### 12.1 Schema (Drift, Version 2)  
  
Extend `AttemptRows` to support Su-Pu:  
  
| Column | Type | Purpose |  
|--------|------|---------|  
| `id` | text | Su-Pu unique ID (SP-YYYY-MMDD-PUZZLEID-V#) |  
| `puzzle_id` | text | FK to puzzle |  
| `su_pu_class` | text | `official`, `practice`, `retry`, `legacy` |  
| `attempt_number` | int | 1, 2, 3... for this puzzle |  
| `parent_su_pu_id` | text nullable | FK to previous Su-Pu (for retries) |  
| `elapsed_seconds` | int | |  
| `error_count` | int | |  
| `hint_nudge_count` | int | Tier 1 hints |  
| `hint_explanation_count` | int | Tier 2 hints |  
| `hint_reveal_count` | int | Tier 3 hints |  
| `auto_check_enabled` | bool | |  
| `mistake_reveal_enabled` | bool | |  
| `completed` | bool | |  
| `clean_solve` | bool | 净谱: zero errors, zero hints |  
| `ranked_eligible` | bool | |  
| `score_total` | int | |  
| `score_breakdown_json` | text | Full breakdown |  
| `scoring_version` | int | |  
| `move_history_json` | text | Full move sequence |  
| `technique_counts_json` | text | Technique profile |  
| `total_steps` | int | |  
| `efficiency_ratio` | real | |  
| `player_difficulty_rating` | real nullable | 1.0–5.0 |  
| `player_difficulty_rated_at` | datetime nullable | |  
| `player_notes` | text nullable | 谱评 |  
| `player_tags_json` | text nullable | |  
| `is_favorite` | bool | 珍藏谱 |  
| `replay_hash` | text nullable | Integrity hash |  
| `puzzle_checksum` | text nullable | Puzzle integrity hash |  
| `content_version` | text nullable | |  
| `certificate_image_path` | text nullable | |  
| `certificate_generated_at` | datetime nullable | |  
| `started_at` | datetime | |  
| `completed_at` | datetime nullable | |  
  
### 12.2 Storage Management  
  
- Move history JSON: compact, ~2-5KB per Su-Pu  
- 10,000 Su-Pu ≈ 20-50MB for move data (manageable)  
- Certificate images: generated only on explicit save/share  
- No automatic image generation  
- Future: storage management settings (delete old Su-Pu, clear certificates)  
  
### 12.3 Data Retention  
  
- All Su-Pu kept by default  
- Player can delete individual Su-Pu  
- Player can clear certificate images without deleting Su-Pu  
- Future: export all Su-Pu data, import on new device  
- Cloud sync post-MVP  
  
---  
  
## 13. Implementation Plan  
  
### Phase 1: Su-Pu Data Foundation (Week 1-2)  
  
**Prerequisite**: Schema V2 migration  
  
**Tasks:**  
- Implement Su-Pu domain model  
- Add Su-Pu class enum and classification logic  
- Auto-classify at completion: `official` (正谱) | `practice` (习谱) | `retry` (重修谱) | `legacy` (旧谱)  
- Compute and store replay hash and puzzle checksum  
- Add parent Su-Pu ID for retry linking  
- Add favorite flag (珍藏谱), player notes (谱评), player tags fields  
- Add player difficulty rating field  
- Add certificate image path field  
- Repository methods:  
  - `allCompletedSuPu()`  
  - `suPuForPuzzle(puzzleId)` — all versions  
  - `bestOfficialSuPu(puzzleId)` (最佳正谱)  
  - `bestOverallSuPu(puzzleId)`  
  - `toggleFavorite(suPuId)` (珍藏谱)  
  - `updatePlayerRating(suPuId, rating)`  
  - `updatePlayerNotes(suPuId, notes)` (谱评)  
- Unit tests for classification, versioning, repository  
  
**Exit criteria:**  
- Every completed puzzle auto-saves as a Su-Pu with correct class  
- Multiple attempts on same puzzle create versioned Su-Pu  
- Favorites, notes, ratings persist and reload  
  
### Phase 2: Cáng Pǔ Gé — Record Hall (Week 3-4)  
  
**Tasks:**  
- Build 藏谱阁 screen with collection header stats  
- Group Su-Pu by puzzle with version indicators  
- Show best official (最佳正谱) and best overall per puzzle  
- Show improvement deltas between versions  
- Implement filter views: All (全部), Official (正谱), Clean (净谱), Favorites (珍藏), In Progress (残谱)  
- Implement difficulty and date filters  
- Build puzzle collection view (all Su-Pu for one puzzle)  
- Build single Su-Pu detail view  
- Favorite toggle (珍藏谱) from detail and list  
- Player notes entry (谱评) from detail view  
- Entry points: Home, Completion Screen, Scholar's Path  
- Empty state: "Your collection begins with your first Su-Pu"  
  
**Exit criteria:**  
- 藏谱阁 displays all Su-Pu grouped by puzzle  
- Multiple versions visible and distinguishable  
- Favorites filter works  
- Collection stats accurate  
  
### Phase 3: 复盘 & 对谱 — Replay & Comparison (Week 5-6)  
  
**Tasks:**  
- 复盘 viewer: animated board playback, step list, speed controls  
- Su-Pu detail view: score breakdown, technique profile, metadata  
- Version timeline on detail view (all Su-Pu for this puzzle)  
- Player difficulty rating input on completion and detail  
- 谱评 (player notes) input on detail  
- 对谱 (comparison) view:  
  - Side-by-side replay with synchronized playback  
  - Divergence point detection and display  
  - Score delta and technique comparison  
- 重解 (Retry) action from detail and collection views  
- Certificate placeholder on detail view  
  
**Exit criteria:**  
- Su-Pu detail shows all metadata correctly  
- 复盘 plays back Su-Pu accurately  
- Two Su-Pu can be compared via 对谱  
- Divergence points identified  
- 重解 creates properly versioned new Su-Pu  
  
### Phase 4: Score Certificate (Week 7-8)  
  
**Tasks:**  
- Certificate widget with full Orbace branding  
- Rice-paper background, vermilion seal, ink typography  
- All required content: score, class (正谱/习谱/重修谱), breakdown, techniques, player input  
- 净谱 marker when applicable  
- Su-Pu ID in footer  
- Render certificate to PNG via RepaintBoundary  
- Share via platform share sheet (share_plus)  
- Save to app-local documents  
- Store image path in Su-Pu record  
- Regenerate on demand if image missing  
- Certificate accessible from: completion screen, Su-Pu detail, 藏谱阁  
  
**Exit criteria:**  
- Certificate renders correctly on iPhone and iPad  
- Share opens native share sheet  
- Saved certificate reloads after app restart  
- Certificate includes all Su-Pu metadata  
  
### Phase 5: 名谱榜 & Polish (Week 9-10)  
  
**Tasks:**  
- Per-puzzle local 名谱榜 (on-device ranking)  
- 正谱 only for ranked display  
- Best 正谱 per puzzle highlighted  
- Ranking rules enforced (same puzzle, same scoring version, 正谱 only)  
- 名谱榜 accessible from puzzle collection view  
- "复盘 Best" from 名谱榜  
- Collection stats enhancements  
- Accessibility pass on all Su-Pu screens  
- Empty states and error states  
  
**Exit criteria:**  
- Local 名谱榜 ranks 正谱 correctly  
- 习谱 and 重修谱 excluded from ranking  
- All Su-Pu screens pass accessibility validation  
  
---  
  
## 14. UAT Test Cases  
  
### Su-Pu Creation & Classification  
- Complete puzzle with no assists → Su-Pu saved as 正谱 (official)  
- Complete puzzle with hints → Su-Pu saved as 习谱 (practice)  
- 重解 puzzle → Su-Pu saved as 重修谱 (retry) with parent link  
- Verify replay hash and puzzle checksum stored  
  
### 藏谱阁 (Record Hall)  
- Open Record Hall → all Su-Pu visible, grouped by puzzle  
- Complete 3 attempts on same puzzle → 3 versions visible  
- Toggle 珍藏 (favorite) → appears in 珍藏谱 filter  
- Delete Su-Pu → removed from collection  
- Collection stats accurate after multiple solves  
  
### 复盘 (Replay) & 对谱 (Compare)  
- 复盘 a Su-Pu → playback smooth, step list accurate  
- 对谱 two Su-Pu → synchronized playback, divergences shown  
- Replay does not create new Su-Pu  
- Replay does not affect scores  
  
### 重解 (Retry)  
- 重解 from detail → new Su-Pu with 重修谱 class  
- Parent Su-Pu ID linked correctly  
- Improvement delta shown  
- 重修谱 not ranked  
  
### Score Certificate  
- View certificate → all data matches Su-Pu  
- Share certificate → native share sheet opens  
- 净谱 marker appears for clean solves  
- Su-Pu ID present in footer  
  
### 名谱榜 (Leaderboard Readiness)  
- 正谱 appear on local 名谱榜  
- 习谱 and 重修谱 excluded from ranking  
- Same puzzle, different players → ranked correctly  
- Scoring version mismatch → excluded  
  
---  
  
## 15. What Su-Pu Unlocks  
  
### 15.1 For the Player  
  
| Before (Standard) | After (Su-Pu) |  
|-------------------|---------------|  
| "I solved puzzle #247" | "I created a Su-Pu of #247. It's in my 藏谱阁." |  
| Stats screen shows numbers | 藏谱阁 shows a body of work |  
| Replay is a feature I might use | 复盘 is studying my own Su-Pu |  
| I completed the puzzle | I have 3 Su-Pu for this puzzle, each better |  
| I shared a screenshot | I shared a Su-Pu — a replayable solve record |  
  
### 15.2 For the Product  
  
| Capability | Su-Pu Foundation |  
|------------|-----------------|  
| 复盘 (Replay) | Su-Pu is the replayable object |  
| Scoring | Su-Pu carries the score |  
| 对谱 (Comparison) | Su-Pu can be compared side-by-side |  
| 传谱 (Sharing) | Su-Pu can be transmitted |  
| 名谱榜 (Leaderboards) | 名谱 are top-ranked Su-Pu |  
| Learning | Study 名谱 to improve your own Su-Pu |  
| Retention | Your Su-Pu collection is your Sudoku identity |  
| Community | Su-Pu exchange creates culture |  
  
---  
  
## 16. Recommendation  
  
Proceed with implementation in this order:  
  
1. **Phase 1**: Su-Pu data foundation (schema, classification, repository)  
2. **Phase 2**: 藏谱阁 (collection UI, grouping, filters)  
3. **Phase 3**: 复盘 and 对谱 (replay and comparison)  
4. **Phase 4**: Score certificate generation and sharing  
5. **Phase 5**: 名谱榜 (local leaderboard) and polish  
  
This order prioritizes data integrity first, then collection experience, then replay and comparison (the learning engine), then sharing (the growth engine), then ranking (the competitive layer).  
  
The Su-Pu (数谱) concept transforms what would otherwise be separate features into a single, coherent, culturally-resonant system that players can understand, value, and invest in. Every solve becomes a Su-Pu. Every Su-Pu has a home in the Record Hall (藏谱阁). Every Su-Pu can be replayed (复盘), compared (对谱), annotated (谱评), shared (传谱), and improved upon (重解).  
  
