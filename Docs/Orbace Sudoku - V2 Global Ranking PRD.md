# Orbace Sudoku - V2 Global Ranking PRD

**Version**: 0.1 Draft  
**Date**: 2026-06-28  
**Status**: Draft for product review  
**Target Release**: V2, after V1 mobile production launch  
**Platforms**: iOS, Android, and web gameplay on `orbacesudoku.com`

## 1. Executive Summary

Orbace Sudoku V2 adds a server-backed **Global Ranking System** without changing the V1 local/offline integrity rules.

V1 continues to support local play, local Su-Pu records, local ranking, replay, certificates, imported puzzles, and learning-oriented progression. V2 introduces a distinct competitive layer: **Official Ranking Games**. Only games published by Orbace as official daily, weekly, monthly, tournament, or annual ranking events can earn global ranking status.

The V2 promise:

> Keep everyday Sudoku calm and personal. Make global competition opt-in, account-based, time-boxed, fair, and auditable.

## 2. Product Principles

1. **Do not change V1 local ranking rules.** Existing Clean, Official, Retry, Practice, Imported, Record Hall, and Compare Su-Pu behavior remains intact.
2. **Global ranking is opt-in.** Players must register/sign in to participate.
3. **Official Ranking Games are special events.** Ordinary Level Pack, Tea Moment, imported, and replayed puzzles do not earn global ranking points.
4. **One attempt only.** Official ranking games can be played once, with no pause.
5. **Fair time window.** Official games are available only during the published Eastern Time window.
6. **Transparent scoring.** Normal game score remains visible, but global ranking points use a separate event-points model.
7. **Replay and audit matter.** Submitted ranking records should include replay data for verification, dispute review, and shareable community proof.

## 3. Relationship to V1

| Area | V1 Behavior | V2 Global Ranking Behavior |
| --- | --- | --- |
| Local Ranking | Device-local ranking for eligible built-in puzzles | Unchanged |
| Compare Su-Pu / 对谱 | Compare any two completed records for the same puzzle | Unchanged, plus optional comparison of official submitted records |
| Imported Puzzles | Personal, local-only, not official ranked | Unchanged |
| Retry | Personal improvement, not official ranked | Unchanged |
| Official Global Ranking | Not available | Account-based, server-backed official ranking events only |
| Replay | Local replay | Server-submitted replay for official events; shareable replay links |
| Certificates | Local score card and share card | Event certificate can include official event placement and global points |

## 4. Target Users

### 4.1 Competitive Players

Players who want fair comparison against others and are willing to follow stricter rules.

Needs:

- Clear event schedule.
- Fair one-attempt rules.
- Transparent scoring and placement bonus.
- Public or semi-public leaderboards.
- Replay proof and shareable results.

### 4.2 Existing Orbace Learners

Players who use V1 for calm practice but may occasionally join official events.

Needs:

- No pressure in everyday play.
- Clear distinction between practice and official competition.
- Gentle onboarding into official event rules.

### 4.3 Web Visitors

Players discovering Orbace through `orbacesudoku.com`.

Needs:

- Playable web experience.
- Clear sign-up path.
- View leaderboards and shared replays.
- Download mobile apps for richer offline play.

## 5. Feature Scope

### 5.1 Account Management

V2 requires registered accounts for global ranking.

Required:

- Email/password sign-up.
- Social sign-in options if feasible.
- Display name.
- Country/region optional.
- Time zone detected, with all official event windows still anchored to Eastern Time.
- Account deletion request path.
- Password reset.
- Terms acceptance.
- Privacy consent.

Recommended:

- Guest browsing for leaderboards and shared replays.
- Guest play for non-ranked web puzzles.
- Account required only before submitting official ranking records.

### 5.2 Official Ranking Games

Official Ranking Games are event puzzles published by Orbace.

Rules:

- Only Orbace-designated official ranking games can earn global ranking status.
- Player must be signed in before starting.
- Game can only be started during the availability window.
- Availability window: **Eastern Time 01:00 to 22:00**.
- Once started, the official attempt is consumed.
- No pause.
- No retry.
- No hints.
- No auto-check assist.
- No manual replay before submission.
- App/web must save start and end timestamps server-side.
- If the player disconnects, the event should be marked started; reconnect behavior must be defined before implementation.

### 5.3 Daily Official Ranking

Schedule:

