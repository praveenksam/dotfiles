# Host config for the invest VPS. Loaded when `hostname -s` == gotthard
# Set the hostname to match: sudo hostnamectl set-hostname gotthard

export INVEST_HOME="$HOME/invest"
export DBT_PROFILES_DIR="$HOME/.dbt"

# Read-only URI for interactive exploration. The write credentials live in
# ~/invest/.env and are never exported into an interactive shell.
export INVEST_DB_URI="postgresql://claude_agent@localhost:5432/invest_db"

# --- navigation ---
alias inv="cd $INVEST_HOME"
alias invlogs="cd $INVEST_HOME/logs"
alias invdbt="cd $INVEST_HOME/dbt"

# --- database ---
alias db="docker exec -it invest-db psql -U postgres -d invest_db"
alias dbsize="docker exec invest-db psql -U postgres -d invest_db -c \"SELECT relname, pg_size_pretty(pg_total_relation_size(relid)) FROM pg_catalog.pg_statio_user_tables ORDER BY pg_total_relation_size(relid) DESC;\""
alias dbjobs="docker exec invest-db psql -U postgres -d invest_db -c 'SELECT job_name, started_at, status, rows_written FROM job_runs ORDER BY started_at DESC LIMIT 15;'"
alias dbup="cd $INVEST_HOME && docker compose up -d"
alias dbdown="cd $INVEST_HOME && docker compose down"

# --- euporie console pre-wired to invest_db ---
# Opens a console with jupysql loaded and connected. Query with %%sql cells.
alias sqlc="cd $INVEST_HOME && euporie-console --kernel-name invest"

# --- pipeline jobs (see doc 07) ---
alias ingest="sudo systemctl start ingest-prices.service ingest-filings.service"
alias brief="sudo systemctl start morning-brief.service"
alias quarterly="sudo systemctl start quarterly-cycle.service"

# --- claude, scoped to this project ---
alias ci="cd $INVEST_HOME && CLAUDE_CONFIG_DIR=~/.claude-invest claude"

# --- quick health check ---
function invstatus() {
  echo "── timers ──"
  systemctl list-timers --no-pager 2>/dev/null | grep -E 'ingest|brief|quarterly|backup' || echo "none"
  echo "\n── last job runs ──"
  dbjobs 2>/dev/null || echo "db unreachable"
  echo "\n── dbt freshness ──"
  (cd "$INVEST_HOME/dbt" 2>/dev/null && dbt source freshness 2>/dev/null | tail -5) || echo "dbt not set up yet"
  echo "\n── disk ──"
  df -h / | tail -1
}
