-- ================================================================
--  CMS 话术管理系统 - Supabase 数据库 Schema
--  在 Supabase SQL Editor 中执行此文件
-- ================================================================

-- 1. 话术表
CREATE TABLE IF NOT EXISTS scripts (
  id          bigint generated always as identity primary key,
  platform    text not null default '抖音',
  type        text not null default '评论话术',
  title       text not null,
  content     text not null,
  media       jsonb default '[]'::jsonb,
  extract_count integer default 0,
  generated   boolean default false,
  created_at  timestamptz default now()
);

-- 2. 提取记录表
CREATE TABLE IF NOT EXISTS extractions (
  id          bigint generated always as identity primary key,
  uid         text not null,
  script_id   bigint not null,
  extracted_at timestamptz default now()
);

-- 3. 媒体资产表
CREATE TABLE IF NOT EXISTS media_assets (
  id            bigint generated always as identity primary key,
  url           text not null,
  name          text not null,
  type          text not null default 'image',
  platform      text not null default '通用',
  size          bigint default 0,
  paired_script_id      bigint,
  paired_script_title   text,
  paired_script_content text,
  paired_script_type    text,
  created_at    timestamptz default now()
);

-- 4. 分享表
CREATE TABLE IF NOT EXISTS shares (
  id          bigint generated always as identity primary key,
  share_id    text not null unique,
  title       text not null default '未命名分享',
  description text default '',
  scripts     jsonb default '[]'::jsonb,
  media_assets jsonb default '[]'::jsonb,
  view_count  integer default 0,
  created_at  timestamptz default now()
);

-- ================================================================
--  Row Level Security (RLS) - 公开读写（适合分享场景）
-- ================================================================

ALTER TABLE scripts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_all_scripts" ON scripts FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE extractions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_all_extractions" ON extractions FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE media_assets ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_all_media" ON media_assets FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE shares ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_all_shares" ON shares FOR ALL USING (true) WITH CHECK (true);

-- ================================================================
--  索引（提升查询性能）
-- ================================================================
CREATE INDEX IF NOT EXISTS idx_scripts_platform ON scripts(platform);
CREATE INDEX IF NOT EXISTS idx_scripts_type ON scripts(type);
CREATE INDEX IF NOT EXISTS idx_extractions_uid ON extractions(uid);
CREATE INDEX IF NOT EXISTS idx_shares_share_id ON shares(share_id);

-- ================================================================
--  Storage Bucket（用于存储视频/图片）
--  在 Supabase Dashboard → Storage 中手动创建名为 "media" 的 bucket
--  并设置为 Public
-- ================================================================
