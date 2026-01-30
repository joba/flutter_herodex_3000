# Superhero API CORS Proxy

This proxy server bypasses CORS restrictions when using superheroapi.com from web browsers.

## Setup

1. Install dependencies:

```bash
npm install
```

2. Set your API key:

```bash
export SUPERHERO_API_KEY=your_key_here
```

3. Start the server:

```bash
npm start
```

The proxy runs on `http://localhost:3000`

## For Production

Deploy to:

- **Vercel**: `vercel deploy`
- **Heroku**: `git push heroku main`
- **Railway**: Connect your repo

Then update `_corsProxy` in `lib/managers/api_manager.dart` with your deployed URL.
