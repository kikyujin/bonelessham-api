# 🌐 HAMLOG HTTP API

**Turbo HAMLOG を HTTP API 化するプロジェクト**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.8+](https://img.shields.io/badge/python-3.8+-blue.svg)](https://www.python.org/downloads/)
[![AutoHotkey](https://img.shields.io/badge/AutoHotkey-v1.1-green.svg)](https://www.autohotkey.com/)

---

## 📖 概要

**HAMLOG HTTP API**は、[Boneless HAM](https://github.com/kikyujin/bonelessham)の後継プロジェクトです。Turbo HAMLOGのバイナリデータベースに直接アクセスせず、UIオートメーション経由でデータを取得・設定できるHTTP APIサーバーを提供します。

### できること

- ✅ コールサインでログデータを検索
- ✅ ブラウザ・スクリプトからログ作成
- ✅ REST API経由でHAMLOG操作
- ✅ 外部アプリケーションとの連携

---

## 🎯 ユースケース

### 1. 自動ログ記録
無線機とPCを接続し、交信内容を自動記録

### 2. コンテスト支援
パイルアップ時の高速ログ入力

### 3. Web UI
ブラウザベースのモダンなログ入力画面

### 4. 外部連携
他のアマチュア無線ソフトウェアとの統合

---

## ⚡ クイックスタート

### 3ステップで起動

```bash
# 1. Flaskインストール
pip install flask

# 2. サーバー起動
python hamlog_api_server.py

# 3. テスト
curl http://localhost:8669/api/status
```

詳細: [QUICKSTART.md](QUICKSTART.md)

---

## 📋 API仕様

### エンドポイント一覧

```http
GET  /api/status                 # HAMLOG起動確認
GET  /api/callsign/{callsign}    # データ取得
POST /api/log                    # ログ作成
PUT  /api/log                    # ログ更新
POST /api/clear                  # クリア
```

### 使用例

```python
import requests

# コールサイン検索
response = requests.get('http://localhost:8669/api/callsign/JA1ABC')
print(response.json())

# ログ作成
requests.post('http://localhost:8669/api/log', json={
    'callsign': 'JH1XYZ',
    'his': '59',
    'my': '59',
    'freq': '430',
    'mode': 'FM'
})
```

---

## 📁 ファイル構成

```
hamlog-api/
├── hamlog_api_server.py      # Flask HTTPサーバー
├── hamlog_api.ahk            # AHK自動化スクリプト
├── hamlog_api_test.py        # テストクライアント
├── hamlog_api_ui.html        # Web UI
├── setup.bat                 # Windowsセットアップ
├── requirements.txt          # Python依存パッケージ
│
└── 📚 ドキュメント
    ├── README.md             # このファイル
    ├── QUICKSTART.md         # クイックスタート
    ├── HAMLOG_API_README.md  # 詳細API仕様
    └── ARCHITECTURE.md       # アーキテクチャ図
```

---

## 🖥️ システム要件

### 必須

- **OS**: Windows 10/11
- **Turbo HAMLOG**: Ver 5.47以降推奨
- **AutoHotkey**: v1.1
- **Python**: 3.8+

### オプション

- **Flask**: Web APIフレームワーク
- **curl**: APIテスト用

---

## 🚀 インストール

### 自動セットアップ(推奨)

```batch
# setup.bat を実行
setup.bat
```

### 手動セットアップ

```bash
# 1. リポジトリクローン
git clone https://github.com/kikyujin/hamlog-api.git
cd hamlog-api

# 2. 依存パッケージインストール
pip install -r requirements.txt

# 3. パス設定
# hamlog_api_server.py の以下を編集:
#   AHK_SCRIPT = r"C:\path\to\hamlog_api.ahk"
#   AUTOHOTKEY = r"C:\Program Files\AutoHotkey\AutoHotkey.exe"

# 4. サーバー起動
python hamlog_api_server.py
```

---

## 🧪 テスト

### 方法1: curl

```bash
# ステータス確認
curl http://localhost:8669/api/status

# コールサイン検索
curl http://localhost:8669/api/callsign/JA1ABC
```

### 方法2: Pythonテストスクリプト

```bash
# 全テスト実行
python hamlog_api_test.py all

# 対話モード
python hamlog_api_test.py interactive
```

### 方法3: Web UI

`hamlog_api_ui.html` をブラウザで開く

---

## 📚 ドキュメント

| ファイル | 内容 |
|---------|------|
| [QUICKSTART.md](QUICKSTART.md) | クイックスタートガイド |
| [HAMLOG_API_README.md](HAMLOG_API_README.md) | 詳細API仕様 |
| [ARCHITECTURE.md](ARCHITECTURE.md) | システムアーキテクチャ |

---

## 🐞 既知の問題

### RSTの制限

RSTの先頭が5以外(例: 41)の場合、HAMLOG側が自動的に「5」に書き換えます。

**回避策**: 特殊なRSTはHAMLOGのLOGダイアログで直接入力

### 保存機能

現在、APIからの自動保存には対応していません。LOGダイアログでの手動保存が必要です。

---

## 🛣️ ロードマップ

### v1.0 (現在)
- [x] 基本CRUD操作
- [x] コールサイン検索
- [x] ログ作成/更新/クリア
- [x] Web UI

### v1.1 (計画中)
- [ ] 自動保存API
- [ ] ログ検索API
- [ ] バッチ操作
- [ ] エラーハンドリング強化

### v2.0 (将来)
- [ ] WebSocket対応
- [ ] Electron製GUIクライアント
- [ ] クラウド同期
- [ ] モバイルアプリ

---

## 🤝 コントリビューション

Issue、Pull Request歓迎です！

### 開発の流れ

1. Fork this repository
2. Create your feature branch (`git checkout -b feature/amazing`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing`)
5. Open a Pull Request

---

## 📄 ライセンス

[MIT License](https://opensource.org/licenses/MIT)

```
Copyright (c) 2025 Kikyujin / MULTiTApps Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software...
```

---

## 🙋‍♂️ 作者

- 📡 **Callsign**: JS2OIA
- 🧠 **Name**: Mahito KIDA (a.k.a. Kikyujin)
- 🏢 **Company**: MULTiTApps Inc.
- 💌 **Contact**: 
  - GitHub: [@kikyujin](https://github.com/kikyujin)
  - X: [@777kdm](https://x.com/777kdm)
  - Email: js2oia@jarl.com

---

## 🙏 謝辞

- **Boneless HAM**プロジェクトの開発経験
- Turbo HAMLOG開発者の皆様
- AutoHotkeyコミュニティ
- Flaskコミュニティ
- アマチュア無線コミュニティの皆様

---

## 📞 サポート

- **GitHub Issues**: バグ報告・機能要望
- **Email**: 技術的な質問
- **X**: 最新情報・交流

---

## ⚠️ 注意事項

このプロジェクトはTurbo HAMLOGの**非公式ツール**です。
UIオートメーションを使用しているため、HAMLOGのバージョンアップで
動作しなくなる可能性があります。

自己責任でご利用ください。
**73! de JS2OIA**

*Boneless HAM の精神を受け継ぎ、Turbo HAMLOG をもっと自由に。*
