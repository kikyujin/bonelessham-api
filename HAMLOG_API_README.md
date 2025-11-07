# HAMLOG HTTP API Server 🌐

**Boneless HAM**の後継プロジェクト。HAMLOGをHTTP API化し、ブラウザやスクリプトから操作可能に。

---

## 🎯 概要

Turbo HAMLOGのバイナリデータベースに直接アクセスせず、UIオートメーション経由でデータを取得/設定できるHTTP APIサーバーです。

### アーキテクチャ

```
┌─────────────┐
│   Client    │ curl/Postman/ブラウザ/スクリプト
└──────┬──────┘
       │ HTTP (localhost:86109)
       ↓
┌─────────────┐
│Flask Server │ Python
└──────┬──────┘
       │ subprocess
       ↓
┌─────────────┐
│  AHK Script │ AutoHotkey v1
└──────┬──────┘
       │ UI Automation
       ↓
┌─────────────┐
│   HAMLOG    │ Turbo HAMLOG 5.47+
└─────────────┘
```

---

## 📦 必要なもの

- **Turbo HAMLOG** (Ver 5.47以降推奨)
- **AutoHotkey v1.1** ([ダウンロード](https://www.autohotkey.com/download/ahk-install.exe))
- **Python 3.8+**
- **Flask** (`pip install flask`)

---

## 🚀 セットアップ

### 1. インストール

```bash
git clone https://github.com/kikyujin/hamlog-api.git
cd hamlog-api
pip install flask
```

### 2. パス設定

`hamlog_api_server.py`の以下を環境に合わせて編集:

```python
AHK_SCRIPT = r"C:\path\to\hamlog_api.ahk"  # ← 実際のパス
AUTOHOTKEY = r"C:\Program Files\AutoHotkey\AutoHotkey.exe"
```

### 3. HAMLOG起動

Turbo HAMLOGを起動し、LOGダイアログを開いておく(初回のみ)

### 4. サーバー起動

```bash
python hamlog_api_server.py
```

起動すると `http://127.0.0.1:86109` でAPIが利用可能になります。

---

## 🔌 API仕様

### ステータス確認

```http
GET /api/status
```

**レスポンス例:**
```json
{
  "status": "running",
  "hwnd": 12345678
}
```

---

### コールサインでデータ取得

```http
GET /api/callsign/{callsign}
```

**例:**
```bash
curl http://localhost:86109/api/callsign/JA1ABC
```

**レスポンス例:**
```json
{
  "callsign": "JA1ABC",
  "date": "25/01/15",
  "time": "12:34J",
  "his": "59",
  "my": "59",
  "freq": "145",
  "mode": "FM",
  "code": "",
  "gl": "",
  "qsl": "",
  "name": "山田太郎",
  "qth": "東京都",
  "rem1": "",
  "rem2": ""
}
```

---

### ログ作成(HAMLOGへセット)

```http
POST /api/log
Content-Type: application/json

{
  "callsign": "JA1XYZ",
  "his": "59",
  "my": "59",
  "freq": "430",
  "mode": "FM",
  "name": "田中",
  "qth": "埼玉県"
}
```

**レスポンス例:**
```json
{
  "status": "success",
  "message": "Log data set to HAMLOG"
}
```

**注意:** このAPIは**HAMLOGのLOGダイアログにデータをセットするだけ**です。保存は手動で行ってください。

---

### ログ更新

```http
PUT /api/log
Content-Type: application/json

{
  "callsign": "JA1XYZ",
  "rem1": "QSL via buro"
}
```

指定したフィールドのみ更新します。

---

### LOGダイアログクリア

```http
POST /api/clear
```

HAMLOGのLOGダイアログを`Alt+A`でクリアします。

---

## 💡 使用例

### curlで取得

```bash
# ステータス確認
curl http://localhost:86109/api/status

# コールサイン検索
curl http://localhost:86109/api/callsign/JH1ABC

# ログセット
curl -X POST http://localhost:86109/api/log \
  -H "Content-Type: application/json" \
  -d '{
    "callsign": "JA1XYZ",
    "his": "59",
    "my": "59",
    "freq": "144",
    "mode": "SSB"
  }'
```

### Pythonスクリプトから

```python
import requests

# データ取得
response = requests.get('http://localhost:86109/api/callsign/JA1ABC')
data = response.json()
print(data['name'])  # 山田太郎

# ログ作成
log_data = {
    'callsign': 'JH1XYZ',
    'his': '59',
    'my': '59',
    'freq': '50',
    'mode': 'CW'
}
response = requests.post('http://localhost:86109/api/log', json=log_data)
print(response.json())
```

### JavaScriptから(ブラウザ)

```javascript
// データ取得
fetch('http://localhost:86109/api/callsign/JA1ABC')
  .then(res => res.json())
  .then(data => console.log(data));

// ログ作成
fetch('http://localhost:86109/api/log', {
  method: 'POST',
  headers: {'Content-Type': 'application/json'},
  body: JSON.stringify({
    callsign: 'JH1XYZ',
    his: '59',
    my: '59',
    freq: '430',
    mode: 'FM'
  })
}).then(res => res.json())
  .then(data => console.log(data));
```

---

## 🐞 既知の問題

### RSTの制限(boneless.ahkと同じ)

RSTの先頭が5以外(例: 41)の場合、HAMLOG側が自動的に「5」に書き換えます。  
**回避策:** 特殊なRSTはHAMLOGのLOGダイアログで直接入力してください。

### 保存機能なし

現在、APIからの自動保存には対応していません(boneless.ahkと同様)。  
LOGダイアログでの手動保存が必要です。

### JSON簡易パーサー

AHK側のJSONパース処理は簡易実装です。複雑なJSONには[Jxon.ahk](https://github.com/cocobelgica/AutoHotkey-JSON)の利用を推奨。

---

## 🛠 今後の拡張案

- [ ] 保存API実装(`POST /api/save`)
- [ ] 複数ログの一括登録
- [ ] QSLカード管理API
- [ ] WebSocketでリアルタイム同期
- [ ] Electron製GUIクライアント
- [ ] ログ検索API(`GET /api/search?qth=東京`)

---

## 📄 ライセンス

[MIT License](https://opensource.org/licenses/MIT)

---

## 🙋‍♂️ 作者

- 📡 Callsign: JS2OIA
- 🧠 作者名: Mahito KIDA a.k.a. Kikyujin
- 💌 連絡先: [GitHub](https://github.com/kikyujin) / [✉️](mailto:js2oia@jarl.com)

---

## 🙏 謝辞

- **Boneless HAM**プロジェクトの実装経験がベース
- Turbo HAMLOG開発者の皆様(UIオートメーションをお許しください...)