- Monday through Friday.
- One official game per day.
- Available Eastern Time 01:00 to 22:00.
- Leaderboard finalizes after 22:00 Eastern Time.

Daily ranking points:

| Result | Participation / Quality Points |
| --- | ---: |
| Started but unfinished | 10 |
| Finished with 3+ errors/hints | 20 |
| Finished with 2 errors/hints | 30 |
| Finished with 1 error/hint | 50 |
| Finished with 0 errors/hints, clean play | 100 |

After 22:00 Eastern Time, all finished submissions are ordered by completion time, shortest time first.

Placement bonus:

| Placement | Bonus Points |
| --- | ---: |
| 1st | 400 |
| 2nd | 200 |
| 3rd | 100 |
| 4th-10th | 50 |

Maximum daily ranking points under the current draft:

- 100 clean-play points + 400 1st-place bonus = **500 points**.
- 100 clean-play points + 50 4th-10th bonus = **150 points** for each 4th-10th place finisher.

### 5.4 Saturday Mini Tournament

Schedule:

- Every Saturday except the third Saturday of the month.
- Three official games.
- Available Eastern Time 01:00 to 22:00 unless a special tournament window is published.

Rules:

- Player may start each tournament game once.
- No pause.
- Each game produces participation/quality points.
- Tournament placement can be based on total completion time across finished games, total ranking points, or a hybrid model.

Recommended scoring:

- Apply the daily participation/quality points to each of the three games.
- Rank tournament players by:
  1. Number of completed games.
  2. Total quality points.
  3. Total completion time, shortest first.
  4. Earliest final submission time as tie-breaker.

Open product decision:

- Confirm whether tournament placement bonus is per game or per tournament.

### 5.5 Monthly Tournament

Schedule:

- Every third Saturday of the month.
- Five official games.

Rules:

- Same one-attempt/no-pause/no-assist rules.
- Five-game tournament score.
- Monthly tournament leaderboard.

Recommended scoring:

- Apply quality points per game.
- Rank by:
  1. Number of completed games.
  2. Total quality points.
  3. Total completion time.
  4. Clean-game count.
  5. Earliest final submission time.

### 5.6 Annual Ranking

Annual ranking aggregates official event points over a calendar year.

Recommended leaderboards:

- Daily leaderboard.
- Weekly leaderboard.
- Monthly leaderboard.
- Annual leaderboard.
- Tournament leaderboard.
- Player profile history.

Annual ranking should include:

- Total global ranking points.
- Number of official games started.
- Number of official games finished.
- Clean completion rate.
- Average completion time.
- Best daily placement.
- Tournament placements.

## 6. Web Gameplay on `orbacesudoku.com`

V2 should include official web gameplay so players can participate without installing the app.

Required web features:

- Sign in / sign up.
- View official event schedule.
- Start eligible official event puzzle.
- Play Sudoku in browser.
- No pause for official games.
- Submit official result.
- View leaderboard after event close.
- View own event history.
- View shared replay links.

Recommended web features:

- Non-ranked practice puzzle demo.
- App download prompts for iOS and Android.
- Public event archive.
- Replay viewer for shared official Su-Pu.
- Player profile pages with privacy controls.

Technical note:

- Web gameplay should use the same puzzle engine rules and replay event schema as mobile. If the web implementation uses a different frontend stack, the scoring and eligibility logic must be shared through backend validation or a shared deterministic package.

## 7. Additional Game Packs

V2 should expand content beyond the V1 bundled 1,800 puzzles.

Pack types:

- Official ranking event packs.
- Seasonal event packs.
- Monthly tournament packs.
- Annual championship packs.
- Training packs aligned to official event techniques.
- Premium downloadable packs from `orbacesudoku.com`.

Pack metadata should include:

- Pack ID.
- Puzzle ID.
- Difficulty.
- Technique tags.
- Estimated completion time.
- Ranking eligibility.
- Event eligibility.
- Content version.
- Checksum/signature.
- Release and retirement dates.

Pack delivery:

- Mobile apps should support remote manifest download.
- Web should load server-published packs.
- Official ranking event puzzles must be server-controlled to prevent early access or tampering.

## 8. Share Replay and Official Records

V2 should extend local replay into shareable official records.

Required:

- Submitted official attempts include replay data.
- Server stores replay event stream.
- Player can choose whether to make replay public.
- Shared replay link opens on web.
- Replay page shows puzzle, player display name, score, ranking points, placement, time, clean/error/hint status, and event date.

