# 実装レビュー依頼

## リポジトリ

https://github.com/Mihara-Yamato-com/yamato_training_app

---

## 実装機能

- ログイン機能
- ログアウト機能
- ユーザー新規登録
- 一般ユーザー情報表示
- 一般ユーザー情報編集
- 管理者ユーザー一覧
- 管理者ユーザー編集
- 管理者ユーザー削除
- 権限制御（一般ユーザー／管理者）

---

## 確認していただきたいコード

- `app/controlers`
- `app/models`
- `app/views/admin/users/index.html.erb`
- `app/views/users/edit.html.erb`
viewファイルに関してはなるべく同じclassを何か所にも多用しないように心がけたのですが、もっと簡略化できるところもあったともうので見ていただきたいです。

---

## 特にレビューしていただきたい箇所

### ① ログイン処理

-[SessionsController#create](app/controllers/sessions_controller.rb)

確認していただきたい点

- ログイン処理の流れ
- session管理

---

### ② current_userの実装と権限制御

- [ApplicationController](app/controllers/application_controller.rb)
- [admin::UsersController](app/controllers/admin/users_controller.rb)

確認したいこと

- current_userの実装方法
- require_admin
- before_actionの使い方
- 一般ユーザーから管理者画面へのアクセス制御

---

### ③ ユーザー編集

- [UsersController](app/controllers/users_controller.rb)


確認したいこと

- 一般ユーザーと管理者で
  current_user と params[:id] を
  使い分けている設計

---

## 自分で工夫した点

- Deviseを使用せずログイン機能を実装
- roleによる画面遷移
- 一覧画面を開く際に管理者権限チェック
- userと@userの使い分け
- 理解するためにコードの簡素化

