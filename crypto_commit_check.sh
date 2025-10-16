#!/usr/bin/env bash
# ---------------------------------------------------------------
# crypto_commit_check.sh
# Verifies commit counts for major crypto & Celo repositories.
# ---------------------------------------------------------------

WORKDIR="$(pwd)/repos"
mkdir -p "$WORKDIR"
cd "$WORKDIR" || exit 1

REPOS=(
  "bitcoin/bitcoin"
  "ethereum/go-ethereum"
  "ethereum/solidity"
  "monero-project/monero"
  "smartcontractkit/chainlink"
  "input-output-hk/cardano-node"
  "paritytech/polkadot"
  "celo-org/celo-monorepo"
  "celo-org/celo-blockchain"
)

RESULTS_FILE="../commit_results.md"
echo "## 🪙 Crypto & Celo Commit Summary (auto-updated)" > "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"
echo "| Repository | Commits | Last Updated |" >> "$RESULTS_FILE"
echo "|------------|---------|--------------|" >> "$RESULTS_FILE"

for REPO in "${REPOS[@]}"; do
  NAME=$(basename "$REPO")
  if [ -d "$NAME/.git" ]; then
    cd "$NAME" || continue
    git fetch --all --quiet
  else
    git clone --quiet --mirror "https://github.com/${REPO}.git" "$NAME"
    cd "$NAME" || continue
  fi

  COUNT=$(git rev-list --all --count 2>/dev/null || echo "N/A")
  UPDATED=$(git log -1 --format="%cs" 2>/dev/null || echo "N/A")
  echo "| **${REPO}** | ${COUNT} | ${UPDATED} |" >> "$RESULTS_FILE"

  cd "$WORKDIR" || exit 1
done

echo "" >> "$RESULTS_FILE"
echo "_Updated automatically by GitHub Actions on $(date -u '+%Y-%m-%d %H:%M UTC')_" >> "$RESULTS_FILE"
