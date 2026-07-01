# Orbace Sudoku V2 — Development Playbook  
  
**Version**: 1.0  
**Date**: 2026-06-29  
**Audience**: All development teams  
**Purpose**: Coding standards, file organization, naming conventions, testing guidelines, and workflow for the Orbace Sudoku V2 monorepo  
  
---  
  
## Table of Contents  
  
1. [General Rules (All Teams)](#1-general-rules-all-teams)  
2. [App Dev Team (Flutter Mobile + Web)](#2-app-dev-team-flutter-mobile--web)  
3. [Web Dev Team (Flutter Web)](#3-web-dev-team-flutter-web)  
4. [Backend Dev Team (TypeScript)](#4-backend-dev-team-typescript)  
5. [Testing Team (QA)](#5-testing-team-qa)  
6. [Git Workflow](#6-git-workflow)  
7. [Code Review Checklist](#7-code-review-checklist)  
  
---  
  
## 1. General Rules (All Teams)  
  
### 1.1 Repository Structure (DO NOT CHANGE)  
  
```  
orbace-sudoku/  
├── apps/  
│   ├── mobile/          # App Team primary workspace  
│   └── web/             # Web Team primary workspace  
├── packages/  
│   ├── sudoku_engine/   # Shared — App Team owns, Backend Team consumes models  
│   ├── sudoku_models/   # Shared — Any team can add models (PR review required)  
│   ├── sudoku_ui/       # Shared — App + Web Teams contribute widgets  
│   └── sudoku_api/      # Shared — Backend Team owns API client interfaces  
├── backend/  
│   ├── org-api/         # Backend Team primary workspace  
│   ├── edge-functions/  # Backend Team  
│   └── admin/           # Backend Team  
├── infra/  
│   ├── supabase/        # Backend Team owns  
│   ├── vercel/          # Web Team + Backend Team  
│   └── fly/             # Backend Team  
├── tools/  
│   ├── puzzle_gen/      # App Team owns  
│   └── scripts/         # All teams  
├── docs/                # All teams  
├── melos.yaml  
└── README.md  
```  
  
### 1.2 Naming Conventions  
  
| Element | Convention | Example | Wrong |  
|---------|-----------|---------|-------|  
| **Files** | snake_case | `org_card.dart` | `OrgCard.dart` |  
| **Classes** | PascalCase | `OrgCardWidget` | `orgCardWidget` |  
| **Variables** | camelCase | `playerName` | `player_name` |  
| **Constants** | camelCase (Dart) / UPPER_SNAKE_CASE (TypeScript) | `maxRpPerDay` / `MAX_RP_PER_DAY` | — |  
| **Functions** | camelCase | `calculateSpeedBonus()` | `CalculateSpeedBonus()` |  
| **Database columns** | snake_case | `player_id` | `playerId` |  
| **API endpoints** | kebab-case | `/org/submit-result` | `/org/submitResult` |  
| **JSON keys** | snake_case | `{ "player_id": "..." }` | `{ "playerId": "..." }` |  
| **Git branches** | kebab-case with prefix | `feature/org-card-states` | `orgCardStates` |  
| **Commits** | conventional commits | `feat(org): add submission validation` | `added stuff` |  
  
### 1.3 Commit Convention  
  
```  
feat(scope): description       # New feature  
fix(scope): description        # Bug fix  
refactor(scope): description   # Code restructuring  
test(scope): description       # Adding tests  
docs(scope): description       # Documentation  
chore(scope): description      # Build, CI, dependencies  
  
Scopes:  
  mobile, web, engine, models, ui, api, backend, infra, tools  
```  
  
### 1.4 Branch Naming  
  
```  
feature/<short-description>    # New feature  
fix/<short-description>        # Bug fix  
refactor/<short-description>   # Code restructuring  
hotfix/<short-description>     # Production emergency  
  
Examples:  
  feature/org-card-state-machine  
  fix/leaderboard-tiebreaker  
  refactor/supu-model-extraction  
  hotfix/org-submission-timeout  
```  
  
### 1.5 Pull Request Rules  
  
- **PR title** must follow commit convention  
- **PR description** must include: What changed, Why, How to test, Screenshots (if UI)  
- **Minimum 1 reviewer** from a different team for shared package changes  
- **CI must pass** (tests, analyze, lint) before merge  
- **No direct commits to main** — everything via PR  
  
### 1.6 Where to Find Things  
  
| I need to... | Go here |  
|--------------|---------|  
| Add a new domain model | `packages/sudoku_models/lib/src/models/` |  
| Add a shared UI widget | `packages/sudoku_ui/lib/src/widgets/` |  
| Add puzzle logic | `packages/sudoku_engine/lib/src/` |  
| Add an API endpoint (client) | `packages/sudoku_api/lib/src/` |  
| Add an API endpoint (server) | `backend/org-api/src/routes/` |  
| Add a database migration | `infra/supabase/migrations/` |  
| Add a screen to mobile app | `apps/mobile/lib/features/<feature>/` |  
| Add a page to web app | `apps/web/lib/features/<feature>/` |  
| Write a cron job | `backend/edge-functions/supabase/functions/` |  
| Generate puzzles | `tools/puzzle_gen/` |  
  
---  
  
## 2. App Dev Team (Flutter Mobile + Web)  
  
### 2.1 Your Domains  
  
| You Own | You Contribute To | You Consume |  
|---------|-------------------|-------------|  
| `apps/mobile/` | `packages/sudoku_ui/` | `packages/sudoku_engine/` |  
| `tools/puzzle_gen/` | `packages/sudoku_models/` | `packages/sudoku_models/` |  
| — | `packages/sudoku_api/` | `packages/sudoku_api/` |  
  
### 2.2 File Organization: Mobile App  
  
```  
apps/mobile/lib/  
├── main.dart                          # Entry point. Minimal logic.  
├── app.dart                           # MaterialApp, router, theme  
│  
├── features/                          # Feature-based organization  
│   ├── home/  
│   │   ├── home_screen.dart           # Screen widget  
│   │   ├── widgets/                   # Screen-specific widgets  
│   │   │   ├── tea_moment_card.dart  
│   │   │   ├── org_card.dart          # 9-state card  
│   │   │   ├── continue_playing_card.dart  
│   │   │   └── supu_preview_card.dart  
│   │   └── bloc/                      # State management (if using BLoC)  
│   │       ├── home_bloc.dart  
│   │       ├── home_event.dart  
│   │       └── home_state.dart  
│   │  
│   ├── gameplay/  
│   │   ├── game_screen.dart           # Standard gameplay  
│   │   ├── org_game_screen.dart       # ORG gameplay (no pause, no hints)  
│   │   ├── completion_screen.dart     # Post-solve  
│   │   └── widgets/  
│   │       ├── board_section.dart  
│   │       ├── number_pad_section.dart  
│   │       └── org_rules_banner.dart  
│   │  
│   ├── ranking/  
│   │   ├── ranking_tab.dart  
│   │   ├── leaderboard_screen.dart  
│   │   └── player_profile_screen.dart  
│   │  
│   ├── supu/  
│   │   ├── record_hall_screen.dart    # 藏谱阁  
│   │   ├── supu_detail_screen.dart  
│   │   └── compare_screen.dart        # 对谱  
│   │  
│   ├── account/  
│   │   ├── sign_in_screen.dart  
│   │   ├── sign_up_screen.dart  
│   │   ├── privacy_screen.dart  
│   │   └── delete_account_screen.dart  
│   │  
│   ├── growth/  
│   │   ├── scholar_path_screen.dart  
│   │   └── extreme_challenge_screen.dart  
│   │  
│   └── settings/  
│       └── settings_screen.dart  
│  
├── navigation/  
│   ├── app_router.dart                # GoRouter configuration  
│   └── bottom_nav_bar.dart            # 5-tab seal icon bar  
│  
├── platform/                          # Platform-specific implementations  
│   ├── push_notifications.dart        # FCM + APNs abstraction  
│   ├── secure_storage.dart            # Keychain/Keystore wrapper  
│   └── device_fingerprint.dart        # Device ID for anti-cheat  
│  
└── theme/  
    └── app_theme.dart                 # ThemeData configuration  
```  
  
### 2.3 Screen Naming Convention  
  
```  
Pattern: <feature>_<type>.dart  
  
Types:  
  _screen.dart     — Full screen widget (top-level route)  
  _card.dart       — A card widget within a screen  
  _dialog.dart     — A dialog/popup  
  _sheet.dart      — A bottom sheet  
  _tab.dart        — A tab within a tab bar  
  
Examples:  
  home_screen.dart           ✅  
  org_card.dart              ✅  
  rules_confirmation_dialog.dart  ✅  
  leaderboard_screen.dart    ✅  
  HomePage.dart              ❌ (wrong naming convention)  
  orgCard.dart               ❌ (should be snake_case)  
```  
  
### 2.4 Widget Structure Rules  
  
```dart  
// ✅ CORRECT: Screen file structure  
//  
// File: home_screen.dart  
  
import 'package:flutter/material.dart';  
import 'package:sudoku_models/sudoku_models.dart';  // Shared models  
import 'package:sudoku_ui/sudoku_ui.dart';          // Shared widgets  
import 'package:sudoku_api/sudoku_api.dart';         // API client  
import 'widgets/tea_moment_card.dart';               // Local widgets  
import 'bloc/home_bloc.dart';                        // State management  
  
/// Home screen — first tab of bottom navigation.  
///  
/// Displays Tea Moment, Daily Ranking card, Continue Playing,  
/// Su-Pu preview, and Growth preview.  
class HomeScreen extends StatefulWidget {  
  const HomeScreen({super.key});  
  
  @override  
  State<HomeScreen> createState() => _HomeScreenState();  
}  
  
class _HomeScreenState extends State<HomeScreen> {  
  // ...  
}  
```  
  
### 2.5 State Management  
  
**Rule**: Use Riverpod for all state management.  
  
```dart  
// ✅ CORRECT: Riverpod provider  
// File: providers/org_status_provider.dart  
  
import 'package:riverpod_annotation/riverpod_annotation.dart';  
import 'package:sudoku_api/sudoku_api.dart';  
  
part 'org_status_provider.g.dart';  
  
@riverpod  
class OrgStatusNotifier extends _$OrgStatusNotifier {  
  @override  
  Future<OrgStatus> build() async {  
    final api = ref.read(orgApiClientProvider);  
    return api.getStatus();  
  }  
  
  Future<void> refresh() async {  
    state = const AsyncLoading();  
    state = await AsyncValue.guard(() => ref.read(orgApiClientProvider).getStatus());  
  }  
}  
```  
  
### 2.6 Testing Rules  
  
```dart  
// ✅ CORRECT: Test file alongside source  
// File: home_screen_test.dart (same directory as home_screen.dart)  
  
void main() {  
  group('HomeScreen', () {  
    testWidgets('shows Tea Moment card when loaded', (tester) async {  
      await tester.pumpWidget(  
        ProviderScope(  
          overrides: [  
            orgStatusProvider.overrideWith((ref) => OrgStatus(  
              todayEvent: null,  
              playerStatus: PlayerStatus.notSignedIn,  
            )),  
          ],  
          child: const MaterialApp(home: HomeScreen()),  
        ),  
      );  
        
      expect(find.text('今日茶局'), findsOneWidget);  
      expect(find.text('Tea Moment'), findsOneWidget);  
    });  
  
    testWidgets('shows ORG card with sign-in prompt when no account', (tester) async {  
      // ...  
      expect(find.text('Sign in to participate'), findsOneWidget);  
    });  
  });  
}  
```  
  
### 2.7 When to Put Code in Shared Packages  
  
| Situation | Where to Put It |  
|-----------|-----------------|  
| Widget used ONLY in mobile | `apps/mobile/lib/features/<feature>/widgets/` |  
| Widget used in BOTH mobile and web | `packages/sudoku_ui/lib/src/widgets/` |  
| Model used in BOTH mobile and backend | `packages/sudoku_models/lib/src/models/` |  
| API client used in BOTH mobile and web | `packages/sudoku_api/lib/src/` |  
  
**Rule of thumb**: If you write it twice, extract it to packages.  
  
---  
  
## 3. Web Dev Team (Flutter Web)  
  
### 3.1 Your Domains  
  
| You Own | You Contribute To | You Consume |  
|---------|-------------------|-------------|  
| `apps/web/` | `packages/sudoku_ui/` | `packages/sudoku_engine/` |  
| `infra/vercel/` | `packages/sudoku_api/` | `packages/sudoku_models/` |  
  
### 3.2 File Organization: Web App  
  
```  
apps/web/lib/  
├── main.dart  
├── app.dart  
│  
├── features/  
│   ├── landing/  
│   │   ├── landing_page.dart  
│   │   └── widgets/  
│   │       ├── hero_section.dart  
│   │       ├── feature_showcase.dart  
│   │       └── leaderboard_preview.dart  
│   │  
│   ├── player/  
│   │   ├── web_player_screen.dart  
│   │   └── widgets/  
│   │       ├── keyboard_shortcuts_overlay.dart  
│   │       └── desktop_board_layout.dart  
│   │  
│   ├── replay/  
│   │   └── public_replay_viewer.dart  # /supu/{id} route  
│   │  
│   ├── leaderboard/  
│   │   └── public_leaderboard_page.dart  
│   │  
│   └── account/  
│       ├── sign_in_page.dart  
│       └── privacy_page.dart  
│  
├── routes/  
│   └── web_router.dart                # GoRouter with URL-based routes  
│  
├── platform/  
│   ├── keyboard_shortcuts.dart        # Web keyboard handling  
│   ├── browser_storage.dart           # localStorage wrapper  
│   └── seo_meta.dart                  # Meta tags for social sharing  
│  
└── theme/  
    └── web_theme.dart                 # Web-specific theme overrides  
```  
  
### 3.3 Web-Specific Patterns  
  
```dart  
// ✅ CORRECT: Keyboard shortcut handling  
// File: platform/keyboard_shortcuts.dart  
  
/// Registers keyboard shortcuts for the web player.  
///  
/// Shortcuts:  
///   1-9: Input number  
///   Arrow keys: Navigate cells  
///   Space: Toggle notes  
///   Backspace/Delete: Erase cell  
///   H: Hint (if available)  
///   ?: Show shortcuts overlay  
class KeyboardShortcutManager {  
  final Map<LogicalKeyboardKey, VoidCallback> _shortcuts = {};  
    
  void register(LogicalKeyboardKey key, VoidCallback action) {  
    _shortcuts[key] = action;  
  }  
    
  KeyEventResult handleKeyEvent(FocusNode node, KeyEvent event) {  
    if (event is KeyDownEvent) {  
      final action = _shortcuts[event.logicalKey];  
      action?.call();  
      return KeyEventResult.handled;  
    }  
    return KeyEventResult.ignored;  
  }  
}  
```  
  
### 3.4 SEO Rules  
  
```dart  
// ✅ CORRECT: Set meta tags for each page  
// File: platform/seo_meta.dart  
  
import 'package:seo/seo.dart';  
  
void setPageMetaTags({  
  required String title,  
  required String description,  
  required String canonicalUrl,  
}) {  
  // Title tag  
  document.title = '$title — Orbace Sudoku';  
    
  // Meta description  
  final metaDesc = MetaTag('description', description);  
  document.head?.append(metaDesc.render());  
    
  // Open Graph (for social sharing)  
  final ogTitle = MetaTag('og:title', title);  
  document.head?.append(ogTitle.render());  
    
  // Canonical URL  
  final canonical = LinkTag('canonical', canonicalUrl);  
  document.head?.append(canonical.render());  
}  
  
// Usage in landing page:  
// setPageMetaTags(  
//   title: 'Calm Puzzles. Real Progress.',  
//   description: 'The Sudoku app that respects your focus...',  
//   canonicalUrl: 'https://orbacesudoku.com',  
// );  
```  
  
### 3.5 Web Testing Rules  
  
```dart  
// ✅ CORRECT: Test with different viewport sizes  
void main() {  
  group('LandingPage', () {  
    testWidgets('renders correctly on desktop', (tester) async {  
      tester.view.physicalSize = const Size(1440, 900);  
      tester.view.devicePixelRatio = 1.0;  
        
      await tester.pumpWidget(const MaterialApp(home: LandingPage()));  
        
      // Desktop should show horizontal layout  
      expect(find.text('Download on App Store'), findsOneWidget);  
    });  
  
    testWidgets('renders correctly on mobile web', (tester) async {  
      tester.view.physicalSize = const Size(390, 844);  
      tester.view.devicePixelRatio = 3.0;  
        
      await tester.pumpWidget(const MaterialApp(home: LandingPage()));  
        
      // Mobile should stack vertically  
      expect(find.text('Download on App Store'), findsOneWidget);  
    });  
  });  
}  
```  
  
---  
  
## 4. Backend Dev Team (TypeScript)  
  
### 4.1 Your Domains  
  
| You Own | You Contribute To | You Consume |  
|---------|-------------------|-------------|  
| `backend/org-api/` | `infra/supabase/migrations/` | Sudoku solver logic (via Dart package or reimplementation) |  
| `backend/edge-functions/` | `packages/sudoku_models/` (JSON schema) | — |  
| `backend/admin/` | — | — |  
| `infra/fly/` | — | — |  
  
### 4.2 File Organization: ORG API (Fly.io)  
  
```  
backend/org-api/  
├── package.json  
├── tsconfig.json  
├── .env.example                       # Template for environment variables  
├── Dockerfile  
│  
├── prisma/  
│   ├── schema.prisma                  # Database schema (source of truth)  
│   └── migrations/                    # Auto-generated by Prisma  
│  
├── src/  
│   ├── index.ts                       # Fastify server entry point  
│   ├── config.ts                      # Environment variable loading  
│   │  
│   ├── routes/  
│   │   ├── health.routes.ts           # GET /health  
│   │   ├── org.routes.ts              # ORG submission routes  
│   │   ├── auth.routes.ts             # UUID account routes  
│   │   └── leaderboard.routes.ts      # Leaderboard query routes  
│   │  
│   ├── services/  
│   │   ├── submission.service.ts      # Submission validation + storage  
│   │   ├── validation.service.ts      # Anti-cheat validation logic  
│   │   ├── leaderboard.service.ts     # Redis sorted set management  
│   │   ├── scoring.service.ts         # RP calculation  
│   │   └── notification.service.ts    # Push notification dispatch  
│   │  
│   ├── middleware/  
│   │   ├── auth.middleware.ts         # JWT verification  
│   │   ├── rate-limit.middleware.ts   # Rate limiting  
│   │   └── error-handler.middleware.ts  
│   │  
│   └── lib/  
│       ├── prisma.ts                  # Prisma client singleton  
│       ├── redis.ts                   # Upstash Redis client singleton  
│       ├── sentry.ts                  # Sentry initialization  
│       └── logger.ts                  # Structured logging (Pino)  
│  
└── tests/  
    ├── routes/  
    │   ├── org.routes.test.ts  
    │   └── auth.routes.test.ts  
    ├── services/  
    │   ├── submission.service.test.ts  
    │   └── validation.service.test.ts  
    └── helpers/  
        ├── setup.ts                   # Test database setup  
        └── factories.ts               # Test data factories  
```  
  
### 4.3 TypeScript Naming Conventions  
  
```typescript  
// ✅ CORRECT: File naming  
// org.routes.ts        — Route definitions  
// submission.service.ts — Business logic services  
// auth.middleware.ts    — Middleware  
// prisma.ts            — Singleton clients  
  
// ❌ WRONG:  
// OrgRoutes.ts         — PascalCase files  
// submission_service   — Underscores instead of dots  
  
// ✅ CORRECT: Function naming  
async function calculateSpeedBonus(submissions: OrgSubmission[]): Promise<void> { }  
async function validateReplayHash(hash: string, puzzleId: string): Promise<boolean> { }  
  
// ✅ CORRECT: Interface naming  
interface OrgSubmissionPayload { }  
interface LeaderboardEntry { }  
  
// ❌ WRONG:  
interface IOrgSubmission { }  // No Hungarian notation  
```  
  
### 4.4 Service Pattern  
  
```typescript  
// ✅ CORRECT: Service class pattern  
// File: src/services/submission.service.ts  
  
import { PrismaClient } from '@prisma/client';  
import { Redis } from '@upstash/redis';  
import { captureException } from '@sentry/node';  
import { logger } from '../lib/logger';  
  
export class SubmissionService {  
  constructor(  
    private readonly prisma: PrismaClient,  
    private readonly redis: Redis,  
  ) {}  
  
  /**  
   * Validates and stores an ORG submission.  
   *  
   * @param payload — The submission data from the client  
   * @returns The validated submission with calculated bonuses  
   * @throws {ValidationError} If submission fails validation  
   */  
  async submit(payload: OrgSubmissionPayload): Promise<SubmissionResult> {  
    // 1. Validate time window  
    this.validateTimeWindow(payload.eventId);  
  
    // 2. Check duplicate  
    await this.ensureNoDuplicate(payload.eventId, payload.playerId);  
  
    // 3. Validate replay hash  
    const hashValid = await this.validateReplayHash(  
      payload.replayHash,  
      payload.puzzleId,  
    );  
    if (!hashValid) {  
      throw new ValidationError('Replay hash mismatch');  
    }  
  
    // 4. Calculate completion bonus  
    const completionBonus = this.calculateCompletionBonus(  
      payload.completed,  
      payload.errorCount,  
      payload.hintCount,  
    );  
  
    // 5. Store submission  
    const submission = await this.prisma.orgSubmission.create({  
      data: {  
        eventId: payload.eventId,  
        playerId: payload.playerId,  
        supuId: payload.supuId,  
        completed: payload.completed,  
        errorCount: payload.errorCount,  
        hintCount: payload.hintCount,  
        elapsedSeconds: payload.elapsedSeconds,  
        completionBonus,  
        totalRp: completionBonus,  
        submittedForSpeed: payload.submittedForSpeed,  
        replayHash: payload.replayHash,  
        validationStatus: 'accepted',  
      },  
    });  
  
    // 6. Update Redis for live leaderboard  
    if (payload.submittedForSpeed && payload.completed) {  
      await this.redis.zadd(  
        `org:live:${payload.eventId}`,  
        { score: payload.elapsedSeconds!, member: payload.playerId },  
      );  
    }  
  
    logger.info({ submissionId: submission.submissionId }, 'Submission accepted');  
    return { submissionId: submission.submissionId, completionBonus };  
  }  
  
  private calculateCompletionBonus(  
    completed: boolean,  
    errorCount: number,  
    hintCount: number,  
  ): number {  
    if (!completed) return 10;  
    const totalIssues = errorCount + hintCount;  
    if (totalIssues >= 3) return 20;  
    if (totalIssues === 2) return 30;  
    if (totalIssues === 1) return 50;  
    return 100; // Clean solve  
  }  
}  
```  
  
### 4.5 Route Pattern  
  
```typescript  
// ✅ CORRECT: Fastify route definition  
// File: src/routes/org.routes.ts  
  
import { FastifyInstance, FastifyRequest, FastifyReply } from 'fastify';  
import { SubmissionService } from '../services/submission.service';  
import { authMiddleware } from '../middleware/auth.middleware';  
  
interface SubmitBody {  
  eventId: string;  
  supuId: string;  
  completed: boolean;  
  errorCount: number;  
  hintCount: number;  
  elapsedSeconds?: number;  
  submittedForSpeed: boolean;  
  replayHash: string;  
  clientVersion: string;  
  platform: 'ios' | 'android' | 'web';  
}  
  
export async function orgRoutes(app: FastifyInstance): Promise<void> {  
  // All ORG routes require authentication  
  app.addHook('onRequest', authMiddleware);  
  
  // POST /org/submit  
  app.post<{ Body: SubmitBody }>(  
    '/org/submit',  
    {  
      schema: {  
        body: {  
          type: 'object',  
          required: ['eventId', 'supuId', 'completed', 'submittedForSpeed'],  
          properties: {  
            eventId: { type: 'string' },  
            supuId: { type: 'string' },  
            completed: { type: 'boolean' },  
            errorCount: { type: 'integer', minimum: 0 },  
            hintCount: { type: 'integer', minimum: 0 },  
            elapsedSeconds: { type: 'integer', minimum: 0 },  
            submittedForSpeed: { type: 'boolean' },  
            replayHash: { type: 'string' },  
            clientVersion: { type: 'string' },  
            platform: { type: 'string', enum: ['ios', 'android', 'web'] },  
          },  
        },  
      },  
    },  
    async (request: FastifyRequest<{ Body: SubmitBody }>, reply: FastifyReply) => {  
      const submissionService = request.di.get(SubmissionService);  
        
      try {  
        const result = await submissionService.submit({  
          ...request.body,  
          playerId: request.playerId!, // Set by auth middleware  
        });  
          
        return reply.status(201).send(result);  
      } catch (error) {  
        if (error instanceof ValidationError) {  
          return reply.status(422).send({ error: error.message });  
        }  
        throw error;  
      }  
    },  
  );  
}  
```  
  
### 4.6 Database Migration Rules  
  
```sql  
-- ✅ CORRECT: Migration file  
-- File: infra/supabase/migrations/005_add_tournament_support.sql  
  
-- Add tournament_id to official_events  
ALTER TABLE official_events  
ADD COLUMN tournament_id TEXT;  
  
-- Create index for tournament queries  
CREATE INDEX idx_events_tournament   
ON official_events(tournament_id)   
WHERE tournament_id IS NOT NULL;  
  
-- Add tournament results table  
CREATE TABLE leaderboard_tournament (  
  tournament_id TEXT PRIMARY KEY,  
  event_type TEXT NOT NULL,  
  results_json JSONB NOT NULL,  
  total_participants INTEGER NOT NULL,  
  finalized_at TIMESTAMPTZ NOT NULL DEFAULT NOW()  
);  
  
-- ❌ WRONG:  
-- - Do not modify existing migrations — create new ones  
-- - Do not include data changes in schema migrations (use seed files)  
-- - Do not use "IF EXISTS" without a clear rollback plan  
```  
  
### 4.7 Backend Testing Rules  
  
```typescript  
// ✅ CORRECT: Service test  
// File: tests/services/submission.service.test.ts  
  
import { describe, it, expect, beforeAll, afterAll } from 'vitest';  
import { SubmissionService } from '../../src/services/submission.service';  
import { createTestDatabase, clearTestDatabase } from '../helpers/setup';  
import { createValidSubmission } from '../helpers/factories';  
  
describe('SubmissionService', () => {  
  let service: SubmissionService;  
  
  beforeAll(async () => {  
    const db = await createTestDatabase();  
    const redis = createTestRedis();  
    service = new SubmissionService(db, redis);  
  });  
  
  afterAll(async () => {  
    await clearTestDatabase();  
  });  
  
  describe('submit', () => {  
    it('accepts a valid clean submission', async () => {  
      const payload = createValidSubmission({  
        completed: true,  
        errorCount: 0,  
        hintCount: 0,  
      });  
  
      const result = await service.submit(payload);  
  
      expect(result.completionBonus).toBe(100);  
    });  
  
    it('calculates completion bonus for 1 error', async () => {  
      const payload = createValidSubmission({  
        completed: true,  
        errorCount: 1,  
        hintCount: 0,  
      });  
  
      const result = await service.submit(payload);  
  
      expect(result.completionBonus).toBe(50);  
    });  
  
    it('rejects duplicate submission', async () => {  
      const payload = createValidSubmission();  
      await service.submit(payload);  
  
      await expect(service.submit(payload)).rejects.toThrow('Duplicate submission');  
    });  
  
    it('rejects submission outside time window', async () => {  
      const payload = createValidSubmission({  
        submittedAt: new Date('2026-06-29T23:00:00Z'), // After 22:00 ET  
      });  
  
      await expect(service.submit(payload)).rejects.toThrow('Window closed');  
    });  
  });  
});  
```  
  
---  
  
## 5. Testing Team (QA)  
  
### 5.1 Testing Levels  
  
| Level | Who | What | When |  
|-------|-----|------|------|  
| **Unit** | Developers | Individual functions, widgets, services | Every PR |  
| **Integration** | Developers | API routes, database queries, cross-package | Every PR for backend |  
| **Widget** | Developers + QA | UI screens, state transitions | Before merging to main |  
| **End-to-End** | QA | Full user journeys | Weekly during development, daily before launch |  
| **Manual Exploratory** | QA | Edge cases, UX feel, accessibility | Each phase completion |  
| **Load** | Backend + QA | ORG submission concurrency, leaderboard queries | Phase 6 |  
  
### 5.2 Test Data  
  
```  
Test accounts (use these for all testing):  
  
Tier 0 (Anonymous):  
  - No account. Can play Tea Moment, Level Packs.  
  - Cannot access Ranking tab.  
  
Tier 1 (Auto-UUID):  
  - player_id: test-uuid-001  
  - friendly_name: TestPuzzle_001  
  - Can participate in ORG  
  - Cannot have custom display name  
  
Tier 2 (Registered):  
  - email: testplayer@orbace.com  
  - password: Test123!@#  
  - display_name: TestSolver  
  - Full access  
  
Tier 2 (Social Auth):  
  - Google: orbacetest@gmail.com  
  - Apple: orbacetest@privaterelay.appleid.com  
  
Admin:  
  - email: admin@orbace.com  
  - Can create ORG events, view audit logs  
```  
  
### 5.3 Test Cases by Feature  
  
#### Home Screen  
  
| ID | Test Case | Expected Result | Priority |  
|----|-----------|----------------|----------|  
| HOME-001 | Anonymous user opens app | Tea Moment card primary. ORG card shows "Sign in to participate." Bottom nav: 5 tabs, Ranking shows lock icon. | P0 |  
| HOME-002 | Registered user during ORG window | ORG card shows LIVE state with countdown. "Start Ranking Game" button active. | P0 |  
| HOME-003 | Registered user, ORG in progress | ORG card shows "Attempt in progress — no pause." Resume button. | P0 |  
| HOME-004 | Registered user, ORG submitted | ORG card shows provisional rank. Countdown to results. | P0 |  
| HOME-005 | Results published | ORG card shows final rank, RP breakdown, share button. | P0 |  
| HOME-006 | Continue Playing card | Shows in-progress puzzle with percentage and last played time. | P1 |  
| HOME-007 | Su-Pu preview card | Shows count: "247 Su-Pu · 42 clean." Taps to Record Hall. | P1 |  
  
#### ORG Gameplay  
  
| ID | Test Case | Expected Result | Priority |  
|----|-----------|----------------|----------|  
| ORG-001 | Start ORG | Rules confirmation dialog appears. Must tap "I Understand." | P0 |  
| ORG-002 | ORG gameplay | Timer visible. Hints grayed out. Auto-check disabled indicator. Window countdown. | P0 |  
| ORG-003 | Background app during ORG | Warning appears. If backgrounded, attempt marked abandoned. 10 RP earned. | P0 |  
| ORG-004 | Complete ORG | Completion screen shows Solve Score + Completion Bonus. "Submit" vs "Keep Local." | P0 |  
| ORG-005 | Submit ORG | Loading animation. Success shows provisional rank. Su-Pu saved to Record Hall. | P0 |  
| ORG-006 | Submit ORG with hints used | Completion bonus earned but speed bonus forfeited. 习谱 classification. | P0 |  
| ORG-007 | Submit after 22:00 ET | Submission rejected with "Window closed" message. | P0 |  
| ORG-008 | Resubmit same ORG | Rejected with "Already submitted" message. | P0 |  
  
#### Leaderboard  
  
| ID | Test Case | Expected Result | Priority |  
|----|-----------|----------------|----------|  
| LB-001 | View daily leaderboard (no account) | Full leaderboard visible. Player row not highlighted. | P0 |  
| LB-002 | View daily leaderboard (account, not submitted) | Full leaderboard visible. "You did not participate today." | P0 |  
| LB-003 | View daily leaderboard (submitted) | Own row highlighted. Rank, RP, time shown. | P0 |  
| LB-004 | Tap leaderboard row | Shows mini-profile or replay option. | P1 |  
| LB-005 | Switch to Weekly/Monthly/Annual | Correct data loaded. | P1 |  
| LB-006 | Live leaderboard during window | Top 10 shown. "847 submissions" updates. | P1 |  
  
#### Account & Privacy  
  
| ID | Test Case | Expected Result | Priority |  
|----|-----------|----------------|----------|  
| ACC-001 | Create account via Google | Redirect to Google. Return to app with display name screen. | P0 |  
| ACC-002 | Create account via Apple | Redirect to Apple. Return to app with display name screen. | P0 |  
| ACC-003 | Create account via Email | Form validation. Email verification sent. | P0 |  
| ACC-004 | Auto-UUID creation | Open Ranking tab first time. Friendly name assigned. | P0 |  
| ACC-005 | Upgrade UUID → Registered | History transferred. Name changed on past leaderboards. | P0 |  
| ACC-006 | Change privacy to Private | ORG replay no longer public. Leaderboard still shows name. | P1 |  
| ACC-007 | Share as Anonymous | Shared replay shows "Anonymous Orbace Player." | P1 |  
| ACC-008 | Delete account | Confirmation with name typing. Data removed. Leaderboard shows "Anonymous." | P1 |  
| ACC-009 | Underage registration | Restricted account created. No ranking. No sharing. | P1 |  
  
#### Web Platform  
  
| ID | Test Case | Expected Result | Priority |  
|----|-----------|----------------|----------|  
| WEB-001 | Landing page loads | Hero section with seal. App store CTAs. Leaderboard preview. | P0 |  
| WEB-002 | Play Tea Moment on web | Board interactive. Keyboard shortcuts work. | P0 |  
| WEB-003 | View shared replay | /supu/{id} shows full playback. No account needed. | P0 |  
| WEB-004 | Sign in on web | Same account as mobile. Syncs progress. | P1 |  
| WEB-005 | ORG on web | Same rules as mobile. Browser close warning. | P1 |  
| WEB-006 | Responsive layout | Desktop (1440px), Tablet (768px), Mobile (390px) all correct. | P1 |  
  
### 5.4 Bug Reporting Template  
  
```  
Title: [Feature] Short description  
  
Severity:  
  P0 — Crash, data loss, ranking integrity, cannot submit ORG  
  P1 — Feature broken, wrong data displayed, accessibility blocker  
  P2 — Visual issue, minor UX annoyance, edge case  
  P3 — Cosmetic, enhancement request  
  
Environment:  
  Platform: iOS 18.2 / Android 15 / Chrome 126  
  Device: iPhone 15 Pro / Pixel 8 / MacBook Pro  
  App Version: 2.0.0 (build 142)  
  Account: testplayer@orbace.com  
  
Steps to Reproduce:  
  1. Open app  
  2. Navigate to Ranking tab  
  3. Tap on Daily leaderboard  
  4. ...  
  
Expected Result:  
  Leaderboard shows today's results with player's row highlighted.  
  
Actual Result:  
  Leaderboard shows yesterday's results. Date header is correct but data is stale.  
  
Screenshot/Video: [Attach]  
  
Additional Context:  
  Happens after app has been in background for >1 hour.  
```  
  
---  
  
## 6. Git Workflow  
  
### 6.1 Daily Workflow  
  
```bash  
# 1. Start the day — get latest  
git checkout main  
git pull origin main  
melos bootstrap  # Update dependencies if changed  
  
# 2. Create feature branch  
git checkout -b feature/org-card-state-machine  
  
# 3. Make changes, commit frequently  
git add apps/mobile/lib/features/home/widgets/org_card.dart  
git commit -m "feat(mobile): add ORG card state 4 (window open, not started)"  
  
git add packages/sudoku_models/lib/src/models/org_event.dart  
git commit -m "feat(models): add OrgCardState enum with 9 states"  
  
# 4. Run tests before pushing  
melos exec --scope="mobile" -- flutter test  
melos exec --scope="sudoku_models" -- dart test  
  
# 5. Push and create PR  
git push origin feature/org-card-state-machine  
# Create PR on GitHub  
```  
  
### 6.2 PR Review Process  
  
```  
1. Author creates PR with:  
   - Descriptive title (conventional commit format)  
   - Description: what, why, how to test  
   - Screenshots/video for UI changes  
   - Linked issue (if applicable)  
  
2. CI must pass:  
   ✅ Lint (melos analyze)  
   ✅ Tests (melos test)  
   ✅ Build (mobile: flutter build, web: flutter build web)  
  
3. Reviewer(s):  
   - Package changes: reviewer from different team  
   - Mobile-only changes: another mobile dev  
   - Backend changes: another backend dev  
  
4. Reviewer checks:  
   - Code follows this playbook  
   - Tests cover new functionality  
   - No breaking changes to shared packages  
   - UI matches Figma design (if applicable)  
  
5. Merge when:  
   - At least 1 approval  
   - All comments resolved  
   - CI green  
```  
  
### 6.3 Branch Cleanup  
  
```bash  
# After PR is merged, delete the branch  
git branch -d feature/org-card-state-machine  
  
# Periodically clean up local branches  
git fetch --prune  
git branch -vv | grep 'gone]' | awk '{print $1}' | xargs git branch -D  
```  
  
---  
  
## 7. Code Review Checklist  
  
### 7.1 All Code  
  
- [ ] Follows naming conventions (Section 1.2)  
- [ ] Files in correct directories (Section 1.6)  
- [ ] Commit messages follow conventional commit format (Section 1.3)  
- [ ] No commented-out code  
- [ ] No `print()` statements (use logger)  
- [ ] No hardcoded values (use constants or config)  
- [ ] Error handling present (no uncaught exceptions)  
- [ ] Sensitive data never logged or printed  
  
### 7.2 Dart/Flutter Code  
  
- [ ] Widget file has a doc comment explaining its purpose  
- [ ] State management uses Riverpod (not setState for complex state)  
- [ ] UI widget tested with `testWidgets` for key states  
- [ ] Shared widget extracted to `packages/sudoku_ui/` if used in both mobile and web  
- [ ] Model class has `fromJson` and `toJson` methods  
- [ ] No business logic in widget files (extract to services/providers)  
  
### 7.3 TypeScript Code  
  
- [ ] Route has JSON schema validation  
- [ ] Service has unit tests for success and error cases  
- [ ] Database queries use parameterized inputs (no SQL injection)  
- [ ] Prisma schema changes accompanied by migration file  
- [ ] Rate limiting applied to public endpoints  
- [ ] Errors caught and returned with appropriate HTTP status codes  
  
### 7.4 Database  
  
- [ ] Migration file is additive (no destructive changes without rollback plan)  
- [ ] New columns have appropriate defaults or are nullable  
- [ ] Indexes created for new query patterns  
- [ ] Migration tested on staging database before production  
  
### 7.5 Security  
  
- [ ] JWT token validated on all authenticated endpoints  
- [ ] Player can only access their own data (Row-Level Security or app-level check)  
- [ ] User input validated and sanitized  
- [ ] No secrets in code (use environment variables)  
- [ ] Rate limiting on auth endpoints  
  
---  
  
## Quick Reference Cards  
  
### App Dev Team  
  
```  
Where to put a new screen:  
  apps/mobile/lib/features/<feature>/<name>_screen.dart  
  
Where to put a shared widget:  
  packages/sudoku_ui/lib/src/widgets/<category>/<name>.dart  
  
How to run tests:  
  cd apps/mobile && flutter test  
  
How to run the app:  
  cd apps/mobile && flutter run  
  
How to add a dependency:  
  cd apps/mobile  
  flutter pub add <package>  
  # If shared package: update pubspec.yaml with path: ../../packages/<name>  
```  
  
### Web Dev Team  
  
```  
Where to put a new page:  
  apps/web/lib/features/<feature>/<name>_page.dart  
  
Where to put a shared widget:  
  packages/sudoku_ui/lib/src/widgets/<category>/<name>.dart  
  
How to run tests:  
  cd apps/web && flutter test  
  
How to run the app:  
  cd apps/web && flutter run -d chrome  
  
How to deploy:  
  git push main  # Vercel auto-deploys  
```  
  
### Backend Dev Team  
  
```  
Where to put a new route:  
  backend/org-api/src/routes/<name>.routes.ts  
  
Where to put business logic:  
  backend/org-api/src/services/<name>.service.ts  
  
How to run tests:  
  cd backend/org-api && npm test  
  
How to run locally:  
  cd backend/org-api && npm run dev  
  
How to create a migration:  
  cd backend/org-api && npx prisma migrate dev --name <description>  
  
How to deploy:  
  git push main  # GitHub Actions deploys to Fly.io  
```  
  
### Testing Team  
  
```  
Where to find test cases:  
  docs/ (PRDs) + this playbook (Section 5.3)  
  
Where to log bugs:  
  GitHub Issues with template from Section 5.4  
  
Test accounts:  
  See Section 5.2  
  
How to run a specific test:  
  Ask dev team for the command (varies by package)  
```  
  
---  
  
*End of Orbace Sudoku V2 Development Playbook*  
