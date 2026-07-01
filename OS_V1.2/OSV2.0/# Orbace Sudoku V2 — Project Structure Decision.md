# Orbace Sudoku V2 — Project Structure Decision  
  
**Version**: 1.0  
**Date**: 2026-06-29  
**Context**: Existing V1 Flutter mobile app. Adding backend services, web platform, and V2 features.  
  
---  
  
## 1. The Decision  
  
### Recommendation: **Monorepo with Three Packages**  
  
```  
orbace-sudoku/  
├── apps/  
│   ├── mobile/          # Existing V1 Flutter app (migrated)  
│   └── web/             # Flutter Web app  
├── packages/  
│   ├── sudoku_engine/   # Shared puzzle logic (solver, generator, validator)  
│   ├── sudoku_models/   # Shared domain models (Puzzle, SuPu, Score, Attempt)  
│   ├── sudoku_ui/       # Shared UI components (board widget, number pad, seals)  
│   └── sudoku_api/      # Shared API client (Supabase, ORG endpoints)  
├── backend/  
│   ├── org-api/         # Fly.io Fastify server (ORG submission endpoint)  
│   ├── edge-functions/  # Supabase Edge Functions (cron jobs, notifications)  
│   └── admin/           # Admin panel (Flutter Web or Retool)  
├── infra/  
│   ├── supabase/        # Database migrations, seed data  
│   ├── vercel/          # Vercel configuration  
│   └── fly/             # Fly.io configuration  
├── tools/  
│   ├── puzzle_gen/      # Dart CLI for bulk puzzle generation  
│   └── scripts/         # Deployment, data migration scripts  
├── docs/                # PRDs, architecture docs, competitive analysis  
├── pubspec.yaml         # Workspace root  
├── melos.yaml           # Monorepo management (Melos)  
└── README.md  
```  
  
---  
  
## 2. Why Monorepo (Not Separate Repos)  
  
| Factor | Monorepo | Separate Repos |  
|--------|----------|----------------|  
| **Shared code (engine, models, UI)** | ✅ One version. No sync issues. | ❌ Version mismatch risk. Duplicated code or complex package publishing. |  
| **Cross-platform consistency** | ✅ Mobile and Web share widgets, API client, models. One PR updates both. | ❌ Two PRs. Two review cycles. Drift. |  
| **Database migrations** | ✅ One source of truth in `infra/supabase/`. | ❌ Which repo owns the schema? |  
| **API types** | ✅ Shared Dart models. Backend TypeScript types generated from same schema. | ❌ Types get out of sync. |  
| **CI/CD** | ✅ One pipeline. Selective builds based on changed files. | ⚠️ Multiple pipelines. Orchestration needed. |  
| **Developer onboarding** | ✅ Clone once. Everything works. | ❌ Clone 3+ repos. Set up inter-repo links. |  
| **Refactoring** | ✅ Change model → mobile + web + API client update in one commit. | ❌ Change model → publish package → update consumers → pray. |  
  
**Verdict**: Monorepo is the clear winner for a team of 4-6 building a cross-platform product with shared logic.  
  
---  
  
## 3. Detailed Package Breakdown  
  
### 3.1 `packages/sudoku_engine` — Pure Dart, Zero Dependencies on Flutter  
  
```dart  
// The core puzzle logic. No UI. No platform code.  
// Can run in Dart CLI, Flutter, server-side Dart.  
  
lib/  
├── src/  
│   ├── solver/  
│   │   ├── backtracking_solver.dart  
│   │   ├── human_ranked_solver.dart  
│   │   └── techniques/  
│   │       ├── naked_single.dart  
│   │       ├── hidden_single.dart  
│   │       ├── naked_pair.dart  
│   │       ├── hidden_pair.dart  
│   │       └── pointing_pair.dart  
│   ├── generator/  
│   │   └── puzzle_generator.dart  
│   ├── validator/  
│   │   └── puzzle_validator.dart  
│   ├── difficulty/  
│   │   └── difficulty_rater.dart  
│   └── scoring/  
│       └── score_calculator.dart  
└── sudoku_engine.dart  // Public API  
```  
  
**Consumed by**: `apps/mobile`, `apps/web`, `tools/puzzle_gen`  
  
---  
  
### 3.2 `packages/sudoku_models` — Pure Dart, Serializable  
  
