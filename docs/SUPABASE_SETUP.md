# Supabase Setup Guide (SignalCircle MVP)

## 1) Create project
1. Create a new Supabase project in the dashboard.
2. Copy values from **Project Settings → API**:
   - Project URL
   - Publishable (anon) key

## 2) Apply schema
1. Open SQL Editor.
2. Run `supabase/schema.sql`.
3. Verify that RLS is enabled on all app tables.

## 3) Auth settings
- Enable Email provider.
- Optional: enable Google or GitHub social login.
- Add redirect URLs for local/prod dashboard routes.

## 4) Front-end env contract
For the future React/Vite implementation:

```bash
VITE_SUPABASE_URL=https://YOUR-PROJECT.supabase.co
VITE_SUPABASE_PUBLISHABLE_KEY=YOUR_ANON_KEY
```

## 5) Realtime
Enable Realtime for `posts`, `comments`, and `likes` tables, then subscribe in the dashboard client so circle feeds update instantly.

## 6) Storage
Create a public or signed-access bucket named `avatars` for profile photos.
