[README.md](https://github.com/user-attachments/files/26164656/README.md)
# Fridgy 🧊
### Your Dinner Decision Engine

---

## Deploy in 5 Minutes

### 1. Add assets to `/public/assets/`
Place these files in `public/assets/`:
- `logo.png` — Fridgy wordmark (transparent bg)
- `mascot.png` — Character illustration (transparent bg)
- `hero.png` — Hero composition (transparent bg)
- `intro.mp4` — Loading screen animation

### 2. Supabase Setup
1. [supabase.com](https://supabase.com) → New Project
2. Settings → API → copy **Project URL** and **anon public** key
3. SQL Editor → paste contents of `supabase/schema.sql` → Run

### 3. Configure the app
Open `public/index.html`, find these two lines near the top of `<script>`:
```js
const SUPABASE_URL     = 'https://YOUR_PROJECT.supabase.co';
const SUPABASE_ANON_KEY = 'YOUR_ANON_KEY_HERE';
```
Replace with your real values.

### 4. Push to GitHub → Deploy on Netlify
```bash
git init
git add .
git commit -m "Initial Fridgy deploy 🧊"
git remote add origin https://github.com/YOU/fridgy.git
git push -u origin main
```
Then: Netlify → New Site → Import from Git → select repo → Deploy.
`netlify.toml` handles all build config automatically.

---

## Project Structure
```
fridgy/
├── public/
│   ├── index.html           ← Full app
│   └── assets/
│       ├── logo.png         ← Wordmark (transparent)
│       ├── mascot.png       ← Character (transparent)
│       ├── hero.png         ← Hero composition (transparent)
│       └── intro.mp4        ← Loading animation
├── supabase/
│   └── schema.sql           ← Run in Supabase SQL Editor
├── netlify.toml
├── .gitignore
└── README.md
```

---

## Asset Usage Rules
| File | Used for |
|------|----------|
| `logo.png` | Header, loading screen, auth screen branding only |
| `mascot.png` | Character sections — home hero, cook page |
| `hero.png` | Landing/home hero area |
| `intro.mp4` | Loading screen video animation |

All images use `object-contain` and constrained sizing — never full-width.