```dart  
// Domain models shared across all Dart consumers.  
  
lib/  
├── src/  
│   ├── models/  
│   │   ├── puzzle.dart          // SudokuPuzzle  
│   │   ├── supu.dart            // SuPu (attempt record)  
│   │   ├── score.dart           // ScoreBreakdown  
│   │   ├── difficulty.dart      // SudokuDifficulty enum  
│   │   ├── technique.dart       // TechniqueDefinition  
│   │   ├── org_event.dart       // OfficialEvent, OrgSubmission  
│   │   ├── player.dart          // PlayerProfile, PlayerAccount  
│   │   ├── leaderboard.dart     // LeaderboardEntry, DailyLeaderboard  
│   │   └── award.dart           // ScholarPathStage, Award  
│   └── serialization/  
│       ├── from_json.dart  
│       └── to_json.dart  
└── sudoku_models.dart  
```  
  
**Consumed by**: `apps/mobile`, `apps/web`, `packages/sudoku_api`, `packages/sudoku_ui`  
  
---  
  
### 3.3 `packages/sudoku_ui` — Flutter Widget Library  
  
```dart  
// Shared UI components. Flutter dependency.  
  
lib/  
├── src/  
│   ├── widgets/  
│   │   ├── board/  
│   │   │   ├── sudoku_board.dart  
│   │   │   ├── sudoku_cell.dart  
│   │   │   └── board_highlights.dart  
│   │   ├── controls/  
│   │   │   ├── number_pad.dart  
│   │   │   ├── notes_toggle.dart  
│   │   │   └── undo_redo.dart  
│   │   ├── seals/  
│   │   │   ├── seal_widget.dart       // Vermilion seal with character  
│   │   │   └── seal_animation.dart  
│   │   ├── certificates/  
│   │   │   └── score_certificate.dart  
│   │   ├── leaderboard/  
│   │   │   ├── leaderboard_list.dart  
│   │   │   └── leaderboard_row.dart  
│   │   └── common/  
│   │       ├── orbace_button.dart  
│   │       ├── orbace_card.dart  
│   │       └── loading_states.dart  
│   └── themes/  
│       ├── ink_wash_theme.dart  
│       ├── celadon_theme.dart  
│       └── app_colors.dart  
└── sudoku_ui.dart  
```  
  
**Consumed by**: `apps/mobile`, `apps/web`  
  
---  
  
### 3.4 `packages/sudoku_api` — Dart HTTP Client  
  
```dart  
// Typed API client for Supabase and ORG endpoints.  
  
lib/  
├── src/  
│   ├── clients/  
│   │   ├── supabase_client.dart      // Supabase SDK wrapper  
│   │   └── org_api_client.dart       // Fly.io ORG endpoint client  
│   ├── repositories/  
│   │   ├── auth_repository.dart      // Sign in, sign up, upgrade  
│   │   ├── org_repository.dart       // ORG status, start, submit  
│   │   ├── leaderboard_repository.dart  
│   │   └── player_repository.dart  
│   └── middleware/  
│       ├── auth_interceptor.dart  
│       └── retry_interceptor.dart  
└── sudoku_api.dart  
```  
  
**Consumed by**: `apps/mobile`, `apps/web`  
  
---  
  
### 3.5 `apps/mobile` — iOS + Android App  
  
```dart  
// Thin app shell. Most logic in packages.  
  
lib/  
├── main.dart                          // Entry point  
├── app.dart                           // MaterialApp + Router  
├── features/  
│   ├── home/  
│   │   ├── home_screen.dart  
│   │   └── widgets/  
│   │       ├── tea_moment_card.dart  
│   │       └── org_card.dart          // 9-state card  
│   ├── gameplay/  
│   │   ├── game_screen.dart  
│   │   ├── org_game_screen.dart       // ORG-specific (no pause, no hints)  
│   │   └── completion_screen.dart  
│   ├── ranking/  
│   │   ├── ranking_tab.dart  
│   │   ├── leaderboard_screen.dart  
│   │   └── player_profile_screen.dart  
│   ├── supu/  
│   │   ├── record_hall_screen.dart    // 藏谱阁  
│   │   ├── supu_detail_screen.dart  
│   │   └── compare_screen.dart        // 对谱  
│   ├── account/  
│   │   ├── sign_in_screen.dart  
│   │   ├── privacy_screen.dart  
│   │   └── delete_account_screen.dart  
│   ├── growth/  
│   │   ├── scholar_path_screen.dart  
│   │   └── extreme_challenge_screen.dart  
│   └── settings/  
│       └── settings_screen.dart  
├── navigation/  
│   └── app_router.dart  
└── platform/  
    ├── push_notifications.dart  
    ├── secure_storage.dart  
    └── device_fingerprint.dart  
```  
  
