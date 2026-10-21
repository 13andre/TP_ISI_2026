SELECT 'stg_teams' AS tabela, COUNT(*) AS linhas FROM stg_teams
UNION ALL SELECT 'stg_matches', COUNT(*) FROM stg_matches
UNION ALL SELECT 'stg_venues', COUNT(*) FROM stg_venues
UNION ALL SELECT 'stg_tournament_stages', COUNT(*) FROM stg_tornement_stages
UNION ALL SELECT 'stg_match_events', COUNT(*) FROM stg_match_events;