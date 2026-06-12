#!/usr/bin/env bash
set -e

# ============================================================
#  飞书活动大管家 — 一键安装脚本
#  功能：自动检测、安装、配置所有依赖
# ============================================================

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
PASS="${GREEN}✓${NC}"; FAIL="${RED}✗${NC}"; WARN="${YELLOW}⚠${NC}"; INFO="${BLUE}→${NC}"

echo ""
echo "  🎉  飞书活动大管家 — 安装向导"
echo "  ================================"
echo ""

# ---- 1. Node.js ----
echo -n "  [1/5] Node.js ................. "
if command -v node &>/dev/null; then
    NODE_VER=$(node -v)
    echo -e "${PASS} ${NODE_VER}"
else
    echo -e "${FAIL} 未安装"
    echo ""
    echo "  ${YELLOW}请先安装 Node.js（≥18）：${NC}"
    echo "    macOS:  brew install node"
    echo "    Linux:  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -"
    echo "            sudo apt-get install -y nodejs"
    echo "    Win:    https://nodejs.org 下载安装包"
    exit 1
fi

# ---- 2. npx / skills CLI ----
echo -n "  [2/5] skills CLI .............. "
if npx --version &>/dev/null; then
    echo -e "${PASS}"
else
    echo -e "${FAIL}"
    echo "  ${YELLOW}npm 版本过低，请升级：npm install -g npm@latest${NC}"
    exit 1
fi

# ---- 3. lark-cli ----
echo -n "  [3/5] lark-cli ................ "
if command -v lark-cli &>/dev/null; then
    LARK_VER=$(lark-cli --version 2>&1 | head -1)
    echo -e "${PASS} ${LARK_VER}"
else
    echo -e "${FAIL} 未安装"
    echo ""
    echo "  ${INFO} 正在安装 lark-cli ..."
    npm install -g @larksuite/cli
    echo "  ${PASS} lark-cli 安装完成"
fi

# ---- 3b. lark-cli 配置检查 ----
echo -n "  [3b]  lark-cli 配置 ........... "
if lark-cli config show 2>&1 | grep -q "appId"; then
    echo -e "${PASS} 已配置"
else
    echo -e "${WARN} 未配置"
    echo ""
    echo "  ${YELLOW}飞书应用未初始化。请按以下步骤操作：${NC}"
    echo ""
    echo "  ① 打开飞书开发者后台 https://open.feishu.cn"
    echo "  ② 创建企业自建应用，获取 App ID 和 App Secret"
    echo "  ③ 运行初始化命令："
    echo ""
    echo "     lark-cli config init"
    echo ""
    echo "  ${YELLOW}是否需要我帮你引导完成应用创建？${NC}"
    exit 1
fi

# ---- 4. 必要 Skills ----
echo "  [4/5] 必要 Skills ............. "
SKILLS=(
    "baoyu-diagram"
    "baoyu-cover-image"
    "baoyu-format-markdown"
    "baoyu-image-gen"
    "baoyu-infographic"
    "brainstorming"
    "writing-plans"
)

MISSING=()
for skill in "${SKILLS[@]}"; do
    if [ -d "$HOME/.agents/skills/$skill" ] || [ -d "$HOME/.hermes/skills/$skill" ]; then
        echo -e "         ${PASS} $skill"
    else
        echo -e "         ${FAIL} $skill"
        MISSING+=("$skill")
    fi
done

if [ ${#MISSING[@]} -gt 0 ]; then
    echo ""
    echo "  ${INFO} 正在安装缺失的 Skills ..."
    for skill in "${MISSING[@]}"; do
        case "$skill" in
            brainstorming|writing-plans)
                npx skills add obra/superpowers@$skill -g -y 2>/dev/null && \
                    echo "         ${PASS} $skill 安装完成" || \
                    echo "         ${FAIL} $skill 安装失败（请检查网络）"
                ;;
            *)
                npx skills add jimliu/baoyu-skills@$skill -g -y 2>/dev/null && \
                    echo "         ${PASS} $skill 安装完成" || \
                    echo "         ${FAIL} $skill 安装失败（请检查网络）"
                ;;
        esac
    done
fi

# ---- 5. 飞书权限自检 ----
echo -n "  [5/5] 飞书权限自检 ........... "
PERMS=(
    "docx:document" "drive:drive" "im:message" "calendar:calendar"
    "base:app" "contact:contact" "im:message.send_as_user"
)
if lark-cli auth status 2>/dev/null | grep -q "user"; then
    echo -e "${PASS} 已授权"
else
    echo -e "${WARN} 需要授权"
    echo ""
    echo "  ${INFO} 请运行以下命令完成飞书授权："
    echo ""
    echo "     lark-cli auth login --domain all"
    echo ""
    echo "  ${YELLOW}完成授权后重新运行本脚本即可。${NC}"
    exit 1
fi

# ---- 完成 ----
echo ""
echo "  ================================"
echo "  ${GREEN}✅ 全部检查通过！活动大管家已就绪${NC}"
echo ""
echo "  ${INFO} 下一步："
echo "    1. 打开飞书，找到你要用的群聊"
echo "    2. 把机器人拉进群"
echo "    3. 在群里 @大管家 开始使用"
echo ""
echo "  ${INFO} 快速开始："
echo "    @大管家 帮我策划一个 AI 分享活动"
echo ""
