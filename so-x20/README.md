# UNO Club

A responsive, phone friendly UNO room game using React, Vite and Supabase. It includes username/password accounts, a lobby, shareable room codes, live multiplayer room updates, and up to 10 players per room.

## Run locally

1. Install Node.js 20 or newer.
2. In this folder, run `npm install`.
3. Copy `.env.example` to `.env` if you want to override the configured Supabase project values.
4. Run `npm run dev` and open the local address Vite prints.

The project URL and publishable key are configured for the browser. A publishable key is designed to be public; never put a Supabase service role key in this site.

## Supabase setup

1. Open the Supabase SQL Editor for the configured project and run all of `supabase.sql`.
2. In **Authentication → Providers → Email**, enable email/password sign in and turn off **Confirm email**. The app maps usernames to generated `@uno-club.local` addresses, so there is no email step.
3. In **Database → Publications**, make sure `uno_rooms` is included in `supabase_realtime` so room changes appear live. The app also checks for changes every few seconds as a fallback.

This prototype intentionally has permissive database policies: room contents, including hands, are readable by anyone with the project URL, and visitors can modify rooms. Use it for casual play with people you trust. It is not suitable for private or competitive games without server-side turn validation and stricter policies.

## Deploy to Netlify

Import this folder as a Netlify site. The included `netlify.toml` sets the build command to `npm run build` and publish directory to `dist`. If using Netlify environment variables, set `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` in **Site configuration → Environment variables**, then redeploy.

## Game rules included

Match by color, number, or action. Skip, Reverse (including two-player Reverse), Draw Two, Wild, and Wild Draw Four are supported; Wild Draw Four is restricted to when the player has no card matching the active color. Players draw when unable to play, can play a drawn card or pass when it matches, and call UNO at one card. Another player can catch an uncalled UNO for a two-card penalty. The first player to empty their hand wins. Draw cards do not stack.
