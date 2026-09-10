#!/usr/bin/env bash
# Usage:
#   scripts/lc.sh fetch <slug> [--langs elixir,python]
#   scripts/lc.sh run <filepath> [--submit]
#
# `run` derives the problem slug from the containing directory name and the
# language from the file extension, so it can be pointed at "the file the
# IDE currently has open" (e.g. problems/0001-two-sum/solution.ex) without
# typing the slug or --lang by hand.
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<'EOF' >&2
Usage:
  scripts/lc.sh fetch <slug> [--langs elixir,python]
  scripts/lc.sh run <filepath> [--submit]
EOF
  exit 1
}

lang_from_ext() {
  case "$1" in
    ex) echo elixir ;;
    erl) echo erlang ;;
    py) echo python ;;
    go) echo go ;;
    *) echo "unknown solution extension: .$1" >&2; exit 1 ;;
  esac
}

cmd="${1:-}"
[ -n "$cmd" ] || usage
shift

case "$cmd" in
  fetch)
    slug="${1:-}"
    [ -n "$slug" ] || usage
    shift
    exec elixir "$script_dir/fetch_problem.exs" "$slug" "$@"
    ;;

  run)
    filepath="${1:-}"
    [ -n "$filepath" ] || usage
    shift

    [ -f "$filepath" ] || { echo "no such file: $filepath" >&2; exit 1; }

    slug="$(basename "$(dirname "$filepath")")"
    ext="${filepath##*.}"
    lang="$(lang_from_ext "$ext")"

    exec elixir "$script_dir/run_solution.exs" "$slug" --lang "$lang" "$@"
    ;;

  *)
    usage
    ;;
esac
