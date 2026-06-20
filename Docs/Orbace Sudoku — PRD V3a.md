# Orbace Sudoku — Product Requirements Document  
  
**Version**: 3.0    
**Date**: 2026-06-20    
**Platform**: Flutter for iOS and Android    
**Status**: Finalized for implementation planning    
**Supersedes**: V0.5 (teaching + cultural focus), V2.0 (expert features + ranked integrity)  
  
---  
  
## Document Heritage  
  
V3 synthesizes two prior versions:  
  
| Source | Strengths Adopted | Weaknesses Addressed |  
|--------|-------------------|---------------------|  
| **V0.5 (Teaching + Cultural)** | Three-tier hint system, human-ranked solver, cultural design layer, Scholar's Path, calm design constraints | Expert features underdeveloped, no ranked integrity framework, additive scoring untested |  
| **V2.0 (Expert + Ranked)** | Attempt-based data model, ranked eligibility flags, phased leaderboard strategy, anti-cheat framework, monetization prohibitions, puzzle metadata enrichment | Hint system weakened to two tiers, cultural differentiation removed, scoring formula time-dominant, replay conflates review with retry, awards lack progression structure, calm lacks specific constraints |  
  
---  
  
## 1. Executive Summary  
  
Orbace Sudoku is a cross-platform Flutter Sudoku game that occupies an unserved position: **the teaching depth of Good Sudoku, the calm accessibility that mass-market apps fail to deliver, and a fair competitive layer for players who seek mastery.**  
  
The base game is classic 9x9 Sudoku. The differentiation is not the rules — it is everything around them.  
  
**Core promise:**  
  
> Open the app to a calm, beautiful board with no interruptions. Receive hints that teach logical techniques, not just reveal answers. Track your growth through replay, transparent scoring, and a structured award journey. For those ready, unlock fair Extreme challenges where ranked play has integrity.  
  
**Three strategic pillars:**  
  
1. **Teach** — Three-tier hints explain technique logic. A human-ranked solver ensures every puzzle is solvable through understanding, not guessing.  
2. **Calm** — No ads during active play. Timer off by default. Design constraints enforce focus-respecting interaction. Cultural themes create emotional distinction.  
3. **Master** — Replay, transparent scoring, staged awards, and a gated Extreme mode with integrity-verified leaderboards for players who want to prove skill.  
  
Few competitors deliver this combination, and none reviewed position the full set as a cross-platform freemium product with calm defaults, teaching, replay, scoring, awards, and ranked integrity together.  
  
---  
  
## 2. Competitive Landscape  
  
### 2.1 Market Structure  
  
| Segment | Examples | Monetization | Core Weakness |  
|---------|----------|--------------|---------------|  
| Mass-Market Free | Sudoku.com (Easybrain) | Heavy ads, IAP | Interruptions destroy focus; hints don't teach |  
| Premium Indie | Good Sudoku (Zach Gage) | Paid / premium-positioned | iOS only; limited progression; no broad competitive layer |  
| Utility/Power User | Andoku 3 | Free/ads | Feature-heavy but emotionally flat; no teaching |  
| Casual Game | Sudoku Quest | IAP/lives | Mechanics distract from solving |  
  
### 2.2 Orbace Sudoku's Position  
  
| Attribute | Market Best | Orbace V3 |  
|-----------|-------------|-----------|  
| Teaching hints | Good Sudoku (iOS, premium-positioned) | Cross-platform, freemium, three-tier with technique names in English and Chinese |  
| Calm experience | Good Sudoku (premium-positioned) | Freemium with strict no-active-play-ad rules |  
| Structured progression | None | Level packs with seal collection + staged Scholar's Path awards |  
| Cultural identity | None | Ink Wash themes, seal completions, Tea Moment, Scholar's Path naming |  
| Replay | Under-positioned in mobile Sudoku | Full step-by-step replay with optimal path comparison |  
| Transparent scoring | Brainium (partial) | Full breakdown; accuracy-weighted; time as optional bonus only |  
| Ranked play with integrity | None | Gated Extreme mode; ranked eligibility flags; phased leaderboards |  
| Cross-platform | Sudoku.com (ad-heavy) | Flutter: iOS + Android from launch |  
  
### 2.3 Competitive Intelligence  
  
**Sudoku.com (Easybrain)**: Proves mass-market demand. Their users tolerate ads; they don't prefer them. Hints reveal cells without explanation. No replay, no meaningful scoring. Orbace competes on respect, not volume.  
  
**Good Sudoku (Zach Gage)**: The quality ceiling for teaching and board feel. iOS-only and premium-positioned, with less emphasis on staged progression and broad competitive systems. Orbace uses the same seriousness about hint quality while extending the concept across platforms with progression, awards, and an opt-in mastery layer.  
  
**Andoku 3**: Feature benchmark for variants. Orbace defers variants to post-MVP. Win on emotional experience, not feature count.  
  
**Brainium Sudoku**: Strongest learning + scoring combination in market. Orbace must exceed on input reliability, ranked fairness, and ad-free calm.  
  
**Cracking the Cryptic**: Proves market for "Sudoku as craft." Orbace's themed packs and Scholar's Path can achieve similar perceived value through cultural resonance.  
  
### 2.4 Competitive Risk Register  
  
| Risk | Severity | Mitigation |  
|------|----------|------------|  
| Good Sudoku adds Android + competitive | Medium | Premium positioning limits reach; Orbace's freemium + progression serves different audience |  
| Sudoku.com improves hints | Medium | Ad-revenue model disincentivizes features that extend session time |  
| Market dismisses as "another Sudoku app" | High | Differentiation visible in first 5 seconds: cultural aesthetic, no ad banner, calm typography |  
| AI-powered Sudoku apps emerge | Low-Medium | LLMs unreliable for deterministic logic; technique-based hints are verifiably correct |  
| "Calm" reads as "boring" | Medium | Satisfying haptics, seal animations, and completion delight deliver emotion without noise |  
  
---  
  
## 3. Product Goals  
  
1. Deliver a polished, cross-platform Sudoku game in Flutter for iOS and Android.  
2. Provide three-tier teaching hints that name techniques and explain logical reasoning.  
3. Ship 1,800 solver-validated puzzles with pre-computed human-logic solve paths.  
4. Build fair difficulty progression from Beginner through Expert.  
5. Differentiate through replay, transparent accuracy-weighted scoring, staged awards, and gated Extreme challenges.  
6. Create a calm default experience with competitive features as opt-in only.  
7. Embed cultural design cues (themes, seals, naming, daily ritual) for emotional and visual distinctiveness.  
8. Maintain codebase readiness for variants, monetization, and worldwide backend.  
  
---  
  
## 4. Target Audiences  
  
### 4.1 Primary: Calm Casual Players  
  
- Adult puzzle players seeking short, satisfying, uninterrupted sessions  
- Users who dislike aggressive ads, forced timers, and guilt mechanics  
- Players who appreciate beautiful, culturally distinctive design  
  
### 4.2 Secondary: Growth-Minded Learners  
  
- Beginners needing tutorials and forgiving onboarding  
- Intermediate players wanting to progress from Easy to Hard  
- Players who value hints that explain "why," not just reveal "what"  
  
### 4.3 Tertiary: Mastery Seekers (Opt-In)  
  
- Advanced players demanding validated logical solvability (no guessing)  
- Competitive players wanting transparent scoring, awards, and fair leaderboards  
- Expert users who replay solves to analyze and improve  
- Players seeking gated Extreme challenges with ranked integrity  
  
### 4.4 Audience Compatibility Principle  
  
**The calm path is the default path.** Timer is off. Scoring is shown but not pressured. Leaderboards are behind an unlock gate. A player who never engages with mastery features should never feel their absence as a deficiency. Competition is a door the player chooses to open.  
  
