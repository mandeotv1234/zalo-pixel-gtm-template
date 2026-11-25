# Hướng dẫn cài đặt Zalo Pixel GTM Template

## Tổng quan

Landing page push `dataLayer` → GTM nhận → Tag Zalo Pixel fire → `ztracker.js` gửi beacon → Zalo Ads Manager ghi nhận conversion.

```
Landing page
  └─ dataLayer.push({ event: 'zp_track', zp_event_name: 'Purchase', ... })
        └─ GTM Trigger: Custom Event = zp_track
              └─ GTM Tag: Zalo Pixel - Track Event
                    └─ ztracker.js → /ptrck/events → /ptrck/log
```

---

## Checklist

```
[ ] Bước 1 — Import template
[ ] Bước 2 — Tạo 8 Variables
[ ] Bước 3 — Tạo 2 Triggers
[ ] Bước 4 — Tạo Tag Initialize
[ ] Bước 5 — Tạo Tag Track Event
[ ] Bước 6 — Publish container
[ ] Bước 7 — Tạo Conversion trong Zalo Ads Manager
[ ] Bước 8 — Verify
```

---

## Bước 1 — Import Custom Template

1. Vào GTM container → **Mẫu** (Templates) → **Mẫu thẻ** (Tag Templates)
2. Click **Tìm kiếm trong thư viện** → tìm "Zalo Pixel" → Import
   - Hoặc: **Mới** → dấu ⋮ → **Nhập** → upload file `template.tpl`
3. Save

---

## Bước 2 — Tạo Variables (Biến lớp dữ liệu)

**Cách tạo:** Biến → Biến do người dùng xác định → Mới → chọn **Biến lớp dữ liệu** → điền tên → Save

Tạo đủ 10 biến sau:

| Tên biến GTM | Tên biến lớp dữ liệu | Giá trị mặc định |
|---|---|---|
| `DLV - zp_event_name` | `zp_event_name` | *(để trống)* |
| `DLV - zp_pixel_id` | `zp_pixel_id` | *(để trống)* |
| `DLV - zp_value` | `value` | `0` |
| `DLV - zp_currency` | `currency` | `VND` |
| `DLV - zp_content_id` | `content_id` | *(để trống)* |
| `DLV - zp_content_name` | `content_name` | *(để trống)* |
| `DLV - zp_content_type` | `content_type` | *(để trống)* |
| `DLV - zp_quantity` | `quantity` | *(để trống)* |
| `DLV - zp_query` | `query` | *(để trống — bắt buộc cho `Search`)* |
| `DLV - zp_contents` | `contents` | *(để trống — chuỗi mã trang/mã sản phẩm phân cách dấu phẩy, dùng cho AddToWishlist)* |

> **Phiên bản:** chọn Phiên bản 2 cho tất cả.
> **Pixel V2:** `contents` là **chuỗi phân cách dấu phẩy** (vd. `'401,402'` — đúng theo
> tài liệu zalo-ads-v2 "Danh sách mã trang hoặc mã sản phẩm, phân cách bằng dấu phẩy"),
> không phải mảng — tag Track event truyền thẳng giá trị này vào `ztrq('track', ...)`
> không qua biến đổi.

---

## Bước 3 — Tạo Triggers (Điều kiện kích hoạt)

### Trigger 1: Initialization (cho Initialize)

| Field | Giá trị |
|---|---|
| Loại | **Lượt xem trang — Khởi tạo** (Initialization) |
| Kích hoạt trên | Tất cả sự kiện khởi tạo |
| Tên | `Trigger - Initialization - All Pages` |

> Dùng "Khởi tạo" thay vì "DOM Ready" — trigger này fire sớm nhất, trước DOM Ready, đảm bảo pixel init xong trước mọi tag khác.

### Trigger 2: zp_track (cho Track Event)

| Field | Giá trị |
|---|---|
| Loại | **Sự kiện tùy chỉnh** |
| Tên sự kiện | `zp_track` |
| Kích hoạt trên | Tất cả sự kiện tùy chỉnh |
| Tên | `Trigger - zp_track` |

---

## Bước 4 — Tạo Tag Initialize

Tag này load `ztracker.js` và set `window._ztrk.pid`. **Phải chạy trước Tag Track.**

| Field | Giá trị |
|---|---|
| Loại thẻ | Zalo Pixel *(template vừa import)* |
| Action | **Initialize** |
| Pixel ID | `7071675013144936448` |
| Điều kiện kích hoạt | `Trigger - Initialization - All Pages` |
| Tên thẻ | `Zalo Pixel - Initialize` |

> Advanced Settings: không cần thay đổi gì.

---

## Bước 5 — Tạo Tag Track Event

Tag này xử lý tất cả 17 events. Chỉ cần tạo 1 tag duy nhất.

### Cấu hình chính

| Field | Giá trị |
|---|---|
| Loại thẻ | Zalo Pixel *(template vừa import)* |
| Action | **Track event** |
| Event type | **Custom event** |
| Custom event name | `{{DLV - zp_event_name}}` |
| Tên thẻ | `Zalo Pixel - Track Event` |

### Event parameters

| Field | Giá trị |
|---|---|
| `content_id` | `{{DLV - zp_content_id}}` |
| `content_name` | `{{DLV - zp_content_name}}` |
| `content_type` | `{{DLV - zp_content_type}}` |
| `currency` | `{{DLV - zp_currency}}` |
| `value` | `{{DLV - zp_value}}` |
| `quantity` | `{{DLV - zp_quantity}}` |
| `contents` | `{{DLV - zp_contents}}` (chuỗi phân cách dấu phẩy, vd. `'401,402'`) |
| Additional parameters | `query` → `{{DLV - zp_query}}` (dùng cho `Search`) |

