> **Đã resolved cho Pixel V2 (2026-11-11):** mục 9 bên dưới nêu các điểm mở (A-4, A-5) lúc viết doc này (2026-09-14). Qua test thực tế trên `adtima-ztracker`/zaui-market/landing-page, đã xác nhận: **Vấn đề 1** → `contents` là **mảng `{id, quantity}`** (không phải chuỗi) — `template.tpl` đã sửa theo hướng này. **Rủi ro 1** (duplicate events khi kind=3 bật) → **đã xảy ra thật**: `track()` giờ luôn gửi beacon bất kể cấu hình conversion, cảnh báo trùng event đã thêm vào README.md/GTM-SETUP.md. **Rủi ro 2** (SPA thiếu pageview) → ztracker.js tự nhận diện SPA framework và tự gửi pageview, không còn là rủi ro cho React/Vue/Next/... — xem README.md mục "SPA / pageview". Giữ nguyên nội dung gốc bên dưới làm lịch sử quyết định.

# Zalo Pixel — Ghi chú từ Public Docs (AS-3678) + GTM Template Alignment

**Nguồn**: `zaloads-public-docs` branch `feature/AS-3678`  
**Ngày đọc**: 2026-09-14  
**Mục đích**: Tóm tắt pixel hoạt động thế nào + kiểm tra GTM template có đúng hướng không.

---

## 1. Pixel là gì và đo được gì

Zalo Ads Pixel là đoạn mã đặt trên website hoặc Zalo Mini App. Sau khi tải, pixel **tự động**:

- Gửi `pageview` (lượt xem trang) ngay khi khởi tạo xong
- Ghi nhận thời gian ở lại, độ sâu cuộn, lượt nhấp
- Tải danh sách quy tắc chuyển đổi từ Zalo backend → tự gắn listener theo phần tử (`kind=4`)

Ngoài phần tự động, người dùng gọi thêm sự kiện trong mã.

---

## 2. Hai cách tích hợp chính thức

| | Script embed | npm SDK |
|---|---|---|
| Cần build tool | Không | Có |
| Gọi trong mã | `ztrq('track', name, params)` | `ZaloAdsPixel.track(name, params)` |
| TypeScript | Không | Có |
| Phù hợp | Website truyền thống, landing page, CMS | React, Next.js, Mini App |
| Trạng thái | **Đang hoạt động** | **Chưa phát hành** |

> GTM Template **không** được nhắc đến trong public docs. Đây là hướng đi riêng của team.

---

## 3. Script embed — API bề mặt

### 3.1. Mã nhúng chuẩn

```html
<!-- Zalo Ads Pixel Code -->
<script>
!function(e,t,r,n,c){if(!e.ztrq){c=e.ztrq=function(){c.queue?c.queue.push(arguments):
c.call(c,arguments)},e._ztrk||(e._ztrk=c),c.queue=[];var u=t.createElement(r);u.async=!0,
u.src=n;var a=t.getElementsByTagName(r)[0];a.parentNode.insertBefore(u,a)}
}(window,document,"script","https://s.zzcdn.me/ztr/ztracker.js?id=<PIXEL_ID>");
</script>
<!-- End Zalo Ads Pixel Code -->
```

Pixel ID truyền qua query param `?id=<PIXEL_ID>`. Đoạn nhúng tạo hàng đợi — gọi `ztrq(...)` an toàn trước khi script tải xong.

Bản rút gọn (không hàng đợi, mất sự kiện gửi trước khi script load):
```html
<script async src="https://s.zzcdn.me/ztr/ztracker.js?id=<PIXEL_ID>"></script>
```

### 3.2. Ba action của `ztrq`

| `action` | Tham số | Mô tả |
|---|---|---|
| `'track'` | `eventName, parameters?` | Gửi sự kiện chuẩn hoặc tùy chỉnh |
| `'pageview'` | — | Gửi lượt xem trang thủ công (chỉ dùng trong SPA) |
| `'pid'` | `pixelIds` (chuỗi phân cách phẩy) | Đổi Pixel ID lúc chạy |

