# 🎉 飞书活动大管家

> 一条命令，在飞书群聊里拥有一个全自动活动策划团队

---

## ⚡ 5 分钟安装

```bash
# 1. 运行安装脚本（自动检测环境 + 安装缺失依赖）
bash scripts/setup.sh

# 2. 首次使用需完成飞书授权
lark-cli auth login --domain all

# 3. 把机器人拉进飞书群，开始使用
```

---

## 📋 你需要准备

| 项目 | 说明 |
|------|------|
| Node.js ≥ 18 | `brew install node` / [nodejs.org](https://nodejs.org) |
| 飞书应用 | [open.feishu.cn](https://open.feishu.cn) 创建企业自建应用 |
| 一个飞书群 | 把机器人拉进去 |

---

## 🧠 它能做什么

在群里 @机器人，说一句话，自动完成整个活动策划：

```
@大管家 帮我策划一个 30 人的 AI 代码分享赛
```

大管家会自动：

| 步骤 | Agent | 产出 |
|:--:|-------|------|
| 0 | 主题确认 | 追问人数、时间、形式 → 搜同类活动 → 给 3-5 个方案方向 |
| 1 | 触发解析 | 拆解任务 → 分配 Agent |
| 2 | 设计图 | 活动流程图 + 封面图 |
| 3 | 信息采集 | 报名表（多维表格）+ 报名链接 |
| 4 | 验证/初审 | 作品自动初审（通过/待复审/拒绝） |
| 5 | 策划 | 完整活动方案文档 + 日历日程 + 宣传海报 |
| 6 | 协调汇总 | 全程监控 → 断点续传 → 最终报告 |

---

## 🛠 环境自检

```bash
bash scripts/setup.sh   # 自动检查一切
```

检查项目：
- ✅ Node.js 是否安装
- ✅ skills CLI 是否可用
- ✅ lark-cli 是否安装并配置
- ✅ 7 个必要 Skill 是否就绪
- ✅ 飞书权限是否已授权

---

## 🆘 常见问题

**Q: 安装脚本报 "lark-cli 未配置"？**
> ① 打开 [飞书开发者后台](https://open.feishu.cn) → 创建企业自建应用
> ② 复制 App ID 和 App Secret
> ③ 运行 `lark-cli config init` 按提示填写

**Q: 机器人不在群里？**
> 在群聊设置 → 群机器人 → 添加机器人 → 搜索你的应用名称

**Q: Skill 安装失败？**
> 检查网络能否访问 github.com，或配置代理后重试

---

## 📁 目录结构

```
event-butler/
├── scripts/setup.sh          # 一键安装脚本
├── agents/                   # Agent prompt 定义
│   ├── orchestrator.md       # 总调度 Agent
│   ├── theme-confirm.md      # 0️⃣ 主题确认
│   ├── design.md             # 2️⃣ 设计图
│   ├── collect.md            # 3️⃣ 信息采集
│   ├── verify.md             # 4️⃣ 验证/初审
│   └── plan.md               # 5️⃣ 策划
├── templates/                # 模板
│   └── status_table.md       # 状态表模板
└── README.md                 # 本文件
```