Recommended:

- Share card includes QR/link to replay.
- Replay can be embedded in social posts as a certificate preview.
- Public replay can be hidden or deleted by player if allowed by policy.
- Orbace can preserve anonymized ranking integrity data even if public profile is hidden.

Privacy:

- Default replay visibility should be private or unlisted until the player opts in.
- Leaderboard display name can be public while replay details remain private.

## 9. Scoring Model

V2 keeps two score concepts:

1. **Normal Sudoku Score**: current Orbace score based on difficulty, accuracy, time, efficiency, clean bonus, and score class.
2. **Global Ranking Points**: event points used for daily/weekly/monthly/annual leaderboard competition.

Global Ranking Points formula:

```text
global_points = participation_quality_points + placement_bonus_points
```

Participation/quality points:

- 10 started but unfinished.
- 20 finished with 3+ errors/hints.
- 30 finished with 2 errors/hints.
- 50 finished with 1 error/hint.
- 100 finished clean with 0 errors/hints.

Placement bonus:

- Applied only after event close.
- Based on official finished submissions.
- Ordered by completion time, shortest first.

Submission choice:

- Player can choose whether to submit their play record.
- If not submitted, the play remains personal and does not earn global ranking points.
- Once submitted, the record becomes part of the official event audit trail.

Open implementation question:

- For an official ranking game, should the result auto-submit on completion, or should completion show a submit confirmation? Product direction says player can choose to submit, so V2 should show a clear opt-in submit action, while warning that non-submitted records do not earn global points.

## 10. Server-Side Database and Services

V2 requires backend services.

Core services:

- Authentication service.
- Player profile service.
- Puzzle/event publishing service.
- Official attempt service.
- Replay storage service.
- Leaderboard calculation service.
- Anti-cheat / integrity service.
- Admin content management.
- Notification/email service.

Core database entities:

| Entity | Purpose |
| --- | --- |
| users | Account identity and authentication link |
| player_profiles | Display name, region, privacy settings |
| puzzle_packs | Remote pack metadata |
| puzzles | Official puzzle definitions and checksums |
| events | Daily, mini tournament, monthly, annual event definitions |
| event_games | One or more puzzles inside an event |
| official_attempts | Player start/end, result, score, status |
| replay_events | Step-by-step replay stream |
| leaderboard_snapshots | Frozen rankings after event close |
| ranking_points_ledger | Auditable point transactions |
| audit_logs | Admin and integrity events |

Attempt statuses:

- not_started
- started
- abandoned
- completed_unsubmitted
- submitted_pending_validation
- accepted
- rejected
- disqualified

## 11. Integrity and Anti-Cheat

Minimum controls:

- Server creates official attempt before play starts.
- Server records start time.
- Client sends signed event ID and attempt ID with all submissions.
- Puzzle payload is only available during event window.
- Attempt can only be submitted once.
- Replay event count and final board must match the solution.
- Completion time must be computed from server-trusted timestamps where possible.
- Suspicious results flagged for review.

Recommended controls:

- Device/app attestation where available.
- Rate limiting.
- Server-side final board validation.
- Replay reconstruction validation.
- Hash chain for replay moves.
- Admin disqualification workflow.
- Version lock: only supported app/web versions can enter official events.

## 12. User Experience

### 12.1 Mobile Entry Points

Home screen:

- Official Ranking card.
- Today’s official game status.
- Countdown to event close.
- Sign-in prompt if not registered.

Official Ranking screen:

- Daily game.
- Weekly/mini tournament.
- Monthly tournament.
- Leaderboards.
- My official records.
- Rules.

Before start:

- Show strict rules:
  - One attempt only.
  - No pause.
  - No hints.
  - Available Eastern 01:00-22:00.
  - Submit required for points.
- Require confirmation.

After finish:

- Show normal score.
- Show participation/quality points.
- Show provisional status before event close.
- Offer Submit for Global Ranking.
- After 22:00, show placement bonus and final daily points.

### 12.2 Web Entry Points

Website navigation:

- Play
- Official Ranking
- Leaderboards
- Replays
- Packs
- Download App
- Sign In

Web official play:

- Same one-attempt rules.
- Browser warning before start.
- Resume policy must be explicit if the tab closes.

## 13. Notifications

Recommended:

- Daily game available notification.
- Event closing soon notification.
- Placement finalized notification.
- Tournament reminder.
- Monthly tournament reminder.

