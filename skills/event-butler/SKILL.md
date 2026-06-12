---
name: event-butler
description: "飞书活动大管家：一条命令在飞书群聊中拥有全自动活动策划团队（主题确认→设计图→报名采集→作品初审→方案策划→协调汇总）"
version: 1.1.0
metadata:
  requires:
    bins: ["node", "lark-cli"]
  dependencies:
    skills:
      - jimliu/baoyu-skills@baoyu-diagram
      - jimliu/baoyu-skills@baoyu-cover-image
      - jimliu/baoyu-skills@baoyu-format-markdown
      - jimliu/baoyu-skills@baoyu-image-gen
      - jimliu/baoyu-skills@baoyu-infographic
      - obra/superpowers@brainstorming
      - obra/superpowers@writing-plans
---

# 🎉 飞书活动大管家

在飞书群聊中说一句话，7 个 AI Agent 自动协作完成整个活动策划。

## 安装

```bash
npx skills add ronds/event-butler -g -y
```

> 把 `ronds` 换成你的 GitHub 用户名

## 使用

1. 把飞书机器人拉进群
2. 在群里 @机器人：
```
@大管家 帮我策划一个 30 人的 AI 代码分享赛
```
3. 大管家会自动：主题确认 → 设计流程图 → **字段协商** → 创建报名表 → 作品初审 → 输出方案 → 生成海报

## 核心设计原则

### 🔑 字段协商（v1.1.0 新增）
报名 Agent 在创建表格前，**必须**与用户协商字段，不可跳过：
- 根据活动类型推荐字段模板
- 用户确认/增删/修改后才建表
- 避免创建出不符合实际需求的报名表

### 🔓 默认组织权限
报名表创建后自动设置组织范围内可访问：
- `link_share_entity: "tenant_readable"` — 组织内可访问
- `share_entity: "same_tenant"` — 组织内共享（飞书默认值）

### 🤖 Agent 协作 DAG
```
0️⃣主题确认 → 2️⃣设计图 → 3️⃣信息采集（含字段协商）→ 4️⃣验证/初审 → 5️⃣策划 → 6️⃣汇总
```

## 环境依赖

需要先安装一次性依赖：
- Node.js ≥ 18
- lark-cli: `npm install -g @larksuite/cli`
- 飞书应用配置: `lark-cli config init`

## 安装自检

```bash
event-butler check   # 检查所有依赖是否就绪
```
