# Terminal-native data tooling. Cross-platform — genuinely more useful on the
# VPS than on the Mac, since it replaces tunnelling to a GUI for quick queries.

# --- Jupyter kernels via uv (unchanged from your .zshrc) ---
# Register current project's uv venv as a Jupyter kernel
kernel-add() {
  local name="${1:-$(basename $PWD)}"
  local pyver=$(uv run python --version 2>&1 | awk '{print $2}')
  uv add --dev ipykernel
  uv add --dev jupysql
  uv run python -m ipykernel install --user \
    --name "$name" \
    --display-name "$name ($pyver)"
  echo "✓ Kernel '$name' registered for Python $pyver"
}

# Remove a registered kernel
kernel-rm() {
  jupyter kernelspec uninstall "$1"
}

# List all kernels
kernel-ls() {
  jupyter kernelspec list
}

# --- euporie shortcuts ---
alias en="euporie-notebook"
alias ec="euporie-console"
alias ep="euporie-preview"

# --- dbt ---
alias dr="dbt run"
alias dt="dbt test"
alias dbuild="dbt build"
alias dcomp="dbt compile"
alias ddocs="dbt docs generate && dbt docs serve"
alias dfresh="dbt source freshness"