Controls:

- Opt-in only.
- Separate notification preferences for daily, tournament, and result updates.

## 14. Monetization

V2 monetization options:

- Free official daily participation.
- Premium training packs.
- Premium seasonal packs.
- Optional ad-supported web pages outside active gameplay.
- Subscription for advanced analytics, replay insights, and expanded archives.

Rules:

- No ads during official gameplay.
- No paid advantage for official ranking.
- Purchased packs cannot directly grant global ranking points unless they are official event packs available under equal rules.

## 15. Analytics

Track:

- Account sign-up conversion.
- Official game starts.
- Official game completions.
- Submit vs non-submit rate.
- Abandonment rate.
- Clean completion rate.
- Leaderboard views.
- Replay shares.
- Web-to-app conversion.
- Tournament participation.

Do not track:

- Sensitive personal data beyond account requirements.
- Private replay visibility beyond necessary storage and integrity controls.

## 16. MVP Scope for V2

V2 MVP should include:

- Account registration/login.
- Daily official ranking game, Monday-Friday.
- Eastern 01:00-22:00 availability.
- One attempt, no pause.
- Submit official record.
- Server-side attempt storage.
- Daily leaderboard finalization after 22:00.
- Global ranking points for daily events.
- Web leaderboard.
- Mobile leaderboard.
- Shareable official replay link.
- Admin tool to publish daily puzzles.

Defer:

- Annual championship.
- Advanced anti-cheat attestation.
- Paid pack purchase flow.
- Full replay analytics.
- Weekly/monthly rich profile pages.
- Multi-game tournaments if daily MVP is not stable.

## 17. Phased Implementation Plan

### Phase V2-0: Architecture and Policy

- Finalize submit vs auto-submit policy.
- Finalize disconnect/resume policy.
- Choose backend stack.
- Define account, privacy, and terms requirements.
- Define official attempt and replay schemas.

### Phase V2-1: Backend Foundation

- Auth.
- User profiles.
- Event/puzzle database.
- Official attempt lifecycle.
- Replay storage.
- Admin event publishing.

### Phase V2-2: Daily Official Ranking MVP

- Mobile Official Ranking screen.
- Web official game page.
- Start official attempt.
- Submit official attempt.
- Daily leaderboard finalization job after 22:00 Eastern.
- Ranking points ledger.

### Phase V2-3: Replay Sharing

- Server replay viewer.
- Share replay URL.
- Share card with official event result.
- Privacy controls.

### Phase V2-4: Tournaments

- Saturday three-game mini tournament.
- Third-Saturday five-game monthly tournament.
- Tournament leaderboard.
- Tournament certificate.

### Phase V2-5: Packs and Website Commerce

- Remote pack manifest.
- Additional training packs.
- Official event pack pipeline.
- Optional purchase/download flow from `orbacesudoku.com`.

### Phase V2-6: Hardening and Scale

- Anti-cheat review tools.
- Device/app integrity checks.
- Load testing.
- Observability.
- Data retention tooling.
- Customer support tooling.

## 18. Open Questions

1. Should official attempts auto-submit on completion, or require explicit player submission?
2. If a player starts an official game and the app crashes, is the attempt lost, abandoned, or resumable?
3. Should official games be playable only in app, only on web, or both at launch?
4. Should web gameplay allow keyboard-first expert input?
5. Should replay be public by default, private by default, or submission-dependent?
6. Should annual ranking be based on all points, best N events, or streak-weighted points?
7. How will underage players, privacy, and regional compliance be handled?

## 19. Success Metrics

V2 success indicators:

- 20%+ of active V1 players create accounts.
- 10%+ of registered players start at least one official daily game per week.
- 70%+ official game completion rate among started attempts.
- 50%+ submit rate among completed official attempts.
- Replay share rate above 5% of submitted attempts.
- Daily leaderboard return rate improves week over week during beta.
- No unresolved high-severity ranking integrity defects during beta.

## 20. Summary

Global Ranking should be a new V2 layer, not a change to V1 local ranking. V1 remains calm, local, and learning-focused. V2 adds official competitive play through account-based events, server validation, web gameplay, official replays, and global leaderboards.

The key product distinction:

- **Local Ranking**: personal official records for built-in puzzles on one device.
- **Compare Su-Pu**: study tool for any two records of the same puzzle.
- **Global Ranking**: account-based official event competition with server-side rules and published leaderboards.
