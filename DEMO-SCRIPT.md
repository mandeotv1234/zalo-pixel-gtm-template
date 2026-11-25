# Demo: Zalo Pixel GTM Template

**Ngày:** 2026-09-15 | **Audience:** Team review

---

## Bối cảnh

Hiện tại, để tích hợp Zalo Pixel vào website, developer phải nhúng đoạn script thủ công vào HTML và tự gọi `ztrq('track', ...)` trong code. Mỗi lần thay đổi event hay thêm conversion phải deploy lại code.

**Mục tiêu:** Cho phép marketer/analyst cấu hình và deploy Zalo Pixel qua Google Tag Manager — không cần developer sau lần setup đầu tiên.

---

## Những gì đã làm

| Hạng mục | Trạng thái | Mô tả |
|---|---|---|
| `template.tpl` | ✅ Hoàn thành | GTM Custom Tag Template, publish-ready |
| `GTM-SETUP.md` | ✅ Hoàn thành | Hướng dẫn 8 bước cho marketer |
| Landing page demo | ✅ Live | https://landing-page-pink-six-12.vercel.app |
| GTM container | ✅ Published | GTM-NZJLBMFK, gắn vào landing page |
| Automated test | ✅ Pass 6/6 | `scripts/test-conversions.py` xác nhận beacon fire |
| Docs alignment | ✅ Xong | So với `zaloads-public-docs` branch AS-3678 |

---

## Cơ chế hoạt động

### Tổng quan luồng

```
Marketer cấu hình GTM
        │
        ▼
┌─────────────────────────────────────────┐
│  GTM Container (GTM-NZJLBMFK)          │
│                                         │
│  Tag: Initialize ──► Trigger: Init      │  ← fire sớm nhất (trước DOM Ready)
│  Tag: Track Event ─► Trigger: zp_track  │  ← fire khi landing page push dataLayer
└─────────────────────────────────────────┘
        │                    │
        ▼                    ▼
 ztracker.js load      ztrq('track', eventName, params)
 + _ztrk.pid set
        │
        ▼
 /ptrck/events ──► lấy danh sách conversion rules từ Zalo backend
        │
        ▼
 /ptrck/log ──► beacon ghi nhận conversion
```

---

### Bước 1 — Tạo file template.tpl

File `.tpl` là định dạng riêng của GTM Template Gallery. Cấu trúc gồm 4 section:

```
template.tpl
├── ___TEMPLATE_PARAMETERS___   ← UI fields (Pixel ID, Action, Event params)
├── ___SANDBOXED_JS___          ← Code thực thi trong sandbox GTM
├── ___WEB_PERMISSIONS___       ← Khai báo quyền truy cập
└── ___TESTS___                 ← Unit test tự động
```

#### TEMPLATE_PARAMETERS — UI fields

Marketer thấy gì trong GTM khi cấu hình tag:

```
Pixel ID          [7071675013144936448]
Action            [Initialize ▾]        ← Initialize | Track event
─────────────────────────────────────────  (hiện khi Action = Track event)
Event type        [Standard event ▾]    ← Standard | Custom
Custom event name [{{DLV - zp_event_name}}]
─────────────────────────────────────────
Event parameters
  content_id      [{{DLV - zp_content_id}}]
  content_name    [{{DLV - zp_content_name}}]
  value           [{{DLV - zp_value}}]
  currency        [{{DLV - zp_currency}}]
  quantity        [{{DLV - zp_quantity}}]
  contents        [{{DLV - zp_contents}}]  ← TEXT, chuỗi phân cách dấu phẩy: '401,402'
  ...
```

#### SANDBOXED_JS — Logic thực thi

GTM chạy code trong sandbox (không có `document`, `window` trực tiếp). Phải dùng API của GTM:

