# CLAUDE.md

このファイルはClaude Codeが各セッション開始時に読み込むプロジェクトメモリです。
簡潔・人間にも読める内容を維持し、汎用的な指示のみを置きます
(プロジェクト固有の詳細は `agent_docs/` 以下に分割し、ここからリンクする)。

---

## 0. 必須ルール(最優先・常時適用)

### 0-1. 使用言語の確認
- 作業を開始する前に、**毎回**「どの言語で応答・実行してほしいか」をユーザーに確認すること。
  - コード内のコメント、コミットメッセージ、ドキュメント、チャット上の応答すべてに適用する。
  - 既にセッション内で言語指定があり、かつ話題が変わっていない場合は再確認不要。
  - 指定された言語で一貫して実行・出力すること。途中で無断で切り替えない。

### 0-2. 作業ログ(判断根拠のまとめ)の作成
- タスク完了時、**必ず**以下を含む `.md` 形式の要約を作成すること:
  - 何を実施したか(変更点・成果物の一覧)
  - なぜその実装方針・技術選定に至ったか(検討した代替案があれば含める)
  - 実行中に発生した問題とその対処
  - 残課題・次のステップ(あれば)
- ファイル名の例: `logs/YYYY-MM-DD_タスク概要.md`(プロジェクトの慣習に合わせて配置場所を調整可)
- チャット出力のみで済ませず、必ずファイルとしても保存すること。

### 0-3. 変更ファイルの列挙
- コードやドキュメントに変更を加えた際は、チャット上の回答および0-2の作業ログの両方に、**変更・追加・削除したファイルのパスを一覧で明記**すること。
  - 例: `git status` / `git diff --stat` の結果をそのまま貼るのではなく、意味のある単位で整理して列挙する。
  - 新規作成したファイルと既存ファイルの修正は区別して書く。

---

## 1. プロジェクト概要
- プロジェクト名: yamato_training_app（画面上の表示名は「みはっちユーザー管理システム」）
- 目的・概要: Devise等の認証gemを使わず、`has_secure_password`を用いて自前でログイン/権限制御を実装する学習用のユーザー管理アプリ。一般ユーザー（自分の情報の閲覧・編集）と管理者（ユーザー一覧・編集・削除）の2ロールがある。
- 主要技術スタック: Ruby 3.4系 / Rails ~> 8.1 / PostgreSQL / Puma / Propshaft / Turbo・Stimulus(Hotwire) / solid_cache・solid_queue・solid_cable / bcrypt / Kamalデプロイ / RuboCop(rubocop-rails-omakase) / Brakeman / bundler-audit / Capybara+Selenium(system test)

## 2. ディレクトリ構成(地図)
```
app/
├── controllers/
│   ├── application_controller.rb   # current_user, require_login, require_admin
│   ├── sessions_controller.rb      # ログイン/ログアウト
│   ├── users_controller.rb         # 一般ユーザーの新規登録・自分の情報閲覧/編集
│   └── admin/users_controller.rb   # 管理者用のユーザー一覧/編集/削除
├── models/user.rb                  # role enum(general/admin), email正規化, バリデーション
└── views/{sessions,users,admin/users,layouts}/
config/
├── routes.rb                       # ルーティング定義
└── environments/, initializers/
db/
├── migrate/, schema.rb, seeds.rb    # seeds.rbは現状空(初期管理者なし)
test/
├── controllers/, models/, fixtures/, integration/
.github/workflows/ci.yml            # PR/pushで自動実行されるCI
```

## 3. よく使うコマンド
- サーバ起動: `bin/rails server` (`bin/dev` も利用可)
- セットアップ: `bin/setup`（bundle install → db:prepare → ログ/tmpクリア）
- テスト: `bin/rails test`（コントローラ/モデル）、`bin/rails test:system`（Capybara/Selenium）
- Lint/セキュリティ: `bin/rubocop`、`bin/brakeman --no-pager`、`bin/bundler-audit`、`bin/importmap audit`
- DB: `bin/rails db:prepare` / `db:migrate` / `db:seed`

## 4. コーディング規約
- Strong Parametersは各コントローラの private `user_params` に集約する。
- 権限は `enum :role, { general: 0, admin: 1 }` で管理。ロール判定は `user.general?` / `user.admin?` を使う。
- ログイン状態・認可は `ApplicationController#current_user` / `#require_login` / `#require_admin` を必ず経由する。コントローラ内で `session[:user_id]` を直接参照しない。
- メールアドレスの正規化(strip・downcase)は `User` モデルの `normalizes :email` に一本化済み。コントローラ側で個別に `downcase` しない。
- RuboCopは `rubocop-rails-omakase` ベース（`.rubocop.yml`参照）。

## 5. ワークフロー
- 実装方針: 既存コードを読む → 影響範囲を確認 → 実装 → `bin/rails test` → コミット。
- 大きな変更(マイグレーション、認可ロジック、破壊的操作)の前には必ず計画を提示しユーザーの承認を得ること。
- ブランチ運用: `develop` で作業 → PRで `main` にマージ、という流れが多い。Claude作業時は指定されたフィーチャーブランチ上で作業し、`main`には直接コミットしない。
- コミットメッセージ規約: 日本語・簡潔な体言止め/命令形（例:「ユーザー編集機能とデータ削除」「エラー修正」）。プレフィックス(feat:等)は使っていない。

## 6. 触れる際に注意が必要な領域
- `app/models/user.rb` と `app/controllers/admin/users_controller.rb`: 権限(role)まわりの変更は、最後の管理者を削除/降格できないようにするガード(`demoting_last_admin?`など)との整合性を必ず確認する。
- `db/schema.rb` / `db/migrate/`: マイグレーションを追加したら `db/schema.rb` にも必ず反映する(自動生成できない実行環境のため手動同期が必要になる場合がある)。
- `test/fixtures/users.yml`: `email` にDBレベルのユニーク制約があるため、fixture間でメールアドレスを重複させない。`password_digest` は `BCrypt::Password.create(...)` をERBで埋め込んで生成する。
- `db/seeds.rb` は空で初期管理者が存在しない。管理者アカウントの復旧手段が現状ないため、管理者関連のロジックを変更する際は特に慎重に。

## 7. テスト・検証
- `bin/rails test` … コントローラ/モデルテスト一式。ログインが必要な画面は `test_helper.rb` の `sign_in_as(user)` ヘルパーで認証してからアクセスする。
- `bin/rails test:system` … Capybara/Selenium経由のシステムテスト。
- CI(`.github/workflows/ci.yml`)でPR毎に `brakeman` / `bundler-audit` / `importmap audit` / `rubocop` / `test` / `test:system` が走る。マージ前は全てgreenであることを期待する。

## 8. 運用ルール
- 同じ内容を2回訂正したら、このファイルに追記して恒久化する。
- 個人的な設定・秘密情報は `CLAUDE.local.md`(gitignore対象)に記載し、ここには書かない。
- ファイルが古くなっていないか、プロジェクトの大きな変更後に見直すこと。