---  
  
## 5. Differentiation Strategy  
  
### 5.1 Positioning Statement  
  
> Orbace Sudoku is the calm app that teaches you to solve better — and for those who seek it, proves how good you've become.  
  
### 5.2 Differentiation Pillars  
  
| Pillar | Product Behavior | MVP Priority |  
|--------|-----------------|--------------|  
| **Teaching hints** | Three-tier: nudge → technique explanation → reveal. Human-ranked solver names the logical technique | High |  
| **Fair difficulty** | Every puzzle solver-validated with pre-computed human-logic solve path. No guessing required | High |  
| **Calm by design** | No active-play ads. Timer off by default. Design constraints enforce focus-respecting interaction | High |  
| **Replayable improvement** | View past solves. Compare to optimal path. Explicit retry to improve | High |  
| **Transparent scoring** | Accuracy-weighted breakdown shown after every solve. Speed is optional bonus only | High |  
| **Staged awards** | Scholar's Path progression gates Extreme content behind demonstrated skill | High |  
| **Ranked integrity** | Ranked eligibility flags per attempt. Only official challenges count. Assisted solves excluded | Medium |  
| **Cultural identity** | Ink Wash themes, seal completions, Tea Moment, Scholar's Path naming, Solar Terms packs | High |  
| **Cross-platform reach** | Flutter: iOS + Android from launch. Platform-native leaderboards Phase 2 | High |  
  
### 5.3 Cultural Design Layer  
  
Cultural differentiation is a design layer applied to existing features, not a separate feature set:  
  
| Layer | Implementation | User Impact |  
|-------|---------------|-------------|  
| **Board themes** | Ink Wash (水墨, default), Celadon (青瓷, unlockable), Vermilion Seal highlights | Visual distinctiveness in first 5 seconds; all themes maintain cell readability |  
| **Completion ritual** | Difficulty seal stamps (入門, 小成, 貫通, 精深, 入神) replace generic checkmarks | Collectible, culturally resonant accomplishment markers |  
| **Daily puzzle** | "Tea Moment" framing: "一局一茶" (One puzzle, one tea). Timer off by default. Streak counts presence | Contrasts with anxiety-driven daily streaks in competitor apps |  
| **Difficulty naming** | 入門, 小成, 貫通, 精深, 入神, 極致 — traditional learning progression | Feels distinguished, not translated |  
| **Technique names** | Standard Chinese Sudoku community terms: 唯一候選數, 隱性唯一, 數對, etc. | Authentic to Chinese-speaking Sudoku communities |  
| **Award system** | Scholar's Path (學者之路): Foundation → Discipline → Insight → Mastery | Gating framed as learning journey, not grind |  
| **Content packs** | Twenty-Four Solar Terms (二十四節氣) seasonal packs | Natural content calendar, culturally rich |  
  
### 5.4 Calm Design Constraints  
  
"Calm" is operationalized as specific, testable design rules:  
  
| Rule | Specification |  
|------|---------------|  
| Timer default | Off. Player must actively enable per session or in settings |  
| Error display | Gentle cell highlight in accent color. Never red flash, screen shake, or negative sound |  
| Completion flow | Seal animation first. Score presented as information, not judgment. No "TIME'S UP" messaging |  
| Streak tracking | Counts days present, not consecutive completions. No "streak broken" warnings |  
| Animations | 200ms ease-out maximum. Never bouncy, spring-loaded, or urgent |  
| Sound | Ambient only, off by default. No alert sounds |  
| Haptics | Subtle cell-selection click only. Optional. Off by default |  
| Pop-ups | None during active board state except pause menu |  
| Urgency mechanics | None unless player explicitly enables timer |  
| Ad interruptions | Zero during active gameplay. Post-completion only if ad model is active |  
| Color semantics | Color never the sole indicator of state. Shape and position reinforce all signals |  
  
### 5.5 What We Do Not Differentiate On  
  
- ❌ Unique Sudoku rules  
- ❌ "Thousands of levels" as lead message  
- ❌ Heavy animations  
- ❌ Aggressive streak pressure  
- ❌ Variant quantity over core quality  
- ❌ Raw time leaderboards that incentivize guessing  
- ❌ Pay-to-compete mechanics  
  
---  
  
## 6. Core MVP Scope  
  
### 6.1 Must Deliver  
  
**Gameplay Engine:**  
- Classic 9x9 Sudoku gameplay  
- Puzzle generator with unique-solution validator  
- Human-ranked solver implementing five techniques: Naked Single, Hidden Single, Naked Pair, Hidden Pair, Pointing Pair  
- Pre-computed human-logic solve paths stored with every shipped puzzle  
- Difficulty tiers: Beginner (入門), Easy (小成), Medium (貫通), Hard (精深), Expert (入神)  
- Quality gate: reject any puzzle not fully solvable with implemented techniques  
  
**Hint System (Three-Tier):**  
- Tier 1: Gentle nudge — highlights target cell, suggests observation  
- Tier 2: Technique explanation — names the logical technique, highlights reasoning cells with animated sequence, explains the deduction  
- Tier 3: Reveal value — last resort, fills the cell  
- Progressive escalation per cell per session  
- Lantern icon (culturally resonant, not generic lightbulb)  
- Technique names in English and Chinese  
  
**Board Interaction:**  
- Tap cell to select; highlights row, column, box, matching numbers  
- Number pad input with theme accent  
- Notes/pencil mode toggle (single tap pencil icon)  
- Undo and redo with full move history  
- Erase function  
- Auto-remove notes after correct value placement  
- Given numbers visually distinct from player-entered (weight, color)  
- Completed house subtle satisfaction feedback  
  
**Assistance & Settings:**  
- Mistake checking: optional, off by default for Beginner/Easy  
- Timer: off by default, player-enabled  
- Pause and resume  
- Completion detection and state  
  
