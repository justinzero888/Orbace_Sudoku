# Orbace Sudoku - Navigation and Daily UX Redesign Proposal

**Version**: 0.1 Draft  
**Date**: 2026-06-29  
**Status**: Design proposal for V1 production polish and V2 readiness  
**Scope**: Home navigation, Tea Moment vs. Daily Ranking Game, and top-level feature organization.

## 1. Problem Statement

Orbace Sudoku now has a richer feature set than a simple Sudoku app:

- Tea Moment
- Import Puzzle
- Record Hall
- Level Packs
- Official Ranking
- Scholar's Path
- Extreme Challenge
- Settings / policy / remove ads

If all features are presented as equal Home cards, the app starts to feel like a menu, not a product experience. UAT feedback shows that the app needs a clearer information architecture before Global Ranking arrives.

The main design question:

> How does Orbace keep the calm cultural identity of Tea Moment while adding the higher-pressure Daily Ranking Game?

## 2. Brand Interpretation

Tea Moment and Daily Ranking should not compete for the same emotional job.

| Feature | Brand Role | Emotional Tone | User Intent |
| --- | --- | --- | --- |
| Tea Moment | Daily ritual | Calm, reflective, restorative | "I want one good puzzle with no pressure." |
| Daily Ranking Game | Official challenge | Focused, accountable, competitive | "I want to test myself under fair rules." |

Tea Moment is **practice as ritual**. Daily Ranking is **competition as ceremony**.

Recommended brand language:

- Tea Moment: **今日茶局** / daily calm puzzle
- Official Ranking: **今日榜局** / official daily ranking game
- Record Hall: **藏谱阁**
- Compare Su-Pu: **对谱**
- Scholar's Path: **学者之路**
- Extreme Challenge: **极境挑战**

## 3. Recommended Home Structure

Home should not show 7-8 equal cards. It should be organized by player intent.

Recommended hierarchy:

1. **Daily Focus band**
2. **Continue / Play section**
3. **Study and Records section**
4. **Growth and Competition section**
5. **Utility access**

### 3.1 Daily Focus Band

The first screen should lead with daily intent.

Recommended layout:

- Large primary tile: **Tea Moment**
  - Today's puzzle name
  - calm copy
  - Start button
- Secondary compact tile: **Official Ranking**
  - if V1: "Coming Soon"
  - if V2: event open/closed state, countdown, sign-in requirement

Why:

- Tea Moment remains the brand anchor.
- Official Ranking gets visibility without turning Home into a competitive-first app.
- The user immediately understands there are two daily modes: calm and official.

### 3.2 Continue / Play Section

This section should answer: "What can I play now?"

Items:

- Continue current puzzle, if one exists.
- Level Packs.
- Import Puzzle.

Recommended behavior:

- If there is an unfinished puzzle, show **Continue Playing** above Level Packs.
- Level Packs should be the default structured play entry.
- Import Puzzle should be a smaller utility tile, not equal visual weight to Tea Moment.

### 3.3 Study and Records Section

This section should answer: "What have I learned or saved?"

Items:

- Record Hall
- Su-Pu / replay / score cards through Record Hall

Recommended behavior:

- Record Hall should show count: number of Su-Pu saved.
- Surface "recent Su-Pu" preview later if needed.

### 3.4 Growth and Competition Section

This section should answer: "How do I improve or prove skill?"

Items:

- Scholar's Path
- Extreme Challenge
- Official Ranking

Recommended behavior:

- Scholar's Path is learning progression.
- Extreme Challenge is unlocked mastery.
- Official Ranking is server-backed competition and should become more prominent only when account/global ranking is live.

### 3.5 Utility Access

Settings should live in the app bar, not as a major Home tile.

Settings includes:

- Privacy
- Terms of Use
- Remove Ads IPA
- Future account controls
- Future notification controls

## 4. Proposed V1 Home Layout

V1 should remain local-first and calm.

Recommended first viewport:

1. Header:
   - Orbace Sudoku
   - Settings icon
2. Daily Focus:
   - Tea Moment primary tile
   - Official Ranking compact "Coming Soon" tile
3. Play:
   - Level Packs
   - Import Puzzle
