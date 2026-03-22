/**
 * Fridgy — Netlify Function: /api/config
 *
 * Serves Supabase public config to the frontend.
 * SUPABASE_URL and SUPABASE_ANON_KEY live ONLY in Netlify
 * Environment Variables — never in source code or the browser bundle.
 *
 * Note: The anon key is safe to expose (it's designed to be public),
 * but this pattern means you never hardcode it anywhere in your repo.
 *
 * Set these in Netlify → Site Settings → Environment Variables:
 *   SUPABASE_URL
 *   SUPABASE_ANON_KEY
 */
exports.handler = async () => {
  return {
    statusCode: 200,
    headers: { 'Content-Type': 'application/json', 'Cache-Control': 'no-store' },
    body: JSON.stringify({
      url: process.env.SUPABASE_URL,
      key: process.env.SUPABASE_ANON_KEY
    })
  };
};
};
