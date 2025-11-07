# HAMLOG HTTP API - Quick Start Guide

## 📁 ファイル構成

```
hamlog-api/
├── hamlog_api_server.py    # Flask HTTPサーバー
├── hamlog_api.ahk          # AHK API処理スクリプト
├── hamlog_api_test.py      # テストクライアント
├── hamlog_api_ui.html      # Web UI
├── setup.bat               # Windowsセットアップ
├── HAMLOG_API_README.md    # 詳細ドキュメント
└── requirements.txt        # Python依存パッケージ
```

---

## ⚡ クイックスタート

### 1. 前提条件

- ✅ Turbo HAMLOG インストール済み
- ✅ AutoHotkey v1.1 インストール済み
- ✅ Python 3.8+ インストール済み

### 2. セットアップ(3分)

#### Windows

```batch
# 1. リポジトリダウンロード・解凍

# 2. setup.bat を実行
setup.bat
```

#### 手動セットアップ

```bash
# 1. Flaskインストール
pip install flask

# 2. パス設定
# hamlog_api_server.py の以下を編集:
#   AHK_SCRIPT = r"C:\path\to\hamlog_api.ahk"
#   AUTOHOTKEY = r"C:\Program Files\AutoHotkey\AutoHotkey.exe"

# 3. サーバー起動
python hamlog_api_server.py
```

### 3. 動作確認

#### ターミナルから

```bash
# ステータス確認
curl http://localhost:86109/api/status

# コールサイン検索
curl http://localhost:86109/api/callsign/JA1ABC
```

#### ブラウザから

`hamlog_api_ui.html` をブラウザで開く

#### Pythonテストスクリプト

```bash
# 全テスト実行
python hamlog_api_test.py all

# 対話モード
python hamlog_api_test.py interactive
```

---

## 🎯 使用例

### Example 1: コールサイン検索

```python
import requests

response = requests.get('http://localhost:86109/api/callsign/JA1ABC')
data = response.json()

print(f"Name: {data['name']}")
print(f"QTH: {data['qth']}")
```

### Example 2: QSOログ作成

```python
import requests

log = {
    'callsign': 'JH1XYZ',
    'his': '59',
    'my': '59',
    'freq': '430',
    'mode': 'FM',
    'name': '田中',
    'qth': '埼玉県'
}

response = requests.post('http://localhost:86109/api/log', json=log)
print(response.json())
```

### Example 3: JavaScriptから

```javascript
// データ取得
const response = await fetch('http://localhost:86109/api/callsign/JA1ABC');
const data = await response.json();
console.log(data);

// ログ作成
await fetch('http://localhost:86109/api/log', {
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

## 📋 API エンドポイント一覧

| Method | Endpoint | 説明 |
|--------|----------|------|
| GET | `/api/status` | HAMLOG起動状態確認 |
| GET | `/api/callsign/{callsign}` | コールサインでデータ取得 |
| POST | `/api/log` | ログ作成(HAMLOGにセット) |
| PUT | `/api/log` | ログ更新 |
| POST | `/api/clear` | LOGダイアログクリア |

---

## 🔧 トラブルシューティング

### サーバーが起動しない

```bash
# Flaskがインストールされているか確認
pip list | grep -i flask

# ポート86109が使用中か確認
netstat -an | findstr 86109

# 別のポートで起動
# hamlog_api_server.py の最終行を編集:
# app.run(host='127.0.0.1', port=8080, debug=True)
```

### HAMLOGが見つからない

1. Turbo HAMLOGを起動
2. LOGダイアログを開く
3. APIリクエスト実行

それでもダメな場合:
- `hamlog_api.ahk` の `GetHamlogWindow()` 関数を確認
- HAMLOGのウィンドウクラスが変わっている可能性

### 日本語が文字化けする

AHKスクリプトをUTF-8(BOM付き)で保存してください。

---

## 🚀 応用例

### 自動ログ記録システム

無線機とPCを接続し、交信内容を自動的にHAMLOGに記録:

```python
import requests
import serial

# 無線機からデータ受信
ser = serial.Serial('COM3', 9600)

while True:
    data = parse_rig_data(ser.readline())
    
    # HAMLOGに自動記録
    requests.post('http://localhost:86109/api/log', json={
        'callsign': data['callsign'],
        'freq': data['freq'],
        'mode': data['mode'],
        # ...
    })
```

### コンテスト支援ツール

パイルアップ時の高速ログ入力:

```python
callsigns = ['JA1AAA', 'JA1BBB', 'JA1CCC']

for cs in callsigns:
    requests.post('http://localhost:86109/api/log', json={
        'callsign': cs,
        'his': '59',
        'my': '59',
        'freq': '50',
        'mode': 'CW'
    })
    # HAMLOG側で保存操作
    input(f"{cs} saved? Press Enter...")
    requests.post('http://localhost:86109/api/clear')
```

### QSLカード印刷自動化

ログデータを取得して自動印刷:

```python
# 複数コールサインからデータ取得
for cs in target_callsigns:
    data = requests.get(f'http://localhost:86109/api/callsign/{cs}').json()
    generate_qsl_card(data)
    print_qsl_card()
```

---

## 📚 参考リンク

- [AutoHotkey公式](https://www.autohotkey.com/)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [Turbo HAMLOG](http://www.hamlog.com/)

---

## 🤝 コントリビューション

Issue、Pull Request歓迎です！

特に以下の機能実装に協力者募集:
- [ ] 保存API(ControlClick安定化)
- [ ] ログ検索API
- [ ] WebSocket対応
- [ ] Electron版GUIクライアント

---

## 📞 サポート

- GitHub Issues: (リポジトリURL)
- Email: js2oia@jarl.com
- X: @777kdm

---

**73! de JS2OIA**
