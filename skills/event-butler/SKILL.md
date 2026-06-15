---
name: event-butler
description: "飞书活动大管家：一条命令在飞书群聊中拥有全自动活动策划团队（主题确认→设计图→报名采集→作品初审→方案策划→协调汇总）"
version: 1.3.0
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
3. 大管家会自动完成全流程

## 核心设计原则

### 👤 发起人（v1.2.0）
每次活动自动追踪「发起人」— 即触发活动的用户：
- 所有通知（新报名、截止提醒、异常）默认发送给发起人
- 字段协商、内容确认等关键决策由发起人确认
- 发起人的 open_id 在状态表中持久化

### 📨 消息发送规范（v1.3.0）
群消息**必须**使用 `lark-cli im +messages-send`，**禁止**使用内置 `send_message` 工具：
- **超链接**：使用 post JSON 的 `a` 标签 `{"tag":"a","text":"...","href":"..."}`，飞书**不支持** Markdown `[文字](url)`
- **海报+文字**：分两条发送（`--image` + `--msg-type post --content`），图片须在 cwd
- **表单链接**：必须是发布后的 share 链接 `/share/base/form/shrcn...`

### 🔔 实时报名通知（v1.2.0）
建表后自动创建 Base 工作流，有人提交报名 → 发起人立刻收到飞书消息：
- 使用 `AddRecordTrigger` + `LarkMessageAction`
- 消息包含报名队伍信息 + 一键跳转链接

### 🔑 字段协商（v1.1.0）
报名 Agent 在创建表格前，**必须**与用户协商字段：
- 根据活动类型推荐字段模板（5 种活动类型）
- 用户确认/增删/修改后才建表

### 📋 内容二次确认（v1.1.0）
发送群通知前先展示预览，发起人确认后发送。

### 🤖 bot 入群检查（v1.1.0）
发送前检查 bot 是否在目标群中，不在则引导手动拉入。

### 🗳️ 表单发布（v1.3.0）
API 暂不支持自动发布表单，需引导用户手动点击「发布」获取 share 链接。

### 🔓 默认组织权限
- `link_share_entity: "tenant_readable"` + `share_entity: "same_tenant"`

### 🤖 Agent 协作 DAG
```
用户 @大管家 → 记录发起人
  ↓
0️⃣主题确认 → 2️⃣设计图 → 3️⃣信息采集（字段协商+实时通知+bot入群+内容确认+发布引导）
  ↓                                  ↓
4️⃣验证/初审 ←──────────────────────── 5️⃣策划
  ↓
6️⃣汇总（通知发起人）
```

## 环境依赖

- Node.js ≥ 18
- lark-cli: `npm install -g @larksuite/cli`
- 飞书应用配置: `lark-cli config init`
- bun（用于海报生成）: `curl -fsSL https://bun.sh/install | bash`
- codex CLI（用于海报生成）: `npm install -g @anthropic-ai/codex`

## 安装自检

```bash
event-butler check   # 检查所有依赖是否就绪
```
