#!/usr/bin/env bash
# CI gate for agent-runner (ADR-0018) on this fork: the upstream CLAUDE.md pre-commit checks.
# Not part of the upstream PR.
set -euo pipefail
cd "$(dirname "$0")"
export PATH="$HOME/.cargo/bin:$PATH"
# One shared build cache for all runner worktrees (cargo locks it, so parallel runs just wait).
export CARGO_TARGET_DIR="${CARGO_TARGET_DIR:-$HOME/.cache/spark-dashboard-target}"

# rust-embed needs frontend/dist, so the frontend is always built first.
(cd frontend && npm ci --no-audit --no-fund --loglevel=error && npm run lint && npm run build \
  && npm test -- --run)

cargo fmt --all -- --check
cargo clippy --all-targets --locked -- -D warnings
cargo test --locked