**Replay System:**  
- View replay of any completed attempt (read-only, no score impact)  
- Play/pause/skip/speed controls  
- Step list with technique labels and timestamps  
- Optimal path comparison (player's solve vs. pre-computed optimal)  
- Explicit "Retry this puzzle" action creates new attempt; flagged as retry  
  
**Scoring System:**  
- Solve Quality Score calculated after every completion  
- Transparent breakdown showing all components  
- Accuracy-weighted formula: difficulty-dominant, time as optional bonus  
- Personal best tracking per difficulty  
- Ranked eligibility flags stored per attempt  
  
**Award System:**  
- Scholar's Path staged progression:  
  - Stage 1: Foundation (基礎) — unlocks Hard mastery goals and advanced scoring badges  
  - Stage 2: Discipline (自律) — unlocks Expert mastery goals  
  - Stage 3: Insight (悟性) — unlocks local Extreme Challenge  
- Each stage has clear, skill-based requirements  
- Award progress visible on dedicated screen  
- Seal collection view  
  
**Extreme Challenge (Locked):**  
- Locked entry point visible from launch with unlock requirements displayed  
- Extreme unlocks after Stage 3 (Insight) completion  
- Curated local Extreme puzzle set (separate from standard level library)  
- No-assist rules: hints disabled for ranked score, auto-check disabled for ranked score  
- Ranked eligibility automatically determined per attempt  
- Local Extreme bests board  
  
**Level Content:**  
- Local level packs with difficulty tabs  
- Per-level completion seals  
- Pack progress indicators  
- Daily puzzle ("Tea Moment" framing)  
- First Solar Terms pack (24 puzzles, mixed difficulty)  
- Target: 1,800 shipped levels (Beginner: 200, Easy: 300, Medium: 500, Hard: 500, Expert: 300)  
  
**Presentation:**  
- Ink Wash theme (default)  
- Celadon theme (unlockable)  
- Completion seal with difficulty character  
- Large tappable cells (minimum 44×44pt touch targets)  
- High-contrast board option  
  
**Technical:**  
- Flutter for iOS and Android  
- Offline play  
- Local progress and attempt history persistence  
- Progress survives app restart and updates  
  
### 6.2 Should Deliver  
  
**Learning:**  
- Guided first-time tutorial (single Beginner puzzle, step-by-step with technique instruction)  
- Technique names visible in Tier 2 hints (English and Chinese)  
- Completion screen shows technique breakdown used in solve  
- Clean-solve badge (zero errors, zero hints)  
  
**Scoring & Stats:**  
- Percentile comparison (local, based on stored scores)  
- Streak tracking (days present, not consecutive completions)  
- Best score and best time per difficulty  
- Attempt history per puzzle  
  
**Replay Enhancement:**  
- Replay attempt comparison ("Solved 2:14 faster," "First clean solve")  
- Positive improvement messaging  
  
**Themes & Feel:**  
- Haptics: subtle cell selection and completion feedback (optional, off by default)  
- Sound: ambient only, optional, off by default  
- Accessibility: screen-reader labels for all cells, givens, notes, and values  
  
**Content:**  
- Error limit option  
  
### 6.3 Defer (Post-MVP)  
  
**Platform Competition (Post-MVP Phase 2):**  
- Game Center achievements and leaderboards (iOS)  
- Google Play Games achievements and leaderboards (Android)  
- Platform-specific Extreme daily/weekly rankings  
  
**Worldwide Competition (Post-MVP Phase 3):**  
- Orbace backend for cross-platform player identity  
- Server-issued challenge puzzle IDs  
- Ranked score submission with anti-cheat validation  
- Cross-platform weekly Extreme leaderboard  
- Anonymous or signed-in player profiles  
  
**Learning Expansion:**  
- Technique practice mode (puzzles filtered by dominant technique)  
- Fully animated explained hints with step-by-step cell highlighting  
- Post-game technique analysis with improvement suggestions  
  
**Content:**  
- Additional Solar Terms packs  
- Puzzle variants (4x4, 6x6, Killer Sudoku, Jigsaw Sudoku)  
- Premium puzzle packs  
- Daily challenge archive  
  
**Platform:**  
- Account system with cloud sync  
- Push notifications (gentle daily puzzle reminder, opt-in)  
- Share replay as video/GIF  
  
**Monetization:**  
- Remove-ads IAP  
- Premium puzzle packs  
- Theme packs  
- Rewarded hints for non-ranked casual play (opt-in, never during active board)  
  
---  
  
## 7. Hint System Architecture  
  
### 7.1 Design Philosophy  
  
Good Sudoku's three-tier approach is the benchmark. Orbace Sudoku matches it while adding pre-computed solve paths for deterministic quality and cultural framing (lantern icon, Chinese technique names).  
  
### 7.2 Three-Tier Escalation  
  
```  
Player taps lantern icon  
        │  
        ▼  
┌──────────────────────────────┐  
│ TIER 1: NUDGE                │  
│ "Take a look at this cell."  │  
│ Target cell pulses gently    │  
│ [Dismiss]  [More Help]       │  
└──────────────────────────────┘  
        │  
    More Help  
        ▼  
┌──────────────────────────────┐  
│ TIER 2: EXPLANATION          │  
│ "Naked Single (唯一候選數)    │  
│  Only 7 can go here because  │  
│  1,2,3,4,5,6,8,9 are already │  
│  in the row, column, or box."│  
│ Reasoning cells highlight    │  
│ in animated sequence         │  
│ [Dismiss]  [Show Answer]     │  
└──────────────────────────────┘  
        │  
    Show Answer  
        ▼  
┌──────────────────────────────┐  
│ TIER 3: REVEAL               │  
│ Cell fills with 7            │  
│ Brief dissolve animation     │  
└──────────────────────────────┘  
```  
  
### 7.3 Human-Ranked Solver  
  
The solver applies techniques in order of human-perceived difficulty, not algorithmic convenience:  
  
| Priority | Technique | Chinese Name | Human Difficulty |  
|----------|-----------|--------------|------------------|  
| 1 | Naked Single | 唯一候選數 | Easiest |  
| 2 | Hidden Single | 隱性唯一 | Easy |  
| 3 | Naked Pair | 數對 | Medium |  
| 4 | Hidden Pair | 隱性數對 | Hard |  
| 5 | Pointing Pair | 指向數對 | Hard |  
  
MVP implements five. Post-MVP extends to X-Wing, Swordfish, Forcing Chains for Expert/Extreme.  
  
### 7.4 Pre-Computed Hint Paths  
  
Every shipped puzzle stores its full optimal solve path as `List<StoredSolvingStep>`. During gameplay, hints are a database lookup, not a live solver run. This ensures:  
  
- Deterministic hint quality (tested before shipping)  
- No UI thread blocking  
- Consistent difficulty for all players  
- Instant replay data  
  
### 7.5 Technique Metadata  
  
```dart  
class TechniqueDefinition {  
  final String name;           // "Naked Single"  
  final String chineseName;    // "唯一候選數"  
  final String description;  
  final String explanationTemplate;  // "{number} is the only candidate because..."  
  final HighlightStrategy highlightStrategy;  
  final int difficultyLevel;  
}  
```  
  
### 7.6 Hint State Manager  
  
- Tracks hint tier per cell per session  
- Escalates: Tier 1 → Tier 2 → Tier 3 on repeated requests  
- Resets escalation if board state changes independently (player made own move)  
- Stores hint usage counts for scoring and attempt records  
  
---  
  
## 8. Scoring System  
  
### 8.1 Design Principles  
  
| Principle | Implementation |  
|-----------|---------------|  
| **Difficulty-dominant** | Base score scales exponentially with difficulty; accuracy multiplier determines final |  
| **Accuracy-weighted** | Errors and hints reduce a multiplier; clean solves earn full base |  
| **Speed is optional** | Time bonus only when timer enabled; capped at +10% of base |  
| **Stable** | Same performance produces same accuracy multiplier; streak does not affect per-puzzle score |  
| **Transparent** | Full breakdown shown on completion screen |  
  
### 8.2 Solve Quality Score Formula  
  
```  
Score = (BaseScore × AccuracyMultiplier) + OptionalBonuses  
  
BaseScore (by difficulty):  
  Beginner (入門):    1,000  
  Easy (小成):        2,000  
  Medium (貫通):      4,000  
  Hard (精深):        8,000  
  Expert (入神):     16,000  
  Extreme (極致):    32,000   (local MVP, ranked expansion post-MVP)  
  
AccuracyMultiplier:  
  Starts at 1.00  
  Per error:                   ×0.85  (compounds: 2 errors = 0.7225)  
  Per Tier 1 hint (nudge):     ×0.95  
  Per Tier 2 hint (explain):   ×0.85  
  Per Tier 3 hint (reveal):    ×0.70  
  Auto-check enabled:          ×0.85  
  Clamped to minimum:          0.10  
  
OptionalBonuses (applied only if relevant setting enabled):  
  Time bonus (timer ON only):  
    If ActualTime < TargetTime:  +10% × BaseScore × (1 - ActualTime/TargetTime)  
    Capped at +10% of BaseScore  
  Efficiency bonus:  
    If PlayerSteps ≤ OptimalSteps × 1.2: +5% × BaseScore  
  Clean solve bonus (zero errors, zero hints):  
    +5% × BaseScore  
```  
  
### 8.3 Score Examples  
  
| Scenario | Base | Accuracy | Bonuses | Final |  
|----------|------|----------|---------|-------|  
| Expert, 0 errors, 0 hints, timer off | 16,000 | ×1.00 | +800 (clean) | **16,800** |  
| Expert, 1 error, 0 hints, timer off | 16,000 | ×0.85 | — | **13,600** |  
| Expert, 0 errors, 1 nudge, timer off | 16,000 | ×0.95 | — | **15,200** |  
| Expert, 2 errors, 1 reveal, timer off | 16,000 | ×0.7225 ×0.70 | — | **8,092** |  
| Hard, 0 errors, 0 hints, timer on, fast | 8,000 | ×1.00 | +800 (time) +400 (clean) | **9,200** |  
| Medium, 0 errors, 0 hints, timer off | 4,000 | ×1.00 | +200 (clean) | **4,200** |  
| Beginner, 5 errors, 3 reveals | 1,000 | ×0.4437 ×0.343 | — | **152** |  
  
### 8.4 Completion Screen  
  
```  
┌───────────────────────────────────────────────┐  
│             PUZZLE COMPLETE                    │  
│                                                │  
│             [Seal: 精深]                       │  
│                                                │  
│           ⭐ Score: 13,600                      │  
│                                                │  
│  ┌────────────────────────────────────────┐   │  
│  │  Score Breakdown                       │   │  
│  │  Base (Expert):            16,000     │   │  
│  │  Accuracy Multiplier:       ×0.85     │   │  
│  │    - 1 error (-15%)                    │   │  
│  │  Bonuses:                       0     │   │  
│  │    Timer off, no time bonus            │   │  
│  │  ─────────────────────────────        │   │  
│  │  Final:                    13,600     │   │  
│  │                                        │   │  
│  │  🏆 Personal Best: 15,200              │   │  
│  │  📊 Clean Solve: Not this time         │   │  
│  └────────────────────────────────────────┘   │  
│                                                │  
│  ┌────────────────────────────────────────┐   │  
│  │  Techniques Used                       │   │  
│  │  ████████████ Naked Singles    12     │   │  
│  │  ██████ Hidden Singles         6     │   │  
│  │  ██ Naked Pairs                2     │   │  
│  └────────────────────────────────────────┘   │  
│                                                │  
│   [Next Puzzle]   [View Replay]   [Retry]      │  
└───────────────────────────────────────────────┘  
```  
  
### 8.5 Ranked Eligibility  
  
An attempt is marked `rankedEligible: true` only when ALL conditions are met:  
  
- Puzzle is an official challenge puzzle (`puzzle.rankedEligible == true`)  
- No hints used (any tier)  
- Auto-check disabled for entire session  
- Mistake reveal disabled for entire session  
- Puzzle completed (not abandoned)  
- Completion time within plausible bounds (server-validated post-MVP)  
- App version and scoring version accepted  
  
Ranked eligibility is immutable per attempt — set at completion, never changed.  
  
---  
  
## 9. Replay System  
  
### 9.1 Design Principles  
  
- **Viewing is consequence-free.** Watching a replay does not create a new attempt or affect scores.  
- **Retrying is explicit.** An explicit "Retry this puzzle" action creates a new attempt flagged as a retry.  
- **Improvement is celebrated.** Better scores on retry are acknowledged positively.  
- **Ranked integrity preserved.** Retry attempts are never ranked-eligible.  
  
### 9.2 Replay Viewer  
  
```  
┌───────────────────────────────────────────────────────────┐  
│                      REPLAY SCREEN                         │  
├───────────────────────────────────────────────────────────┤  
│                                                            │  
│  ┌───────────────────────────────────┐  ┌──────────────┐ │  
│  │                                   │  │  Move List   │ │  
│  │         BOARD REPLAY              │  │              │ │  
│  │         (animated)                │  │ 1. NS R5C3=7 │ │  
│  │                                   │  │ 2. HS C7R2=3 │ │  
│  │  Numbers appear in sequence       │  │ 3. NP B1     │ │  
│  │  Current step pulses              │  │ 4. NS R2C5=1 │ │  
│  │  Previous steps shown subtly      │  │ 5. HS C3R8=6 │ │  
│  │                                   │  │ ...          │ │  
│  └───────────────────────────────────┘  └──────────────┘ │  
│                                                            │  
│  ⏮   ⏪   ▶/⏸   ⏩   ⏭    Speed: 1x ▼    Mode: Player ▼  │  
│                                     (Player / Optimal)    │  
│  ┌───────────────────────────────────────────────────────┐ │  
│  │ Step 12/47: Naked Pair in Box 1                        │ │  
│  │ Eliminated candidates 3 and 7 from R1C1, R1C2          │ │  
│  │ ⏱ 0:42 into solve  │  🟢 Easy step                    │ │  
│  └───────────────────────────────────────────────────────┘ │  
└───────────────────────────────────────────────────────────┘  
```  
  
### 9.3 Replay vs. Retry  
  
| Action | Creates Attempt? | Affects Scores? | Ranked Eligible? |  
|--------|-----------------|-----------------|------------------|  
| View replay | No | No | N/A |  
| Retry puzzle | Yes (flagged `isRetry: true`) | Can update local best | Never |  
| First attempt | Yes (flagged `isRetry: false`) | Yes | Yes (if conditions met) |  
  
### 9.4 Attempt History Data  
  
```dart  
class SudokuAttempt {  
  final String id;  
  final String puzzleId;  
  final bool isRetry;  
  final int attemptNumber;           // 1 = first, 2 = first retry, etc.  
  final int elapsedSeconds;  
  final int errorCount;  
  final int hintNudgeCount;  
  final int hintExplanationCount;  
  final int hintRevealCount;  
  final bool autoCheckEnabled;  
  final bool mistakeRevealEnabled;  
  final bool completed;  
  final bool cleanSolve;             // zero errors AND zero hints  
  final bool rankedEligible;         // immutable, set at completion  
  final SudokuScore? score;  
  final List<SudokuMove> moveHistory;  
  final DateTime startedAt;  
  final DateTime? completedAt;  
}  
```  
  
---  
  
## 10. Award System: Scholar's Path (學者之路)  
  
### 10.1 Design Philosophy  
  
Awards are not a checklist. They are a staged journey that gates access to harder content behind demonstrated skill. Each stage requires specific achievements. Completion unlocks meaningful capability.  
  
### 10.2 Award Stages  
  
```  
┌─────────────────────────────────────────────────────────────┐  
│                 SCHOLAR'S PATH (學者之路)                     │  
├─────────────────────────────────────────────────────────────┤  
│                                                              │  
│  STAGE 1: FOUNDATION (基礎)                                  │  
│  ├─ Complete 10 Medium puzzles                               │  
│  ├─ Complete 3 Medium puzzles with 0 hints                   │  
│  ├─ Earn "First Clean Solve" award                           │  
│  ├─ Unlocks: "Steady Hand" seal                              │  
│  └─ Unlocks: Hard mastery goals and advanced scoring badges  │  
│                                                              │  
│  STAGE 2: DISCIPLINE (自律)                                  │  
│  ├─ Complete 20 Hard puzzles                                 │  
│  ├─ Complete 5 Hard puzzles with ≥80% accuracy               │  
│  ├─ Complete 3 Hard puzzles with 0 errors                    │  
│  ├─ Earn "Clean Solve" on Hard                               │  
│  ├─ Unlocks: "Clear Mind" seal                               │  
│  └─ Unlocks: Expert mastery goals                            │  
│                                                              │  
│  STAGE 3: INSIGHT (悟性)                                     │  
│  ├─ Complete 15 Expert puzzles                               │  
│  ├─ Complete 5 Expert puzzles with ≥70% accuracy             │  
│  ├─ Complete 3 Expert puzzles with 0 errors AND 0 hints      │  
│  ├─ Use all 3 MVP advanced techniques: NP, HP, PP            │  
│  ├─ Replay and improve score on 5 puzzles                    │  
│  ├─ Earn "Expert Ready" award                                │  
│  ├─ Unlocks: "Sharp Eye" seal                                │  
│  └─ Unlocks: EXTREME CHALLENGES                              │  
│                                                              │  
│  STAGE 4: MASTERY (登峰) — Post-MVP                           │  
│  ├─ Complete 10 Extreme puzzles                              │  
│  ├─ Place in top 50% on Daily Extreme leaderboard            │  
│  ├─ Unlocks: "Enter the Spirit" seal                         │  
│  ├─ Unlocks: Exclusive board theme                           │  
│  └─ Unlocks: Extreme variant challenges                      │  
│                                                              │  
└─────────────────────────────────────────────────────────────┘  
```  
  
### 10.3 Award UX Principles  
  
- Show clear unlock criteria with progress bars  
- Appear after completion or viewable on Awards screen  
- Avoid excessive celebration during calm play (subtle seal animation only)  
- Unlock meaningful capability, not only badges  
- Never use guilt or FOMO ("Only 2 days left!")  
  
### 10.4 Additional Awards (Non-Gating)  
  
These exist alongside Scholar's Path stages but don't gate content:  
  
| Award | Requirement | Purpose |  
|-------|-------------|---------|  
| First Solve | Complete any puzzle | Onboarding milestone |  
| Daily Week | Complete 7 daily puzzles | Habit formation |  
| Speed Demon | Beat target time on Hard+ (timer on) | Recognize speed (opt-in) |  
| No Notes Needed | Complete Expert without using notes | Recognize mental solving |  
| Perfectionist | 10 clean solves | Recognize consistency |  
| Replay Improver | Improve score on 10 retries | Encourage self-improvement |  
  
---  
  
## 11. Extreme Challenge  
  
### 11.1 Design Principles  
  
- **Gated by skill, not payment.** Extreme unlocks only through Scholar's Path Stage 3.  
- **Fair by design.** Only official challenge puzzles are ranked. Conditions are identical for all players.  
- **Integrity-verified.** Ranked eligibility flags are immutable. Assisted solves are permanently excluded.  
- **Opt-in competitive.** Players who never unlock Extreme never see leaderboards.  
  
### 11.2 Unlock Requirements  
  
Extreme Challenges unlock when Scholar's Path Stage 3 (Insight) is complete:  
- 15 Expert puzzles completed  
- 5 Expert with ≥70% accuracy  
- 3 Expert with zero errors and zero hints  
- 3 different advanced techniques used  
- 5 replay improvements  
  
### 11.3 Extreme Rules  
  
- Only official challenge puzzles are ranked  
- Hints disabled for ranked score  
- Auto-check disabled for ranked score  
- Notes allowed (technique tracking is separate)  
- Pause allowed with anti-abuse handling (server-side post-MVP)  
- Only first eligible completion counts for daily/weekly ranking  
- Retries excluded from ranking  
  
### 11.4 Extreme Challenge Types (Post-MVP Expansion)  
  
| Type | Description | Score Multiplier |  
|------|-------------|------------------|  
| Daily Extreme | One validated Expert+ puzzle. Same worldwide | ×1.0 |  
| Minimal Givens | Minimum givens (17-21). Validated unique solution | ×1.2 |  
| Technique Gauntlet | Requires specific advanced techniques | ×1.3 |  
| No Notes | Notes mode locked. Pure mental solving | ×1.4 |  
  
### 11.5 Leaderboard Strategy  
  
| Phase | Scope | Implementation | Timing |  
|-------|-------|---------------|--------|  
| **Phase 1** | Local Extreme bests | On-device only. Works offline | MVP |  
| **Phase 2** | Platform-native | Game Center (iOS), Google Play Games (Android) | Post-MVP |  
| **Phase 3** | Worldwide cross-platform | Orbace backend, server-issued challenge IDs, anti-cheat | Post-MVP |  
  
### 11.6 Leaderboard Types  
  
| Leaderboard | Fairness Model | Reset Cadence |  
|-------------|---------------|---------------|  
| Daily Extreme | Same puzzle worldwide | Daily |  
| Weekly Extreme | Aggregate best 3 scores from week | Weekly |  
| Seasonal | Aggregate best 10 scores | Monthly/quarterly |  
| Friends | Compare with connected players | N/A |  
  
**Never implemented**: Raw time leaderboards, all-time cumulative ranks, pay-to-compete.  
  
---  
  
## 12. Level Strategy  
  
### 12.1 Content Model  
  
Hybrid approach: algorithmically generated, solver-validated, difficulty-rated, pre-curated for shipping.  
  
| Source | Use Case | Timing |  
|--------|----------|--------|  
| Pre-generated local database | Main campaign, offline play | MVP |  
| Curated Extreme set | Ranked challenges | MVP (local), expanded post-MVP |  
| Runtime generation | Extra puzzles, endless mode | Post-MVP |  
| Remote content service | Daily puzzles, events | Post-MVP |  
| Hand-authored puzzles | Special challenge packs | Optional |  
  
### 12.2 MVP Level Count  
  
| Difficulty | Puzzle Count |  
|------------|-------------|  
| Beginner (入門) | 200 |  
| Easy (小成) | 300 |  
| Medium (貫通) | 500 |  
| Hard (精深) | 500 |  
| Expert (入神) | 300 |  
| Extreme (極致) | 50 (curated, separate library) |  
| **Total** | **1,850** |  
  
### 12.3 Generation Quality Gate  
  
Every puzzle must pass:  
1. Unique solution validated by backtracking solver  
2. Full human-logic solve path exists using only MVP techniques  
3. Difficulty score falls within target range for assigned tier  
4. Solve path pre-computed and stored as `List<StoredSolvingStep>`  
5. `rankedEligible` flag set appropriately: `true` only for official challenge puzzles; standard level-pack puzzles are local-score only  
  
### 12.4 Puzzle Metadata  
  
```dart  
class SudokuPuzzle {  
  final String id;  
  final int size;                    // 9 for classic  
  final int boxWidth;                // 3 for classic  
  final int boxHeight;               // 3 for classic  
  final List<int?> givens;  
  final List<int> solution;  
  final SudokuDifficulty difficulty;  
  final int difficultyScore;  
  final int targetTimeSeconds;  
  final int medianTimeSeconds;  
  final List<String> requiredTechniques;  
  final List<StoredSolvingStep> solvePath;   // Pre-computed  
  final bool rankedEligible;  
  final String? challengeId;                 // For official challenges  
}  
```  
  
---  
  
## 13. Difficulty Rating  
  
Difficulty scored by technique complexity, not givens count:  
  
| Tier | Intended Experience | Typical Technique Mix |  
|------|--------------------|----------------------|  
| Beginner (入門) | Tutorial-friendly. Many givens. Gentle introduction | Naked Singles only |  
| Easy (小成) | Relaxed solving. Minimal notes needed | Singles, occasional Hidden Singles |  
| Medium (貫通) | Notes useful. Moderate scanning | Singles, Pairs |  
| Hard (精深) | Stronger logic and patience required | Pairs, Pointing Pairs |  
| Expert (入神) | Sparse clues. Multiple advanced techniques | Full MVP technique range; X-Wing and beyond after expansion |  
| Extreme (極致) | Challenge-only. No-assist ranked play | Advanced techniques; validated no-guess |  
  
**Rating inputs**: number of givens, solver step count, technique distribution, branching depth, candidate complexity, target solve time estimate.  
  
---  
  
## 14. Gameplay UX  
  
### 14.1 Screen Architecture  
  
```text  
App Shell  
  │  
  ├── Home  
  │     ├── Continue puzzle (if in progress)  
  │     ├── Daily puzzle ("Tea Moment" — 一局一茶)  
  │     ├── Level packs (by difficulty)  
  │     ├── Stats & Awards  
  │     └── Settings  
  │  
  ├── Level Packs  
  │     ├── Difficulty tabs (入門, 小成, 貫通, 精深, 入神)  
  │     ├── Level grid with completion seals  
  │     └── Pack progress indicators  
  │  
  ├── Game Board  
  │     ├── Timer (hidden by default) + Pause  
  │     ├── Board with selection/hint highlights  
  │     ├── Number pad  
  │     ├── Notes toggle (pencil icon)  
  │     ├── Undo / Redo  
  │     ├── Hint (lantern icon)  
  │     ├── Erase  
  │     └── Settings quick-access (mistake check, theme)  
  │  
  ├── Completion  
  │     ├── Difficulty seal animation  
  │     ├── Score with transparent breakdown  
  │     ├── Technique usage summary  
  │     ├── Personal best comparison  
  │     ├── Next Puzzle / View Replay / Retry  
  │  
  ├── Replay Viewer  
  │     ├── Animated board playback  
  │     ├── Playback controls + speed  
  │     ├── Step list with technique labels  
  │     └── Player vs. Optimal mode toggle  
  │  
  ├── Stats & Awards  
  │     ├── Completion counts by difficulty  
  │     ├── Score history  
  │     ├── Technique mastery progress  
  │     ├── Seal collection  
  │     └── Scholar's Path progress with stage gates  
  │  
  └── Extreme Hub (Locked until Stage 3)  
        ├── Unlock requirements display  
        ├── Daily Extreme (when unlocked)  
        ├── Local leaderboard  
        └── Challenge types  
```  
  
### 14.2 Board Interaction Spec  
  
| Action | Behavior |  
|--------|----------|  
| Tap cell | Select cell; highlight row, column, box; highlight matching numbers |  
| Tap number | Enter value in selected cell |  
| Long-press cell | Activate notes mode (alternative to toggle) |  
| Toggle pencil | Enter/exit notes mode; number pad behavior changes |  
| Given numbers | Darker weight, distinct color, not editable |  
| Invalid entry | Shown immediately only if mistake checking enabled; gentle highlight, never red flash |  
| Completed house | Subtle satisfaction feedback (brief highlight pulse) |  
| Hint highlights | Distinct color from selection; animated sequence for Tier 2 |  
  
---  
  
## 15. Technical Architecture  
  
### 15.1 Flutter Module Structure  
  
```text  
lib/src/features/sudoku/  
  domain/  
    sudoku_board.dart  
    sudoku_cell.dart  
    sudoku_puzzle.dart  
    sudoku_move.dart  
    sudoku_attempt.dart  
    sudoku_score.dart  
    sudoku_award.dart  
    sudoku_difficulty.dart  
    solving_step.dart  
    technique_definition.dart  
  engine/  
    sudoku_solver.dart              // Backtracking fallback  
    human_ranked_solver.dart        // Prioritized constraint solver  
    techniques/  
      technique_registry.dart  
      naked_single.dart  
      hidden_single.dart  
      naked_pair.dart  
      hidden_pair.dart  
      pointing_pair.dart  
    sudoku_generator.dart  
    sudoku_validator.dart  
    sudoku_difficulty_rater.dart  
    step_logger.dart  
    score_calculator.dart  
    award_engine.dart  
  hint/  
    hint_state_manager.dart  
    hint_formatter.dart  
  replay/  
    replay_controller.dart  
    replay_renderer.dart  
  data/  
    sudoku_level_repository.dart  
    sudoku_progress_repository.dart  
    sudoku_attempt_repository.dart  
    sudoku_award_repository.dart  
    sudoku_challenge_repository.dart  
  presentation/  
    sudoku_home_screen.dart  
    sudoku_level_pack_screen.dart  
    sudoku_game_screen.dart  
    sudoku_board_widget.dart  
    sudoku_number_pad.dart  
    sudoku_completion_screen.dart  
    sudoku_replay_screen.dart  
    sudoku_stats_screen.dart  
    sudoku_awards_screen.dart  
    sudoku_extreme_screen.dart  
```  
  
### 15.2 Core Data Models  
  
```dart  
enum SudokuDifficulty {  
  beginner,   // 入門  
  easy,       // 小成  
  medium,     // 貫通  
  hard,       // 精深  
  expert,     // 入神  
  extreme,    // 極致  
}  
  
class SudokuPuzzle {  
  final String id;  
  final int size;  
  final int boxWidth;  
  final int boxHeight;  
  final List<int?> givens;  
  final List<int> solution;  
  final SudokuDifficulty difficulty;  
  final int difficultyScore;  
  final int targetTimeSeconds;  
  final int medianTimeSeconds;  
  final List<String> requiredTechniques;  
  final List<StoredSolvingStep> solvePath;  
  final bool rankedEligible;  
  final String? challengeId;  
}  
  
class StoredSolvingStep {  
  final int stepIndex;  
  final String techniqueId;  
  final int row;  
  final int col;  
  final int? value;  
  final List<int> highlightCellIndices;  
  final List<int> affectedCellIndices;  
  final String explanationTemplateKey;  
  final Map<String, String> params;  
}  
  
class SudokuAttempt {  
  final String id;  
  final String puzzleId;  
  final bool isRetry;  
  final int attemptNumber;  
  final int elapsedSeconds;  
  final int errorCount;  
  final int hintNudgeCount;  
  final int hintExplanationCount;  
  final int hintRevealCount;  
  final bool autoCheckEnabled;  
  final bool mistakeRevealEnabled;  
  final bool completed;  
  final bool cleanSolve;  
  final bool rankedEligible;  
  final SudokuScore? score;  
  final List<SudokuMove> moveHistory;  
  final DateTime startedAt;  
  final DateTime? completedAt;  
}  
  
class SudokuScore {  
  final int total;  
  final int baseScore;  
  final double accuracyMultiplier;  
  final int timeBonus;  
  final int efficiencyBonus;  
  final int cleanSolveBonus;  
  final int scoringVersion;  
  final List<String> accuracyFactors;  
}  
  
class ScholarPathStage {  
  final String id;  
  final String name;            // "Foundation"  
  final String chineseName;     // "基礎"  
  final int stageNumber;  
  final List<AwardRequirement> requirements;  
  final String unlocksDescription;  
  final bool isComplete;  
  final double progressPercent;  
}  
```  
  
### 15.3 Persistence  
  
| Component | Technology | Rationale |  
|-----------|-----------|-----------|  
| Puzzle library | Drift (SQLite) | Large dataset, typed queries, migrations |  
| Attempt history | Drift | Relational: attempts → puzzles |  
| Awards progress | Drift | Relational: awards → attempts |  
| Current game state | Drift | Progress + move history |  
| Settings | shared_preferences | Simple key-value |  
| Replay data | Read from attempt.moveHistory | No separate storage needed |  
  
---  
  
## 16. Monetization Strategy  
  
### 16.1 MVP: Free, Zero Active-Play Interruptions  
  
The first release is free with no ads during puzzle solving. This is itself a differentiator and acquisition driver.  
  
### 16.2 Post-MVP Monetization  
  
| Product | Type | Placement Rule |  
|---------|------|----------------|  
| Remove ads | Single IAP | Post-completion, between packs only |  
| Premium puzzle packs | IAP | Themed packs (Solar Terms, etc.) |  
| Theme packs | IAP | Additional board themes |  
| Daily challenge archive | IAP | Access past daily puzzles |  
| Rewarded hints | Opt-in ad | Non-ranked casual play only; player explicitly chooses |  
  
### 16.3 Iron Rules  
  
- No ads during active board play  
- No ads before returning to in-progress puzzle  
- No rewarded hints in ranked or Extreme mode  
- Extreme unlock never purchasable (skill-gated only)  
- Ranked eligibility never purchasable  
  
---  
  
## 17. Analytics Events  
  
Defined early for instrumentation planning:  
  
**Session & Engagement:**  
- `sudoku_app_opened`  
- `sudoku_level_started` (puzzle_id, difficulty, attempt_number, is_retry)  
- `sudoku_level_completed` (puzzle_id, difficulty, score, errors, hints_used, clean_solve, ranked_eligible, time_if_enabled)  
- `sudoku_level_abandoned` (puzzle_id, progress_percent, elapsed_time)  
- `sudoku_daily_started`  
- `sudoku_daily_completed`  
  
**Hints & Learning:**  
- `sudoku_hint_requested` (tier: nudge/explanation/reveal, technique_id if tier_2)  
- `sudoku_hint_dismissed` (tier)  
- `sudoku_mistake_made`  
- `sudoku_notes_enabled`  
- `sudoku_notes_disabled`  
  
**Replay & Mastery:**  
- `sudoku_replay_viewed` (attempt_id, mode: player/optimal, duration_watched)  
- `sudoku_retry_started` (puzzle_id, previous_attempt_id)  
- `sudoku_retry_completed` (score_improved: true/false, improvement_delta)  
- `sudoku_score_breakdown_viewed`  
- `sudoku_award_earned` (award_id, stage_id)  
- `sudoku_stage_completed` (stage_id)  
- `sudoku_extreme_unlocked`  
- `sudoku_extreme_started`  
- `sudoku_extreme_completed`  
  
**Competitive:**  
- `sudoku_ranked_attempt_completed` (challenge_id, score, platform)  
- `sudoku_leaderboard_viewed` (type: local/platform/worldwide)  
  
---  
  
## 18. Accessibility  
  
- High-contrast board option  
- Minimum 44×44pt touch targets for all interactive elements  
- Screen-reader labels: cell position (row, column), value, given/player status, notes state, error state, hint highlights  
- Color never the sole indicator of errors, selection, or highlights  
- Haptics optional and adjustable (off by default)  
- Timer pressure optional (off by default)  
- Large text support for all UI text  
- Cell navigation model for screen readers: swipe to move between cells, double-tap to select, number pad for entry, dedicated "read row" gesture  
  
---  
  
## 19. Implementation Plan  
  
### Phase 1: Engine Foundation (Weeks 1-4)  
  
**Deliverables:**  
- Board, cell, move, puzzle, attempt, score domain models  
- Backtracking solver with unique-solution validation  
- Human-ranked solver implementing 5 techniques  
- SolvingStep output with technique metadata  
- Step logger  
- Basic puzzle generator  
- Score calculator with accuracy-weighted formula  
- Award engine with stage requirement checking  
- Unit tests for all engine components  
  
**Exit criteria:**  
- Generate valid 9x9 puzzles with unique solutions  
- Human-ranked solver produces logical step sequences  
- Solver rejects puzzles requiring unimplemented techniques  
- Score calculator produces correct, stable outputs  
- Award engine correctly evaluates stage requirements  
  
### Phase 2: Playable Game Screen (Weeks 5-8)  
  
**Deliverables:**  
- Sudoku board widget with theme support  
- Selection highlights (cell, row, column, box, matching number)  
- Number pad with theme accent  
- Notes/pencil mode toggle  
- Undo/redo with move history capture  
- Mistake checking (configurable, off by default for Beginner/Easy)  
- Timer (hidden by default, player-enabled)  
- Pause/resume with progress persistence  
- Completion detection  
- Hint button (lantern icon) with three-tier escalation  
- Hint state manager with per-session tracking  
- Tier 1 overlay (nudge)  
- Tier 2 overlay (technique name + reasoning cell highlights + explanation)  
- Tier 3 (reveal with animation)  
- Completion screen with seal placeholder and score breakdown  
- Ink Wash theme (default)  
- All UI text using difficulty name mappings  
  
**Exit criteria:**  
- Complete puzzle flow: start → play with hints → complete → see score  
- Three-tier hint escalation functional  
- Progress survives app restart  
  
### Phase 3: Level Packs, Scoring & Replay (Weeks 9-12)  
  
**Deliverables:**  
- Bulk generation script with quality gate  
- Puzzle quality validator  
- Pre-computed solve path storage  
- Local level repository (Drift)  
- Level pack screen with difficulty tabs and completion seals  
- First Solar Terms pack (24 puzzles)  
- Completion screen: full score breakdown, technique summary, personal best comparison  
- Replay viewer: animated board playback, controls, step list  
- Player vs. Optimal mode toggle  
- Attempt history per puzzle  
- "Retry this puzzle" action with new attempt creation  
- Clean-solve badge  
  
**Exit criteria:**  
- 1,800 puzzles generated, validated, stored with solve paths  
- All puzzles pass human-logic quality gate  
- Completion screen shows full score breakdown  
- Replay plays back completed attempt accurately  
- Retry creates new attempt without overwriting previous  
  
### Phase 4: Awards, Extreme & Daily (Weeks 13-16)  
  
**Deliverables:**  
- Scholar's Path award progression (3 stages)  
- Award requirements tracking with progress bars  
- Seal collection view  
- Stage unlock notifications  
- Curated Extreme puzzle set (50 puzzles)  
- Extreme locked entry point with unlock requirements display  
- Extreme unlock logic (Stage 3 completion)  
- No-assist rules enforcement for ranked Extreme  
- Local Extreme bests board  
- Daily puzzle with Tea Moment framing  
- Streak tracking (days present)  
- Stats screen: completions, scores, streaks, technique mastery, award progress  
- Accessibility pass  
  
**Exit criteria:**  
- Scholar's Path stages track correctly  
- Extreme unlocks after Stage 3 completion  
- Assisted Extreme solves correctly flagged as unranked  
- Daily puzzle appears reliably  
  
### Phase 5: Tutorial, Polish & Release (Weeks 17-20)  
  
**Deliverables:**  
- Guided first-time tutorial (single Beginner puzzle, step-by-step)  
- Celadon theme (unlockable)  
- Haptics and sound settings  
- Dark/low-light theme validation  
- Screen-reader labels for all board states  
- Large text and high-contrast validation  
- App icons and store screenshots  
- Chinese localization complete  
- iOS and Android release validation  
- App Store listing: "Orbace Sudoku — Calm puzzles. Real progress."  
- Chinese listing: "一局一茶 Sudoku — 靜心數獨，每日精進"  
  
**Exit criteria:**  
- Smoke tests pass on all target devices  
- No known board interaction bugs  
- Tutorial completable by first-time Sudoku player  
- All accessibility requirements validated  
- Level database bundled and load-tested  
  
### Phase 6: Platform Competition (Post-MVP, Weeks 21+)  
  
**Deliverables:**  
- Game Center achievements and leaderboards (iOS)  
- Google Play Games achievements and leaderboards (Android)  
- Platform-specific Extreme daily/weekly rankings  
  
### Phase 7: Worldwide Competition (Post-MVP, Future)  
  
**Deliverables:**  
- Orbace backend with player identity  
- Server-issued challenge IDs  
- Ranked score submission  
- Anti-cheat validation (impossible time, score-bound, version check)  
- Cross-platform weekly Extreme leaderboard  
  
### Phase 8: Expansion (Post-MVP, Future)  
  
**Deliverables:**  
- Technique practice mode  
- Puzzle variants (4x4, 6x6, Killer, Jigsaw)  
- Additional Solar Terms packs  
- Share replay as video/GIF  
- Account system with cloud sync  
- Monetization features (remove-ads IAP, premium packs)  
  
---  
  
## 20. Testing Plan  
  
### 20.1 Unit Tests  
  
**Solver & Validator:**  
- Solver solves valid puzzles  
- Solver detects unsolvable puzzles  
- Validator detects duplicate row, column, box values  
- Generator creates unique-solution puzzles  
- Human-ranked solver produces deterministic step order  
- Each technique correctly identified in fixture puzzles  
- Quality gate rejects puzzles requiring unimplemented techniques  
  
**Scoring:**  
- Score calculator produces correct results for known scenarios  
- Accuracy multiplier compounds errors correctly (2 errors = 0.85²)  
- Time bonus only applies when timer enabled  
- Time bonus capped at +10%  
- Efficiency bonus calculates correctly  
- Clean solve bonus applies only when zero errors AND zero hints  
- Ranked eligibility flags set correctly for all assist combinations  
  
**Hints:**  
- Hint state manager escalates tiers correctly  
- Hint state resets when board state changes independently  
- Technique names rendered correctly in English and Chinese  
  
**Awards:**  
- Award engine correctly evaluates stage requirements  
- Stage completion triggers at correct thresholds  
- Stage unlock descriptions match actual unlocked capabilities  
  
**Replay:**  
- Replay viewing does not create new attempt  
- Retry creates new attempt with isRetry: true and incremented attemptNumber  
- Retry updates local best but never sets rankedEligible: true  
  
### 20.2 Widget Tests  
  
- Cell selection updates row/column/box/matching highlights  
- Number input fills selected cell  
- Given cells not editable  
- Notes mode adds/removes candidates  
- Completion state triggers when board matches solution  
- Tier 1 hint highlights target cell only  
- Tier 2 hint shows technique name and multiple highlighted cells in sequence  
- Tier 3 hint fills cell with animation  
- Replay controls advance/rewind board state  
- Player vs. Optimal toggle switches step list  
- Score breakdown renders all components correctly  
- Theme switching updates all board colors  
- Extreme lock screen shows correct unlock requirements  
  
### 20.3 Manual QA  
  
- iOS phone and tablet layout  
- Android phone and tablet layout  
- Rotation behavior (if supported)  
- App resume while puzzle in progress  
- Large text accessibility mode  
- Dark mode and high-contrast mode  
- Screen-reader cell navigation  
- Offline play: full puzzle flow in airplane mode  
- 30-minute play session with no crashes  
- Level database load time on cold start  
- Replay history accuracy over multiple attempts  
- Score consistency: same puzzle, same performance = same score  
  
---  
  
## 21. Key Product Decisions  
  
| Decision | Resolution | Rationale |  
|----------|-----------|-----------|  
| Hint system depth | Three-tier with technique explanation in MVP | Primary teaching differentiator; must match Good Sudoku benchmark |  
| Scoring formula structure | Accuracy-weighted multiplicative | Difficulty-dominant; speed is capped optional bonus; stable outputs |  
| Replay vs. retry | Separate concepts | Viewing is consequence-free; retrying is explicit; protects ranked integrity |  
| Award structure | Staged progression (Scholar's Path) | Gating content behind skill creates purpose; avoids checklist fatigue |  
| Cultural differentiation | Design layer across themes, seals, naming, daily ritual | Low dev cost; high visual distinctiveness; must ship in MVP |  
| Calm enforcement | Specific design constraints | Aspiration is not enough; rules must be testable |  
| Extreme unlock | Skill-gated only (Stage 3) | Never purchasable; maintains competitive integrity |  
| Leaderboard rollout | Local → Platform → Worldwide | De-risks launch; platform-native is free; backend comes when validated |  
| Technique count for MVP | Five (NS, HS, NP, HP, PP) | Covers Beginner–Expert; post-MVP adds advanced |  
| Hint path strategy | Pre-compute and store | Deterministic quality; no UI blocking; enables instant replay |  
| Timer default | Off | Core calm positioning |  
| Streak tracking | Days present, not consecutive completions | No guilt for missing a day; habit over performance |  
| Monetization during active play | Zero interruptions | Core promise; differentiator against ad-heavy market |  
  
---  
  
## 22. MVP Success Metrics  
  
**Product Quality:**  
- 100% shipped puzzles validated with unique solutions  
- 100% shipped puzzles have pre-computed human-logic solve paths (no guessing required)  
- No known crashes during 30-minute play session  
- All touch targets ≥44pt on smallest supported device  
- Score breakdown available for every completed puzzle  
  
**Engagement:**  
- ≥40% of users complete at least one puzzle in first session  
- ≥25% of users start a second puzzle after completion  
- ≥20% of completed-puzzle users view a replay  
- Daily puzzle users return within 7 days  
- Tutorial completion rate ≥80%  
  
**Expert Loop:**  
- Expert players understand score breakdown without external explanation (validated in beta)  
- Scholar's Path progress visible and motivating (validated in beta)  
- ≥10% of Expert completions are clean solves  
  
**Content:**  
- 1,800 standard levels + 50 Extreme shipped with solve paths  
- Each difficulty tier has measurable difficulty range  
- At least one themed pack (Solar Terms) shipped  
  
**Differentiation Validation (Beta):**  
- Testers describe app as "calm" unprompted  
- Testers can identify at least one taught technique after tutorial  
- No tester reports feeling pressured by timer or streaks  
- Cultural themes described positively, not as gimmick  
  
---  
  
## 23. Risks  
  
| Risk | Severity | Mitigation |  
|------|----------|------------|  
| Three-tier hint system delays MVP | Medium | Five techniques sufficient; Tier 2 uses stored solve paths, not live solving |  
| Generated levels feel uneven | High | Solver-based difficulty scoring + pre-computed paths + beta QA |  
| App feels generic | High | Cultural themes, seals, Tea Moment must ship MVP; calm constraints enforceable |  
| "Calm + competitive" tension | Medium | Competition always opt-in behind Stage 3 gate; default path has no leaderboard pressure |  
| Expert puzzles require guessing | High | Quality gate rejects puzzles without full human-logic path |  
| Scoring feels unfair | Medium | Transparent breakdown; tune with expert beta feedback; stable formula |  
| Replay clutters attempt history | Low | Viewing doesn't create attempts; retry is explicit and flagged |  
| Good Sudoku adds Android + competitive | Medium | Premium positioning limits reach; Orbace's freemium + progression + awards is different offer |  
| Sudoku.com improves hints | Medium | Ad model disincentivizes longer sessions; teaching extends engagement |  
| Backend delays worldwide leaderboard | Low | Platform-native leaderboards (Phase 2) work without backend; Phase 3 is independent |  
  
---  
  
## 24. Recommendation  
  
Build Orbace Sudoku V3 as a product with two layers sharing one codebase:  
  
**Layer 1 — Calm Daily Sudoku (default for all):**  
Clean board, fair puzzles, no active-play interruptions, three-tier teaching hints, cultural themes and seals, replay for self-review, transparent scoring as information.  
  
**Layer 2 — Mastery Path (opt-in for those who seek it):**  
Scholar's Path staged awards gating harder content, replay-based improvement, Extreme challenges with ranked integrity, platform-native then worldwide leaderboards.  
  
The engine-first approach remains correct. The human-ranked solver with pre-computed solve paths is the technical foundation for teaching quality, fair scoring, replay, and ranked integrity.  
  
Cultural differentiation must ship in MVP. It is the first-five-seconds signal that distinguishes Orbace Sudoku from every other Sudoku app in the store.  
  
The expert features serve a real audience but are correctly gated behind demonstrated skill. The calm path is always the default. Competition is a door the player chooses to open.  
  
---  
  
*End of PRD V3*  
