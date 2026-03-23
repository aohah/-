-- ============================================================================
-- 国际象棋比赛数据模型 (Hive 数仓 ODS/DWD 层)
-- ============================================================================

-- 1. 俱乐部维度表
CREATE TABLE IF NOT EXISTS dim_clubs_df (
  club_id BIGINT COMMENT '俱乐部唯一ID',
  name STRING COMMENT '俱乐部名称',
  address STRING COMMENT '俱乐部地址',
  details STRING COMMENT '俱乐部其他细节'
) COMMENT '俱乐部维度表'
PARTITIONED BY (dt STRING COMMENT '日期分区');

-- 2. 棋手维度表
CREATE TABLE IF NOT EXISTS dim_players_df (
  player_id BIGINT COMMENT '棋手唯一ID',
  name STRING COMMENT '棋手名称',
  address STRING COMMENT '棋手地址',
  current_ranking INT COMMENT '当前排名 (唯一且只有1个)',
  club_id BIGINT COMMENT '当前所属俱乐部ID (满足:一个棋手只能是一个俱乐部的会员)',
  details STRING COMMENT '棋手其他细节'
) COMMENT '棋手维度表'
PARTITIONED BY (dt STRING COMMENT '日期分区');

-- 3. 赞助商维度表
CREATE TABLE IF NOT EXISTS dim_sponsors_df (
  sponsor_id BIGINT COMMENT '赞助商ID',
  name STRING COMMENT '赞助商名称',
  sponsor_type STRING COMMENT '赞助商类型(企业/政府等)'
) COMMENT '赞助商维度表'
PARTITIONED BY (dt STRING COMMENT '日期分区');

-- 4. 锦标赛事实表
CREATE TABLE IF NOT EXISTS dwd_tournaments_df (
  tournament_code STRING COMMENT '锦标赛独特代码',
  name STRING COMMENT '锦标赛名称',
  host_club_id BIGINT COMMENT '主办俱乐部ID',
  sponsor_ids ARRAY<BIGINT> COMMENT '赞助商ID列表 (满足:零个、一个或多个赞助方)',
  participant_player_ids ARRAY<BIGINT> COMMENT '参赛棋手ID列表 (满足:许多棋手)',
  start_date DATE COMMENT '开始日期',
  end_date DATE COMMENT '结束日期'
) COMMENT '锦标赛明细事实表'
PARTITIONED BY (dt STRING COMMENT '日期分区(按比赛开始日期)');

-- 5. 对局事实表
CREATE TABLE IF NOT EXISTS dwd_matches_di (
  match_id BIGINT COMMENT '对局ID',
  tournament_code STRING COMMENT '所属锦标赛代码',
  player1_id BIGINT COMMENT '选手1 ID',
  player2_id BIGINT COMMENT '选手2 ID',
  match_time TIMESTAMP COMMENT '比赛时间',
  result STRING COMMENT '比赛结果(1胜/2胜/平局/未开始)'
) COMMENT '对局明细事实表'
PARTITIONED BY (dt STRING COMMENT '日期分区(按比赛发生日期)');