**Quan trọng**: Gọi sai tên action (`'Track'`, `'trackk'`) **không ném lỗi** — pixel bỏ qua lặng lẽ.

### 3.3. Domains

| Mục đích | Domain |
|---|---|
| Tải script pixel | `https://s.zzcdn.me/ztr/ztracker.js` |
| Nhận dữ liệu / beacons | `https://log.adtimaserver.vn` |

CSP cần whitelist cả hai.

---

## 4. Standard events (17 sự kiện)

Xác nhận từ `standard-events.json`:

| Nhóm | Events |
|---|---|
| Thương mại điện tử | `ViewContent`, `AddToCart`, `AddToWishlist`, `InitiateCheckout`, `AddPaymentInfo`, `Purchase`, `CustomizeProduct` |
| Khách hàng tiềm năng | `Lead`, `CompleteRegistration`, `Contact`, `SubmitApplication`, `Schedule`, `FindLocation` |
| Tương tác | `Search`, `StartTrial`, `Subscribe` |
| Khác | `Donate` |

**Tham số bắt buộc** (chỉ 2 event):
- `Search` → `query`
- `Purchase` → `currency` + `value`

---

## 5. Parameters

| Param | Kiểu | Ghi chú |
|---|---|---|
| `content_id` | `string` | ID của 1 sản phẩm/trang |
| `contents` | `string` | **Chuỗi ID phân cách dấu phẩy**: `'401,402,512'` |
| `content_name` | `string` | Không chứa PII |
| `content_type` | `'product'` \| `'product_group'` | |
| `content_category` | `string` | |
| `currency` | `string` | ISO 4217, ví dụ `'VND'` |
| `value` | `number` | **Phải là số**, không phải chuỗi |
| `price` | `number` | Đơn giá một sản phẩm |
| `quantity` | `number` | |
| `query` | `string` | Bắt buộc với `Search` |

`content_id` dùng cho 1 sản phẩm; `contents` dùng cho nhiều sản phẩm.  
`value` là tổng giá trị sự kiện; `price` là đơn giá.

---

## 6. Auto-tracking (không cần khai báo)

| Hành vi | Ai làm |
|---|---|
| Lượt xem trang | Pixel tự động khi load |
| Thời gian trên trang, cuộn, nhấp | Pixel tự động |
| Chuyển đổi theo phần tử (`kind=4`) | Pixel tải quy tắc từ Zalo backend, tự gắn listener |
| Nhận diện nguồn quảng cáo (zaclid, zsrcid...) | Pixel tự đọc URL params |

**Cảnh báo quan trọng từ docs:**  
Nếu đã cấu hình quy tắc phần tử trong Zalo Ads Manager cho một nút, VÀ lại gọi `track()` trong mã cho cùng nút đó → **sự kiện bị ghi 2 lần**. Chọn một cơ chế.

---

## 7. Debug

| Cách | Dùng khi |
|---|---|
| `?_ztrdebug=true` | Xem bảng điều khiển gỡ lỗi (desktop) |
| `?_ztrdebug=eruda` | Console gỡ lỗi trên **mobile** — **đã tích hợp sẵn trong pixel** |
| `?_ztrdebug=ver` | Xem phiên bản pixel |
| Network → `log.adtimaserver.vn` | Xác nhận request có rời trình duyệt |

---

## 8. Mini App

- Pixel chạy trong Mini App giống web; tự nhận diện môi trường và bổ sung `appId`, `znId`
- GTM (`gtag.js`) chưa được xác nhận hoạt động trong Mini App — docs Mini App khuyến nghị dùng SDK thay vì GTM

---

## 9. GTM Template — Alignment Check

### ✅ Đúng hướng

| Điểm | Chi tiết |
|---|---|
| Gọi `ztrq('track', eventName, params)` | Đúng — khớp script embed path |
| 17 standard events | Đúng — khớp `standard-events.json` |
| Validation: Search cần `query`, Purchase cần `currency`+`value` | Đúng — khớp docs |
| URL script: `https://s.zzcdn.me/ztr/ztracker.js` | Đúng |
| Permissions: `access_globals`, `inject_script`, `logging`, `access_consent` | Đúng |
| `eventId` field reserve cho dedup (A-5) | Đúng |
| `categories`: ADVERTISING, CONVERSIONS, REMARKETING | Đúng |