4. Study:
   - Record Hall
5. Growth:
   - Scholar's Path
   - Extreme Challenge

Visual weight:

- Tea Moment: primary.
- Level Packs: strong secondary.
- Record Hall: strong secondary once user has saved Su-Pu.
- Official Ranking: compact preview until V2.
- Import Puzzle: utility/action tile.
- Scholar's Path / Extreme: progression tiles.

## 5. Proposed V2 Home Layout

When Daily Ranking launches, Home should become state-aware.

Recommended V2 first viewport:

1. **Today**
   - Tea Moment: calm daily puzzle
   - Official Ranking: event status
2. **Continue**
   - Resume in-progress local puzzle
   - Resume official event only if policy allows; otherwise show locked/attempt consumed
3. **Play**
   - Level Packs
   - Import Puzzle
4. **My Su-Pu**
   - Record Hall
5. **Mastery**
   - Scholar's Path
   - Extreme Challenge

Official Ranking states:

| State | UI Copy |
| --- | --- |
| Not signed in | Sign in to join official ranking |
| Before 01:00 ET | Opens at 01:00 ET |
| Open | Today's Ranking Game is open |
| Started | Attempt in progress |
| Finished unsubmitted | Submit official record |
| Closed before finalization | Ranking closes at 22:00 ET |
| Finalized | View final leaderboard |

## 6. Tea Moment vs. Daily Ranking Rules

Tea Moment:

- Local daily puzzle.
- Calm.
- Timer can remain low-pressure.
- Hints allowed.
- Replay and Su-Pu saved.
- Does not affect global ranking.

Daily Ranking Game:

- Server-published official game.
- Account required.
- Available Eastern 01:00-22:00.
- One attempt.
- No pause.
- No hints/assists.
- Submit required for global points.
- Replay can become public/shared if player opts in.

Important UX rule:

> Tea Moment should never look like a failed ranking attempt. Ranking should never make Tea Moment feel less valuable.

## 7. Recommended Navigation Pattern

For V1, keep one Home page but group sections clearly.

For V2, consider bottom navigation only if the feature set grows further.

Potential V2 bottom tabs:

- Today
- Play
- Record Hall
- Ranking
- Settings/Profile

Do not add bottom navigation in V1 unless Home becomes too dense after UAT. V1 can be solved with better sectioning and visual hierarchy.

## 8. Near-Term Implementation Recommendations

### V1 Production Polish

1. Remove photo import from V1 after UAT feedback.
2. Add Record Hall search.
3. Keep Settings in app bar.
4. Reorder Home so core V1 play paths remain visible:
   - Tea Moment
   - Level Packs
   - Import Puzzle
   - Record Hall
   - Official Ranking preview
   - Scholar's Path
   - Extreme Challenge
5. Add section headers when layout is redesigned:
   - Today
   - Play
   - Study
   - Mastery

### V2 Preparation

1. Keep Official Ranking preview visible but clearly not live.
2. Use the preview to teach future concept:
   - account required
   - official event
   - one attempt
   - server ranking
3. Do not require account in V1.
4. Do not mix Tea Moment with global ranking eligibility.

## 9. Open Design Questions

1. Should V1 Home use section headers immediately, or wait until after build 30 UAT?
2. Should Official Ranking preview stay on Home before backend exists, or move under Scholar's Path until V2?
3. Should Tea Moment eventually show a streak, or would that hurt the calm brand?
4. Should Record Hall become "My Su-Pu" in English-facing navigation, with Record Hall as subtitle?
5. Should Extreme Challenge stay visible while locked, or live under Scholar's Path until unlocked?

## 10. Recommendation

Recommended direction:

- Keep **Tea Moment** as the emotional and visual anchor.
- Treat **Official Ranking** as a separate "official ceremony," not a replacement daily puzzle.
- Keep V1 Home as a single page, but redesign into sections.
- Delay bottom navigation until V2 account/global ranking creates enough repeated-use depth.
- Move photo import out of V1; revisit after a proper OCR/camera design spike.

The strongest Home story is:

> Today, play calmly. Then progress through packs, preserve your Su-Pu, study your growth, and when ready, enter official competition.
