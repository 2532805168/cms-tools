# CMS 话术管理系统

电商分销 + 自媒体内容管理工具，支持 AI 批量生成话术、媒体上传配对、分享链接。

## 部署到 GitHub Pages

### 1. 注册 Supabase
- 访问 https://supabase.com 注册免费账号
- 创建新项目
- 在 SQL Editor 执行 `supabase-schema.sql`
  - ⚠️ **重要**：此 SQL 会创建 `scripts`、`media_assets`、`pairs`、`shares` 四张表
  - ⚠️ 还会创建 Storage RLS 策略（让上传/下载不会报 403）
  - 如果是升级旧库，需先在 SQL Editor 执行 `DROP TABLE IF EXISTS pairs CASCADE;` 再跑新 SQL
- 在 Storage 创建名为 `media` 的 **Public** Bucket
  - ⚠️ Bucket 必须勾选 **Public**（公开），否则分享页图片/视频打不开
- 在 Settings → API 获取 Project URL 和 publishable key（旧版叫 anon key）

### 2. 部署到 GitHub Pages
- 创建 GitHub 公开仓库
- 将 `dist/` 目录下所有文件推送到仓库
- 在仓库 Settings → Pages 选择 main 分支 / root 目录
- 等待 1-2 分钟即可访问

### 3. 配置
- 打开 GitHub Pages 地址访问 `index.html`
- 进入「⚙️ 配置」标签页
- 填入 Supabase URL、publishable key、**仅填 GitHub Pages 根地址**（例如 `https://2532805168.github.io/cms-tools`，不要带 `/share.html?sid=xxx`）
- 保存并测试连接

## 功能
- 🤖 AI 批量生成视频文案 + 评论话术（6 大平台）
- 📋 话术管理（筛选、搜索、复制、删除）
- 🎬 媒体上传（视频/图片，带平台分类，随机配对文案）
- 🔗 分享链接（外部可直接打开复制下载）
- 📊 数据统计
- 🔒 一次性提取（A 提取后，B 自动看到「已提取」，无法再操作）
