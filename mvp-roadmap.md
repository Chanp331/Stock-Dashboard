# SignalCircle MVP Build Prompts (Execution Roadmap)

Use these prompts one-by-one with your coding agent to build a polished, scalable MVP.

## 1) Supabase Foundation
**Prompt:**
"Create Supabase setup docs and SQL migrations for SignalCircle. Add tables: `profiles`, `circles`, `circle_members`, `watchlists`, `posts`, `likes`, `comments`. Enable Row Level Security and add policies so users can only read/write data for circles they belong to. Add indexes and timestamps."

**Done when:**
- `supabase/schema.sql` exists and runs end-to-end.
- RLS is enabled on all app tables.
- Policies are documented and tested.

## 2) Auth + Session Wiring
**Prompt:**
"Integrate Supabase Auth with email/password and prepare social login hooks. Build a robust onboarding flow: account creation, create-or-join-circle, and profile basics. Persist session and redirect authenticated users to dashboard."

**Done when:**
- Login/onboarding has multi-step UX.
- Session check guards the dashboard route.
- Logout is available.

## 3) Front-end Scaffolding (React/Vite target)
**Prompt:**
"Scaffold a React + Vite app structure for long-term migration. Create `supabaseClient` service, `auth` service, `watchlist` service, and `feed` service layers with typed function signatures and error handling conventions."

**Done when:**
- Service modules are defined and documented.
- Environment variable contract is clear: `VITE_SUPABASE_URL`, `VITE_SUPABASE_PUBLISHABLE_KEY`.

## 4) Dashboard MVP V1
**Prompt:**
"Implement MVP dashboard IA: left nav (`Dashboard`, `My Watchlist`, `Post Signal`, `Invite Friends`), primary watchlist table, and signal feed with like/comment counts. Add empty/loading/error states and responsive layout."

**Done when:**
- Navigation and key panels are visually stable on mobile + desktop.
- Users can add/remove watchlist tickers.
- Users can post signals.

## 5) Realtime Collaboration
**Prompt:**
"Connect posts/comments/likes to Supabase Realtime so feed updates instantly across circle members. Use optimistic UI updates with rollback on failure."

**Done when:**
- Two browsers in same circle see updates live.
- No duplicate events from subscriptions.

## 6) Invites & Membership
**Prompt:**
"Implement private invite links and circle join flow. Generate secure invite tokens, enforce expiration, and map accepted invites to `circle_members`."

**Done when:**
- Invite can be generated, shared, and redeemed once.
- Unauthorized users cannot access private circle content.

## 7) Product Polish
**Prompt:**
"Refine trust-focused UI style system (typography, spacing, color tokens, states). Add accessibility checks (contrast, focus ring, semantic landmarks) and mobile-first refinements."

**Done when:**
- WCAG contrast targets are met for key screens.
- All major interactions are keyboard friendly.

## 8) V2 Enhancements
**Prompt:**
"Ship right-side activity feed, watchlist/feed tabs, persistent `Post Signal` action with modal composer, profile settings, and avatar upload via Supabase Storage."

**Done when:**
- Core V2 features are discoverable and production-ready.
- Storage upload and profile editing are stable.
