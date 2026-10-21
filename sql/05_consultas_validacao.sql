USE mundial2026;
GO

-- 1. Contagem de linhas nas tabelas (esperado: 48, 104, 104, 16, 7, 601, 48)
SELECT 'stg_teams' AS tabela, COUNT(*) AS linhas FROM stg_teams
UNION ALL SELECT 'stg_matches', COUNT(*) FROM stg_matches
UNION ALL SELECT 'stg_match_details', COUNT(*) FROM stg_match_details
UNION ALL SELECT 'stg_venues', COUNT(*) FROM stg_venues
UNION ALL SELECT 'stg_tornement_stages', COUNT(*) FROM stg_tornement_stages
UNION ALL SELECT 'stg_match_events', COUNT(*) FROM stg_match_events
UNION ALL SELECT 'classificacao_grupo', COUNT(*) FROM classificacao_grupo;

-- 2. Jogos em que o resultado difere entre CSV e JSON (esperado: 0 linhas)
SELECT d.match_id, d.home_score AS json_casa, m.home_score AS csv_casa,
       d.away_score AS json_fora, m.away_score AS csv_fora
FROM stg_match_details d
JOIN stg_matches m ON m.match_id = d.match_id
WHERE d.home_score <> m.home_score OR d.away_score <> m.away_score;

-- 3. Nomes das equipas da casa do JSON sem correspondência em stg_teams (esperado: 0 linhas)
SELECT DISTINCT d.home_team
FROM stg_match_details d
LEFT JOIN stg_teams t ON t.team_name = d.home_team
WHERE t.team_id IS NULL;

-- 4. Nomes das visitantes do JSON sem correspondência em stg_teams (esperado: 0 linhas)
SELECT DISTINCT d.away_team
FROM stg_match_details d
LEFT JOIN stg_teams t ON t.team_name = d.away_team
WHERE t.team_id IS NULL;

-- 5. Jogos que existem só numa das duas fontes (esperado: 0 linhas)
SELECT COALESCE(d.match_id, m.match_id) AS match_id
FROM stg_match_details d
FULL OUTER JOIN stg_matches m ON m.match_id = d.match_id
WHERE d.match_id IS NULL OR m.match_id IS NULL;