```js
// Khai báo GTM sandbox APIs
const injectScript  = require('injectScript');
const setInWindow   = require('setInWindow');
const callInWindow  = require('callInWindow');
const logToConsole  = require('logToConsole');

const pixelId = data.pixelId;
const SCRIPT_URL = 'https://dev-adtima-static.zdn.vn/ztr/ztracker.js';

if (data.action === 'initialize') {
  // 1. Set _ztrk.pid TRƯỚC khi inject script
  //    ztracker.js đọc window._ztrk.pid ngay khi load
  setInWindow('_ztrk', { pid: pixelId, queue: [] }, false);

  // 2. Inject ztracker.js — dùng cacheToken để tránh load 2 lần
  //    nếu có nhiều tag Initialize trên cùng trang
  const cacheToken = 'ztrk#' + pixelId;
  injectScript(SCRIPT_URL, data.gtmOnSuccess, data.gtmOnFailure, cacheToken);

} else {
  // Track event — gọi ztrq đã được ztracker.js expose ra window
  const params = {};
  if (data.value)        params.value        = makeNumber(data.value);
  if (data.currency)     params.currency     = data.currency;
  if (data.content_id)   params.content_id   = data.content_id;
  // Pixel V2: contents là chuỗi mã trang/mã sản phẩm phân cách dấu phẩy (vd. '401,402'),
  // không phải mảng — forward nguyên văn, không transform.
  if (data.contents) params.contents = data.contents;
  // ... các param khác

  // Pixel V2: track() luôn gửi beacon — không còn phụ thuộc event đã được
  // cấu hình conversion trong Zalo Ads Manager hay chưa (khác V1).
  callInWindow('ztrq', 'track', data.customEventName, params);
  data.gtmOnSuccess();
}
```

#### WEB_PERMISSIONS — Quyền truy cập (3 quyền)

```
access_globals:
  ztrq   → execute: true   (để callInWindow gọi ztrq)
  _ztrk  → read: true, write: true   (để set pid trước khi script load)

inject_script:
  https://dev-adtima-static.zdn.vn/ztr/ztracker.js   (whitelist URL)

logging:
  Chỉ trong debug/preview mode
```

---

### Bước 2 — Import template vào GTM

```
GTM → Mẫu → Mẫu thẻ → Nhập file template.tpl → Save
```

Sau khi import, template xuất hiện như một loại tag tùy chỉnh. Marketer tạo tag như bình thường.

---

### Bước 3 — Tạo 2 Tags trong GTM

#### Tag 1: Initialize

| Field | Giá trị |
|---|---|
| Loại | Zalo Pixel |
| Action | Initialize |
| Pixel ID | `7071675013144936448` |
| Trigger | **Initialization — All Pages** |

> Trigger "Initialization" quan trọng: fire **trước** DOM Ready và trước mọi tag khác, đảm bảo `_ztrk.pid` và `ztracker.js` sẵn sàng trước khi bất kỳ Track event nào chạy.

#### Tag 2: Track Event

| Field | Giá trị |
|---|---|
| Loại | Zalo Pixel |
| Action | Track event |
| Custom event name | `{{DLV - zp_event_name}}` |
| Trigger | **Custom Event = `zp_track`** |
| Setup tag | Zalo Pixel — Initialize (Tag Sequencing) |

Tag Sequencing đảm bảo Initialize chạy xong trước Track Event, kể cả khi cả hai fire gần như đồng thời.

---

### Bước 4 — Landing page push dataLayer

Landing page không nhúng pixel script trực tiếp. Thay vào đó, khi user tương tác, code push vào GTM dataLayer:

```js
// Ví dụ: user click "Thêm vào giỏ hàng"
window.dataLayer.push({
  event:          'zp_track',        // ← GTM Trigger lắng nghe event này
  zp_event_name:  'AddToCart',
  zp_pixel_id:    '7071675013144936448',
  content_id:     'sp001',
  content_name:   'ZPhone Pro 15',
  content_type:   'product',
  value:          14990000,
  currency:       'VND',
  quantity:       1,
});
```

GTM nhận `event: 'zp_track'` → kích hoạt Trigger → chạy Tag Track Event → gọi `ztrq('track', 'AddToCart', params)`.

---

### Bước 5 — ztracker.js xử lý

> **Cập nhật Pixel V2 (2026-11-12):** sơ đồ bên dưới và mục "Tại sao et=4 chứ không phải
> et=3?" ngay sau đây phản ánh trạng thái **lúc viết demo này (2026-09-15)**, khi kind=3
> (standard event) "chưa có, chờ Zalo hỗ trợ". Điều đó **đã không còn đúng**: `track()` giờ
> luôn gửi beacon ngay khi gọi, độc lập với rule kind=4 (element click) — xem cảnh báo
> trùng event trong `README.md`. Giữ nguyên bên dưới làm lịch sử quyết định.

`ztrq('track', eventName, params)` → ztracker.js gọi `handleStandardEvent`:

