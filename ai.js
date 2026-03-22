/**
 * Fridgy — Netlify Function: /api/ai
 *
 * Proxies requests to the Anthropic Claude API.
 * ANTHROPIC_API_KEY lives ONLY in Netlify Environment Variables —
 * it is never exposed to the browser.
 *
 * Set these in Netlify → Site Settings → Environment Variables:
 *   ANTHROPIC_API_KEY   (your sk-ant-... key)
 */
exports.handler = async (event) => {
  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, body: 'Method Not Allowed' };
  }

  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) {
    return {
      statusCode: 500,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ error: 'ANTHROPIC_API_KEY not configured in Netlify.' })
    };
  }

  let body;
  try {
    body = JSON.parse(event.body);
  } catch {
    return { statusCode: 400, body: 'Invalid JSON body' };
  }

  try {
    const response = await fetch('https://api.anthropic.com/v1/messages', {
      method: 'POST',
      headers: {
        'Content-Type':         'application/json',
        'x-api-key':            apiKey,
        'anthropic-version':    '2023-06-01'
      },
      body: JSON.stringify({
        model:      body.model      || 'claude-sonnet-4-20250514',
        max_tokens: body.max_tokens || 1200,
        system:     body.system,
        messages:   body.messages
      })
    });

    const data = await response.json();

    return {
      statusCode: response.status,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    };
  } catch (err) {
    return {
      statusCode: 500,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ error: err.message })
    };
  }
};
