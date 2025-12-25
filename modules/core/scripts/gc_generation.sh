#!/usr/bin/env bash
set -e

echo "=== delete old gens ==="
nix-collect-garbage --delete-older-than 30d

echo "=== store gc ==="
nix store gc

echo "=== optimise ==="
nix store optimise