```
ztracker.js nhận lệnh track
        │
        ▼
GET /ptrck/events?pixelId=7071675013144936448
        │
        ▼ (response: danh sách conversion rules)
┌─────────────────────────────────────┐
│ kind=4 (element click):             │
│   #btn-add-to-cart → eId=200123...  │  ← Đang hoạt động
│   #btn-purchase    → eId=839411...  │
│   ...                               │
│ kind=3 (standard event):            │
│   AddToCart → eId=...               │  ← Chưa có lúc viết demo này (xem ghi chú ở trên)
└─────────────────────────────────────┘
        │
        ▼ (khi element click khớp rule kind=4 — HOẶC bất kỳ lúc nào track() được gọi, độc lập)
POST /ptrck/log?pId=...&eId=...&et=4
        │
        ▼
Zalo Ads Manager ghi nhận conversion ✅
```

---

### Tại sao `et=4` chứ không phải `et=3`?

Hiện tại Zalo Ads Manager chỉ tạo được 2 loại conversion rule:
- **kind=4** — Element click (khớp theo `id`, `class`, text của DOM element)
- **kind=2** — URL match

GTM template gọi `ztrq('track', 'AddToCart', ...)` → ztracker.js tìm rule **kind=3** (Standard event) trong `/ptrck/events` → **không thấy** → không fire beacon qua path này.

Beacon `/ptrck/log` hiện tại fire nhờ **kind=4 rule** khớp với `#btn-add-to-cart`, `#btn-purchase`... — hoạt động song song với GTM.

Khi Zalo bật kind=3 support (dự kiến cùng lúc npm SDK release), `ztrq('track', ...)` từ GTM template sẽ tự động fire beacon mà không cần thêm cấu hình.

---

## Kết quả test tự động

```
python3.11 scripts/test-conversions.py
```

Playwright mở trình duyệt, thao tác đúng flow user, xác nhận `/ptrck/log` beacon:

```
✅ AddToCart          eId=2001235552467550668  et=4
✅ InitiateCheckout   eId=1407377257742598641  et=4
✅ Lead               eId=2543952331569234421  et=4
✅ CompleteReg        eId=297231720438432246   et=4
✅ Contact/Schedule   eId=865241089499857352   et=4
✅ Purchase           eId=839411886326153727   et=4

RESULT: 6/6
```

Ngoài ra pixel còn tự động gửi (không cần cấu hình):
- `tracklp?type=pageview` — lượt xem trang khi pixel load
- `tracklp?type=viewable` — thời gian ở lại trang, độ cuộn

---

## Kịch bản demo live (15 phút)

### Phần 1 — Landing page (3 phút)
1. Mở https://landing-page-pink-six-12.vercel.app
2. Mở DevTools → Network → filter `ptrck`
3. Click **"Thêm vào giỏ"** → thấy `/ptrck/log?eId=...&et=4` fire
4. Tiến hành thanh toán hết flow → thấy Purchase beacon

### Phần 2 — GTM (5 phút)
1. Mở GTM container GTM-NZJLBMFK → **Mẫu** → mở "Zalo Pixel"
2. Giới thiệu tab: Thông tin / Trường / Mã / Quyền / Thử nghiệm
3. Tab **Quyền** → giải thích 3 quyền (access_globals `ztrq`+`_ztrk`, inject_script URL, logging)
4. GTM → **Thẻ** → mở "Zalo Pixel — Initialize" → giải thích Initialization trigger
5. Mở "Zalo Pixel — Track Event" → giải thích Tag Sequencing, Custom Event trigger

### Phần 3 — Test tự động (2 phút)
1. Chạy `python3.11 scripts/test-conversions.py` trong terminal
2. Playwright mở Chrome → tự thao tác → in kết quả 6/6

### Phần 4 — Sơ đồ cơ chế + Q&A (5 phút)
Dùng diagram trong tài liệu này để giải thích luồng end-to-end.

---

## Những gì chưa làm / Điểm mở

| Hạng mục | Trạng thái | Ghi chú |
|---|---|---|
| Kind=3 (Standard event) beacon | ⏳ Chờ Zalo | Template đã sẵn sàng, chờ backend bật |
| Mini App support | ❓ Cần xác nhận | GTM `gtag.js` chưa xác nhận chạy trong Mini App |
| Consent (ad_storage) | ❓ Chờ Biz + Legal | A-7 — quyết định xem có cần check consent không |
| Icon template | ⬜ Chưa có | Cần cho Gallery submit, không cần cho internal |
| Gallery submission | ⬜ Chưa làm | Cần Legal review (A-8) + icon trước |
| SPA pageview guidance | ⬜ Chưa viết | Cần thêm vào GTM-SETUP.md |
