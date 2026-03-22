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
  const url = process.env.SUPABASE_URL;
  const key = process.env.SUPABASE_ANON_KEY;

  if (!url || !key) {
    return {
      statusCode: 500,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ error: 'Supabase env vars not configured in Netlify.' })
    };
  }

  return {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json',
      'Cache-Control': 'no-store'            // never cache credentials
    },
    body: JSON.stringify({ url, key })
  };
};
