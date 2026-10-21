# TP1 – Integração de Sistemas de Informação

**Integração e análise das seleções do Mundial de 2026** (grupos, classificações, confederações e alertas de resultados)

Licenciatura em Engenharia de Sistemas Informáticos · Escola Superior de Tecnologia do IPCA · 2026/27

- **Autor:** [Nome completo] · Nº [número] · [email]
- **Repositório:** https://github.com/13andre/TP_ISI_2026
- **Vídeo de demonstração:** [inserir link ou QR code]

---

## 1. O que faz este trabalho

Processo ETL (Extract, Transform, Load) construído com o **Pentaho Data Integration (Kettle) Community** que:

1. **Extrai** dados do Mundial de 2026 de duas origens e dois formatos: ficheiros **CSV** (seleções, jogos, estádios, fases e eventos) e um ficheiro **JSON** (detalhe dos jogos), carregando-os para tabelas de *staging* numa base de dados **SQL Server**.
2. **Transforma** os dados: valida o formato das horas com uma **expressão regular**, cruza as duas fontes para validar resultados e nomes das seleções, calcula a **classificação da fase de grupos** (pontos, vitórias, empates, derrotas, golos e diferença de golos, com posição por grupo e confederação) e identifica **alertas de resultados** (goleadas com diferença igual ou superior a 4 golos).
3. **Carrega** a classificação na base de dados e **exporta-a em CSV, JSON e XML**, gerando também o ficheiro de alertas.

Os cinco processos são orquestrados por um **Job** (`main_job.kjb`) com tratamento de erro (ramos para *Abort job*) e registo em log.

## 2. Estrutura do repositório

```
TP_ISI_2026/
├── README.md
├── docs/            relatório e diagramas (prints)
├── raw/             dados de entrada (CSV e JSON)
├── sql/             scripts SQL (base, tabelas, validações)
├── workflows/       transformações (.ktr) e job (.kjb)
├── export/          ficheiros gerados pelo processo
├── logs/            log de execução do Job
├── config/          reservada (sem uso nesta versão)
└── nodered/         reservada (sem uso nesta versão)
```

| Ficheiro | Função |
|---|---|
| `workflows/fase1_csv.ktr` | Fase 1 – lê 5 CSV e grava `stg_teams`, `stg_matches`, `stg_venues`, `stg_tornement_stages`, `stg_match_events` |
| `workflows/fase1_json.ktr` | Fase 1 – lê o JSON e grava `stg_match_details` |
| `workflows/fase2_classificacao.ktr` | Fase 2 – calcula a classificação por grupo e grava `classificacao_grupo` |
| `workflows/fase2_alertas.ktr` | Fase 2 – valida horas (regex) e gera alertas de goleadas |
| `workflows/fase3_exportacao.ktr` | Fase 3 – exporta a classificação para CSV, JSON e XML |
| `workflows/main_job.kjb` | Job que executa as transformações por ordem, com tratamento de erro e log |

## 3. Requisitos

- **Pentaho Data Integration (Kettle) Community 10.2** (`pdi-ce-10.2.0.0-222`)
- **Java** (testado com JDK 11.0.31)
- **SQL Server** (testado com SQL Server Express, instância `localhost\SQLEXPRESS`) e, opcionalmente, o SQL Server Management Studio
- **Driver JDBC da Microsoft** (`mssql-jdbc`, versão `jre11`): copiar o `.jar` para `data-integration/lib` do Kettle e reiniciar o Spoon
- A autenticação SQL Server tem de estar ativa (modo misto) e o protocolo **TCP/IP** ativo na porta **1433**

## 4. Como executar

1. **Preparar a base de dados.** No SQL Server, executar por ordem os scripts de `sql/`:
   - `01_criar_base_e_utilizador.sql` – cria a base `mundial2026` e o login `kettle`. A palavra-passe é a que consta no próprio script; deve ser a mesma usada na ligação do Kettle (ou alterada nos dois sítios).
   - `02_criar_tabelas.sql` – cria as tabelas de *staging* e de resultados.
2. **Ligação do Kettle.** Os ficheiros `.ktr` usam a ligação `mundial2026` (tipo *MS SQL Server (Native)*, host `localhost`, porta `1433`, base `mundial2026`, utilizador `kettle`, com os parâmetros `encrypt=true` e `trustServerCertificate=true`). Se necessário, ajustar em *Edit connection*.
3. **Executar.** Abrir o `workflows/main_job.kjb` no Spoon (`data-integration/Spoon.bat`) e carregar em *Run*. Os caminhos usam `${Internal.Entry.Current.Directory}`, por isso o projeto deve manter a estrutura de pastas.
4. **Em alternativa, linha de comandos (Kitchen)**, a partir da pasta `data-integration`:

```
.\Kitchen.bat /file:<caminho>\workflows\main_job.kjb /level:Basic /logfile:<caminho>\logs\execucao.log
```

O código de saída `0` indica que o Job terminou sem erros.

## 5. Resultados esperados

| Tabela / ficheiro | Esperado |
|---|---|
| `stg_teams` | 48 linhas |
| `stg_matches` | 104 linhas |
| `stg_match_details` | 104 linhas |
| `stg_venues` | 16 linhas |
| `stg_tornement_stages` | 7 linhas |
| `stg_match_events` | 601 linhas |
| `classificacao_grupo` | 48 linhas (12 grupos × 4 seleções, `played` = 3) |
| `export/classificacao.csv`, `.json`, `.xml` | 48 seleções cada |
| `export/alertas.csv` | 4 alertas (diferença de golos ≥ 4) |

As consultas de `sql/03_consultas_validacao.sql` comparam as duas fontes (CSV e JSON) e devem devolver **0 linhas** nas verificações de discrepâncias.

## 6. Fontes de dados

- **FIFA World Cup 2026 Dataset** (licença CC0): https://github.com/mominullptr/FIFA-World-Cup-2026-Dataset
  - `teams.csv`, `matches.csv`, `venues.csv`, `tournament_stages.csv`, `match_events.csv`, `real_match_details.json`

## 7. Notas

- O nome da tabela `stg_tornement_stages` mantém uma gralha de escrita ("tornement") por ter sido criada assim na primeira execução; não afeta o funcionamento.
- A classificação ordena por pontos, diferença de golos e golos marcados; não implementa os critérios de desempate adicionais da FIFA (confronto direto, fair play).
- Funcionalidades previstas como trabalho futuro (relatório, secção 7): notificações por email, transferência por SFTP, dashboard, streaming MQTT dos eventos e carregamento dos golos individuais.
