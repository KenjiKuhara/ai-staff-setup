# ============================================================
# AI社員セットアップスクリプト
# 『AI社員の育て方』付録
#
# 使い方: VS Code のターミナルで以下を実行
#   iex(irm 'https://raw.githubusercontent.com/KenjiKuhara/ai-staff-setup/main/setup.ps1')
# ============================================================

$ErrorActionPreference = "Stop"

function Write-Step($step, $total, $message) {
    Write-Host "[$step/$total] $message" -ForegroundColor Yellow
}

function Write-Ok($message) {
    Write-Host "  $message" -ForegroundColor Green
}

function Write-Info($message) {
    Write-Host "  $message" -ForegroundColor Gray
}

function Write-Err($message) {
    Write-Host "  $message" -ForegroundColor Red
}

function Refresh-PathFromRegistry {
    $machinePath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
    $userPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$machinePath;$userPath"
}

# --- バナー ---
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "" -ForegroundColor Cyan
Write-Host "       AI社員セットアップ" -ForegroundColor Cyan
Write-Host "" -ForegroundColor Cyan
Write-Host "  『AI社員の育て方』環境構築ガイド" -ForegroundColor Cyan
Write-Host "" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$totalSteps = 3

# ============================================================
# Step 1: Node.js
# ============================================================
Write-Step 1 $totalSteps "Node.js を確認しています..."

$nodeCmd = Get-Command node -ErrorAction SilentlyContinue

if (-not $nodeCmd) {
    Write-Info "Node.js が見つかりません。インストールします..."
    Write-Info "(管理者権限の確認画面が出たら「はい」を押してください)"
    Write-Host ""

    $wingetCmd = Get-Command winget -ErrorAction SilentlyContinue
    if (-not $wingetCmd) {
        Write-Err "winget が見つかりません。"
        Write-Err "Microsoft Store で「アプリ インストーラー」を更新してから再実行してください。"
        return
    }

    winget install OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements

    if ($LASTEXITCODE -ne 0) {
        Write-Err "Node.js のインストールに失敗しました。"
        Write-Err "手動でインストールしてください: https://nodejs.org/"
        return
    }

    Refresh-PathFromRegistry

    $nodeCmd = Get-Command node -ErrorAction SilentlyContinue
    if (-not $nodeCmd) {
        Write-Err "Node.js をインストールしましたが、PATH に反映されませんでした。"
        Write-Err "ターミナルを閉じて開き直し、もう一度このコマンドを実行してください。"
        return
    }

    $v = & node --version
    Write-Ok "Node.js $v をインストールしました。"
} else {
    $v = & node --version
    Write-Ok "Node.js $v ... OK"
}

# ============================================================
# Step 2: Claude Code
# ============================================================
Write-Step 2 $totalSteps "Claude Code を確認しています..."

$claudeCmd = Get-Command claude -ErrorAction SilentlyContinue

if (-not $claudeCmd) {
    Write-Info "Claude Code をインストールしています..."
    Write-Host ""

    & npm install -g @anthropic-ai/claude-code 2>&1 | ForEach-Object { Write-Info $_ }

    Refresh-PathFromRegistry

    $claudeCmd = Get-Command claude -ErrorAction SilentlyContinue
    if (-not $claudeCmd) {
        Write-Err "Claude Code をインストールしましたが、PATH に反映されませんでした。"
        Write-Err "ターミナルを閉じて開き直し、もう一度このコマンドを実行してください。"
        return
    }

    Write-Ok "Claude Code をインストールしました。"
} else {
    Write-Info "最新版に更新しています..."
    & npm update -g @anthropic-ai/claude-code 2>&1 | Out-Null
    Write-Ok "Claude Code ... OK (最新版)"
}

# ============================================================
# Step 3: AI社員の初期ファイルを作成
# ============================================================
Write-Step 3 $totalSteps "AI社員の初期ファイルを作成しています..."

# --- フォルダ作成 ---
$dirs = @(
    ".company\secretary\inbox",
    ".company\reviews",
    ".company\.trash"
)

