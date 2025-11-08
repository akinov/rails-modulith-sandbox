# Rails Modulith Sandbox

Ruby 3.4.7とRails 8.1.1を使用したPackwerkベースのモジュラモノリス構成のサンプルプロジェクトです。

## 概要

このプロジェクトは以下の特徴を持っています：

- **Ruby**: 3.4.7
- **Rails**: 8.1.1 (APIモード・最小構成)
- **データベース**: SQLite3
- **アーキテクチャ**: Packwerkを使用したモジュラモノリス

## プロジェクト構成

```
.
├── app/                      # ルートパッケージ（共通コード）
│   ├── controllers/
│   │   └── application_controller.rb
│   └── models/
│       └── application_record.rb
├── packs/                    # パッケージディレクトリ
│   └── posts/               # Postsパッケージ
│       ├── package.yml      # パッケージ設定
│       └── app/
│           ├── controllers/
│           │   └── posts_controller.rb
│           └── models/
│               └── post.rb
├── config/
├── db/
├── Gemfile
├── packwerk.yml             # Packwerk設定
└── package.yml              # ルートパッケージ設定
```

## セットアップ

```bash
# 依存関係をインストール
bundle install

# データベースをセットアップ
rails db:migrate

# Packwerkチェックを実行
bin/packwerk check
```

## サーバー起動

```bash
rails server
```

サーバーはデフォルトで `http://localhost:3000` で起動します。

## API エンドポイント

### 1. 投稿一覧の取得

```bash
curl http://localhost:3000/posts
```

**レスポンス例:**
```json
[
  {
    "id": 1,
    "text": "Hello, Packwerk!",
    "created_at": "2025-11-08T01:15:00.000Z",
    "updated_at": "2025-11-08T01:15:00.000Z"
  }
]
```

### 2. 投稿詳細の取得

```bash
curl http://localhost:3000/posts/1
```

**レスポンス例:**
```json
{
  "id": 1,
  "text": "Hello, Packwerk!",
  "created_at": "2025-11-08T01:15:00.000Z",
  "updated_at": "2025-11-08T01:15:00.000Z"
}
```

### 3. 新規投稿の作成

```bash
curl -X POST http://localhost:3000/posts \
  -H "Content-Type: application/json" \
  -d '{"post": {"text": "Hello, Packwerk!"}}'
```

**レスポンス例:**
```json
{
  "id": 1,
  "text": "Hello, Packwerk!",
  "created_at": "2025-11-08T01:15:00.000Z",
  "updated_at": "2025-11-08T01:15:00.000Z"
}
```

## Packwerkについて

Packwerkは、Shopifyが開発したRuby用のモジュラモノリスツールです。

### 主な機能

- **パッケージ境界の強制**: パッケージ間の依存関係を明示的に管理
- **プライバシーの強制**: パッケージ内の定数の可視性を制御
- **依存関係の可視化**: パッケージ間の依存関係を追跡

### Packwerkコマンド

```bash
# 違反をチェック
bin/packwerk check

# 違反を検証（記録済みの違反と比較）
bin/packwerk validate

# パッケージ構造を更新
bin/packwerk update
```

### パッケージの追加方法

1. `packs/` ディレクトリ内に新しいパッケージディレクトリを作成
2. `package.yml` ファイルを作成
3. `app/` ディレクトリ構造を作成（controllers, models, etc.）
4. 依存関係を `package.yml` に記述

**例: `packs/users/package.yml`**
```yaml
enforce_dependencies: true
enforce_privacy: true

dependencies:
  - "."
  - "packs/posts"
```

## 開発のヒント

### Zeitwerk自動読み込み

Packwerkパッケージは、`config/application.rb` で設定されたZeitwerkの自動読み込みパスによって自動的に読み込まれます：

```ruby
config.paths.add "packs", glob: "*/app/*", eager_load: true
```

### パッケージ間の依存関係

パッケージ間で定数を参照する場合は、`package.yml` で依存関係を明示的に宣言する必要があります。宣言しない場合、`bin/packwerk check` がエラーを報告します。

## 参考リンク

- [Packwerk公式ドキュメント](https://github.com/Shopify/packwerk)
- [Rails Guides](https://guides.rubyonrails.org/)
- [Zeitwerk](https://github.com/fxn/zeitwerk)

## ライセンス

MIT
