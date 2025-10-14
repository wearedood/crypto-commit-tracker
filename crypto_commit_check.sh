#!/usr/bin/env bash
# ---------------------------------------------------------------
# crypto_commit_check.sh
# Verifies the number of GitHub commits made to key crypto repos.
# ---------------------------------------------------------------

# Directory to clone repositories into
WORKDIR="${HOME}/crypto_repos"
mkdir -p "$WORKDIR"
cd "$WORKDIR" || exit 1

# List of repositories to track
REPOS=(
  "bitcoin/bitcoin"
  "ethereum/go-ethereum"
  "ethereum/solidity"
  "monero-project/monero"
  "litecoin-project/litecoin"
  "smartcontractkit/chainlink"
  "input-output-hk/cardano-node"
  "paritytech/polkadot"
  "xmrig/xmrig"
)

echo "---------------------------------------------------------------"
echo " Verifying commit counts for curated crypto repositories"
echo " Location: $WORKDIR"
echo "---------------------------------------------------------------"

printf "%%-35s | %%10s | %%10s\n" "Repository" "Commits" "Updated"
echo "---------------------------------------------------------------"

for REPO in "${REPOS[@]}"; do
  NAME=$(basename "$REPO")

  # Clone or update the repo (shallow fetch if already exists)
  if [ -d "$NAME/.git" ]; then
    cd "$NAME" || continue
    git fetch --all --quiet
  else
    git clone --quiet --mirror "https://github.com/${REPO}.git" "$NAME"
    cd "$NAME" || continue
  fi

  # Count commits (all branches)
  COUNT=$(git rev-list --all --count 2>/dev/null || echo "N/A")
  UPDATED=$(git log -1 --format="%cs" 2>/dev/null || echo "N/A")

  printf "%%-35s | %%10s | %%10s\n" "$REPO" "$COUNT" "$UPDATED"

  cd "$WORKDIR" || exit 1
done

echo "---------------------------------------------------------------"
echo " Done! All counts reflect the total commits across all branches."
echo "---------------------------------------------------------------"      
