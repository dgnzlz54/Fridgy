# Fridgy 🧊
### Your Dinner Decision Engine

A smart kitchen & meal planning app for households — scan your pantry, get AI-powered recipe suggestions, calculate per-person portions based on fitness goals, and plan your week.

---

## 🚀 Deploy in 5 Minutes

### 1. Supabase Setup

1. Go to [supabase.com](https://supabase.com) → **New Project**
2. Choose a name (e.g. `fridgy`), set a strong password, pick a region
3. Once created, go to **Settings → API**
4. Copy your **Project URL** and **anon public** key
5. Go to **SQL Editor** and run the contents of `supabase/schema.sql`

### 2. Add Environment Variables to Netlify

1. In your Netlify site → **Site Settings → Environment Variables**
2. Add these two:

```
SUPABASE_URL        = https://your-project.supabase.co
SUPABASE_ANON_KEY   = your-anon-key-here
```

> **Or** edit `public/index.html` directly — search for `YOUR_PROJECT` and `YOUR_ANON_KEY_HERE` and replace them.

### 3. GitHub → Netlify

1. Push this repo to GitHub
2. Go to [netlify.com](https://netlify.com) → **Add new site → Import from Git**
3. Connect your GitHub repo
4. Build settings are auto-detected from `netlify.toml`
5. Deploy! ✅

---

## 📁 Project Structure

```
fridgy/
├── public/
│   ├── index.html          ← Main app (single page)
│   ├── mascot.webp         ← Fridgy character illustration
│   ├── logo-wordmark.webp  ← Fridgy logo text
│   ├── full-logo.webp      ← Full logo with character
│   └── intro.mp4           ← Loading screen animation
├── supabase/
│   └── schema.sql          ← Database schema (run this in Supabase)
├── netlify.toml            ← Netlify config
├── .gitignore
└── README.md
```

---

## 🗄️ Supabase Tables

| Table | Purpose |
|-------|---------|
| `profiles` | One per user, linked to auth |
| `household_members` | People in the household with fitness goals |
| `pantry_items` | Food items with expiry tracking |
| `shopping_items` | Grocery list |
| `meal_plans` | Weekly meal schedule |

All tables have **Row Level Security** — users can only see their own data.

---

## 🤖 AI Features

The app uses **Claude (claude-sonnet-4)** via the Anthropic API for recipe suggestions. It takes into account:
- What's in your pantry (prioritising items expiring soon)
- Each person's calorie & macro targets (calculated via Mifflin-St Jeor)
- Dietary restrictions & dislikes (never violated)
- Whether leftovers are needed for next day's lunch

The AI call happens client-side — to add your Anthropic API key securely in production, use a Netlify Function as a proxy (see `netlify/functions/` if you want to add this later).

---

## 🔧 Local Development

No build step needed — it's a plain HTML/CSS/JS app.

```bash
# Just open in browser
open public/index.html

# Or use a local server
npx serve public
```

---

## 📋 Features

- ✅ Supabase Auth (email + password)
- ✅ Household member profiles with TDEE/macro calculation
- ✅ Pantry management with expiry tracking
- ✅ Barcode scan simulation
- ✅ AI chat for recipe suggestions (Claude API)
- ✅ Per-person portion calculator
- ✅ Leftover lunch planning
- ✅ Weekly meal planner
- ✅ Shopping list with sync
- ✅ Demo mode (no login needed)

---

## 🎨 Tech Stack

- **Frontend**: Vanilla HTML/CSS/JS (no framework needed)
- **Auth + DB**: Supabase
- **AI**: Anthropic Claude API
- **Hosting**: Netlify
- **Fonts**: Google Fonts (Lora, DM Mono, Playfair Display)
