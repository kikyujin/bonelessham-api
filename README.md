# 🌐 bonelessham-api

**Turbo HAMLOG を HTTP API 化するプロジェクト**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.8+](https://img.shields.io/badge/python-3.8+-blue.svg)](https://www.python.org/downloads/)
[![AutoHotkey](https://img.shields.io/badge/AutoHotkey-v1.1-green.svg)](https://www.autohotkey.com/)

---

## 📖 概要

**bonelessham-api**は、[Boneless HAM](https://github.com/kikyujin/bonelessham)の後継プロジェクトです。Turbo HAMLOGのバイナリデータベースに直接アクセスせず、UIオートメーション経由でデータを取得・設定できるHTTP APIサーバーを提供します。

### できること

- ✅ コールサインでログデータを検索
- ✅ ブラウザ・スクリプトからログ作成
- ✅ REST API経由でHAMLOG操作
- ✅ LAN内の他PCからアクセス可能
- ✅ Tailscale経由で外部アクセス対応

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

### 前提条件

- ✅ Turbo HAMLOG インストール済み
- ✅ AutoHotkey v1.1 インストール済み
- ✅ Python 3.8+ インストール済み

### 3ステップで起動

```bash
# 1. リポジトリクローン
git clone https://github.com/kikyujin/bonelessham-api.git
cd bonelessham-api

# 2. 依存パッケージインストール
pip install -r requirements.txt

# 3. サーバー起動
.\setup.bat
```

起動すると `http://(running-IP):8669` でAPIが利用可能になります。

---

## 🧪 動作確認

### curlでテスト

```bash
# ステータス確認
curl http://localhost:8669/api/status

# コールサイン検索
curl http://localhost:8669/api/callsign/JA1ABC

# ログ作成
curl -X POST http://localhost:8669/api/log \
  -H "Content-Type: application/json" \
  -d "{\"callsign\":\"JS2OIA\",\"his\":\"59\",\"my\":\"59\",\"freq\":\"145\",\"mode\":\"FM\"}"
```

### Web UIで試す

ブラウザで `hamlog_api_ui.html` を開く
※ hamlog_api_ui.html 208行目の "API_BASE" を環境に合わせて変更してください。

---

## 📋 API仕様

### エンドポイント一覧

| Method | Endpoint | 説明 |
|--------|----------|------|
| GET | `/api/status` | HAMLOG起動確認 |
| GET | `/api/callsign/{callsign}` | データ取得 |
| POST | `/api/log` | ログ作成 |
| PUT | `/api/log` | ログ更新 |
| POST | `/api/clear` | クリア |

### レスポンス例

```json
{
  "callsign": "JS2OIA",
  "name": "気球人",
  "qth": "愛知県弥富市",
  "freq": 430,
  "mode": "FM",
  "his": 59,
  "my": 59,
  "date": "25/11/07",
  "time": "18:58J"
}
```

---

## 🌐 LAN内公開

デフォルトで `host='0.0.0.0'` に設定されているため、LAN内の他PCからアクセス可能です。

```bash
# 他のPCから
curl http://192.168.1.100:8669/api/status
```

### Windowsファイアウォール設定（必要なら）

```powershell
# PowerShellを管理者権限で実行
New-NetFirewallRule -DisplayName "HAMLOG API" -Direction Inbound -LocalPort 8669 -Protocol TCP -Action Allow
```

---

## 🔐 外部アクセス（Tailscale推奨）

外出先からアクセスする場合は、Tailscale経由を推奨します。

1. サーバーPC・クライアントPCにTailscaleをインストール
2. Tailscale IPアドレスでアクセス

```bash
curl http://100.x.x.x:8669/api/status
```

---

## 📁 ファイル構成

```
bonelessham-api/
├── hamlog_api_server.py      # Flask HTTPサーバー
├── hamlog_api.ahk            # AHK自動化スクリプト
├── hamlog_api_ui.html        # Web UI
├── requirements.txt          # Python依存パッケージ
└── README.md                 # このファイル
```

---

## 🖥️ システム要件

### 必須

- **OS**: Windows 10/11
- **Turbo HAMLOG**: Ver 5.47以降推奨
- **AutoHotkey**: v1.1
- **Python**: 3.8+

---

## 💡 使用例

### Pythonスクリプトから

```python
import requests

# コールサイン検索
response = requests.get('http://localhost:8669/api/callsign/JA1ABC')
data = response.json()
print(f"Name: {data['name']}, QTH: {data['qth']}")

# ログ作成
log = {
    'callsign': 'JS2OIA',
    'his': '59',
    'my': '59',
    'freq': '430',
    'mode': 'FM'
}
requests.post('http://localhost:8669/api/log', json=log)
```

### JavaScriptから

```javascript
// データ取得
const response = await fetch('http://localhost:8669/api/callsign/JA1ABC');
const data = await response.json();

// ログ作成
await fetch('http://localhost:8669/api/log', {
  method: 'POST',
  headers: {'Content-Type': 'application/json'},
  body: JSON.stringify({
    callsign: 'JH1XYZ',
    his: '59',
    my: '59',
    freq: '144',
    mode: 'SSB'
  })
});
```

---

## 🐞 既知の問題

### RSTの制限

RSTの先頭が5以外(例: 41)の場合、HAMLOG側が自動的に「5」に書き換えます。

**回避策**: 特殊なRSTはHAMLOGのLOGダイアログで直接入力

### 保存機能

現在、APIからの自動保存には対応していません。LOGダイアログでの手動保存が必要です（うまくHAMLOGを制御できないため）。  
  
※ 個人的意見：ここまで情報取れるなら、HAMLOGに記録させるより自分で記録したほうが早いと考えています。

---

## 🛣️ ロードマップ

### v1.0 (現在)
- [x] 基本CRUD操作
- [x] コールサイン検索
- [x] ログ作成/更新/クリア
- [x] Web UI
- [x] LAN内公開

### v2.0 (計画中)
- [ ] ローカルDB（SQLite）導入
- [ ] 局データキャッシュ
- [ ] バッチ同期機能
- [ ] 自動保存API
- [ ] ログ検索API

### v3.0 (将来)
- [ ] 専用GUI作成
- [ ] 音声認識対応
- [ ] クラウド対応
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
in the Software without restriction...
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