foreach ($dir in $dirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Info "フォルダ作成: $dir\"
    }
}

# --- CLAUDE.md ---
if (-not (Test-Path "CLAUDE.md")) {

$claudeMd = @'
# AI社員

## 起動トリガー

以下のいずれかの発言でAI社員が起動します:
- `company`
- `おはよう`

### 起動ルーティン

1. 秘書として挨拶する
2. `.company/secretary/inbox/` に未処理のファイルがあれば報告する
3. 業務棚卸しリスト（`.company/secretary/work-inventory.md`）を確認し、前回の状況を踏まえて会話を始める
4. まだ棚卸しが十分でなければ、仕事についてヒアリングする（下記参照）

---

## あなたのAI社員: 秘書

あなたの最初のAI社員は「秘書」です。
あなたの仕事を聞き出して、AIに任せられるものを一緒に見つけていく相棒です。

### 秘書の目的

あなたの仕事の「思考コスト」を下げること。AIの新機能を試すことではありません。
今やっている仕事をAIに渡して、あなたの時間を空けることが最優先です。

### 秘書の性格: ヒアリング型

秘書はあなたに積極的に質問します。あなたは聞かれたことに答えるだけで大丈夫です。

よく使う質問:
- 「最近、面倒だなと感じている仕事はありますか?」
- 「よくやる仕事で、AIに渡せたらいいなと思うものはありますか?」
- 「毎回同じような手順を踏んでいる仕事はどれですか?」
- 「前回お聞きした○○の仕事、その後どうですか?」

答えやすい質問から始めて、少しずつ深掘りしていきます。

### 業務棚卸しリスト

ヒアリングで聞き出した仕事は `.company/secretary/work-inventory.md` に記録します。

記録する項目:
- 業務名
- 頻度（毎日/毎週/月1など）
- 面倒さ（高/中/低）
- AI化の判定（○ AIでやる / △ 一部AIでやる / × 人間がやるべき）
- 備考（やってみた結果、うまくいかなかった理由など）

棚卸しリストは育てていくものです。最初は3つくらいから始めて、会話のたびに増やしていきます。

### 禁止事項
- ファイルを削除しない（不要なファイルは `.company/.trash/` に移動する）
- 確認なしに外部へ情報を送信しない
- 「こんなこともできます」と機能を押し売りしない。あくまで相手の仕事から出発する

---

## フォルダ構成

```
.company/
  secretary/
    inbox/              <- 何でも放り込む場所（メモ、アイデア、依頼）
    work-inventory.md   <- 業務棚卸しリスト（秘書が育てる）
  reviews/              <- 品質チェックのログ
  .trash/               <- 削除の代わりにここに移動する
```

---

## 慣れてきたら

この秘書は初心者向けの「ヒアリング型」です。
AIに慣れてきたら、このCLAUDE.mdを自由に書き換えて、自分好みの秘書に育ててください。
秘書に「もっと自律的に動いて」と伝えるだけでも変わります。
'@

    [System.IO.File]::WriteAllText(
        (Join-Path $PWD "CLAUDE.md"),
        $claudeMd,
        [System.Text.UTF8Encoding]::new($false)
    )
    Write-Info "作成: CLAUDE.md"
} else {
    Write-Info "スキップ: CLAUDE.md（既に存在します）"
}

# --- 完了 ---
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "" -ForegroundColor Green
Write-Host "  セットアップ完了!" -ForegroundColor Green
Write-Host "" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "  次のステップ:" -ForegroundColor White
Write-Host ""
Write-Host "    1. claude と入力して Enter" -ForegroundColor White
Write-Host "       (初回はログイン画面が表示されます)" -ForegroundColor Gray
Write-Host ""
Write-Host "    2. company と入力して Enter" -ForegroundColor White
Write-Host "       (秘書が起動します)" -ForegroundColor Gray
Write-Host ""
Write-Host "  秘書が立ち上がったら、何でも相談してください。" -ForegroundColor Cyan
Write-Host "  「部署を増やしたい」と言えば、組織が拡張できます。" -ForegroundColor Cyan
Write-Host ""
