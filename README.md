# leetcode (Elixir)

Personal LeetCode archive, solved outside the web GUI, in whatever language
fits the problem. Problems are scaffolded from LeetCode's (unofficial)
GraphQL API; solved-status stats are synced the same way.

Scripts are standalone `.exs` files using `Mix.install/1` — no Mix project,
no `mix deps.get`. First run downloads `req` via Hex and caches it; after
that it's instant.

## Setup

```bash
cp config.example .config
# fill in LEETCODE_SESSION and LEETCODE_CSRF_TOKEN (see below)
```

### Getting your session cookie

`sync_stats.exs` needs to read your *own* solved-problem list, which means
authenticating as you. `fetch_problem.exs` (pulling problem statements) does
**not** need auth — it works with an empty `.env`.

To get the cookie values: log into leetcode.com in your browser, open dev
tools → Application/Storage → Cookies, and copy the values of
`LEETCODE_SESSION` and `csrftoken`. These are session credentials, not API
keys — treat them the same way (never commit `.env`, rotate if leaked).

## Usage

Scaffold a new problem folder with statement + solution stub:

```bash
elixir scripts/fetch_problem.exs two-sum --langs elixir,python
```

This creates `problems/0001-two-sum/` with the problem statement in
`README.md` and empty `solution.ex` / `solution.py` stubs (pre-filled with
LeetCode's starter code where available).


## Layout

```
problems/
  0001-two-sum/
    README.md       # problem statement, pulled via API
    solution.ex
    solution.py
    notes.md         # your own notes, optional
scripts/
  common.exs         # shared GraphQL client (Req-based)
  fetch_problem.exs   # scaffold a problem folder
```

