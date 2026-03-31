# AI社員セットアップ

書籍『AI社員の育て方』の読者向けセットアップスクリプトです。

コマンド1つで、あなたのパソコンにAI社員（AI秘書）を立ち上げます。

## はじめての方へ

パソコンに詳しくない方は、まず **[事前準備ガイド](docs/preparation.md)** をお読みください。
アカウントの作り方から、画面の開き方まで、1つずつ説明しています。

## 必要なもの

- Windows 11
- インターネット接続
- Anthropic アカウント（[作成方法はこちら](docs/preparation.md#step-1-anthropic-アカウントを作成する)）

VS Code や Node.js は、インストールされていなければスクリプトが自動でインストールします。

## 使い方

### 1. PowerShell を開く

キーボードの Windows キーを押して `powershell` と入力し、「Windows PowerShell」を開きます。

### 2. 作業フォルダーを作る

```powershell
mkdir $HOME\ai-staff
cd $HOME\ai-staff
```

### 3. セットアップを実行する

```powershell
iex(irm 'https://raw.githubusercontent.com/KenjiKuhara/ai-staff-setup/main/setup.ps1')
```

以下が自動でインストール/作成されます（既にあるものはスキップ）:

- VS Code
- Node.js
- Claude Code
- AI社員の初期ファイル（CLAUDE.md、秘書室フォルダー）

### 4. AI社員を起動する

セットアップ完了後、VS Code でフォルダーを開き、ターミナルで:

```
claude
```

初回はAnthropicアカウントでログインしてください。ログイン後:

```
company
```

秘書が挨拶をしたら完了です。

## トラブルシューティング

詳しくは [事前準備ガイド](docs/preparation.md) をご覧ください。

| 症状 | 対処 |
|------|------|
| winget が見つかりません | Microsoft Store で「アプリ インストーラー」を更新 |
| PATH に反映されませんでした | ターミナルを閉じて開き直し、再実行 |
| ログインできない | [Claude Code 公式ドキュメント](https://docs.anthropic.com/en/docs/claude-code)を参照 |

## 書籍について

『AI社員の育て方』は、AIを「社員」として組織に迎え入れ、マニュアルで育て、品質管理し、自律的に仕事を回す仕組みを解説した本です。

著者: 久原健司

## ライセンス

MIT License