Không field nào bắt buộc — field nào trống thì đơn giản không có mặt trong payload gửi
đi, tag vẫn fire bình thường.

### Cài đặt nâng cao — Trình tự thẻ

Scroll xuống cuối → **Cài đặt nâng cao** → **Trình tự thẻ**:

```
☑ Kích hoạt thẻ trước khi thẻ này kích hoạt
   Thẻ thiết lập: Zalo Pixel - Initialize
   ☑ Không kích hoạt thẻ này nếu thẻ thiết lập thất bại
```

### Điều kiện kích hoạt

Gán trigger: `Trigger - zp_track`

---

## Bước 6 — Publish Container

1. Click **Gửi** (Submit) góc trên phải
2. Phiên bản: đặt tên ví dụ `v1 - Zalo Pixel setup`
3. Click **Xuất bản** (Publish)

---

## Bước 7 — Tạo Conversion trong Zalo Ads Manager

Vào: **Công cụ** → **Chuyển đổi** → **Tạo chuyển đổi**

### Danh sách conversion cần tạo

| Tên Conversion | Sự kiện | Counting | Conversion window |
|---|---|---|---|
| `ZTech - Purchase` | Purchase | Tất cả | 7 ngày click + 1 ngày view |
| `ZTech - Add to Cart` | AddToCart | Tất cả | 7 ngày click |
| `ZTech - Initiate Checkout` | InitiateCheckout | Một lần | 7 ngày click |
| `ZTech - Lead` | Lead | Một lần | 7 ngày click |
| `ZTech - Complete Registration` | CompleteRegistration | Một lần | 7 ngày click |
| `ZTech - View Content` | ViewContent | Tất cả | 1 ngày click |

### Cách điền form cho từng conversion

```
1. Nguồn:         Zalo Pixel
2. Pixel:         [chọn pixel 7071675013144936448]
3. Sự kiện:       [chọn event tương ứng từ bảng trên]
4. Counting:      [xem bảng trên]
5. Window:        [xem bảng trên]
6. Giá trị:
   - Purchase     → "Sử dụng giá trị từ sự kiện"
   - Còn lại      → để trống hoặc 0
7. Save
```

---

## Bước 8 — Verify (kiểm tra)

### Dùng GTM Preview

1. GTM → **Xem trước** → nhập URL landing page → Connect
2. Mở landing page → click 1 button bất kỳ
3. Trong GTM Preview panel → tab **Thẻ** → kiểm tra:
   - `Zalo Pixel - Initialize` → **Đã kích hoạt** ✓
   - `Zalo Pixel - Track Event` → **Đã kích hoạt** ✓

### Kiểm tra Network (DevTools → tab Network → lọc `ptrck`)

| Request | Kết quả mong đợi |
|---|---|
| `ztracker.js` | Status 200 |
| `/ptrck/events?pixelId=...` | `{"events": [...]}` |
| `/ptrck/log?pId=...&eId=...` | Status 200 *(chỉ xuất hiện khi event khớp với conversion đã tạo)* |

### Kiểm tra dataLayer trong Console

```javascript
// Paste vào DevTools Console sau khi click 1 button
window.dataLayer.filter(e => e.event === 'zp_track')
// Phải thấy các object có zp_event_name, zp_pixel_id, ...
```

---

## Lưu ý quan trọng

- Tag **Initialize phải chạy trước** Track Event — đảm bảo bằng Tag Sequencing ở Bước 5.
- **Pixel V2 = `kind=5`:** tag Track Event gọi `ztrq('track', eventName, params)` → log dưới dạng `kind=5` (`EventKind.NEW_STANDARD`) và **luôn** gửi `/ptrck/log` ngay khi dataLayer push `zp_track` — khớp conversion kind=5 đã tạo thì dùng cid thật, không khớp gì cũng vẫn gửi (dùng `UNDECLARED_EVENT_ID`). Bước 7 (tạo Conversion) chỉ cần thiết nếu bạn muốn sự kiện hiện ra như một "Conversion" chọn được làm mục tiêu tối ưu quảng cáo — không phải điều kiện để beacon được gửi.
- ⚠️ **Không cấu hình trùng cơ chế:** `kind=4` (Event Builder webElement rule — id/class/nội dung nút bấm) là kind khác, độc lập với kind=5. Nếu một hành động đã được track qua tag GTM này (kind=5), đừng cấu hình thêm rule kind=4 cho cùng hành động trong Zalo Ads Manager — sẽ bị đếm 2 lần.
- Pixel ID trong tag Initialize và dataLayer của landing page phải **trùng khớp**.
- SPA (React/Vue/Next/...): pixel tự gửi pageview khi đổi route, không cần thêm tag — xem `README.md` mục "SPA / pageview".
- Thấy conversion lạ kèm referrer `gtm-msr.appspot.com`: đó là bot quét container của Google, không phải traffic thật — xem `README.md` mục "Traffic quét bot của Google".
- Tag Track Event tự gắn `eventTrigger=GTM` vào mọi beacon nó gửi (không cần cấu hình) — cần `adtima-ztracker` bản **v1.9.0+** mới nhận diện đúng, xem `README.md` mục "`eventTrigger` = `"GTM"`".
