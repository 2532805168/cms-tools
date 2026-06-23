-- ================================================================
--  CMS 话术管理系统 - Supabase 数据库 Schema v2
--  在 Supabase SQL Editor 中执行此文件
-- ================================================================

-- 1. 话术表
CREATE TABLE IF NOT EXISTS scripts (
  id          bigint generated always as identity primary key,
  platform    text not null default '抖音',
  type        text not null default '评论话术',
  title       text not null,
  content     text not null,
  created_at  timestamptz default now()
);

-- 2. 媒体资产表
CREATE TABLE IF NOT EXISTS media_assets (
  id            bigint generated always as identity primary key,
  url           text not null,
  name          text not null,
  type          text not null default 'image',
  platform      text not null default '通用',
  size          bigint default 0,
  created_at    timestamptz default now()
);

-- 3. 配对表（核心：视频↔视频文案，图片↔评论话术，1对1）
CREATE TABLE IF NOT EXISTS pairs (
  id            bigint generated always as identity primary key,
  media_id      bigint not null,
  script_id     bigint not null,
  pair_type     text not null,
  is_extracted  boolean default false,
  extracted_by  text,
  extracted_at  timestamptz,
  created_at    timestamptz default now(),
  UNIQUE(media_id),
  UNIQUE(script_id)
);

-- 4. 分享配置表
CREATE TABLE IF NOT EXISTS shares (
  id          bigint generated always as identity primary key,
  share_id    text not null unique,
  title       text not null default '话术素材库',
  description text default '',
  view_count  integer default 0,
  created_at  timestamptz default now()
);

-- ================================================================
--  Row Level Security (RLS) - 公开读写
-- ================================================================
ALTER TABLE scripts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_all_scripts" ON scripts FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE media_assets ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_all_media" ON media_assets FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE pairs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_all_pairs" ON pairs FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE shares ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_all_shares" ON shares FOR ALL USING (true) WITH CHECK (true);

-- ================================================================
--  索引
-- ================================================================
CREATE INDEX IF NOT EXISTS idx_scripts_platform ON scripts(platform);
CREATE INDEX IF NOT EXISTS idx_scripts_type ON scripts(type);
CREATE INDEX IF NOT EXISTS idx_pairs_extracted ON pairs(is_extracted);

-- ================================================================
--  Storage Bucket
--  在 Supabase Dashboard → Storage 中创建名为 "media" 的 Public Bucket
-- ================================================================

-- ================================================================
--  Storage RLS 策略（关键！否则上传/读取会报 403）
--  对 storage.objects 表配置公开策略，仅作用于 media 桶
-- ================================================================

-- 允许所有人读取 media 桶中的文件（公开下载）
CREATE POLICY "public_read_media"
ON storage.objects FOR SELECT
USING ( bucket_id = 'media' );

-- 允许所有人上传到 media 桶（管理员前端直接上传）
CREATE POLICY "public_insert_media"
ON storage.objects FOR INSERT
WITH CHECK ( bucket_id = 'media' );

-- 允许所有人更新 media 桶中的文件（如需覆盖）
CREATE POLICY "public_update_media"
ON storage.objects FOR UPDATE
USING ( bucket_id = 'media' )
WITH CHECK ( bucket_id = 'media' );

-- 允许所有人删除 media 桶中的文件（如需清理）
CREATE POLICY "public_delete_media"
ON storage.objects FOR DELETE
USING ( bucket_id = 'media' );
