# Keep local tool dirs on PATH (idempotent when applied to a fresh machine)
fish_add_path ~/Scripts ~/.local/bin

if status is-interactive
    # Docker Compose abbreviations
    abbr -a dc 'docker compose'
    abbr -a dcu 'docker compose up -d'
    abbr -a dcub 'docker compose up -d --build'
    abbr -a dcl 'docker compose logs -f'
    abbr -a dcd 'docker compose down'
    abbr -a dcr 'docker compose restart'
    abbr -a dcp 'docker compose ps'
    abbr -a dwpmove 'docker compose --profile tools run --rm wpmovejs'
    abbr -a dwpmove-build 'docker compose --profile tools build wpmovejs'
    abbr -a dwpmove-shell 'docker compose --profile tools run --rm --entrypoint sh wpmovejs'
    abbr -a dwpcli 'docker compose run --rm wp-cli wp'
end