**Dependencies**:  
- `sudoku_engine`  
- `sudoku_models`  
- `sudoku_ui`  
- `sudoku_api`  
- `drift` (local database)  
- `flutter_secure_storage`  
- `firebase_messaging` (Android push)  
- `sentry_flutter`  
  
---  
  
### 3.6 `apps/web` — Flutter Web App  
  
```dart  
// Shares packages with mobile. Web-specific features only.  
  
lib/  
├── main.dart  
├── app.dart  
├── features/  
│   ├── landing/  
│   │   └── landing_page.dart  
│   ├── player/  
│   │   └── web_player_screen.dart     // Keyboard-optimized  
│   ├── replay/  
│   │   └── public_replay_viewer.dart  // /supu/{id}  
│   └── leaderboard/  
│       └── public_leaderboard.dart  
├── platform/  
│   ├── keyboard_shortcuts.dart  
│   └── browser_storage.dart  
└── seo/  
    └── meta_tags.dart  
```  
  
**Dependencies** (same as mobile, minus native-only):  
- `sudoku_engine`  
- `sudoku_models`  
- `sudoku_ui`  
- `sudoku_api`  
- `sentry_flutter`  
  
---  
  
### 3.7 `backend/org-api` — Fly.io Fastify Server (TypeScript)  
  
```  
backend/org-api/  
├── package.json  
├── tsconfig.json  
├── src/  
│   ├── index.ts                      // Fastify server entry  
│   ├── routes/  
│   │   ├── org.routes.ts             // ORG submission routes  
│   │   ├── auth.routes.ts            // UUID registration routes  
│   │   └── health.routes.ts  
│   ├── services/  
│   │   ├── submission.service.ts  
│   │   ├── validation.service.ts     // Anti-cheat validation  
│   │   └── leaderboard.service.ts    // Redis sorted set management  
│   ├── middleware/  
│   │   ├── auth.middleware.ts  
│   │   └── rate-limit.middleware.ts  
│   └── lib/  
│       ├── prisma.ts                 // Prisma client  
│       ├── redis.ts                  // Upstash Redis client  
│       └── sentry.ts  
├── prisma/  
│   └── schema.prisma                 // Database schema (shared with edge-functions)  
└── Dockerfile  
```  
  
---  
  
### 3.8 `backend/edge-functions` — Supabase Edge Functions (TypeScript)  
  
```  
backend/edge-functions/  
├── supabase/  
│   └── functions/  
│       ├── calculate-results/  
│       │   └── index.ts              // Daily leaderboard finalization (22:05 ET)  
│       ├── publish-results/  
│       │   └── index.ts              // Publish results (23:00 ET)  
│       ├── send-notifications/  
│       │   └── index.ts              // Push notification dispatch  
│       ├── weekly-finalize/  
│       │   └── index.ts  
│       └── monthly-finalize/  
│           └── index.ts  
└── shared/  
    ├── prisma.ts                     // Same Prisma client as org-api  
    └── types.ts  
```  
  
---  
  
### 3.9 `infra/` — Infrastructure as Code  
  
```  
infra/  
├── supabase/  
│   ├── migrations/  
│   │   ├── 001_initial_schema.sql  
│   │   ├── 002_player_accounts.sql  
│   │   ├── 003_org_events.sql  
│   │   └── 004_leaderboards.sql  
│   └── seed/  
│       ├── puzzles.sql  
│       └── test_players.sql  
├── vercel/  
│   └── vercel.json                  # Routes, cron jobs, environment  
├── fly/  
│   ├── fly.toml  
│   └── Dockerfile  
└── scripts/  
    ├── deploy-all.sh  
    └── db-migrate.sh  
```  
  
---  
  
### 3.10 `tools/` — Development & Content Tools  
  
```  
tools/  
├── puzzle_gen/                       # Dart CLI (uses sudoku_engine)  
│   ├── pubspec.yaml  
│   └── bin/  
│       └── generate.dart             # Bulk puzzle generation  
└── scripts/  
    ├── seed_database.sh  
    ├── create_org_event.sh  
    └── export_player_data.sh  
```  
  
---  
  
## 4. Migration Plan: V1 Mobile App → V2 Monorepo  
  
### Step 1: Create Monorepo Structure (Day 1)  
  
```bash  
mkdir orbace-sudoku  
cd orbace-sudoku  
git init  
  
# Create directories  
mkdir -p apps/mobile apps/web  
mkdir -p packages/sudoku_engine packages/sudoku_models packages/sudoku_ui packages/sudoku_api  
mkdir -p backend/org-api backend/edge-functions backend/admin  
mkdir -p infra/supabase infra/vercel infra/fly  
mkdir -p tools/puzzle_gen tools/scripts  
mkdir -p docs  
```  
  
