# Common Lounge

A colourful browser lounge for small groups of friends. Create a room, share its URL, chat, pin tea, solve one of ten Motive mysteries, and play Guess the Person, Mafia & Doctor, or Pacheesa together.

## Features

- Supabase Realtime room presence, chat, votes, and game events
- Persistent tea posts with likes, threaded replies, and owner deletion
- Ten illustrated collaborative murder-mystery cases
- Guess the Person for two or more players with secret locking and timed rounds
- Mafia & Doctor with private roles, night actions, voting, and win conditions
- Pacheesa with private raises and synchronized 15-second rounds
- Responsive scrapbook-inspired interface with touch-first mobile navigation
- Owner deletion for developed photos, including their cloud-storage files

## Local development

1. Copy `.env.example` to `.env.local`.
2. Add the Supabase project URL and anonymous key.
3. Install dependencies and start Vite:

```bash
npm install
npm run dev
```

## Validation

```bash
npm run typecheck
npm run build
```

## Deployment

The application is a static Vite build and can be deployed to Vercel. Configure `SUPABASE_URL` and `SUPABASE_ANON_KEY` in the Vercel project environment.

Live site: [motive-phi.vercel.app](https://motive-phi.vercel.app)
