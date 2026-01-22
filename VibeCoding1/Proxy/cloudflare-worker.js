/**
 * Cloudflare Worker proxy for Aladin TTB API
 * - Keeps TTBKey on server side only
 * - App calls: https://<worker-domain>/aladin/<endpoint>.aspx?Query=...&...
 *
 * Deploy:
 * 1) wrangler init
 * 2) put TTB_KEY in Secrets: wrangler secret put TTB_KEY
 * 3) route /aladin/*
 */

export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    // Expect: /aladin/ItemSearch.aspx or /aladin/ItemList.aspx ...
    const parts = url.pathname.split("/").filter(Boolean);
    if (parts.length < 2 || parts[0] !== "aladin") {
      return new Response("Not Found", { status: 404 });
    }

    const endpoint = parts.slice(1).join("/");
    const upstream = new URL(`http://www.aladin.co.kr/ttb/api/${endpoint}`);

    // Copy query params + inject ttbkey
    url.searchParams.forEach((v, k) => upstream.searchParams.set(k, v));
    upstream.searchParams.set("ttbkey", env.TTB_KEY);

    const res = await fetch(upstream.toString(), {
      method: "GET",
      headers: { "Accept": "application/json" }
    });

    // Pass through
    return new Response(res.body, {
      status: res.status,
      headers: {
        "content-type": res.headers.get("content-type") ?? "application/json; charset=utf-8",
        "cache-control": "public, max-age=60"
      }
    });
  }
}