### Step 2: Set Up Melos (Monorepo Manager)  
  
```bash  
# Install Melos  
dart pub global activate melos  
  
# Create melos.yaml  
cat > melos.yaml << EOF  
name: orbace_sudoku  
  
packages:  
  - apps/*  
  - packages/*  
  - tools/*  
  
scripts:  
  analyze:  
    run: melos exec -- dart analyze  
  test:  
    run: melos exec -- flutter test  
  build:mobile:  
    run: melos exec --scope="mobile" -- flutter build  
  build:web:  
    run: melos exec --scope="web" -- flutter build web  
EOF  
  
melos bootstrap  
```  
  
### Step 3: Extract Shared Code from V1 (Week 1-2)  
  
**Phase 3a: Extract `sudoku_engine`**  
```bash  
# Move solver, generator, validator, difficulty rater  
# from apps/mobile/lib/engine/ → packages/sudoku_engine/lib/src/  
# Verify all tests still pass  
melos exec --scope="sudoku_engine" -- dart test  
```  
  
**Phase 3b: Extract `sudoku_models`**  
```bash  
# Move domain models  
# from apps/mobile/lib/domain/ → packages/sudoku_models/lib/src/models/  
```  
  
**Phase 3c: Extract `sudoku_ui`**  
```bash  
# Move shared widgets  
# from apps/mobile/lib/presentation/shared/ → packages/sudoku_ui/lib/src/widgets/  
```  
  
**Phase 3d: Create `sudoku_api`**  
```bash  
# Create new package with API client  
# Supabase client + ORG endpoint client  
```  
  
### Step 4: Update Mobile App Dependencies  
  
```yaml  
# apps/mobile/pubspec.yaml  
dependencies:  
  sudoku_engine:  
    path: ../../packages/sudoku_engine  
  sudoku_models:  
    path: ../../packages/sudoku_models  
  sudoku_ui:  
    path: ../../packages/sudoku_ui  
  sudoku_api:  
    path: ../../packages/sudoku_api  
```  
  
### Step 5: Create Web App (Week 3)  
  
```bash  
cd apps  
flutter create --platforms=web web  
# Update pubspec.yaml with same shared packages  
```  
  
### Step 6: Set Up Backend (Week 3-4)  
  
```bash  
cd backend/org-api  
npm init  
npm install fastify prisma @supabase/supabase-js ioredis @sentry/node  
npx prisma init  
# Point Prisma to Supabase PostgreSQL  
```  
  
---  
  
## 5. CI/CD Configuration  
  
### GitHub Actions Workflow (Selective Builds)  
  
```yaml  
# .github/workflows/ci.yml  
name: CI  
  
on:  
  push:  
    branches: [main]  
  pull_request:  
    branches: [main]  
  
jobs:  
  # Detect which packages changed  
  changes:  
    runs-on: ubuntu-latest  
    outputs:  
      mobile: ${{ steps.filter.outputs.mobile }}  
      web: ${{ steps.filter.outputs.web }}  
      backend: ${{ steps.filter.outputs.backend }}  
      engine: ${{ steps.filter.outputs.engine }}  
    steps:  
      - uses: actions/checkout@v4  
      - uses: dorny/paths-filter@v2  
        id: filter  
        with:  
          filters: |  
            mobile: apps/mobile/**  
            web: apps/web/**  
            backend: backend/**  
            engine: packages/sudoku_engine/**  
  
  # Test shared engine (always runs)  
  test-engine:  
    needs: changes  
    if: needs.changes.outputs.engine == 'true' || needs.changes.outputs.mobile == 'true' || needs.changes.outputs.web == 'true'  
    runs-on: ubuntu-latest  
    steps:  
      - uses: actions/checkout@v4  
      - uses: subosito/flutter-action@v2  
      - run: cd packages/sudoku_engine && dart test  
  
  # Build mobile  
  build-mobile:  
    needs: [changes, test-engine]  
    if: needs.changes.outputs.mobile == 'true'  
    runs-on: macos-latest  
    steps:  
      - uses: actions/checkout@v4  
      - uses: subosito/flutter-action@v2  
      - run: cd apps/mobile && flutter build ios --no-codesign  
      - run: cd apps/mobile && flutter build apk  
  
  # Build web  
  build-web:  
    needs: [changes, test-engine]  
    if: needs.changes.outputs.web == 'true'  
    runs-on: ubuntu-latest  
    steps:  
      - uses: actions/checkout@v4  
      - uses: subosito/flutter-action@v2  
      - run: cd apps/web && flutter build web  
      - uses: amondnet/vercel-action@v25  
        with:  
          vercel-token: ${{ secrets.VERCEL_TOKEN }}  
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}  
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}  
  
  # Deploy backend  
  deploy-backend:  
    needs: [changes]  
    if: needs.changes.outputs.backend == 'true'  
    runs-on: ubuntu-latest  
    steps:  
      - uses: actions/checkout@v4  
      - uses: superfly/flyctl-actions@1.4  
        with:  
          args: deploy  
        env:  
          FLY_API_TOKEN: ${{ secrets.FLY_API_TOKEN }}  
  
  # Database migration  
  migrate-db:  
    needs: [changes]  
    if: needs.changes.outputs.backend == 'true'  
    runs-on: ubuntu-latest  
    steps:  
      - uses: actions/checkout@v4  
      - run: cd backend/org-api && npx prisma migrate deploy  
        env:  
          DATABASE_URL: ${{ secrets.DATABASE_URL }}  
```  
  