### ❌ Sai / Cần sửa

#### Vấn đề 1 — `contents` sai kiểu dữ liệu

Template hiện gửi `contents` là **array of objects**:
```js
params.contents = data.contents.map(row => ({id: row.id, quantity: makeNumber(row.quantity)}));
// → [{id: 'sku-001', quantity: 2}, {id: 'sku-002', quantity: 1}]
```

Docs (TypeScript interface + ecommerce guide) định nghĩa `contents` là **chuỗi phân cách phẩy**:
```ts
contents?: string;  // '401,402,512'
```
```js
// Đúng theo docs:
contents: cart.items.map(i => i.productId).join(',')  // '401,402,512'
```

**Cần xác nhận với Backend Zalo Pixel** vì A-4 vẫn mở. Nếu backend nhận string, cần sửa template.

#### Vấn đề 2 — Cách truyền Pixel ID khác với snippet chuẩn

Snippet docs: `?id=<PIXEL_ID>` trong URL  
Template: URL không có query param, thay vào đó `setInWindow('_ztrk', {pid: pixelId, queue: []}, false)` trước `injectScript`

Về lý thuyết cả hai đều hoạt động vì ztracker.js đọc `_ztrk.pid`. Nhưng nếu ztracker.js được cập nhật và không còn đọc `_ztrk.pid` nữa, template sẽ bị.

**Nên test lại hành vi** với pixel ID thực để xác nhận.

#### Vấn đề 3 — Không cần nhúng Eruda thủ công

Landing page đang nhúng Eruda từ CDN bên ngoài. Thực ra pixel đã có debug mode mobile sẵn qua `?_ztrdebug=eruda`. Eruda thủ công trên landing page là OK cho dev nhưng **không nên áp dụng cho production**.

### ⚠️ Rủi ro tiềm ẩn

#### Rủi ro 1 — Duplicate events khi kind=3 được bật

Hiện tại `ztrq('track', eventName, params)` **không** fire beacon vì Zalo Ads Manager chỉ tạo được kind=4 (element click) conversions, chưa có kind=3 (STANDARD).

Khi Zalo bật hỗ trợ kind=3 (có thể xảy ra khi npm SDK release):
- Template gọi `ztrq('track', 'AddToCart', ...)` → fire beacon (kind=3)
- Zalo Ads Manager element rule cho `btn-add-to-cart` → fire beacon (kind=4)
- **Sự kiện được ghi 2 lần**

Cần có hướng dẫn rõ trong README/GTM-SETUP: "Nếu dùng GTM Template thì **không** cấu hình element click rules trong Zalo Ads Manager cho cùng sự kiện."

#### Rủi ro 2 — SPA không có pageview tracking

Template không tự động gửi `pageview` khi route thay đổi trong SPA (React Router, Next.js). Docs đề cập rõ vấn đề này và khuyến nghị gọi `ztrq('pageview')` trong hook điều hướng. Cần bổ sung vào README.

---

## 10. Kết luận

**Hướng đi của GTM Template là đúng** — template wrap script embed path (`ztrq('track', ...)`) mà docs mô tả, chạy trong GTM sandbox với permission rõ ràng.

**Việc cần làm ngay:**
1. Xác nhận với Backend Zalo Pixel: `contents` là chuỗi hay array? → Sửa template cho đúng
2. Bổ sung cảnh báo vào README về duplicate event nếu vừa dùng template vừa cấu hình element rules
3. Bổ sung hướng dẫn SPA pageview tracking vào GTM-SETUP.md
4. Test lại template với thực tế: tạo GTM container, import template.tpl, xem request có đi ra `log.adtimaserver.vn` không và `et=` bằng bao nhiêu

**Điểm mở quan trọng nhất (A-1):** Mini App có nạp được GTM không — nếu không thì toàn bộ phạm vi Mini App của template phải bỏ.