---  
  
## 6. Development Workflow  
  
### Daily Development  
  
```bash  
# Clone once  
git clone https://github.com/orbace/orbace-sudoku.git  
cd orbace-sudoku  
  
# Bootstrap all packages  
melos bootstrap  
  
# Run all tests  
melos test  
  
# Run mobile app  
cd apps/mobile && flutter run  
  
# Run web app  
cd apps/web && flutter run -d chrome  
  
# Run backend locally  
cd backend/org-api && npm run dev  
  
# Generate a puzzle pack  
cd tools/puzzle_gen && dart run bin/generate.dart --difficulty expert --count 100  
```  
  
### Making Changes  
  
```bash  
# 1. Create feature branch  
git checkout -b feature/org-card-states  
  
# 2. Make changes across packages  
# packages/sudoku_models/lib/src/models/org_event.dart  (add new state enum)  
# packages/sudoku_ui/lib/src/widgets/org_card.dart       (add state UI)  
# apps/mobile/lib/features/home/widgets/org_card.dart    (wire up)  
  
# 3. Run affected tests  
melos exec --scope="sudoku_models" -- dart test  
melos exec --scope="sudoku_ui" -- flutter test  
melos exec --scope="mobile" -- flutter test  
  
# 4. Open PR  
# CI runs only affected builds  
```  
  
---  
  
## 7. Version Management  
  
### Package Versioning Strategy  
  
```  
All packages share the same version number: 2.0.0  
  - packages/sudoku_engine: 2.0.0  
  - packages/sudoku_models: 2.0.0  
  - packages/sudoku_ui: 2.0.0  
  - packages/sudoku_api: 2.0.0  
  - apps/mobile: 2.0.0  
  - apps/web: 2.0.0  
  
Rationale:  
  - Simpler than independent versioning  
  - All packages release together  
  - No compatibility matrix to maintain  
  - Melos supports unified versioning  
```  
  
---  
  
## 8. Summary: Decision Matrix  
  
| Option | Shared Code | Build Speed | Onboarding | Cross-Platform Consistency | Recommended |  
|--------|-------------|-------------|------------|---------------------------|-------------|  
| **Monorepo with Melos** | ✅ Excellent | ✅ Selective builds | ✅ One clone | ✅ Single source of truth | ✅ YES |  
| Separate repos | ❌ Package publishing overhead | ✅ Independent | ❌ Multi-repo setup | ❌ Version drift risk | ❌ |  
| Single Flutter project with folders | ⚠️ OK for small | ❌ No selective builds | ✅ Simple | ✅ Single project | ❌ (too coupled) |  
  
**Final Decision: Monorepo with Melos**  
  
```  
orbace-sudoku/  
├── apps/mobile/       # Flutter iOS + Android  
├── apps/web/          # Flutter Web  
├── packages/          # Shared Dart/Flutter libraries  
├── backend/           # TypeScript services  
├── infra/             # IaC + migrations  
├── tools/             # CLI utilities  
└── docs/              # Documentation  
```  
  
**This structure gives Orbace:**  
- Single repository for all code  
- Shared packages for engine, models, UI, and API  
- Selective CI/CD builds (only changed packages)  
- Consistent versioning across all components  
- Easy developer onboarding (clone once)  
- Backend TypeScript in same repo with shared Prisma schema  
- Infrastructure as code alongside application code  
